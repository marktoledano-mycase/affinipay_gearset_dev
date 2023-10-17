@isTest
public class TestGiactHttpMock implements HttpCalloutMock {

	public static Map<String,String> GIACT_JSON_RESPONSE_MAP = new Map<String,String>();
	static {
	GIACT_JSON_RESPONSE_MAP.put('ACK_GOOD_RESPONSE_JSON', 
		'{"ItemReferenceId":5000984910,"CreatedDate":"2017-10-06T12:35:05.7040296-05:00","ErrorMessage":null,"VerificationResponse":6,"AccountResponseCode":13,"BankName":"WELLS FARGO BANK NA (ARIZONA)","AccountAddedDate":null,"AccountLastUpdatedDate":null,"AccountClosedDate":null,"BankAccountType":null,"VoidedCheckImage":null,"FundsConfirmationResult":null,"CustomerResponseCode":null,"MatchedPersonData":null,"ConsumerAlertMessages":null,"MatchedBusinessData":null,"OfacListPotentialMatches":null,"GIdentifyKbaResult":null,"EmailAddressInformationResult":null,"IpAddressInformationResult":null,"DomainRegistry":null,"MobileVerifyResult":null,"MobileIdentifyResult":null,"MobileLocationResult":null,"PhoneIntelligenceResult":null}');
	GIACT_JSON_RESPONSE_MAP.put('ACK_ERR_400_RESPONSE_JSON', '{"errors":[{"status":"400","title":"Invalid Inquiry","detail":"UniqueId cannot be longer than 50 characters."}]}');
	GIACT_JSON_RESPONSE_MAP.put('ACK_GOOD_AUTHERROR_RESPONSE_JSON', '{"ItemReferenceId":5000984792,"CreatedDate":"2017-10-06T11:33:58.6260561-05:00","ErrorMessage":null,"VerificationResponse":8,"AccountResponseCode":19,"BankName":"WELLS FARGO BANK NA (ARIZONA)","AccountAddedDate":null,"AccountLastUpdatedDate":null,"AccountClosedDate":null,"BankAccountType":null,"VoidedCheckImage":null,"FundsConfirmationResult":null,"CustomerResponseCode":null,"MatchedPersonData":null,"ConsumerAlertMessages":null,"MatchedBusinessData":null,"OfacListPotentialMatches":null,"GIdentifyKbaResult":null,"EmailAddressInformationResult":null,"IpAddressInformationResult":null,"DomainRegistry":null,"MobileVerifyResult":null,"MobileIdentifyResult":null,"MobileLocationResult":null,"PhoneIntelligenceResult":null}');
	}

    protected Integer code;
    protected String status;
    protected String requestCode;
    protected String requestMessage;
    protected String body;

    public TestGiactHttpMock(String bodyKey) {
        this.code = 200;
        this.status = 'Success';
        this.body = GIACT_JSON_RESPONSE_MAP.get(bodyKey);
	}
	
    public TestGiactHttpMock(Integer httpCode, 
    						String httpStatus, 
    						String requestCode,
    						String requestMessage) {
        this.code = httpCode;
        this.status = httpStatus;
        this.body = '{"code":"'+ requestCode + '","message":"' + requestMessage + '"}';
	}
	public HTTPResponse respond(HTTPRequest req) {
	    HttpResponse resp = new HttpResponse();
	    resp.setStatusCode(code);
	    resp.setStatus(status);
	    resp.setBody(body);
	    return resp;
	}


}