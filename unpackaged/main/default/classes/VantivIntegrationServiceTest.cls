@isTest
private class VantivIntegrationServiceTest {

    static testMethod void makeRequestforActionException1() {
		VantivIntegrationService service = new VantivIntegrationService();
		Boolean receivedException = false;
		Account a = VantivTestUtils.genAccount(true, 'MyCase Account');
		ValuePlus__c vp = VantivTestUtils.genValuePlus(true, a.Id, null, 'MyCase Payments');
		
		Test.startTest();
		try
		{
			VantivPostResponse vantivPostResponse = service.makeRequestforAction('ErrorAction', vp.Id);
		}
		catch(Exception e)
		{
			System.debug(e.getMessage());
			if(e.getMessage().containsIgnoreCase('ErrorAction'))
			{
				receivedException = true;
			}
		}
		System.assert(receivedException);
		Test.stopTest();
    }
    
    static testMethod void makeRequestforActionException2() {
		VantivIntegrationService service = new VantivIntegrationService();
		Boolean receivedException = false;
		Account a = VantivTestUtils.genAccount(true, 'MyCase Account');
		ValuePlus__c vp = VantivTestUtils.genValuePlus(true, a.Id, null, 'MyCase Payments');
		
		Test.startTest();
		try
		{
			VantivPostResponse vantivPostResponse = service.makeRequestforAction('TestAction', null);
		}
		catch(Exception e)
		{
			System.debug(e.getMessage());
			if(e.getMessage().containsIgnoreCase('Invalid Action or ID'))
			{
				receivedException = true;
			}
		}
		System.assert(receivedException);
		Test.stopTest();
    }
    
    static testmethod void makeLegalEntityRequestCreate(){
    	VantivIntegrationService service = new VantivIntegrationService();
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
		VantivPostResponse vantivPostResponse = service.makeRequestforAction('LegalEntityCreateRequest', vp.Id);
		System.debug(vantivPostResponse);
		System.assert(vantivPostResponse.isSuccess);
		Test.stopTest();
	}
	
	static testmethod void makeLegalEntityRequestUpdate(){
		VantivIntegrationService service = new VantivIntegrationService();
		Account a = VantivTestUtils.genAccount(true, 'MyCase Account');
		ValuePlus__c vp = VantivTestUtils.genValuePlusWithLegalId(true, a.Id, null, 'MyCase Payments');
		
		VantivTestUtils.genTestSettings(true);
		VantivTestUtils.genUpdateLegalEntity();
		VantivTestUtils.genRootElement();
		VantivTestUtils.genVantivEntityType();
		
		Test.setMock(HttpCalloutMock.class, new VantivMockResponse(VantivTestUtils.legalEntitySuccessResponse, 200));
		
		Test.startTest();
		VantivPostResponse vantivPostResponse = service.makeRequestforAction('LegalEntityUpdateRequest', vp.Id);
		System.debug(vantivPostResponse);
		System.assert(vantivPostResponse.isSuccess);
		Test.stopTest();
	}
	
	
	static testmethod void makeSubMerchantRequestCreate(){
		VantivIntegrationService service = new VantivIntegrationService();
		Account a = VantivTestUtils.genAccount(true, 'MyCase Account');
		ValuePlus__c vp = VantivTestUtils.genValuePlusWithLegalId(true, a.Id, null, 'MyCase Payments');
		Bank_Account__c ba = VantivTestUtils.genBankAccount(true, vp.Id);
		
		VantivTestUtils.genTestSettings(true);
		VantivTestUtils.genCreateSubMerchant();
		VantivTestUtils.genRootElement();
		//VantivTestUtils.genVantivEntityType();
		
		Test.setMock(HttpCalloutMock.class, new VantivMockResponse(VantivTestUtils.subMerchantSuccessResponse, 200));
		
		Test.startTest();
		VantivPostResponse vantivPostResponse = service.makeRequestforAction('SubMerchantCreateRequest', ba.Id);
		System.debug(vantivPostResponse);
		System.assert(vantivPostResponse.isSuccess);
		Test.stopTest();
	}
	
	static testmethod void makeSubMerchantRequestUpdate(){
		VantivIntegrationService service = new VantivIntegrationService();
		Account a = VantivTestUtils.genAccount(true, 'MyCase Account');
		ValuePlus__c vp = VantivTestUtils.genValuePlusWithLegalId(true, a.Id, null, 'MyCase Payments');
		Bank_Account__c ba = VantivTestUtils.genBankAccountWithSubmerchantId(true, vp.Id);
		
		VantivTestUtils.genTestSettings(true);
		VantivTestUtils.genUpdateSubMerchant();
		VantivTestUtils.genRootElement();
		
		Test.setMock(HttpCalloutMock.class, new VantivMockResponse(VantivTestUtils.subMerchantSuccessResponse, 200));
		
		Test.startTest();
		VantivPostResponse vantivPostResponse = service.makeRequestforAction('SubMerchantUpdateRequest', ba.Id);
		System.debug(vantivPostResponse);
		System.assert(vantivPostResponse.isSuccess);
		Test.stopTest();
	}
	
	static testmethod void makeGetRequestEntity(){
		VantivIntegrationService service = new VantivIntegrationService();
		Account a = VantivTestUtils.genAccount(true, 'MyCase Account');
		ValuePlus__c vp = VantivTestUtils.genValuePlusWithLegalId(true, a.Id, null, 'MyCase Payments');
		
		VantivTestUtils.genTestSettings(true);
		VantivTestUtils.genCreateLegalEntity();
		VantivTestUtils.genRootElement();
		VantivTestUtils.genVantivEntityType();
		
		Test.setMock(HttpCalloutMock.class, new VantivMockResponse(VantivTestUtils.legalEntitySuccessResponse, 200));
		
		Test.startTest();
		VantivPostResponse vantivPostResponse = service.makeRequestforAction('LegalEntityRetrieveRequest', vp.Id);
		System.debug(vantivPostResponse);
		System.assertEquals('Approved',vantivPostResponse.responseDescription);
		Test.stopTest();
	}
	/* SOLUNUS MODIFICATION TO PROD: 
	static testmethod void makeCallOutException(){
		VantivIntegrationService service = new VantivIntegrationService();
		Account a = VantivTestUtils.genAccount(true, 'MyCase Account');
		ValuePlus__c vp = VantivTestUtils.genValuePlus(true, a.Id, null, 'MyCase Payments');
		
		VantivTestUtils.genTestSettings(true);
		VantivTestUtils.genCreateLegalEntity();
		VantivTestUtils.genRootElement();
		VantivTestUtils.genVantivEntityType();
		
		Test.setMock(HttpCalloutMock.class, new VantivMockResponse(VantivTestUtils.legalEntityFailedResponse, 400));
		
		Test.startTest();
		try
		{
			VantivPostResponse vantivPostResponse = service.makeRequestforAction('LegalEntityCreateRequest', vp.Id);
			System.debug(vantivPostResponse);
		}
		catch(Exception e)
		{
			System.assert(e.getMessage().containsIgnoreCase('Response code was 400 which indicates a failure'));
		}
		Test.stopTest();
	}
	*/
	
	static testmethod void getConfigTest()
	{
		VantivIntegrationService service = new VantivIntegrationService();
		VantivTestUtils.genTestSettings(true);
		Boolean isFirstAvailable = false;
		Boolean isSecondFailed = true;
		
		Test.startTest();
		try
		{
			service.getConfig('MyCase Payments');
			if(service.activeConfig.Name == 'MyCase Payments')
			{
				isFirstAvailable = true;
			}
			
			service.getConfig('Test');
		}
		catch(Exception e)
		{
			if(e.getMessage().containsIgnoreCase('No vantiv_integration__c records found'))
			{
				isSecondFailed = true;
			}
		}
		Test.stopTest();
		
	}

	static testmethod void testAuditlog () {
		Test.startTest();
		VantivUtils.createAuditLog('a1l8000000BqvIR',
			'Pass',
			'',
			'',
			'',
			'',
			true
			);
		Test.stopTest();
	}
}