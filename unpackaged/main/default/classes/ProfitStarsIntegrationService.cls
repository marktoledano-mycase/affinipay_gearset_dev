/******************************************************************************************************
* copyright © 2015
*
* File		: ProfitStarsIntegrationService.cls
*
* Purpose	: This is a service class. This class is called to submit any request to profitstars.
				This class controlls the flow of request in sequence retrieve, build, validate, configure, 
				call out, analyze response
*
* Referred from 	: 10+ Classes
*
* Test Classes: PS_BatchGetMidLidTest
*               PS_UpdateLIDsOnBankAccountsTest
* 				PS_OutboundBankAccountUpdatesTest
* 				ProfitStarsRequestValidation_Tests
* 				PS_BatchBankAccountUpdatesTest
* 				ps_buttonMethodsTest
* 				PS_BatchFieldUpdatesTest
* 				PS_BatchFieldUpdatesForOutboundTest
*				ps_eCheckButtonMethodsTest
*-----------------------------------------------------------------------------
*
*Release Date		Request 	Updated By			Description
*----------------------------------------------------------------------------------------------------------------------
*06/24/2015			Nill							Initial Creation
*07/21/2015			R151866		Venkat Araveeti		MyCase Integration
*08/28/2015			R152441		Venkat Araveeti		Updated addon Process to location to allow users to add locations
*													on click. 
*08/28/2015			R152441		Venkat Araveeti		Updated addon Process to location to allow users to add locations
*													on click. 
*09/13/2016			R163756		Rohit Kumar Malik	Create a batch to update MID and LIDs (GET Request) from ProfitStars
*09/13/2016			R164098
*
*03/31/2020			R2025316 	Ryan Kleinberg		Inbound V+ can set processing day to 1 or 3 days
*******************************************************************************************************/
public with sharing virtual class ProfitStarsIntegrationService extends RestClient{

	public class PSISException extends Exception{
		public PSISException(String action, Id valuePlus, String response, String faultCode){
			ProfitStarsUtils.createAuditLogInRealtime(action, valuePlus, response, faultCode, '');		//request #R151866 updated to capture application type
		}
	}

	/*
	ProfitStars integration service.
	Extends RestClient
	To be extended by functional classes.
	 */

	/////////////////////////// Class Variables /////////////////////////////////
	@testVisible public ProfitStarsIntegration__c activeConfig;
	
	@testVisible public static String recordType;   //request #R151866 added this variable to capture the recordtype from record
    @testVisible public static Boolean oneDayProcessing = false;

	/////////////////////////// Constructor /////////////////////////////////////
	public ProfitStarsIntegrationService(){
		//request #R151866 commented this action as specific config is required.
		/* this.activeConfig = ProfitStarsUtils.getConfig();
		if (this.activeConfig == null) {
			throw new PSISException('No ProfitStarsIntegration__c records found. Unable to proceed with callouts');
		} */
	}

	/////////////////////////// Public Methods //////////////////////////////////

	/**
	 * Makes a given request type, having built the request from an ID
	 * @param  action keyword defining the type of call being made
	 * @param  id     ID of the record in question
	 * @return        JSON string
	 */
	//Public String makeRequestWithGuid(String action, Id id) {
	public String makeRequestWithGuid(String action, Id id, Id bankId, String product){
		//return get(url, this.headers, bodyTxt);
		if(action.toLowerCase() == 'enrollment'){
			return makeEnrollmentRequest(id, product);
		} else if(action.toLowerCase() == 'location' && bankId != null){
			return makeLocationRequest(action, id, bankId, product);
		} else if(action.toLowerCase() == 'location' || action.toLowerCase() == 'bank account'){
			return makeMultipleBankAccountOrLocRequest(action, id, product);
		} else if(action.toLowerCase() == 'velocity'){
			return makeVelocityRequest(action, id, bankId, product);
		} else if(action.toLowerCase() == 'midlid'){
			return makeGetAllMerchantsRequest(action, id, product);
		} else{
			return makeMaintOtherRequest(action, id, product);
		}
	}
	
	public String makeEnrollmentRequest(Id id, String product){
		ProfitStarsRequestBuilder.ProfitStarsRequest bodyObj = ProfitStarsRequestBuilder.createEnrollmentRequestFromActionAndRecordId(id, product);
		// All calls require the Agent info details which are stored in the ProfitstarsIntegration custom setting.
		System.debug('the record type is '+ recordType);

		ProfitStarsIntegration__c psi = getConfig(recordType, product);
		bodyObj.APIIntegration.Account.put('custServProviderId', (String) psi.get('EntityId__c'));
		bodyObj.APIIntegration.Account.put('RequestEmail', (String) psi.get('Maintenance_Username__c'));
		bodyObj.APIIntegration.Opportunity.put('RecordType', (String) psi.get('Record_Type__c'));
        
        //APM Payments PS custom setting should only be used for inbound
        if(psi.Name == 'APM Payments'){
            
            //make sure it's a V+ obj
            if(id.getSObjectType().getDescribe().getName() == 'ValuePlus__c'){

                //if "1 day" is selected change the PS opp record type
                if(oneDayProcessing){
                    bodyObj.APIIntegration.Opportunity.put('RecordType', 'tmp-EPS-260313-0');
                }
            }
        }
		

		if(recordType == 'MyCase Payments'){
			bodyObj.APIIntegration.Account.put('ClassificationCode', '541110');
		}else {
			bodyObj.APIIntegration.Account.put('ClassificationCode', '531311');
		}

		String reqBody = JSON.serialize(bodyObj);
		System.debug('*** reqBody '+ reqBody);

		//https://use4-cai.dm-us.informaticacloud.com/active-bpel/rt/API-Integration-Salesforce
		HttpRequest req = buildHttpRequest(reqBody, 'API-Integration-Salesforce');
		Http http = new Http();
		HTTPResponse resp = http.send(req);
		System.debug('resp.getBody: '+ resp.getBody());
		
		return resp.getBody();
	}

	public String makeGetAllMerchantsRequest(String action, Id id, String product){

		Date startDate = Date.today().addDays(-1);
		Date endDate = Date.today().addDays(1);

		String startDateStr = String.valueOf(startDate);
		String endDateStr = String.valueOf(endDate);

		ProfitStarsIntegration__c  pd = [Select Id, Name, EntityId__c, Maintenance_Username__c from ProfitStarsIntegration__c where id = :id];

        if (pd.name.equals('APM Payments') || pd.name.equals('APM Payments Echeck')){
            recordType = 'APM Payments';
        } else if (pd.name.equals('MyCase Payments')){
            recordType = 'MyCase Payments';
        }

		Map<String, String> bodyMap = new Map<String, String>();

		bodyMap.put('request_email', pd.Maintenance_Username__c);
		bodyMap.put('custServProviderId', pd.EntityId__c); //this is partner Id
		bodyMap.put('merchant_enabled', 'Enabled'); //this value can be 'All', 'Enabled' or 'Disabled'
		bodyMap.put('begin_date', startDateStr);
		bodyMap.put('end_date', endDateStr);

		System.debug('the record type is '+ recordType);
		String reqBody = JSON.serialize(bodyMap);
		System.debug('*** reqBody '+ reqBody);

		HttpRequest req = buildHttpRequest(reqBody, 'GetAllMerchants');
		//https://use4-cai.dm-us.informaticacloud.com/active-bpel/rt/GetAllMerchants
		Http http = new Http();
		HTTPResponse resp = http.send(req);
		System.debug('resp.getBody: '+ resp.getBody());
		return resp.getBody();
	}

	//Just a placeholder method, not used in any logic yet.
	public String makeGetAllLocationsRequest(Id id, String product){

		ValuePlus__c record = [Select ProfitStars_Merchant_ID__c, recordType.Name from ValuePlus__c Where Id = :id LIMIT 1];
		recordType = record.recordType.Name;
		System.debug('the record type is '+ recordType);

		ProfitStarsIntegration__c psi = getConfig(recordType, product);

		Map<String, String> bodyMap = new Map<String, String>();
		bodyMap.put('request_email', (String) psi.get('Maintenance_Username__c'));
		bodyMap.put('custServProviderId', (String) psi.get('EntityId__c')); //this is partner Id
		bodyMap.put('entity_id', record.ProfitStars_Merchant_ID__c); //this is the Merchant Id

		String reqBody = JSON.serialize(bodyMap);
		System.debug('*** reqBody '+ reqBody);

		HttpRequest req = buildHttpRequest(reqBody, 'GetAllLocations');
		//https://use4-cai.dm-us.informaticacloud.com/active-bpel/rt/GetAllLocations
		Http http = new Http();
		HTTPResponse resp = http.send(req);
		System.debug('resp.getBody: '+ resp.getBody());
		return resp.getBody();
	}

	//Just a placeholder method, not used in any logic yet.
	public String makeGetLocationByLocationIdRequest(Id id, String product){

		Map<String, String> bodyMap = new Map<String, String>();
		bodyMap.put('request_email', 'bizsys@appfolio.com');
		bodyMap.put('custServProviderId', '268009'); //this is partner Id
		bodyMap.put('entity_id', ''); //this is the Merchant Id
		bodyMap.put('location_id', '');

		System.debug('the record type is '+ recordType);
		//String reqBody = JSON.serialize(bodyObj);
		String reqBody = JSON.serialize(bodyMap);
		System.debug('*** reqBody '+ reqBody);

		//https://use4-cai.dm-us.informaticacloud.com/active-bpel/rt/GetLocationByLocationId
		HttpRequest req = buildHttpRequest(reqBody, 'GetLocationByLocationId');
		Http http = new Http();
		HTTPResponse resp = http.send(req);
		System.debug('resp.getBody: '+ resp.getBody());
		return resp.getBody();
	}

	public String makeGetLocationByLocationNameRequest(String merchId, String recordTypeName, String locationName, String product){

		recordType = recordTypeName;
		ProfitStarsIntegration__c psi = getConfig(recordType, product);

		Map<String, String> bodyMap = new Map<String, String>();
		bodyMap.put('request_email', (String) psi.get('Maintenance_Username__c'));
		bodyMap.put('custServProviderId', (String) psi.get('EntityId__c')); //this is partner Id
		bodyMap.put('entity_id', merchId); //this is the Merchant Id
		bodyMap.put('location_name', locationName);

		System.debug('the record type is '+ recordTypeName);
		String reqBody = JSON.serialize(bodyMap);
		System.debug('*** reqBody '+ reqBody);

		//https://use4-cai.dm-us.informaticacloud.com/active-bpel/rt/GetLocationByLocationName
		HttpRequest req = buildHttpRequest(reqBody, 'GetLocationByLocationName');
		Http http = new Http();
		HTTPResponse resp = http.send(req);
		System.debug('makeGetLocationByLocationNameRequest resp.getBody: '+ resp.getBody());
		return resp.getBody();
	}

	//Just a placeholder method, not used in any logic yet.
	public String makeGetVelocitySettingsByLocationIdRequest(Id id, String product){

		ValuePlus__c record = [Select ProfitStars_Merchant_ID__c, Outbound_MID__c, recordType.Name from ValuePlus__c Where Id = :id LIMIT 1];
		recordType = record.recordType.Name;
		System.debug('the record type is '+ recordType);

		ProfitStarsIntegration__c psi = getConfig(recordType, product);

		Map<String, String> bodyMap = new Map<String, String>();
		bodyMap.put('request_email', (String) psi.get('Maintenance_Username__c'));
		bodyMap.put('custServProviderId', (String) psi.get('EntityId__c')); //this is partner Id

		if(product == null){
			bodyMap.put('entity_id', record.ProfitStars_Merchant_ID__c); //this is the Merchant Id
		} else{
			bodyMap.put('entity_id', record.Outbound_MID__c); //this is the Merchant Id
		}

		bodyMap.put('location_id', '');

		String reqBody = JSON.serialize(bodyMap);
		System.debug('*** reqBody '+ reqBody);

		//https://use4-cai.dm-us.informaticacloud.com/active-bpel/rt/GetVelocitySettingsByLocationId
		HttpRequest req = buildHttpRequest(reqBody, 'GetVelocitySettingsByLocationId');
		Http http = new Http();
		HTTPResponse resp = http.send(req);
		System.debug('resp.getBody: '+ resp.getBody());
		return resp.getBody();
	}

	public String makeGetVelocitySettingsByMerchantIdRequest(Id id, String product){

		ValuePlus__c record = [Select ProfitStars_Merchant_ID__c, Outbound_MID__c, recordType.Name from ValuePlus__c Where Id = :id LIMIT 1];
		recordType = record.recordType.Name;
		System.debug('the record type is '+ recordType);

		ProfitStarsIntegration__c psi = getConfig(recordType, product);

		Map<String, String> bodyMap = new Map<String, String>();
		bodyMap.put('request_email', (String) psi.get('Maintenance_Username__c'));
		bodyMap.put('custServProviderId', (String) psi.get('EntityId__c')); //this is partner Id

		if(product == null){
			bodyMap.put('entity_id', record.ProfitStars_Merchant_ID__c); //this is the Merchant Id
		} else{
			bodyMap.put('entity_id', record.Outbound_MID__c); //this is the Merchant Id
		}

		bodyMap.put('merchant_enabled', 'Enabled'); //this value can be 'All', 'Enabled' or 'Disabled'

		String reqBody = JSON.serialize(bodyMap);
		System.debug('*** reqBody '+ reqBody);

		//https://use4-cai.dm-us.informaticacloud.com/active-bpel/rt/GetVelocitySettingsByMerchantId
		HttpRequest req = buildHttpRequest(reqBody, 'GetVelocitySettingsByMerchantId');
		Http http = new Http();
		HTTPResponse resp = http.send(req);
		System.debug('resp.getBody: '+ resp.getBody());
		return resp.getBody();
	}

	
    //A Location Request is used to add a location for an existing merchant with velocity set at the merchant level (for a single record).
	public String makeLocationRequest(String action, Id id, Id bankId, String product){
		Map<String, String> bodyObj = ProfitStarsRequestBuilder.createBankLocationVelocityReqFromActionAndRecordId(action, id, bankId, product);
		
		System.debug('the record type is '+ recordType);
		ProfitStarsIntegration__c psi = getConfig(recordType, product);

		bodyObj.put('custServProviderId', (String) psi.get('EntityId__c'));
		bodyObj.put('request_email', (String) psi.get('Maintenance_Username__c'));

		String reqBody = JSON.serialize(bodyObj);
		System.debug('*** reqBody '+ reqBody);

		HttpRequest req = new HttpRequest();
		req = buildHttpRequest(reqBody, 'LocationRequest');

		Http http = new Http();
		HTTPResponse resp = http.send(req);
		System.debug('resp.getBody: '+ resp.getBody());
	
		return resp.getBody();
	}

	//A Bank Request is used to update a bank account for an existing merchant (for multiple records).
	//A Location Request is used to add a location for an existing merchant with velocity set at the merchant level (for multiple records).
	public String makeMultipleBankAccountOrLocRequest(String action, Id id, String product){
		Map<Id, Map<String, String>> bodyObjMap = ProfitStarsRequestBuilder.createMultipleMaintenanceReqFromActionAndRecordId(action, id, product);
		
		System.debug('the record type is '+ recordType);
		ProfitStarsIntegration__c psi = getConfig(recordType, product);
		String entityId = (String) psi.get('EntityId__c');
		String reqEmail = (String) psi.get('Maintenance_Username__c');

		//List<ps_GuidResp.PS_Resp_Maint> resultsList = new List<ps_GuidResp.PS_Resp_Maint>();
		Map<Id, ps_GuidResp.PS_Resp_Maint> resultsMap = new Map<Id, ps_GuidResp.PS_Resp_Maint>();

		//for(Map<String, String> bodyObj : bodyObjList){
		for(Id bankId : bodyObjMap.keySet()){
			Map<String, String> bodyObj = bodyObjMap.get(bankId);
			bodyObj.put('custServProviderId', entityId);
			bodyObj.put('request_email', reqEmail);

			String reqBody = JSON.serialize(bodyObj);
			System.debug('*** reqBody '+ reqBody);

			HttpRequest req = new HttpRequest();
			if(action.toLowerCase() == 'bank account'){
				//https://use4-cai.dm-us.informaticacloud.com/active-bpel/rt/BankRequest
				req = buildHttpRequest(reqBody, 'BankRequest');
			} else if(action.toLowerCase() == 'location'){
				//https://use4-cai.dm-us.informaticacloud.com/active-bpel/rt/LocationRequest
				req = buildHttpRequest(reqBody, 'LocationRequest');
			}

			Http http = new Http();
			HTTPResponse resp = http.send(req);
			System.debug('resp.getBody: '+ resp.getBody());
			//resultsList.add(parseMaintResponse(resp.getBody()));
			resultsMap.put(bankId, parseMaintResponse(resp.getBody()));
		}

		Map<String, Map<Id, ps_GuidResp.PS_Resp_Maint>> retResults = new Map<String, Map<Id, ps_GuidResp.PS_Resp_Maint>>();
		retResults.put('results', resultsMap);
		return JSON.serialize(retResults);
	}

	//A Velocity Request will update velocity for an existing merchant and location. 
    //This request is used in tandem with GETs to obtain the unique velocity setting ID (vsid) to populate this request.
	public String makeVelocityRequest(String action, Id id, Id bankId, String product){
		String vsId; //Unique velocity Id, this value can be retrieved using the makeGetVelocitySettingsByMerchantIdRequest call or the makeGetVelocitySettingsByLocationIdRequest call
		String operationType; //can be Sale, Credit, Refund (case sensitive). 
		String velocitySettingsResult = makeGetVelocitySettingsByMerchantIdRequest(id, product);

		ps_GuidResp.GetVelocitySettingsByMerchantIdResults parseResult = (ps_GuidResp.GetVelocitySettingsByMerchantIdResults) System.JSON.deserialize(velocitySettingsResult, ps_GuidResp.GetVelocitySettingsByMerchantIdResults.class);
		
		if(parseResult != null && parseResult.getVelocityByMerchant != null && parseResult.getVelocityByMerchant.getVelocitySettingsByMerchantIdResult != null){
			if(!parseResult.getVelocityByMerchant.getVelocitySettingsByMerchantIdResult.wsVelocitySettings.isEmpty()){

				for(ps_GuidResp.WSVelocitySettings velSetting : parseResult.getVelocityByMerchant.getVelocitySettingsByMerchantIdResult.wsVelocitySettings){

					for(ps_GuidResp.OperationType opType : velSetting.operationType){
						if(!String.isEmpty(product) && product == 'echeck'){
							if(opType.wsOperationType.toLowerCase() == 'credit'){
								vsId = velSetting.vsId;
								operationType = opType.wsOperationType; //Case-sensitive, so keep it as is from the response
								break;
							}
						} else if(opType.wsOperationType.toLowerCase() == 'sale'){
							vsId = velSetting.vsId;
							operationType = opType.wsOperationType; //Case-sensitive, so keep it as is from the response
							break;
						}
					}
				}
			}
		}

		if(!String.isEmpty(vsId) && !String.isEmpty(operationType)){
			Map<String, String> bodyObj = ProfitStarsRequestBuilder.createBankLocationVelocityReqFromActionAndRecordId(action, id, bankId, product);
			System.debug('the record type is '+ recordType);
			ProfitStarsIntegration__c psi = getConfig(recordType, product);

			bodyObj.put('custServProviderId', (String) psi.get('EntityId__c'));
			bodyObj.put('request_email', (String) psi.get('Maintenance_Username__c'));
			bodyObj.put('vsid', vsId);
			bodyObj.put('operation_type', operationType);

			String reqBody = JSON.serialize(bodyObj);
			System.debug('*** reqBody '+ reqBody);

			//https://use4-cai.dm-us.informaticacloud.com/active-bpel/rt/VelocityRequest
			HttpRequest req = buildHttpRequest(reqBody, 'VelocityRequest');
			Http http = new Http();
			HTTPResponse resp = http.send(req);
			System.debug('resp.getBody: '+ resp.getBody());
		
			return resp.getBody();
		} else{
			throw new PSISException('No Velocity Id or Operation Type returned from ProfitStars.');
			return null;
		}
	}

	// An Other Request is used as a custom request to update an address, phone number, or any 
    // information other than a velocity, location, or bank account for an existing merchant.
	public String makeMaintOtherRequest(String action, Id id, String product) {
		Map<String, String> bodyObj = new Map<String, String>();

		if(action.toLowerCase() == 'return only account'){
			bodyObj = ProfitStarsRequestBuilder.createReturnOnlyBankReqFromActionAndRecordId(action, id, product);
		} else{
			bodyObj = ProfitStarsRequestBuilder.createMaintOtherReqFromActionAndRecordId(action, id, product);
		}
		
		System.debug('the record type is '+ recordType);
		ProfitStarsIntegration__c psi = getConfig(recordType, product);

		bodyObj.put('request_email', (String) psi.get('Maintenance_Username__c'));
		bodyObj.put('custServProviderId', (String) psi.get('EntityId__c')); //this is partner Id

		String reqBody = JSON.serialize(bodyObj);
		System.debug('*** reqBody '+ reqBody);

		HttpRequest req = new HttpRequest();

		//https://use4-cai.dm-us.informaticacloud.com/active-bpel/rt/OtherRequest
		req = buildHttpRequest(reqBody, 'OtherRequest');

		Http http = new Http();
		HTTPResponse resp = http.send(req);
		System.debug('resp.getBody: '+ resp.getBody());
	
		return resp.getBody();
	}

	/////////////////////////// Overridden RestClient methods ///////////////////

	/**
	 * Make a get request
	 * RestClient.get('http://www.google.com/', HeaderMap{'q', 'convenance'}, 'some body of text for unknown reason.')
	 * @param  url                      URL to post to
	 * @param  map<String,headers,body> Headers to use for request
	 * @param  body                     Body of Get request
	 * @return responseBody             String response body (JSON txt)
	 */
	/*public override String get(String url, Map<String, String> headers, String body) {
		if (url == null || url.trim() == '') {
			// Failsafe the URL if none is given.
			url = ProfitStarsUtils.ensureTrailingSlash(activeConfig.Url_domain__c) + ProfitStarsUtils.ensureTrailingSlash(activeConfig.PalId__c) + 'run';
		}
		this.afterTheFactConstructor(url, 'GET', headers, body);
		return this.responseBody;
	}*/

	/**
	 * Make a Post Request
	 * @param  url                      URL to post to
	 * @param  Map<String,headers,body> Headers to use for request
	 * @return                          String response body (JSON txt)
	 */
	/*public override String post(String url, Map<String, String> headers, String body) {

		for (String fieldName : headers.KeySet ()) {
			System.debug('BizSys_RK: FieldName : ' + fieldName + ' Field Value : ' + headers.get (fieldName));
		}

		this.afterTheFactConstructor(url, 'POST', headers, body);
		return this.responseBody;
	}

	/////////////////////////// Helper Methods //////////////////////////////////
	@testVisible
	private ps_GuidResp makeCallout(ProfitStarsRequestBuilder.ProfitStarsRequest bodyObj, String pal) {
		setStandardHeaders();
		System.debug('BizSys_RK the active config before call '+activeConfig);
		String url = ProfitStarsUtils.ensureTrailingSlash(activeConfig.Url_domain__c) + ProfitStarsUtils.ensureTrailingSlash(pal) + 'run';
		String bodyTxt = JSON.serialize(bodyObj);
		System.debug('the request text is '+ url + ' ' +bodyTxt);
		System.debug('the config user is '+activeConfig);
		ps_GuidResp guid_response = ps_GuidResp.parse(post(url, this.headers, bodyTxt));
		//log.error('Response is: ', guid_response, 'end response');
		System.debug('the response is '+guid_response);

		if (!guid_response.san_list.NameValueMap.containsKey('code')) {
			throw new PSISException('Failed to get a response code. Check logs for possible success. (this is likely a failure) ');
		}
		Integer statusCode = Integer.valueOf(guid_response.san_list.NameValueMap.get('code').trim());
		if (statusCode > 299 ||
				statusCode < 200) {
			throw new PSISException('Response code was: ' + guid_response.san_list.NameValueMap.get('code').trim() + ' which indicates a failure. Message is: ' +
															guid_response.san_list.NameValueMap.get('message').trim());
		}
		return guid_response;
	}*/

	/**
	 * ensures a stander set of headers, needed for profitstars integration
	 * are set and ready to go.
	 */
	/*private void setStandardHeaders() {
		// Accepts header
		this.headers.put('Accept', 'application/json');
		this.headers.put('Content-Type', 'application/json');
	}*/

	/**
	 * Sets the basic Auth header for initial guid post calls.
	 */
	/*private void setEnrollmentAuthHeader() {
		Blob headerValue = Blob.valueOf(this.activeConfig.Username__c + ':' + this.activeConfig.Password__c);
		String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
		this.headers.put('Authorization', authorizationHeader);
	}*/

	/**
	 * Sets the basic Auth header for initial guid post calls.
	 */
	/*private void setMaintAuthHeader() {
		Blob headerValue = Blob.valueOf(this.activeConfig.Username__c + ':' + this.activeConfig.Password__c);
		String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
		this.headers.put('Authorization', authorizationHeader);
	}*/
	
	//request #R151866 Updated to retrive record specific config type
	private ProfitStarsIntegration__c getConfig(String application, String product) {
		ProfitStarsIntegration__c psi = ProfitStarsUtils.getConfig(application, product); //request #R151866 Updated to retrive record specific config type
		if(psi == null)
		{
			throw new PSISException('No ProfitStarsIntegration__c records found. Unable to proceed with callouts');
		}
		this.activeConfig = psi;
		return psi;
	}

	private HttpRequest buildHttpRequest(String requestBody, String endpoint){
		String fullEndpoint = 'callout:ProfitStars_RiskForce/' + endpoint;
		System.debug('ProfitStars EndPoint: ' + fullEndpoint);
		HttpRequest newReq = new HttpRequest();
		newReq.setEndpoint(fullEndpoint);
		newReq.setMethod('POST');
		newReq.setBody(requestBody);
		newReq.setHeader('Authorization', 'Basic');
		newReq.setHeader('Content-Type','application/json');
		newReq.setTimeout(90000);
System.debug('ProfitStars Callout: ' + newReq);
		return newReq;
	}

	private ps_GuidResp.PS_Resp_Maint parseMaintResponse(String resBody){
		System.debug('Response body: ' + resBody);
		ps_GuidResp.PS_Resp_Maint parsed = (ps_GuidResp.PS_Resp_Maint) System.JSON.deserialize(resBody, ps_GuidResp.PS_Resp_Maint.class);
		System.debug('The parsed result is: ' + parsed);
		return parsed;
	}

}