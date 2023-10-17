@isTest
private class VantivRequestBuilderTest {
 /* SOLUNUS MODIFICATION TO PROD: 
    static testMethod void createRequestBodyTest() {
		Account a = VantivTestUtils.genAccount(true, 'MyCase Account');
		ValuePlus__c vp = VantivTestUtils.genValuePlus(true, a.Id, null, 'MyCase Payments');
		
		//VantivTestUtils.genTestSettings(true);
		VantivTestUtils.genCreateLegalEntity();
		VantivTestUtils.genRootElement();
		VantivTestUtils.genVantivEntityType();
		
		Test.setMock(HttpCalloutMock.class, new VantivMockResponse(VantivTestUtils.legalEntitySuccessResponse, 200));
		
		Test.startTest();
		String requestBody = VantivRequestBuilder.createRequestBody('LegalEntityCreateRequest', vp.Id);
		System.debug(requestBody);
		System.assert(requestBody != null);
		Test.stopTest();
    }
    */
    static testmethod void createSubMerchantRequestBodyTest(){
		Account a = VantivTestUtils.genAccount(true, 'MyCase Account');
		ValuePlus__c vp = VantivTestUtils.genValuePlusWithLegalId(true, a.Id, null, 'MyCase Payments');
		Bank_Account__c ba = VantivTestUtils.genBankAccount(true, vp.Id);
		
		VantivTestUtils.genTestSettings(true);
		VantivTestUtils.genCreateSubMerchant();
		VantivTestUtils.genRootElement();
		//VantivTestUtils.genVantivEntityType();
		
		Test.setMock(HttpCalloutMock.class, new VantivMockResponse(VantivTestUtils.subMerchantSuccessResponse, 200));
		
		Test.startTest();
		String requestBody = VantivRequestBuilder.createSubMerchantRequestBody('SubMerchantCreateRequest', ba.Id);
		System.debug(requestBody);
		System.assert(requestBody != null);
		Test.stopTest();
	}
	
	static testmethod void createGetRequestBodyTest(){
		Account a = VantivTestUtils.genAccount(true, 'MyCase Account');
		ValuePlus__c vp = VantivTestUtils.genValuePlusWithLegalId(true, a.Id, null, 'MyCase Payments');
		Bank_Account__c ba = VantivTestUtils.genBankAccountWithSubmerchantId(true, vp.Id);
		
		//VantivTestUtils.genTestSettings(true);
		VantivTestUtils.genCreateSubMerchant();
		VantivTestUtils.genRootElement();
		
		Test.setMock(HttpCalloutMock.class, new VantivMockResponse(VantivTestUtils.subMerchantSuccessResponse, 200));
		
		Test.startTest();
		//VantivButtons.callSubMerchantCreateReq(ba.Id);
		String requestBody = VantivRequestBuilder.createGetRequestBody('SubMerchantRetrieveRequest', ba.Id);
		System.debug(requestBody);
		System.assert(requestBody == null);
		Test.stopTest();
	}
	
	static testmethod void createGetRequestBodyTest2(){
		Account a = VantivTestUtils.genAccount(true, 'MyCase Account');
		ValuePlus__c vp = VantivTestUtils.genValuePlusWithLegalId(true, a.Id, null, 'MyCase Payments');
		
		//VantivTestUtils.genTestSettings(true);
		VantivTestUtils.genCreateLegalEntity();
		VantivTestUtils.genRootElement();
		VantivTestUtils.genVantivEntityType();
		
		Test.setMock(HttpCalloutMock.class, new VantivMockResponse(VantivTestUtils.legalEntitySuccessResponse, 200));
		
		Test.startTest();
		String requestBody = VantivRequestBuilder.createGetRequestBody('LegalEntityRetrieveRequest', vp.Id);
		System.debug(requestBody);
		System.assert(requestBody == null);
		Test.stopTest();
	} 
	
	static testmethod void BuildQueryFromRequestFieldsWithSub()
	{
		VantivTestUtils.genCreateLegalEntity();
		
		List<sObject> cSetting = new List<sObject>();
		cSetting.add(VantivTestUtils.addFieldToCustomSetting('LegalEntityCreateRequest', 'subQuery2', 'subQuery2', 'Bank_Account__c.AccountNo__c', '', true, true, 99998));
		cSetting.add(VantivTestUtils.addFieldToCustomSetting('LegalEntityCreateRequest', 'subQuery3', 'subQuery3', 'Bank_Account__c.routingNo__c', '111000025', true, true, 99997));
		insert cSetting;
		
		Map<String, sObject> requestFields = VantivUtils.getRequestFields('LegalEntityCreateRequest');
		
		Test.startTest();
		String result = VantivRequestBuilder.BuildQueryFromRequestFields(requestFields, 'LegalEntityCreateRequest');
		System.debug(result);
		System.assert(result != null);
		Test.stopTest();
	}
	
	static testmethod void BuildRequestBodyFromRecordWithSub()
	{
		Account a = VantivTestUtils.genAccount(true, 'MyCase Account');
		ValuePlus__c vp = VantivTestUtils.genValuePlusWithLegalId(true, a.Id, null, 'MyCase Payments');
		Bank_Account__c ba = VantivTestUtils.genBankAccountWithSubmerchantId(true, vp.Id);
		
		VantivTestUtils.genCreateLegalEntity();
		VantivTestUtils.genTestSettings(true);
		VantivTestUtils.genRootElement();
		VantivTestUtils.genVantivEntityType();
		
		List<sObject> cSetting = new List<sObject>();
		cSetting.add(VantivTestUtils.addFieldToCustomSetting('LegalEntityCreateRequest', 'subQuery2', 'subQuery2', 'Bank_Account__c.AccountNo__c', '', true, true, 99998));
		cSetting.add(VantivTestUtils.addFieldToCustomSetting('LegalEntityCreateRequest', 'subQuery3', 'subQuery3', 'Bank_Account__c.routingNo__c', '111000025', true, true, 99997));
		insert cSetting;
		
		Map<String, sObject> requestFields = VantivUtils.getRequestFields('LegalEntityCreateRequest');
		
		Test.startTest();
		ValuePlus__c record = VantivRequestBuilder.getRecord(requestFields, 'LegalEntityCreateRequest', vp.Id);
		String xmlBody = VantivRequestBuilder.BuildRequestBodyFromRecord(requestFields, record, 'LegalEntityCreateRequest');
		System.debug(xmlBody);
		System.assert(xmlBody != null);
		Test.stopTest();
	}
}