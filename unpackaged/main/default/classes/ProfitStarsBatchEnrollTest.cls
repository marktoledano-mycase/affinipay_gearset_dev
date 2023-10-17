/*
* Test class for the ProfitStarsBatchEnroll class.
*/
@isTest
private class ProfitStarsBatchEnrollTest{

	static String validEnrollCallJson = '{"transaction_id":"006M000000JcyDsIAJ","result":"Application Created","message":"Success","code":"200","application_id":"00000939"}';
	static String errorEnrollCallJson = '{"transaction_id":null,"result":"Error","message":"Failed","code":"400","application_id":null}';
	static String exceptionJson = '{}';

	//Creates test data that is used by the unit tests in this class.
    @TestSetup
    public static void createTestData(){
    	TestDataFactory.createCustomSettings();

    	TestDataFactory.DataModel dm = new TestDataFactory.DataModel(1, false);
		//insert accounts
		// dm.accountList[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('MyCase Account').getRecordTypeId();
		dm.accountList[0].ShippingStreet = '44th St S';
		dm.accountList[0].ShippingCity = 'Goleta';
		dm.accountList[0].Ownership_Type__c = null;
		dm.accountList[0].Principal_1_Ownership__c = 25;
		INSERT(dm.accountList);
		
		//insert valuePlus
		dm.valueplusList[0].Account__c = dm.accountList[0].Id;
		dm.valueplusList[0].RecordTypeId = Schema.SObjectType.ValuePlus__c.getRecordTypeInfosByName().get('MyCase Payments').getRecordTypeId();
		dm.valueplusList[0].Stage__c = 'Sold/Not Started';
		dm.valueplusList[0].ProfitStars_Bulk_Enroll__c = true;
		dm.valueplusList[0].PMT_ProfitStars_Migration_Status__c = 'Ready to Transmit';
		INSERT(dm.valuePlusList[0]);

		//insert bank accounts
		dm.bankAccountList[0].ValuePlus__c = dm.valueplusList[0].Id;
		dm.bankAccountList[0].RoutingNo__c = '053000196';
		dm.bankAccountList[0].AccountNo__c = '1234567891';
		dm.bankAccountList[0].Account_Type__c = '0';
		INSERT(dm.bankAccountList[0]);
    }

    static testmethod void enrollmentTest(){

		Test.setMock(HttpCalloutMock.class, new RestClientCalloutMockFactory(200, 'Success', validEnrollCallJson, null));
		TestUtils.genTestSettings(true);
		TestUtils.genEnrollmentCustomSettings();
								 
		Test.startTest();
		ProfitStarsBatchEnroll enrollJob = new ProfitStarsBatchEnroll();
		ID batchprocessid = Database.executeBatch(enrollJob);
		Test.stopTest();

		ValuePlus__c vp = [Select Id, PMT_ProfitStars_Migration_Status__c, ProfitStars_Bulk_Enroll__c from ValuePlus__c where Account__r.Name = 'Test Account0' limit 1];
		System.assert('Transmitted' == vp.PMT_ProfitStars_Migration_Status__c);
		System.assertEquals(false, vp.ProfitStars_Bulk_Enroll__c);

		List<PS_Audit_Log__c> auditLogList = [SELECT Id, Call_Type__c, Error_Message__c FROM PS_Audit_Log__c where Value_plus__c = :vp.Id];
		System.assertNotEquals(0, auditLogList.size());
		System.assert('Batch Enroll' == auditLogList[0].Call_Type__c);
		System.assertEquals('Success', auditLogList[0].Error_Message__c);
	}

	static testmethod void enrollmentErrorTest(){

		Test.setMock(HttpCalloutMock.class, new RestClientCalloutMockFactory(200, 'Success', errorEnrollCallJson, null));
		TestUtils.genTestSettings(true);
		TestUtils.genEnrollmentCustomSettings();
								 
		Test.startTest();
		ProfitStarsBatchEnroll enrollJob = new ProfitStarsBatchEnroll();
		ID batchprocessid = Database.executeBatch(enrollJob);
		Test.stopTest();

		ValuePlus__c vp = [Select Id, PMT_ProfitStars_Migration_Status__c, ProfitStars_Bulk_Enroll__c from ValuePlus__c where Account__r.Name = 'Test Account0' limit 1];
		System.assert('Failed to Transmit' == vp.PMT_ProfitStars_Migration_Status__c);

		List<PS_Audit_Log__c> auditLogList = [SELECT Id, Call_Type__c, Error_Message__c FROM PS_Audit_Log__c where Value_plus__c = :vp.Id];
		System.assertNotEquals(0, auditLogList.size());
		System.assert('Batch Enroll' == auditLogList[0].Call_Type__c);
		System.assertEquals('Failure', auditLogList[0].Error_Message__c);
	}

	static testmethod void enrollmentExceptionTest(){

		Test.setMock(HttpCalloutMock.class, new RestClientCalloutMockFactory(400, 'Failure', exceptionJson, null));
		TestUtils.genTestSettings(true);
		TestUtils.addRequiredFieldToCustomSetting('enrollment');

		ValuePlus__c vp = [Select Id, Phone_Verified__c from ValuePlus__c where Account__r.Name = 'Test Account0' limit 1];
		vp.Phone_Verified__c = null;
        update vp;
								 
		Test.startTest();
		ProfitStarsBatchEnroll enrollJob = new ProfitStarsBatchEnroll();
		ID batchprocessid = Database.executeBatch(enrollJob);
		Test.stopTest();

		List<PS_Audit_Log__c> auditLogList = [SELECT Id, Call_Type__c, Error_Message__c FROM PS_Audit_Log__c where Value_plus__c = :vp.Id];
		System.assertNotEquals(0, auditLogList.size());
		System.assert('Batch Enroll' == auditLogList[0].Call_Type__c);
	}		
}