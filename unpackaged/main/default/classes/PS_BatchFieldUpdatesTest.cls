/*
* Test class for the PS_BatchFieldUpdates class.
*/
@isTest
private class PS_BatchFieldUpdatesTest{

	static String validCallJson = '{"CaseNumber": "00001720", "Success": "true"}';
	static String errorCallJson = '{"CaseNumber": null, "Success": "false", "ErrorMessage": "Bank Routing Number is not valid", "ErrorCode": "FIELD_CUSTOM_VALIDATION_EXCEPTION"}';
	static String exceptionJson = '{}';

	//Creates test data that is used by the unit tests in this class.
    @TestSetup
    public static void createTestData(){
    	TestDataFactory.createCustomSettings();

    	TestDataFactory.DataModel dm = new TestDataFactory.DataModel(1, false);
		//insert accounts
		// dm.accountList[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('MyCase Account').getRecordTypeId();
		dm.accountList[0].ps_UpdateRequired__c = true;
		dm.accountList[0].ProfitStars_Update_Field__c = 'Name';
		INSERT(dm.accountList);
		
		//insert valuePlus
		dm.valueplusList[0].Account__c = dm.accountList[0].Id;
		dm.valueplusList[0].RecordTypeId = Schema.SObjectType.ValuePlus__c.getRecordTypeInfosByName().get('MyCase Payments').getRecordTypeId();
		dm.valueplusList[0].ps_LocationUpdateRequired__c = true;
		dm.valueplusList[0].Stage__c = 'Sold/Not Started';
		dm.valueplusList[0].ProfitStars_Merchant_ID__c = '589801';
		dm.valueplusList[0].Successfully_Enrolled_in_Profit_Stars_at__c = System.today();
		INSERT(dm.valuePlusList[0]);

		//insert bank accounts
		dm.bankAccountList[0].ValuePlus__c = dm.valueplusList[0].Id;
		dm.bankAccountList[0].RoutingNo__c = '053000196';
		dm.bankAccountList[0].AccountNo__c = '1234567891';
		INSERT(dm.bankAccountList[0]);

		TestUtils.genTestSettings(true);
		TestUtils.genFieldCustomSetting();
    }

	static testmethod void batchFieldUpdatesTest(){

		Test.setMock(HttpCalloutMock.class, new RestClientCalloutMockFactory(200, 'Success', validCallJson, null));
								 
		Test.startTest();
		PS_BatchFieldUpdates fieldUpdateJob = new PS_BatchFieldUpdates();
		ID batchprocessid = Database.executeBatch(fieldUpdateJob);
		Test.stopTest();

		Account acc = [Select ProfitStars_Push_Status__c from Account where Name = 'Test Account0'];
		// System.assertEquals('Success', acc.ProfitStars_Push_Status__c);
	}

	static testmethod void batchOwnerUpdatesTest(){

		Test.setMock(HttpCalloutMock.class, new RestClientCalloutMockFactory(200, 'Success', validCallJson, null));

		Account acc = [Select Id from Account where Name = 'Test Account0'];
								 
		Test.startTest();
		acc.Principal_1_First_Name__c = 'POneFName';
		acc.Principal_1_Last_Name__c = 'POneLName';
		acc.Principal_1_SSN__c = '965777521';
		acc.Principal_1_Ownership__c = 50;
		acc.Principal_2_First_Name__c = 'PTwoFName';
		acc.Principal_2_Last_Name__c = 'PTwoLName';
		acc.Principal_2_SSN__c = '965666521';
		acc.Principal_2_Ownership__c = 50;
		acc.ps_UpdateRequired__c = true;
		acc.ProfitStars_Update_Field__c = 'Ownership';
		update acc;

		PS_BatchFieldUpdates fieldUpdateJob = new PS_BatchFieldUpdates();
		ID batchprocessid = Database.executeBatch(fieldUpdateJob);
		Test.stopTest();

		Account acct = [Select ProfitStars_Push_Status__c from Account where Name = 'Test Account0'];
		// System.assertEquals('Success', acct.ProfitStars_Push_Status__c);
	}

	static testmethod void batchFieldErrorUpdatesTest(){

		Test.setMock(HttpCalloutMock.class, new RestClientCalloutMockFactory(200, 'Success', errorCallJson, null));
								 
		Test.startTest();
		PS_BatchFieldUpdates fieldUpdateJob = new PS_BatchFieldUpdates();
		ID batchprocessid = Database.executeBatch(fieldUpdateJob);
		Test.stopTest();

		Account acc = [Select ProfitStars_Push_Status__c from Account where Name = 'Test Account0'];
		// System.assertEquals('Failure', acc.ProfitStars_Push_Status__c);
	}

	static testmethod void testException(){

		TestUtils.addRequiredFieldToCustomSetting('field update');

		ValuePlus__c vp = [Select id, Phone_Verified__c from ValuePlus__c where ProfitStars_Merchant_ID__c = '589801'];
        vp.Phone_Verified__c = null;
        update vp;
		
		Test.setMock(HttpCalloutMock.class, new RestClientCalloutMockFactory(401, 'Failure', exceptionJson, null));
								 
		Test.startTest();
		PS_BatchFieldUpdates fieldUpdateJob = new PS_BatchFieldUpdates();
		fieldUpdateJob.errorMessage = 'error test';
		ID batchprocessid = Database.executeBatch(fieldUpdateJob);
		fieldUpdateJob.finalize(null, null, null);
		Test.stopTest();

		List<PS_Audit_Log__c> auditLogList = [SELECT Id FROM PS_Audit_Log__c];
		// System.assertNotEquals(0, auditLogList.size());
	}
}