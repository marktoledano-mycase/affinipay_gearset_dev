@isTest
private class VantivPostResponseTest {

    static testMethod void testLegalEntitySuccessResponse() {
    	VantivPostResponse vantivResponse = new VantivPostResponse();
    	
    	HttpResponse response = new HttpResponse();
    	response.setStatusCode(200);
    	response.setBody(VantivTestUtils.legalEntitySuccessResponse);
    	
    	Test.startTest();
    	vantivResponse.parse(response);
    	System.debug(vantivResponse.toString());
    	System.assert(vantivResponse.isSuccess);
    	Test.stopTest();
    }
    
    static testMethod void testLegalEntityErrorResponse() {
    	VantivPostResponse vantivResponse = new VantivPostResponse();
    	
    	HttpResponse response = new HttpResponse();
    	response.setStatusCode(200);
    	response.setBody(VantivTestUtils.legalEntityFailedResponse);
    	
    	Test.startTest();
    	vantivResponse.parse(response);
    	System.debug(vantivResponse.toString());
    	System.assert(!vantivResponse.isSuccess);
    	Test.stopTest();
    }
    
    static testMethod void testLegalEntityDuplicateResponse() {
    	VantivPostResponse vantivResponse = new VantivPostResponse();
    	
    	HttpResponse response = new HttpResponse();
    	response.setStatusCode(200);
    	response.setBody(VantivTestUtils.legalEntityDuplicateResponse);
    	
    	Test.startTest();
    	vantivResponse.parse(response);
    	System.debug(vantivResponse.toString());
    	System.assert(vantivResponse.isDuplicate);
    	Test.stopTest();
    }
    
    static testMethod void testSubMerchantSuccessResponse() {
    	VantivPostResponse vantivResponse = new VantivPostResponse();
    	
    	HttpResponse response = new HttpResponse();
    	response.setStatusCode(200);
    	response.setBody(VantivTestUtils.subMerchantSuccessResponse);
    	
    	Test.startTest();
    	vantivResponse.parse(response);
    	System.debug(vantivResponse.toString());
    	System.assert(vantivResponse.subMerchantId != null);
    	Test.stopTest();
    }
    
    static testMethod void testException() {
    	VantivPostResponse vantivResponse = new VantivPostResponse();
    	Boolean isException = false;
    	HttpResponse response = new HttpResponse();
    	response.setStatusCode(200);
    	response.setBody(VantivTestUtils.subMerchantSuccessResponse);
    	
    	Test.startTest();
    	try
    	{
    		vantivResponse.parse(null);
    	}
    	catch(Exception e)
    	{
    		if(e.getMessage().containsIgnoreCase('An empty response was received'))
    		{
    			isException = true;
    		}
    	}
    	System.assert(isException);
    	Test.stopTest();
    }
    
}