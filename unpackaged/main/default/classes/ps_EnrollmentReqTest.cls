/*
* Test class for the ps_EnrollmentReq class.
*/
@isTest
private class ps_EnrollmentReqTest{

	static String validEnrollCallJson = '{"transaction_id":"006M000000JcyDsIAJ","result":"Application Created","message":"Success","code":"200","application_id":"00000939"}';
	
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

		ValuePlus__c vp = [Select Id from ValuePlus__c where Account__r.Name = 'Test Account0' limit 1];
								 
		Test.startTest();
		ps_EnrollmentReq enrollResp = new ps_EnrollmentReq(vp.Id, null);
		Test.stopTest();

		System.assert(enrollResp != null);
	}
    
    static testmethod void oneDayEnrollmentTest(){
        Test.setMock(HttpCalloutMock.class, new RestClientCalloutMockFactory(200, 'Success', validEnrollCallJson, null));
		TestUtils.genTestSettings(true);
		TestUtils.genEnrollmentCustomSettings();

		ValuePlus__c vp = [Select Id from ValuePlus__c where Account__r.Name = 'Test Account0' limit 1];
        vp.Payment_Processing_Days__c = '0 Days';
        update vp;
        
        System.assertEquals(ProfitStarsIntegrationService.oneDayProcessing, False);
        
        Test.startTest();
		ps_EnrollmentReq enrollResp = new ps_EnrollmentReq(vp.Id, null);
		Test.stopTest();
        
        System.assertEquals(ProfitStarsIntegrationService.oneDayProcessing, True);
    }
}