/*
* Test class for the ps_velocityReq class.
*/
@isTest
private class ps_VelocityReq_Tests{

	// static String validMaintCallJson = '{"CaseNumber": "00001720", "Success": "true"}';
	// static String validVelocitySettingCallJson = '{"GetVelocityByMerchant":{"GetVelocitySettingsByMerchantIdResult":{"WSVelocitySettings":[{"CustServProviderId":"214726","DailyPercentageWarning":"0.00","Description":"ACH, Debit","EntityId":"589885","Location":"Merchant Default Location (0)","MaxPeriodAmount":"1150.00","MaxPeriodCount":"2","MaxSingleDayAmount":"1150.00","MaxSingleDayCount":"1","MaxSingleTransactionAmount":"1100.00","MerchantName":"MC PS Test 1-a1l4D00000074qDQAQ","PeriodPercentageWarning":"0.00","SingleAmountPercentageWarning":"0.00","VSID":"2942693","VelocityEnabled":true,"ACHTransactionTypes":[{"WSACHTransactionType":"ARC"},{"WSACHTransactionType":"RCK"},{"WSACHTransactionType":"BOC"},{"WSACHTransactionType":"TEL"},{"WSACHTransactionType":"PPD__CCD"},{"WSACHTransactionType":"WEB"},{"WSACHTransactionType":"POP"},{"WSACHTransactionType":"CTX"}],"EnabledExceptions":[{"WSVelocityExceptions":"Show_Exceptions"}],"OperationType":[{"WSOperationType":"Sale"}],"SettlementType":[{"WSSettlementType":"ACH"}]},{"CustServProviderId":"214726","DailyPercentageWarning":"0.00","Description":"ACH, Refund","EntityId":"589885","Location":"Merchant Default Location (0)","MaxPeriodAmount":"945.00","MaxPeriodCount":"5","MaxSingleDayAmount":"945.00","MaxSingleDayCount":"5","MaxSingleTransactionAmount":"900.00","MerchantName":"MC PS Test 1-a1l4D00000074qDQAQ","PeriodPercentageWarning":"0.00","SingleAmountPercentageWarning":"0.00","VSID":"2942697","VelocityEnabled":true,"ACHTransactionTypes":[{"WSACHTransactionType":"ARC"},{"WSACHTransactionType":"RCK"},{"WSACHTransactionType":"BOC"},{"WSACHTransactionType":"TEL"},{"WSACHTransactionType":"PPD__CCD"},{"WSACHTransactionType":"WEB"},{"WSACHTransactionType":"POP"},{"WSACHTransactionType":"CTX"}],"EnabledExceptions":[{"WSVelocityExceptions":"Show_Exceptions"}],"OperationType":[{"WSOperationType":"Refund"}],"SettlementType":[{"WSSettlementType":"ACH"}]}]}},"HTTPStatusCode":"200"}';
	

	// //Creates test data that is used by the unit tests in this class.
    // @TestSetup
    // public static void createTestData(){
    // 	TestDataFactory.createCustomSettings();

    // 	TestDataFactory.DataModel dm = new TestDataFactory.DataModel(1, false);
	// 	//insert accounts
	// 	dm.accountList[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Property Management').getRecordTypeId();
	// 	dm.accountList[0].ShippingStreet = '44th St S';
	// 	dm.accountList[0].ShippingCity = 'Goleta';
	// 	dm.accountList[0].Ownership_Type__c = null;
	// 	dm.accountList[0].Principal_1_Ownership__c = 25;
	// 	INSERT(dm.accountList);
		
	// 	//insert valuePlus
	// 	dm.valueplusList[0].Account__c = dm.accountList[0].Id;
	// 	dm.valueplusList[0].RecordTypeId = Schema.SObjectType.ValuePlus__c.getRecordTypeInfosByName().get('APM Payments').getRecordTypeId();
	// 	dm.valueplusList[0].Stage__c = 'Sold/Not Started';
	// 	INSERT(dm.valuePlusList[0]);

	// 	//insert bank accounts
	// 	dm.bankAccountList[0].ValuePlus__c = dm.valueplusList[0].Id;
	// 	dm.bankAccountList[0].RoutingNo__c = '053000196';
	// 	dm.bankAccountList[0].AccountNo__c = '1234567891';
	// 	dm.bankAccountList[0].Account_Type__c = '0';
	// 	INSERT(dm.bankAccountList[0]);
    // }

    // static testmethod void ps_velocityReqTest(){

	// 	TestUtils.genTestSettings(true);
	// 	TestUtils.genVelocityCustomSetting();

	// 	ValuePlus__c vp = [Select Id, ProfitStars_Merchant_ID__c from ValuePlus__c where Account__r.Name = 'Test Account0' limit 1];
	// 	vp.ProfitStars_Merchant_ID__c = '343434';
	// 	update vp;

	// 	Bank_Account__c bank = [Select Id, LID__c from Bank_Account__c where Account_Label__c = 'Test Bank Account0'];
	// 	bank.LID__c = '898989';
	// 	update bank;
								 
	// 	Test.startTest();
	// 	Map<String, String> responseHeaders = new Map<String, String>();
	// 	responseHeaders.put('Content-Type', 'application/json');
	// 	Test.setMock(HttpCalloutMock.class, new HttpMockTestTemplate(
	// 		new List<Integer>{200, 200}, 'OK', new List<String> {validVelocitySettingCallJson, 
	// 		validMaintCallJson}, responseHeaders));

	// 	ps_velocityReq velResp = new ps_velocityReq(vp.Id, null);
	// 	Test.stopTest();

	// 	System.assert(velResp != null);
	// }
}