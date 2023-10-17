/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This is the class containing the methods to facilitate the Vantiv/WorldPay Integration.
* 
* @test           VantivIntegrationServiceTest
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Rohit Malik
* @version        1.0
* @created        2016-02-23
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* v1.0            rohit.malik@appfolio.com
* 2016-02-23      Initial Create
*
* v1.1			  vijay.reddy@appfolio.com
* 2019-10-11	  Added sandbox headers
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
public with sharing virtual class VantivIntegrationService extends RestClient
{
	public class VantivIntergrationServiceException extends Exception {}
	public String action='';
	public ID id ;
	public VantivPostResponse vantivPostResponse = new VantivPostResponse();
	
	public vantiv_integration__c activeConfig;
	@testVisible public static String VantivContentType = System.Label.VantivContentType;
	public static String recordType;
	public static String legalEntityId;
	public static String subMerchantId;
	
	public VantivPostResponse makeRequestforAction(String action, Id id)
	{
		System.debug(action);
		System.debug(Id);
		if(VantivUtils.isNullOrBlank(action) || VantivUtils.isNullOrBlank(Id))
		{
			throw new VantivIntergrationServiceException('Invalid Action or ID. Action: '+action+' Id: '+id);
		}
		
		if('LegalEntityCreateRequest'.equalsIgnoreCase(action) || 'LegalEntityUpdateRequest'.equalsIgnoreCase(action))
		{
			return makeLegalEntityRequest(action, id);
		}
		else if('SubMerchantCreateRequest'.equalsIgnoreCase(action) || 'SubMerchantUpdateRequest'.equalsIgnoreCase(action))
		{
			return makeSubMerchantRequest(action, id);
		}
		else if('LegalEntityRetrieveRequest'.equalsIgnoreCase(action) || 'SubMerchantRetrieveRequest'.equalsIgnoreCase(action))
		{
			return makeGetRequest(action, id);
		}
		else
		{
			throw new VantivIntergrationServiceException('Invalid Action : '+action);
		}
	}
	
	public VantivPostResponse makeLegalEntityRequest(String action, Id id)
	{
		String requestBody = VantivRequestBuilder.createRequestBody(action, Id);
		System.debug('request body '+requestBody);
		System.debug('Record Type is '+ recordType);
		getConfig(recordType);
		
		if(action.containsIgnoreCase('Update'))
		{
			makeCallOut(requestBody, 'PUT', action);
			return this.vantivPostResponse;
		}
		makeCallOut(requestBody, 'POST', action);
		ValuePlus__c vp = [Select Id,
							MC_Principal_1_First_Name__c,
							MC_Principal_1_Last_Name__c,
							MC_Principal_1_SSN__c,
							MC_Principal_2_First_Name__c,
							MC_Principal_2_Last_Name__c,
							MC_Principal_2_SSN__c,
							MC_Principal_3_First_Name__c,
							MC_Principal_3_Last_Name__c,
							MC_Principal_3_SSN__c,
							MC_Principal_4_First_Name__c,
							MC_Principal_4_Last_Name__c,
							Principal_4_SSN__c,																					
							Name from ValuePlus__c Where id = :id];

		System.debug('Vantiv Response - ' + this.vantivPostResponse.toString());
		String entityId = this.vantivPostResponse.legalEntityId;
		if (!String.isEmpty(entityId)) {
			for (integer i=2; i<=4; i++){
				try{
					if (i==2) {

						if (!String.isEmpty(vp.MC_Principal_2_First_Name__c) &&
							!String.isEmpty(vp.MC_Principal_2_Last_Name__c) &&
							!String.isEmpty(vp.MC_Principal_2_SSN__c)) {
							requestBody='';
							requestBody = VantivRequestBuilder.createPrincipalRequestBody('LegalEntityPrincipalCreateRequest', Id);
							System.debug('Request Body Rohit Principal 1 - ' + requestBody);
							VantivIntegrationService.legalEntityId = entityId;
							makePrincipalCallOut(requestBody, 'POST', 'LegalEntityPrincipalCreateRequest');
						} else {
							break;
						}

					} else if (i==3) {
						if (!String.isEmpty(vp.MC_Principal_3_First_Name__c) &&
							!String.isEmpty(vp.MC_Principal_3_Last_Name__c) &&
							!String.isEmpty(vp.MC_Principal_3_SSN__c)) {
							requestBody='';
							requestBody = VantivRequestBuilder.createPrincipalRequestBody('LegalEntityPrincipal3Create', Id);
							System.debug('Request Body Rohit Principal 1 - ' + requestBody);
							VantivIntegrationService.legalEntityId = entityId;
							makePrincipalCallOut(requestBody, 'POST', 'LegalEntityPrincipal3Create');
							
						} else {
							break;
						}

					} else if (i==4) {
						if (!String.isEmpty(vp.MC_Principal_4_First_Name__c) &&
							!String.isEmpty(vp.MC_Principal_4_Last_Name__c) &&
							!String.isEmpty(vp.Principal_4_SSN__c)) {
							requestBody='';
							requestBody = VantivRequestBuilder.createRequestBody('LegalEntityPrincipal4Create', Id);
							System.debug('Request Body Rohit Principal 1 - ' + requestBody);
							VantivIntegrationService.legalEntityId = entityId;
							makePrincipalCallOut(requestBody, 'POST', 'LegalEntityPrincipal4Create');
						} else {
							break;
						}
					}

				} catch (Exception e) {
					System.debug (e.getMessage());
					 SystemExceptionLogger.insertSystemExceptionLogEntry(e, 'VantivIntegrationService', 'makeLegalEntityRequest', SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, e.getMessage(), false);
					break;
				}
			}

		}
		
		return this.vantivPostResponse;
	}
	
	public VantivPostResponse makeSubMerchantRequest(String action, Id id)
	{
		String requestBody = VantivRequestBuilder.createSubMerchantRequestBody(action, Id);
		System.debug('request body '+requestBody);
		System.debug('Record Type is '+ recordType);
		getConfig(recordType);
		if(action.containsIgnoreCase('update'))
		{
			makeCallOut(requestBody, 'PUT', action);
			return this.vantivPostResponse;
		}
		makeCallOut(requestBody, 'POST', action);
		return this.vantivPostResponse;
	}
	
	public vantivPostResponse makeGetRequest(String action, Id id)
	{
		VantivRequestBuilder.createGetRequestBody(action, Id);
		getConfig(recordType);
		
		makeCallOut(null, 'GET', action);
		return this.vantivPostResponse;
		
	}

	private void makePrincipalCallOut(String request, String requestType, String action)
	{
		setHeaders();
		String endPoint = VantivUtils.ensureTrailingSlash(this.activeConfig.Endpoint__c)+VantivIntegrationService.legalEntityId+'/principal';
		this.afterTheFactConstructor(endPoint, requestType, this.headers, request);
		//this.vantivPostResponse.parse(this.response);
		
		if(this.response != null && (this.response.getStatusCode() > 299 ||
										this.response.getStatusCode() < 200))
		{
			throw new VantivIntergrationServiceException('Response code was '+this.response.getStatusCode()+' which indicates a failure. The message is '+
															vantivPostResponse.errors);
		}
		System.debug(this.vantivPostResponse.toString());
	}
	
	private void makeCallOut(String request, String requestType, String action)
	{
		setHeaders();
		String endPoint = VantivUtils.getEndPoint(this.activeConfig.Endpoint__c, action, legalEntityId, subMerchantId);
		system.debug('Request Endpoint: ' + endPoint + ' Request Header: ' + this.headers + 'Request Body: ' + request);
		this.afterTheFactConstructor(endPoint, requestType, this.headers, request);
		this.vantivPostResponse.parse(this.response);
		
		if(this.response != null && (this.response.getStatusCode() > 299 ||
										this.response.getStatusCode() < 200))
		{
			throw new VantivIntergrationServiceException('Response code was '+this.response.getStatusCode()+' which indicates a failure. The message is '+
															vantivPostResponse.errors);
		}
		System.debug(this.vantivPostResponse.toString());
	}
	
	private void setHeaders()
	{
		/*this.headers.put('Accept',  'application/com.litle.psp-v11+xml');
		this.headers.put('Content-Type',  'application/com.litle.psp-v11+xml');*/
		//for prod
		this.headers.put('Accept',  VantivContentType);
		this.headers.put('Content-Type',  VantivContentType);
		//for sandbox
		// this.headers.put('Accept',  'application/com.vantivprelive.payfac-v13+xml');
		// this.headers.put('Content-Type',  'application/com.vantivprelive.payfac-v13+xml');
		
		Blob headerValue = Blob.valueOf(this.activeConfig.Username__c+':'+this.activeConfig.Password__c); 
		String authorizationHeader = 'Basic ' + Encodingutil.base64Encode(headerValue);
		
		this.headers.put('Authorization',authorizationHeader);
	}
	
	public void getConfig(String Application)
	{
		this.activeConfig = vantiv_integration__c.getInstance(Application);
		if(this.activeConfig == null)
		{
			throw new VantivIntergrationServiceException('No vantiv_integration__c records found. Unable to proceed with callouts');
		}
	}
}