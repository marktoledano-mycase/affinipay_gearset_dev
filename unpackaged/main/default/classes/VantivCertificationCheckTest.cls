@isTest
public with sharing class VantivCertificationCheckTest {
    static testMethod void VantivCertificationCheckTest() {    	VantivCertificationCheck service = new VantivCertificationCheck();
		Account a = VantivTestUtils.genAccount(true, 'Customer');
		ValuePlus__c vp = VantivTestUtils.genValuePlus(true, a.Id, null, 'MyCase Payments');
		
		VantivTestUtils.genTestSettings(true);
		VantivTestUtils.genCreateLegalEntity();
		VantivTestUtils.genRootElement();
		VantivTestUtils.genVantivEntityType();
		VantivTestUtils.genCreatePrincipal2Entity ();
		VantivTestUtils.genCreatePrincipal3Entity ();
		VantivTestUtils.genCreatePrincipal4Entity ();
		
		Test.setMock(HttpCalloutMock.class, new VantivMockResponse(VantivTestUtils.legalEntitySuccessResponse, 200));
		
		Test.startTest();
		VantivPostResponse vantivPostResponse = service.makeGetRequest('LegalEntityRetrieveRequest','82916971912152256', null);
		System.debug(vantivPostResponse);
		System.assert(vantivPostResponse.isSuccess);
	
		VantivPostResponse vantivPostResponse2 = service.makeGetRequest('SubMerchantRetrieveRequest','82916971912152256','82917128596111582');
		System.debug(vantivPostResponse2);
		System.assert(vantivPostResponse2.isSuccess);
		Test.stopTest();

    }
}