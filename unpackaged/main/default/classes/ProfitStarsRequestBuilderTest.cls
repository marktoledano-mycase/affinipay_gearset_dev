/*
* Test class for the ProfitStarsRequestBuilder class.
*/
@isTest
private class ProfitStarsRequestBuilderTest{

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
		INSERT(dm.valuePlusList[0]);

		//insert bank accounts
		dm.bankAccountList[0].ValuePlus__c = dm.valueplusList[0].Id;
		dm.bankAccountList[0].RoutingNo__c = '053000196';
		dm.bankAccountList[0].AccountNo__c = '1234567891';
		dm.bankAccountList[0].Account_Type__c = '0';
		INSERT(dm.bankAccountList[0]);
    }

    static testmethod void createEnrollmentRequestTest(){

		TestUtils.genTestSettings(true);
		TestUtils.genEnrollmentCustomSettings();

		ValuePlus__c vp = [Select Id from ValuePlus__c where Account__r.Name = 'Test Account0' limit 1];
								 
		Test.startTest();
		ProfitStarsRequestBuilder.ProfitStarsRequest request = ProfitStarsRequestBuilder.createEnrollmentRequestFromActionAndRecordId(vp.Id, null);
		Test.stopTest();

		System.assertNotEquals(null, request);
	}

	static testmethod void createBankLocationVelocityReqTest(){

		TestUtils.genTestSettings(true);
		TestUtils.genVelocityCustomSetting();

		ValuePlus__c vp = [Select Id, ProfitStars_Merchant_ID__c from ValuePlus__c where Account__r.Name = 'Test Account0' limit 1];
		vp.ProfitStars_Merchant_ID__c = '343434';
		update vp;

		Bank_Account__c bank = [Select Id, LID__c from Bank_Account__c where Account_Label__c = 'Test Bank Account0'];
		bank.LID__c = '898989';
		Test.startTest();
		update bank;
								 
		Map<String, String> request = ProfitStarsRequestBuilder.createBankLocationVelocityReqFromActionAndRecordId('velocity', vp.Id, null, null);
		Test.stopTest();

		System.assertNotEquals(null, request);
	}

	static testmethod void createMultipleMaintenanceReqTest(){

		TestUtils.genTestSettings(true);
		TestUtils.genLocationCustomSetting();

		ValuePlus__c vp = [Select Id, ProfitStars_Merchant_ID__c from ValuePlus__c where Account__r.Name = 'Test Account0' limit 1];
		vp.ProfitStars_Merchant_ID__c = '343434';
		update vp;

		Bank_Account__c bank = [Select Id from Bank_Account__c where Account_Label__c = 'Test Bank Account0'];
		bank.ps_LocationUpdateRequired__c = true;
		bank.Ready_for_push_to_ProfitStars__c = true;
		Test.startTest();
		update bank;
								 
		Map<Id, Map<String, String>> request = ProfitStarsRequestBuilder.createMultipleMaintenanceReqFromActionAndRecordId('location', vp.Id, null);
		Test.stopTest();

		System.assertNotEquals(null, request);
	}

	static testmethod void createMaintOtherReqTest(){

		TestUtils.genTestSettings(true);
		TestUtils.genFieldCustomSetting();

		Account acc = [Select Id from Account where Name = 'Test Account0'];
		acc.ps_UpdateRequired__c = true;
		acc.ProfitStars_Update_Field__c = 'Name';
		update acc;

		Test.startTest();
		ValuePlus__c vp = [Select Id, ProfitStars_Merchant_ID__c from ValuePlus__c where Account__r.Name = 'Test Account0' limit 1];
		vp.ProfitStars_Merchant_ID__c = '343434';
		update vp;

		Bank_Account__c bank = [Select Id from Bank_Account__c where Account_Label__c = 'Test Bank Account0'];
		bank.ps_LocationUpdateRequired__c = true;
		bank.Ready_for_push_to_ProfitStars__c = true;
		update bank;
	
		Map<String, String> request = ProfitStarsRequestBuilder.createMaintOtherReqFromActionAndRecordId('field update', vp.Id, null);
		Test.stopTest();

		System.assertNotEquals(null, request);
	}

	static testmethod void createOwnershipUpdateReqTest(){

		TestUtils.genTestSettings(true);
		TestUtils.genFieldCustomSetting();

		Account acc = [Select Id from Account where Name = 'Test Account0'];
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

		Test.startTest();
		ValuePlus__c vp = [Select Id, ProfitStars_Merchant_ID__c from ValuePlus__c where Account__r.Name = 'Test Account0' limit 1];
		vp.ProfitStars_Merchant_ID__c = '343434';
		update vp;
	
		Map<String, String> request = ProfitStarsRequestBuilder.createMaintOtherReqFromActionAndRecordId('ownership update', vp.Id, null);
		Test.stopTest();

		System.assertNotEquals(null, request);
	}

	static testmethod void createReturnOnlyBankReqTest(){

		ValuePlus__c vp = [Select Id, ProfitStars_Merchant_ID__c from ValuePlus__c where Account__r.Name = 'Test Account0' limit 1];
		vp.ProfitStars_Merchant_ID__c = '343434';
		update vp;

		Bank_Account__c bank = [Select Id from Bank_Account__c where Account_Label__c = 'Test Bank Account0'];
		bank.Return_Account_Number__c = '9877899876';
		bank.Return_Routing_Number__c = '009786545';
		bank.LID__c = '009545';
		update bank;
	
		Test.startTest();
		Map<String, String> request = ProfitStarsRequestBuilder.createReturnOnlyBankReqFromActionAndRecordId('return only', bank.Id, null);
		Test.stopTest();

		System.assertNotEquals(null, request);
	}
}