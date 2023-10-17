global class VantivCertificationCheck extends RestClient{

	public class VantivIntergrationServiceException extends Exception {}
	public VantivPostResponse vantivPostResponse = new VantivPostResponse();
	public vantiv_integration__c activeConfig;
	public static String recordType;
	public static String legalEntityId;
	public static String subMerchantId;

	@testVisible public static String VantivContentType = System.Label.VantivContentType;


	public static String createGetRequestBody(String action, String id, String sub_id)
	{
		if(action.containsIgnoreCase('submerchant')&&sub_id!=null&&sub_id!='')
		{
			 VantivCertificationCheck.recordType = 'MyCase Payments';
			 VantivCertificationCheck.legalEntityId = id;
			 VantivCertificationCheck.subMerchantId = sub_id;
		}
		else
		{
			VantivCertificationCheck.recordType = 'MyCase Payments';
			VantivCertificationCheck.legalEntityId = id;
		}
		
		
		return null;
	}
	

	public void getConfig(String Application)
	{
		this.activeConfig = vantiv_integration__c.getInstance(Application);
		if(this.activeConfig == null)
		{
			throw new VantivIntergrationServiceException('No vantiv_integration__c records found. Unable to proceed with callouts');
		}
	}

	public vantivPostResponse makeGetRequest(String action, String id, String sub_id)
	{
		VantivCertificationCheck.createGetRequestBody(action, id, sub_id);
		getConfig(recordType);
		
		makeCallOut(null, 'GET', action);
		return this.vantivPostResponse;
		
	}

	private void setHeaders()
	{

		//for prod
		this.headers.put('Accept', VantivContentType);
		this.headers.put('Content-Type', VantivContentType);
		//for sandbox
		// this.headers.put('Accept',  'application/com.vantivprelive.payfac-v13+xml');
		// this.headers.put('Content-Type',  'application/com.vantivprelive.payfac-v13+xml');
		
		Blob headerValue = Blob.valueOf(this.activeConfig.Username__c+':'+this.activeConfig.Password__c); 
		String authorizationHeader = 'Basic ' + Encodingutil.base64Encode(headerValue);
		
		this.headers.put('Authorization',authorizationHeader);
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

}