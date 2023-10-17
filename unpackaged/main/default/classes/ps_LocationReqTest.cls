/*
* Test class for the ps_LocationReq class.
*/
@isTest
private class ps_LocationReqTest{

	static String validMaintCallJson = '{"CaseNumber": "00001720", "Success": "true"}';
	static String validLocByLocNameCallJson = '{"HTTPStatusCode":"200","GetLocationByLocationName":{"GetLocationByLocationNameResult":{"AccountNumberLast4":"7891","AccountType":"Checking","CustServProviderId":"654321","CustomerLocationNumber":"true","EntityId":"589885","LocationEnabled":true,"LocationId":"4140829","LocationName":"Test Bank Account0","MerchantName":"Test Account0-a1l4D00000074qDQAQ","RoutingNumber":"053000196"}}}';

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

    static testmethod void ps_LocationReqTest(){

		TestUtils.genTestSettings(true);
		TestUtils.genLocationCustomSetting();

		ValuePlus__c vp = [Select Id, ProfitStars_Merchant_ID__c from ValuePlus__c where Account__r.Name = 'Test Account0' limit 1];
		vp.ProfitStars_Merchant_ID__c = '343434';
		update vp;
								 
		Test.startTest();
		Map<String, String> responseHeaders = new Map<String, String>();
		responseHeaders.put('Content-Type', 'application/json');
		Test.setMock(HttpCalloutMock.class, new HttpMockTestTemplate(
			new List<Integer>{200, 200}, 'OK', new List<String> {validMaintCallJson, 
			validLocByLocNameCallJson}, responseHeaders));

		ps_LocationReq locResp = new ps_LocationReq(vp.Id, null);
		Test.stopTest();

		System.assert(locResp != null);
	}
}