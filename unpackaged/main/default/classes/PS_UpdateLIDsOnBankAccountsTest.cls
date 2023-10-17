/*
* Test class for the PS_UpdateLIDsOnBankAccounts class.
*/
@isTest
private class PS_UpdateLIDsOnBankAccountsTest{

	static String successInboundLIDResp = '{"HTTPStatusCode":"200","GetLocationByLocationName":{"GetLocationByLocationNameResult":{"AccountNumberLast4":"1960","AccountType":"Checking","CustServProviderId":"268009","CustomerLocationNumber":"true","EntityId":"589801","LocationEnabled":true,"LocationId":"4139121","LocationName":"Test Bank Account0","MerchantName":"Test Account0-a1l4D00000076pPQAQ","RoutingNumber":"053000196"}}}';
	static String successOutboundLIDResp = '{"HTTPStatusCode":"200","GetLocationByLocationName":{"GetLocationByLocationNameResult":{"AccountNumberLast4":"1960","AccountType":"Checking","CustServProviderId":"258030","CustomerLocationNumber":"true","EntityId":"588601","LocationEnabled":true,"LocationId":"4139122","LocationName":"Test Bank Account0","MerchantName":"Test Account0-a1l4D00000076pPQAQ","RoutingNumber":"053000196"}}}';
	static String exceptionResp = '{"HTTPStatusCode":null,"GetLocationByLocationName":{"GetLocationByLocationNameResult":{"AccountNumberLast4":"1960","AccountType":"Checking","CustServProviderId":"268009","CustomerLocationNumber":"true","EntityId":"589801","LocationEnabled":true,"LocationId":true,"LocationName":"Test Bank Account0","MerchantName":"Test Account0-a1l4D00000076pPQAQ","RoutingNumber":"053000196"}}}';
	static String errorResp = '{"ErrorMessage": "This Merchant (Entity Id) is not associated with this Partner","ErrorCode": "401"}';

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
		//dm.valueplusList[0].Outbound_MID__c = '588601';
		INSERT(dm.valuePlusList[0]);

		//insert bank accounts
		dm.bankAccountList[0].ValuePlus__c = dm.valueplusList[0].Id;
		dm.bankAccountList[0].RoutingNo__c = '053000196';
		dm.bankAccountList[0].AccountNo__c = '0530001960';
		dm.bankAccountList[0].Location_Add_Status__c = 'Submitted';
		//dm.bankAccountList[0].Outbound_Location_Add_Status__c = 'Submitted';
		INSERT(dm.bankAccountList[0]);

		TestUtils.genTestSettings(true);
		TestUtils.genOutboundTestSettings(true);
		TestUtils.genEcheckFieldsTestSettings(true);
    }
    
    public static testMethod void testInboundLIDUpdate(){
        Test.setMock(HttpCalloutMock.class, new RestClientCalloutMockFactory(200, 'Success', successInboundLIDResp, null));
								 
		Test.startTest();
		PS_UpdateLIDsOnBankAccounts updateLIDJob = new PS_UpdateLIDsOnBankAccounts();
		ID batchprocessid = Database.executeBatch(updateLIDJob);
		Test.stopTest();

		Bank_Account__c ba = [Select id, LID__c, Location_Add_Status__c from Bank_Account__c where Account_Label__c = 'Test Bank Account0'];
		System.assertEquals('4139121', ba.LID__c);
		System.assertEquals('Approved', ba.Location_Add_Status__c);
    }

    public static testMethod void testOutboundLIDUpdate(){
        Test.setMock(HttpCalloutMock.class, new RestClientCalloutMockFactory(200, 'Success', successOutboundLIDResp, null));

        ValuePlus__c vp = [Select id, ProfitStars_Merchant_ID__c, Outbound_MID__c from ValuePlus__c where ProfitStars_Merchant_ID__c = '589801'];
        vp.ProfitStars_Merchant_ID__c = null;
        vp.Outbound_MID__c = '588601';
        update vp;

        Bank_Account__c bankAcc = [Select id, Outbound_Location_Add_Status__c, Location_Add_Status__c from Bank_Account__c where Account_Label__c = 'Test Bank Account0'];
        bankAcc.Outbound_Location_Add_Status__c = 'Submitted';
        update bankAcc;
								 
		Test.startTest();
		PS_UpdateLIDsOnBankAccounts updateLIDJob = new PS_UpdateLIDsOnBankAccounts();
		ID batchprocessid = Database.executeBatch(updateLIDJob);
		Test.stopTest();

		Bank_Account__c ba = [Select id, Outbound_LID__c, Outbound_Location_Add_Status__c from Bank_Account__c where Account_Label__c = 'Test Bank Account0'];
		System.assertEquals('4139122', ba.Outbound_LID__c);
		System.assertEquals('Approved', ba.Outbound_Location_Add_Status__c);
    }

    public static testMethod void testInboundErrorResponse(){
        Test.setMock(HttpCalloutMock.class, new RestClientCalloutMockFactory(401, 'Error', errorResp, null));
								 
		Test.startTest();
		PS_UpdateLIDsOnBankAccounts updateLIDJob = new PS_UpdateLIDsOnBankAccounts();
		ID batchprocessid = Database.executeBatch(updateLIDJob);
		Test.stopTest();

		List<PS_Audit_Log__c> auditLogList = [SELECT Id FROM PS_Audit_Log__c];
		System.assertNotEquals(0, auditLogList.size());
    }

    public static testMethod void testOutboundErrorResponse(){
        Test.setMock(HttpCalloutMock.class, new RestClientCalloutMockFactory(401, 'Error', errorResp, null));
								 
		ValuePlus__c vp = [Select id, ProfitStars_Merchant_ID__c, Outbound_MID__c from ValuePlus__c where ProfitStars_Merchant_ID__c = '589801'];
        vp.ProfitStars_Merchant_ID__c = null;
        vp.Outbound_MID__c = '588601';
        update vp;

        Bank_Account__c bankAcc = [Select id, Outbound_Location_Add_Status__c, Location_Add_Status__c from Bank_Account__c where Account_Label__c = 'Test Bank Account0'];
        bankAcc.Outbound_Location_Add_Status__c = 'Submitted';
        update bankAcc;
								 
		Test.startTest();
		PS_UpdateLIDsOnBankAccounts updateLIDJob = new PS_UpdateLIDsOnBankAccounts();
		ID batchprocessid = Database.executeBatch(updateLIDJob);
		Test.stopTest();

		List<PS_Audit_Log__c> auditLogList = [SELECT Id FROM PS_Audit_Log__c];
		System.assertNotEquals(0, auditLogList.size());
    }

    public static testMethod void testException(){
        Test.setMock(HttpCalloutMock.class, new RestClientCalloutMockFactory(200, 'Success', exceptionResp, null));
								 
		Test.startTest();
		PS_UpdateLIDsOnBankAccounts updateLIDJob = new PS_UpdateLIDsOnBankAccounts();
		ID batchprocessid = Database.executeBatch(updateLIDJob);
		Test.stopTest();

		List<System_Exception_Log__c> exceptionLogList = [SELECT Id FROM System_Exception_Log__c];
		// System.assertNotEquals(0, exceptionLogList.size());
    }
}