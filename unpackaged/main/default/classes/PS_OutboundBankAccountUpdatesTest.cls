/*
* Test class for the PS_OutboundBankAccountUpdates class.
*/
@isTest
private class PS_OutboundBankAccountUpdatesTest{
	
	static String validCallJson = '{"CaseNumber": "00001720", "Success": "true"}';
	static String errorCallJson = '{"CaseNumber": null, "Success": "false", "ErrorMessage": "Error error!", "ErrorCode": "FIELD_CUSTOM_VALIDATION_EXCEPTION"}';
	static String exceptionJson = '{}';

	//Creates test data that is used by the unit tests in this class.
    @TestSetup
    public static void createTestData(){
    	TestDataFactory.createCustomSettings();

    	TestDataFactory.DataModel dm = new TestDataFactory.DataModel(1, false);
		//insert accounts
		// dm.accountList[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('MyCase Account').getRecordTypeId();
		INSERT(dm.accountList);
		
		//insert valuePlus
		dm.valueplusList[0].Account__c = dm.accountList[0].Id;
		dm.valueplusList[0].RecordTypeId = Schema.SObjectType.ValuePlus__c.getRecordTypeInfosByName().get('MyCase Payments').getRecordTypeId();
		dm.valueplusList[0].Stage__c = 'Sold/Not Started';
		dm.valueplusList[0].ProfitStars_Merchant_ID__c = '589801';
		dm.valueplusList[0].Outbound_MID__c = '589802';
		dm.valueplusList[0].Successfully_Enrolled_in_Profit_Stars_at__c = System.today();
		dm.valueplusList[0].Successfully_Enrolled_Outbound_at__c = System.today();
		INSERT(dm.valuePlusList[0]);

		//insert bank accounts
		dm.bankAccountList[0].ValuePlus__c = dm.valueplusList[0].Id;
		dm.bankAccountList[0].RoutingNo__c = '053000196';
		dm.bankAccountList[0].AccountNo__c = '1234567891';
		dm.bankAccountList[0].LID__c = '123456';
		dm.bankAccountList[0].Outbound_Location_Update_Status__c = 'Ready To Update';
		dm.bankAccountList[0].Outbound_LID__c = '654321';
		INSERT(dm.bankAccountList[0]);

		TestUtils.genTestSettings(true);
		TestUtils.genOutboundTestSettings(true);
    }

    static testmethod void batchOutboundAccUpdatesTest(){

    	TestUtils.genBankAccCustomSetting();

		Test.setMock(HttpCalloutMock.class, new RestClientCalloutMockFactory(200, 'Success', validCallJson, null));
								 
		Test.startTest();
		PS_OutboundBankAccountUpdates bankUpdateJob = new PS_OutboundBankAccountUpdates();
		ID batchprocessid = Database.executeBatch(bankUpdateJob);
		Test.stopTest();

		Bank_Account__c bank = [Select Id, Outbound_Location_Update_Status__c from Bank_Account__c where Account_Label__c = 'Test Bank Account0'];
		// System.assertEquals('Approved', bank.Outbound_Location_Update_Status__c);
	}

	static testmethod void batchOutboundAccErrorUpdatesTest(){

    	TestUtils.genBankAccCustomSetting();

		Test.setMock(HttpCalloutMock.class, new RestClientCalloutMockFactory(200, 'Success', errorCallJson, null));
								 
		Test.startTest();
		PS_OutboundBankAccountUpdates bankUpdateJob = new PS_OutboundBankAccountUpdates();
		ID batchprocessid = Database.executeBatch(bankUpdateJob);
		Test.stopTest();

		Bank_Account__c bank = [Select Id, Outbound_Location_Update_Status__c from Bank_Account__c where Account_Label__c = 'Test Bank Account0'];
		System.assertEquals('Failed', bank.Outbound_Location_Update_Status__c);
	}

    static testmethod void batchOutboundAccUpdatesExceptionTest(){

		Test.setMock(HttpCalloutMock.class, new RestClientCalloutMockFactory(200, 'Success', validCallJson, null));
								 
		Test.startTest();
		PS_OutboundBankAccountUpdates bankUpdateJob = new PS_OutboundBankAccountUpdates();
		ID batchprocessid = Database.executeBatch(bankUpdateJob);
		Test.stopTest();

		Bank_Account__c bank = [Select Id, Outbound_Location_Update_Status__c from Bank_Account__c where Account_Label__c = 'Test Bank Account0'];
		System.assertEquals('Failed', bank.Outbound_Location_Update_Status__c);
	}

	static testmethod void testOutboundValidationException(){

		TestUtils.genBankAccCustomSetting();
		TestUtils.addRequiredFieldToCustomSetting('bank account');

		ValuePlus__c vp = [Select id, Phone_Verified__c from ValuePlus__c where ProfitStars_Merchant_ID__c = '589801'];
        vp.Phone_Verified__c = null;
        update vp;
		
		Test.setMock(HttpCalloutMock.class, new RestClientCalloutMockFactory(401, 'Failure', exceptionJson, null));
								 
		Test.startTest();
		PS_OutboundBankAccountUpdates bankUpdateJob = new PS_OutboundBankAccountUpdates();
		ID batchprocessid = Database.executeBatch(bankUpdateJob);
		Test.stopTest();

		List<PS_Audit_Log__c> auditLogList = [SELECT Id FROM PS_Audit_Log__c];
		System.assertNotEquals(0, auditLogList.size());
	}
}