/*
* Test class for the PS_BatchBankAccountUpdates class.
*/
@isTest
private class PS_BatchBankAccountUpdatesTest {

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
		dm.valueplusList[0].Successfully_Enrolled_in_Profit_Stars_at__c = System.today();
		INSERT(dm.valuePlusList[0]);

		//insert bank accounts
		dm.bankAccountList[0].ValuePlus__c = dm.valueplusList[0].Id;
		dm.bankAccountList[0].RoutingNo__c = '053000196';
		dm.bankAccountList[0].AccountNo__c = '1234567891';
		dm.bankAccountList[0].LID__c = '123456';
		dm.bankAccountList[0].Ready_for_push_to_ProfitStars__c = true;
		dm.bankAccountList[0].ps_BankAccountUpdateRequired__c = true;
		INSERT(dm.bankAccountList[0]);

		TestUtils.genTestSettings(true);
		TestUtils.genFieldCustomSetting();
    }

    static testmethod void batchAccUpdatesTest(){

    	TestUtils.genBankAccCustomSetting();

		Test.setMock(HttpCalloutMock.class, new RestClientCalloutMockFactory(200, 'Success', validCallJson, null));
								 
		Test.startTest();
		PS_BatchBankAccountUpdates bankUpdateJob = new PS_BatchBankAccountUpdates();
		ID batchprocessid = Database.executeBatch(bankUpdateJob);
		Test.stopTest();

		Bank_Account__c bank = [Select Id, ProfitStars_Push_Status__c from Bank_Account__c where Account_Label__c = 'Test Bank Account0'];
		// System.assertEquals('Success', bank.ProfitStars_Push_Status__c);
	}

	static testmethod void batchAccErrorUpdatesTest(){

    	TestUtils.genBankAccCustomSetting();

		Test.setMock(HttpCalloutMock.class, new RestClientCalloutMockFactory(200, 'Success', errorCallJson, null));
								 
		Test.startTest();
		PS_BatchBankAccountUpdates bankUpdateJob = new PS_BatchBankAccountUpdates();
		ID batchprocessid = Database.executeBatch(bankUpdateJob);
		Test.stopTest();

		Bank_Account__c bank = [Select Id, ProfitStars_Push_Status__c from Bank_Account__c where Account_Label__c = 'Test Bank Account0'];
		System.assertEquals('Failed', bank.ProfitStars_Push_Status__c);
	}

    static testmethod void batchAccUpdatesExceptionTest(){

		Test.setMock(HttpCalloutMock.class, new RestClientCalloutMockFactory(200, 'Success', validCallJson, null));
								 
		Test.startTest();
		PS_BatchBankAccountUpdates bankUpdateJob = new PS_BatchBankAccountUpdates();
		ID batchprocessid = Database.executeBatch(bankUpdateJob);
		Test.stopTest();

		Bank_Account__c bank = [Select Id, ProfitStars_Push_Status__c from Bank_Account__c where Account_Label__c = 'Test Bank Account0'];
		System.assertEquals('Failed', bank.ProfitStars_Push_Status__c);
	}

	static testmethod void testValidationException(){

		TestUtils.genBankAccCustomSetting();
		TestUtils.addRequiredFieldToCustomSetting('bank account');

		ValuePlus__c vp = [Select id, Phone_Verified__c from ValuePlus__c where ProfitStars_Merchant_ID__c = '589801'];
        vp.Phone_Verified__c = null;
        update vp;
		
		Test.setMock(HttpCalloutMock.class, new RestClientCalloutMockFactory(401, 'Failure', exceptionJson, null));
								 
		Test.startTest();
		PS_BatchBankAccountUpdates bankUpdateJob = new PS_BatchBankAccountUpdates();
		ID batchprocessid = Database.executeBatch(bankUpdateJob);
		Test.stopTest();

		List<PS_Audit_Log__c> auditLogList = [SELECT Id FROM PS_Audit_Log__c];
		System.assertNotEquals(0, auditLogList.size());
	}

	static testmethod void testErrorMessage(){

		TestUtils.genBankAccCustomSetting();
		TestUtils.addRequiredFieldToCustomSetting('bank account');

		Test.startTest();
		PS_BatchBankAccountUpdates bankJob = new PS_BatchBankAccountUpdates();
		bankJob.errorMessage = 'error test';
		bankJob.finalize(null, null, null);
		Test.stopTest();

		List<System_Exception_Log__c> exceptionLogList = [SELECT Id FROM System_Exception_Log__c];
		// System.assertNotEquals(0, exceptionLogList.size());
	}
    
    static testmethod void batchAccErrorUpdatesMYCaseTest(){
 		ValuePlus__c vp = [SELECT Id, RecordTypeId from ValuePlus__c limit 1];
		vp.RecordTypeId = InformationStrings.vPlusMycasePaymentsId;
		update vp;     
        
        TestUtils.genBankAccCustomSetting();
        // TestUtils.genMyCaseInboundTestSettings(true);

		Test.setMock(HttpCalloutMock.class, new RestClientCalloutMockFactory(200, 'Success', errorCallJson, null));
								 
		Test.startTest();
		PS_BatchBankAccountUpdates bankUpdateJob = new PS_BatchBankAccountUpdates();
		ID batchprocessid = Database.executeBatch(bankUpdateJob);
		Test.stopTest();

        
		Bank_Account__c bank = [Select Id, ProfitStars_Push_Status__c from Bank_Account__c where Account_Label__c = 'Test Bank Account0'];
		System.assertEquals('Failed', bank.ProfitStars_Push_Status__c);
	}
}