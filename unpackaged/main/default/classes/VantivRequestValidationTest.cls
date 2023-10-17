@isTest
private class VantivRequestValidationTest {
/* SOLUNUS MODIFICATION TO PROD: 
    static testMethod void legalEntityValidationSuccess() 
    {
    	Boolean isFailure = false;
		Account a = VantivTestUtils.genAccount(true, 'MyCase Account');
		ValuePlus__c vp = VantivTestUtils.genValuePlus(true, a.Id, null, 'MyCase Payments');
		Bank_Account__c ba = VantivTestUtils.genBankAccount(true, vp.Id);
		
		VantivTestUtils.genCreateLegalEntity();
		VantivTestUtils.genTestSettings(true);
		VantivTestUtils.genRootElement();
		VantivTestUtils.genVantivEntityType();
		
		List<sObject> cSetting = new List<sObject>();
		cSetting.add(VantivTestUtils.addFieldToCustomSetting('LegalEntityCreateRequest', 'subQuery2', 'subQuery2', 'Bank_Account__c.AccountNo__c', '', false, true, 99998));
		cSetting.add(VantivTestUtils.addFieldToCustomSetting('LegalEntityCreateRequest', 'subQuery3', 'subQuery3', 'Bank_Account__c.routingNo__c', '111000025', true, true, 99997));
		insert cSetting;
		
		Map<String, sObject> requestFields = VantivUtils.getRequestFields('LegalEntityCreateRequest');
		
		Test.startTest();
		ValuePlus__c record = VantivRequestBuilder.getRecord(requestFields, 'LegalEntityCreateRequest', vp.Id);
		try
		{
			VantivRequestValidation.validate(record,requestFields, 'LegalEntityCreateRequest' );
		}
		catch(Exception e)
		{
			isFailure = true;
		}
		System.assert(!isFailure);
		Test.stopTest();
    }
    */
    static testMethod void legalEntityValidationException1() 
    {
    	Boolean isFailure = false;
		Account a = VantivTestUtils.genAccount(true, 'MyCase Account');
		ValuePlus__c vp = VantivTestUtils.genValuePlus(true, a.Id, null, 'MyCase Payments');
		
		VantivTestUtils.genCreateLegalEntity();
		VantivTestUtils.genTestSettings(true);
		VantivTestUtils.genRootElement();
		VantivTestUtils.genVantivEntityType();
		
		Map<String, sObject> requestFields = VantivUtils.getRequestFields('LegalEntityCreateRequest');
		
		Test.startTest();
		ValuePlus__c record = VantivRequestBuilder.getRecord(requestFields, 'LegalEntityCreateRequest', vp.Id);
		try
		{
			VantivRequestValidation validator = new VantivRequestValidation(record,requestFields, 'TestAction' );
		}
		catch(Exception e)
		{
			if(e.getMessage().containsIgnoreCase('TestAction'))
			{
				isFailure = true;
			}
		}
		System.assert(isFailure);
		Test.stopTest();
    }
    /* SOLUNUS MODIFICATION TO PROD: 
    static testMethod void legalEntityValidationException2() 
    {
    	Boolean isFailure = false;
		Account a = VantivTestUtils.genAccount(true, 'MyCase Account');
		ValuePlus__c vp = VantivTestUtils.genValuePlus(true, a.Id, null, 'MyCase Payments');
		vp.Vantiv_Onboarding_Status__c = 'Approved';
		update vp;
		
		VantivTestUtils.genCreateLegalEntity();
		VantivTestUtils.genTestSettings(true);
		VantivTestUtils.genRootElement();
		VantivTestUtils.genVantivEntityType();
		
		Map<String, sObject> requestFields = VantivUtils.getRequestFields('LegalEntityCreateRequest');
		
		Test.startTest();
		ValuePlus__c record = VantivRequestBuilder.getRecord(requestFields, 'LegalEntityCreateRequest', vp.Id);
		try
		{
			VantivRequestValidation validator = new VantivRequestValidation(record,requestFields, 'LegalEntityCreateRequest' );
		}
		catch(Exception e)
		{
			if(e.getMessage().containsIgnoreCase('Legal entity id unavailable'))
			{
				isFailure = true;
			}
		}
		System.assert(isFailure);
		Test.stopTest();
    }
	*/
    
    static testMethod void subMerchantValidationSuccess()
    {
    	Boolean isFailure = false;
    	Account a = VantivTestUtils.genAccount(true, 'MyCase Account');
		ValuePlus__c vp = VantivTestUtils.genValuePlusWithLegalId(true, a.Id, null, 'MyCase Payments');
		Bank_Account__c ba = VantivTestUtils.genBankAccount(true, vp.Id);
		
		VantivTestUtils.genCreateSubMerchant();
		VantivTestUtils.genTestSettings(true);
		
		Map<String, sObject> requestFields = VantivUtils.getRequestFields('SubMerchantCreateRequest');
		
		Test.startTest();
		Bank_Account__c record = VantivRequestBuilder.getBankRecord(requestFields, 'SubMerchantCreateRequest', ba.Id);
		try
		{
			VantivRequestValidation validator = new VantivRequestValidation(record,requestFields, 'SubMerchantCreateRequest' );
		}
		catch(Exception e)
		{
			isFailure = true;
		}
		System.assert(!isFailure);
		Test.stopTest();
    }
    
    static testMethod void subMerchantValidationException1()
    {
    	Boolean isFailure = false;
    	Account a = VantivTestUtils.genAccount(true, 'MyCase Account');
		ValuePlus__c vp = VantivTestUtils.genValuePlusWithLegalId(true, a.Id, null, 'MyCase Payments');
		Bank_Account__c ba = VantivTestUtils.genBankAccount(true, vp.Id);
		ba.Vantiv_Bank_Account_Onboarding_Status__c = 'Approved';
		update ba;
		
		VantivTestUtils.genCreateSubMerchant();
		VantivTestUtils.genTestSettings(true);
		
		Map<String, sObject> requestFields = VantivUtils.getRequestFields('SubMerchantCreateRequest');
		
		Test.startTest();
		Bank_Account__c record = VantivRequestBuilder.getBankRecord(requestFields, 'SubMerchantCreateRequest', ba.Id);
		try
		{
			VantivRequestValidation validator = new VantivRequestValidation(record,requestFields, 'SubMerchantCreateRequest' );
		}
		catch(Exception e)
		{
			if(e.getMessage().containsIgnoreCase('Legal Entity id and/or SubMerchant id is unavailable'))
			{
				isFailure = true;
			}
		}
		System.assert(isFailure);
		Test.stopTest();
    }
    
    static testMethod void subMerchantValidationException2()
    {
    	Boolean isFailure = false;
    	Account a = VantivTestUtils.genAccount(true, 'MyCase Account');
		ValuePlus__c vp = VantivTestUtils.genValuePlusWithLegalId(true, a.Id, null, 'MyCase Payments');
		Bank_Account__c ba = VantivTestUtils.genBankAccount(true, vp.Id);
		vp.CreditCard_Single_Trans_Amount__c = null;
		update vp;
		
		VantivTestUtils.genCreateSubMerchant();
		VantivTestUtils.genTestSettings(true);
		
		Map<String, sObject> requestFields = VantivUtils.getRequestFields('SubMerchantCreateRequest');
		
		Test.startTest();
		Bank_Account__c record = VantivRequestBuilder.getBankRecord(requestFields, 'SubMerchantCreateRequest', ba.Id);
		try
		{
			VantivRequestValidation validator = new VantivRequestValidation(record,requestFields, 'SubMerchantCreateRequest');
		}
		catch(Exception e)
		{
			if(e.getMessage().containsIgnoreCase('Failed to find a value for'))
			{
				isFailure = true;
			}
		}
		System.assert(isFailure);
		Test.stopTest();
    }
}