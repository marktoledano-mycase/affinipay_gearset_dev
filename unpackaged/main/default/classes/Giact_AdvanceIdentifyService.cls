/*
* Test Class: GiactVerifyServiceTest
*/
public with sharing class Giact_AdvanceIdentifyService {

	/***Avoid the Static variables as much as possible***/

	// OAUTH COMPONENTS
	private String body;
	private String bodyHash;
	private String nonce;
	private String signatureMethod;
	private String timestamp;
	private String version;

	// Default Constructor
	public Giact_AdvanceIdentifyService() {}

	public GIACTIntegrationService.PersonSearchResultRecords  gIdentifyAdvanceInquiry (GIACTRestRequestBuilder.GIACTRequestAPMIdentify bodyObj) {
		
		GIACT_GIdentifyRequest inquiryRequest = new GIACT_GIdentifyRequest (bodyObj);
		GIACTIntegrationService.PersonSearchResultRecords identifyPersonSearchResponse;

		body = inquiryRequest.getPrincipalRequestXMLBody ();
		Http http = new Http();

        try {
			HttpResponse res = http.send(getHttpRequest (body));
	    	String responseResult = res.getBody();
	    	
	    	Giact_AdvancedIdentifyResponse identifyResponse = new Giact_AdvancedIdentifyResponse ();
	    	System.debug(LoggingLevel.DEBUG, '*** GIACT Identify Advance Response: ' + responseResult);
			identifyPersonSearchResponse = identifyResponse.parsePersonIdentity(res);
			if(identifyPersonSearchResponse != null){
	    		identifyPersonSearchResponse.xmlRequest = body;
				identifyPersonSearchResponse.xmlResponse = responseResult;
			}

		} catch (System.CalloutException e) {
			System.debug(LoggingLevel.Error, 'Error during GIACT Identify Advance Request - ' + e);
			throw new Giact_AdvanceIdentifyServiceException ('Error during GIACT Identify Advance Request - ' + e);

		}  

		return identifyPersonSearchResponse;
	}	


	public GIACTIntegrationService.BusinessSearchResultRecords  gIdentifyBusinessAdvanceInquiry (GIACTRestRequestBuilder.GIACTRequestAPMIdentify bodyObj) {
		
		GIACT_GIdentifyRequest inquiryRequest = new GIACT_GIdentifyRequest (bodyObj);
    	GIACTIntegrationService.BusinessSearchResultRecords identifyBusinessSearchResponse;
		body = inquiryRequest.getBusinessRequestXMLBody ();

		Http http = new Http();

        try {
			//HttpRequest request = getHttpRequest(body);
			//request.setHeader('SOAPAction','http://www.giact.com/api/identificationservices/v1.0/BusinessComboSearch');
			//HttpResponse res = http.send(request);
			HttpResponse res = http.send(getHttpRequest(body));
	    	Giact_AdvancedIdentifyResponse identifyResponse = new Giact_AdvancedIdentifyResponse (); 
	    	System.debug(LoggingLevel.DEBUG, '*** GIACT Identify Advance Response: ' + res.getBody());
			identifyBusinessSearchResponse = identifyResponse.parseBusinessIdentity(res);
			if(identifyBusinessSearchResponse != null){
	    		identifyBusinessSearchResponse.xmlRequest = body;
				identifyBusinessSearchResponse.xmlResponse = res.getBody();
			}

		} catch (System.CalloutException e) {
			System.debug(LoggingLevel.Error, 'Error during GIACT Identify Advance Request - ' + e);
			throw new Giact_AdvanceIdentifyServiceException ('Error during GIACT Identify Advance Request - ' + e);

		}  

		return identifyBusinessSearchResponse;
	}

	private HttpRequest getHttpRequest (String body) {
		System.debug('*** Advanced Request Body - ' + body);

		String authHeader = '';
		String userName = 'JIK7-KNTS-AZWC-7R7TBD'; 		/*Review*/
		String password = 'QP-_SYigAtnE6'; 						/*Review*/
		Blob headerValue = Blob.valueOf(username + ':' + password);

		Http http = new Http();
        HttpRequest req = new HttpRequest();

		authHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        //@VR: As per request R1812662, setting the timeout to 2 minutes to prevent the timing out issue
        req.setTimeout(120000);
        req.setEndpoint('https://api.giact.com/IdentificationServices/SOAP/IDAdvancedService.asmx');
        //req.setEndpoint('http://www.giact.com/api/identificationservices/v1.0"');
        req.setMethod('POST');
        req.setBody(body);
        req.setHeader('Authorization', authHeader);
        req.setHeader('content-type', 'text/xml; charset=UTF-8');
        req.setHeader('content-length', String.valueOf(body.length()));

        System.debug('***Advance Indentify Service - Request Payload - '  + req);

        return req;
	}

	public class Giact_AdvanceIdentifyServiceException extends Exception  {	}	
}