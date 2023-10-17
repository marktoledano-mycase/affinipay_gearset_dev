/*
* Test class for the ps_buttonMethods class.
*/
@isTest
private class ps_buttonMethodsTest{

	static String validEnrollCallJson = '{"transaction_id":"006M000000JcyDsIAJ","result":"Application Created","message":"Success","code":"200","application_id":"00000939"}';
	static String errorEnrollCallJson = '{"transaction_id":null,"result":"Error","message":"Failed","code":"400","application_id":null}';
	static String validMaintCallJson = '{"CaseNumber": "00001720", "Success": "true"}';
	static String errorMaintCallJson = '{"CaseNumber": null, "Success": "false", "ErrorMessage": "Error error!", "ErrorCode": "FIELD_CUSTOM_VALIDATION_EXCEPTION"}';
	static String validVelocitySettingCallJson = '{"GetVelocityByMerchant":{"GetVelocitySettingsByMerchantIdResult":{"WSVelocitySettings":[{"CustServProviderId":"214726","DailyPercentageWarning":"0.00","Description":"ACH, Debit","EntityId":"589885","Location":"Merchant Default Location (0)","MaxPeriodAmount":"1150.00","MaxPeriodCount":"2","MaxSingleDayAmount":"1150.00","MaxSingleDayCount":"1","MaxSingleTransactionAmount":"1100.00","MerchantName":"MC PS Test 1-a1l4D00000074qDQAQ","PeriodPercentageWarning":"0.00","SingleAmountPercentageWarning":"0.00","VSID":"2942693","VelocityEnabled":true,"ACHTransactionTypes":[{"WSACHTransactionType":"ARC"},{"WSACHTransactionType":"RCK"},{"WSACHTransactionType":"BOC"},{"WSACHTransactionType":"TEL"},{"WSACHTransactionType":"PPD__CCD"},{"WSACHTransactionType":"WEB"},{"WSACHTransactionType":"POP"},{"WSACHTransactionType":"CTX"}],"EnabledExceptions":[{"WSVelocityExceptions":"Show_Exceptions"}],"OperationType":[{"WSOperationType":"Sale"}],"SettlementType":[{"WSSettlementType":"ACH"}]},{"CustServProviderId":"214726","DailyPercentageWarning":"0.00","Description":"ACH, Refund","EntityId":"589885","Location":"Merchant Default Location (0)","MaxPeriodAmount":"945.00","MaxPeriodCount":"5","MaxSingleDayAmount":"945.00","MaxSingleDayCount":"5","MaxSingleTransactionAmount":"900.00","MerchantName":"MC PS Test 1-a1l4D00000074qDQAQ","PeriodPercentageWarning":"0.00","SingleAmountPercentageWarning":"0.00","VSID":"2942697","VelocityEnabled":true,"ACHTransactionTypes":[{"WSACHTransactionType":"ARC"},{"WSACHTransactionType":"RCK"},{"WSACHTransactionType":"BOC"},{"WSACHTransactionType":"TEL"},{"WSACHTransactionType":"PPD__CCD"},{"WSACHTransactionType":"WEB"},{"WSACHTransactionType":"POP"},{"WSACHTransactionType":"CTX"}],"EnabledExceptions":[{"WSVelocityExceptions":"Show_Exceptions"}],"OperationType":[{"WSOperationType":"Refund"}],"SettlementType":[{"WSSettlementType":"ACH"}]}]}},"HTTPStatusCode":"200"}';
	static String validLocByLocNameCallJson = '{"HTTPStatusCode":"200","GetLocationByLocationName":{"GetLocationByLocationNameResult":{"AccountNumberLast4":"7891","AccountType":"Checking","CustServProviderId":"654321","CustomerLocationNumber":"true","EntityId":"589885","LocationEnabled":true,"LocationId":"4140829","LocationName":"Test Bank Account0","MerchantName":"Test Account0-a1l4D00000074qDQAQ","RoutingNumber":"053000196"}}}';
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
		String enrollResp = ps_buttonMethods.callEnrollment(vp.Id);
		Test.stopTest();

		List<PS_Audit_Log__c> auditLogList = [SELECT Id, Call_Type__c, Error_Message__c FROM PS_Audit_Log__c where Value_plus__c = :vp.Id];
		System.assertNotEquals(0, auditLogList.size());
		System.assert('Enroll' == auditLogList[0].Call_Type__c);
		// System.assertEquals('Success', auditLogList[0].Error_Message__c);
	}

	static testmethod void enrollmentErrorTest(){

		Test.setMock(HttpCalloutMock.class, new RestClientCalloutMockFactory(400, 'Failure', errorEnrollCallJson, null));
		TestUtils.genTestSettings(true);
		TestUtils.genEnrollmentCustomSettings();

		ValuePlus__c vp = [Select Id from ValuePlus__c where Account__r.Name = 'Test Account0' limit 1];
								 
		Test.startTest();
		String enrollResp = ps_buttonMethods.callEnrollment(vp.Id);
		Test.stopTest();

		List<PS_Audit_Log__c> auditLogList = [SELECT Id, Call_Type__c, Error_Message__c FROM PS_Audit_Log__c where Value_plus__c = :vp.Id];
		System.assertNotEquals(0, auditLogList.size());
		System.assert('Enroll' == auditLogList[0].Call_Type__c);
		// System.assertEquals('Failure', auditLogList[0].Error_Message__c);
	}

	static testmethod void enrollmentExceptionTest(){

		Test.setMock(HttpCalloutMock.class, new RestClientCalloutMockFactory(400, 'Failure', exceptionJson, null));
		TestUtils.genTestSettings(true);
		TestUtils.addRequiredFieldToCustomSetting('enrollment');

		ValuePlus__c vp = [Select Id, Phone_Verified__c from ValuePlus__c where Account__r.Name = 'Test Account0' limit 1];
		vp.Phone_Verified__c = null;
        update vp;
								 
		Test.startTest();
		String enrollResp = ps_buttonMethods.callEnrollment(vp.Id);
		Test.stopTest();

		List<PS_Audit_Log__c> auditLogList = [SELECT Id, Call_Type__c, Error_Message__c FROM PS_Audit_Log__c where Value_plus__c = :vp.Id];
		System.assertNotEquals(0, auditLogList.size());
		System.assert('Enroll' == auditLogList[0].Call_Type__c);
	}

	static testmethod void velocityTest(){

		TestUtils.genTestSettings(true);
		TestUtils.genVelocityCustomSetting();

		ValuePlus__c vp = [Select Id, ProfitStars_Merchant_ID__c from ValuePlus__c where Account__r.Name = 'Test Account0' limit 1];
		vp.ProfitStars_Merchant_ID__c = '343434';
		update vp;

		Bank_Account__c bank = [Select Id, LID__c from Bank_Account__c where Account_Label__c = 'Test Bank Account0'];
		bank.LID__c = '898989';
		update bank;
								 
		Test.startTest();
		Map<String, String> responseHeaders = new Map<String, String>();
		responseHeaders.put('Content-Type', 'application/json');
		Test.setMock(HttpCalloutMock.class, new HttpMockTestTemplate(
			new List<Integer>{200, 200}, 'OK', new List<String> {validVelocitySettingCallJson, 
			validMaintCallJson}, responseHeaders));

		String velocityResp = ps_buttonMethods.callVelocity(vp.Id);
		Test.stopTest();

		List<PS_Audit_Log__c> auditLogList = [SELECT Id, Call_Type__c, Error_Message__c FROM PS_Audit_Log__c where Value_plus__c = :vp.Id];
		System.assertNotEquals(0, auditLogList.size());
		System.assert('Batch Velocity Update' == auditLogList[0].Call_Type__c);
		// System.assertEquals('Success', auditLogList[0].Error_Message__c);
	}

	static testmethod void velocityErrorTest(){

		TestUtils.genTestSettings(true);
		TestUtils.genVelocityCustomSetting();

		ValuePlus__c vp = [Select Id, ProfitStars_Merchant_ID__c from ValuePlus__c where Account__r.Name = 'Test Account0' limit 1];
		vp.ProfitStars_Merchant_ID__c = '343434';
		update vp;

		Bank_Account__c bank = [Select Id, LID__c from Bank_Account__c where Account_Label__c = 'Test Bank Account0'];
		bank.LID__c = '898989';
		update bank;
								 
		Test.startTest();
		Map<String, String> responseHeaders = new Map<String, String>();
		responseHeaders.put('Content-Type', 'application/json');
		Test.setMock(HttpCalloutMock.class, new HttpMockTestTemplate(
			new List<Integer>{200, 200}, 'OK', new List<String> {validVelocitySettingCallJson, 
			errorMaintCallJson}, responseHeaders));

		String velocityResp = ps_buttonMethods.callVelocity(vp.Id);
		Test.stopTest();

		List<PS_Audit_Log__c> auditLogList = [SELECT Id, Call_Type__c, Error_Message__c FROM PS_Audit_Log__c where Value_plus__c = :vp.Id];
		System.assertNotEquals(0, auditLogList.size());
		System.assert('Batch Velocity Update' == auditLogList[0].Call_Type__c);
		// System.assertEquals('Failure', auditLogList[0].Error_Message__c);
	}

	static testmethod void velocityExceptionTest(){

		TestUtils.genTestSettings(true);
		TestUtils.genVelocityCustomSetting();

		ValuePlus__c vp = [Select Id, ProfitStars_Merchant_ID__c from ValuePlus__c where Account__r.Name = 'Test Account0' limit 1];
		vp.ProfitStars_Merchant_ID__c = '343434';
		update vp;

		Bank_Account__c bank = [Select Id, LID__c from Bank_Account__c where Account_Label__c = 'Test Bank Account0'];
		bank.LID__c = '898989';
		update bank;
								 
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new RestClientCalloutMockFactory(200, 'Success', validMaintCallJson, null));

		String velocityResp = ps_buttonMethods.callVelocity(vp.Id);
		Test.stopTest();

		List<PS_Audit_Log__c> auditLogList = [SELECT Id, Call_Type__c, Error_Message__c FROM PS_Audit_Log__c where Value_plus__c = :vp.Id];
		System.assertNotEquals(0, auditLogList.size());
		System.assert('Batch Velocity Update' == auditLogList[0].Call_Type__c);
	}

	static testmethod void locationTest(){

		TestUtils.genTestSettings(true);
		TestUtils.genLocationCustomSetting();

		ValuePlus__c vp = [Select Id, ProfitStars_Merchant_ID__c from ValuePlus__c where Account__r.Name = 'Test Account0' limit 1];
		vp.ProfitStars_Merchant_ID__c = '343434';
		update vp;

		Bank_Account__c bank = [Select Id from Bank_Account__c where Account_Label__c = 'Test Bank Account0'];
								 
		Test.startTest();
		Map<String, String> responseHeaders = new Map<String, String>();
		responseHeaders.put('Content-Type', 'application/json');
		Test.setMock(HttpCalloutMock.class, new HttpMockTestTemplate(
			new List<Integer>{200, 200}, 'OK', new List<String> {validMaintCallJson, 
			validLocByLocNameCallJson}, responseHeaders));

		String locationResp = ps_buttonMethods.callLocation(bank.Id);
		Test.stopTest();

		List<PS_Audit_Log__c> auditLogList = [SELECT Id, Call_Type__c, Error_Message__c FROM PS_Audit_Log__c where BankAccount__c = :bank.Id];
		System.assertNotEquals(0, auditLogList.size());
		System.assert('Batch Location Update' == auditLogList[0].Call_Type__c);
		// System.assertEquals('Success', auditLogList[0].Error_Message__c);
	}

	static testmethod void locationErrorTest(){

		TestUtils.genTestSettings(true);
		TestUtils.genLocationCustomSetting();

		ValuePlus__c vp = [Select Id, ProfitStars_Merchant_ID__c from ValuePlus__c where Account__r.Name = 'Test Account0' limit 1];
		vp.ProfitStars_Merchant_ID__c = '343434';
		update vp;

		Bank_Account__c bank = [Select Id from Bank_Account__c where Account_Label__c = 'Test Bank Account0'];
								 
		Test.startTest();
		Map<String, String> responseHeaders = new Map<String, String>();
		responseHeaders.put('Content-Type', 'application/json');
		Test.setMock(HttpCalloutMock.class, new HttpMockTestTemplate(
			new List<Integer>{200}, 'OK', new List<String> {errorMaintCallJson}, responseHeaders));

		String locationResp = ps_buttonMethods.callLocation(bank.Id);
		Test.stopTest();

		List<PS_Audit_Log__c> auditLogList = [SELECT Id, Call_Type__c, Error_Message__c FROM PS_Audit_Log__c where BankAccount__c = :bank.Id];
		System.assertNotEquals(0, auditLogList.size());
		System.assert('Batch Location Update' == auditLogList[0].Call_Type__c);
		// System.assertEquals('Failure', auditLogList[0].Error_Message__c);
	}

	static testmethod void locationPSExceptionTest(){

		TestUtils.genLocationCustomSetting();

		ValuePlus__c vp = [Select Id, ProfitStars_Merchant_ID__c from ValuePlus__c where Account__r.Name = 'Test Account0' limit 1];
		vp.ProfitStars_Merchant_ID__c = '343434';
		update vp;

		Bank_Account__c bank = [Select Id from Bank_Account__c where Account_Label__c = 'Test Bank Account0'];
								 
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new RestClientCalloutMockFactory(200, 'Success', validMaintCallJson, null));

		String locationResp = ps_buttonMethods.callLocation(bank.Id);
		Test.stopTest();

		List<PS_Audit_Log__c> auditLogList = [SELECT Id, Call_Type__c, Error_Message__c FROM PS_Audit_Log__c where BankAccount__c = :bank.Id];
		System.assertNotEquals(0, auditLogList.size());
		System.assert('Batch Location Update' == auditLogList[0].Call_Type__c);
	}

	static testmethod void locationExceptionTest(){

		Test.setMock(HttpCalloutMock.class, new RestClientCalloutMockFactory(400, 'Failure', exceptionJson, null));
		TestUtils.genTestSettings(true);
		TestUtils.addRequiredFieldToCustomSetting('Location');

		ValuePlus__c vp = [Select Id, Phone_Verified__c from ValuePlus__c where Account__r.Name = 'Test Account0' limit 1];
		vp.Phone_Verified__c = null;
        update vp;

        Bank_Account__c bank = [Select Id from Bank_Account__c where Account_Label__c = 'Test Bank Account0'];
								 
		Test.startTest();
		String enrollResp = ps_buttonMethods.callLocation(bank.Id);
		Test.stopTest();

		List<PS_Audit_Log__c> auditLogList = [SELECT Id, Call_Type__c, Error_Message__c FROM PS_Audit_Log__c where BankAccount__c = :bank.Id];
		System.assertNotEquals(0, auditLogList.size());
		System.assert('Batch Location Update' == auditLogList[0].Call_Type__c);
	}

	static testmethod void AddReturnAccountTest(){

		TestUtils.genTestSettings(true);

		ValuePlus__c vp = [Select Id, ProfitStars_Merchant_ID__c from ValuePlus__c where Account__r.Name = 'Test Account0' limit 1];
		vp.ProfitStars_Merchant_ID__c = '343434';
		update vp;

		Bank_Account__c bank = [Select Id, Return_Account_Number__c, Return_Routing_Number__c, LID__c from Bank_Account__c where Account_Label__c = 'Test Bank Account0'];
		bank.Return_Account_Number__c = '8569321456';
		bank.Return_Routing_Number__c = '854123678';
		bank.LID__c = '810526';
		update bank;
								 
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new RestClientCalloutMockFactory(200, 'Success', validMaintCallJson, null));

		String returnAccResp = ps_buttonMethods.callAddReturnAccount(bank.Id);
		Test.stopTest();

		List<PS_Audit_Log__c> auditLogList = [SELECT Id, Call_Type__c, Error_Message__c FROM PS_Audit_Log__c where BankAccount__c = :bank.Id];
		System.assertNotEquals(0, auditLogList.size());
		System.assert('Add Return-Only Account' == auditLogList[0].Call_Type__c);
		// System.assertEquals('Success', auditLogList[0].Error_Message__c);
	}

	static testmethod void AddReturnAccountErrorTest(){

		TestUtils.genTestSettings(true);

		ValuePlus__c vp = [Select Id, ProfitStars_Merchant_ID__c from ValuePlus__c where Account__r.Name = 'Test Account0' limit 1];
		vp.ProfitStars_Merchant_ID__c = '343434';
		update vp;

		Bank_Account__c bank = [Select Id, Return_Account_Number__c, Return_Routing_Number__c, LID__c from Bank_Account__c where Account_Label__c = 'Test Bank Account0'];
		bank.Return_Account_Number__c = '8569321456';
		bank.Return_Routing_Number__c = '854123678';
		bank.LID__c = '810526';
		update bank;
								 
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new RestClientCalloutMockFactory(200, 'Success', errorMaintCallJson, null));

		String returnAccResp = ps_buttonMethods.callAddReturnAccount(bank.Id);
		Test.stopTest();

		List<PS_Audit_Log__c> auditLogList = [SELECT Id, Call_Type__c, Error_Message__c FROM PS_Audit_Log__c where BankAccount__c = :bank.Id];
		System.assertNotEquals(0, auditLogList.size());
		System.assert('Add Return-Only Account' == auditLogList[0].Call_Type__c);
		// System.assertEquals('Failure', auditLogList[0].Error_Message__c);
	}

	static testmethod void AddReturnAccountExceptionTest(){

		ValuePlus__c vp = [Select Id, ProfitStars_Merchant_ID__c from ValuePlus__c where Account__r.Name = 'Test Account0' limit 1];
		vp.ProfitStars_Merchant_ID__c = '343434';
		update vp;

		Bank_Account__c bank = [Select Id, Return_Account_Number__c, Return_Routing_Number__c, LID__c from Bank_Account__c where Account_Label__c = 'Test Bank Account0'];
		bank.Return_Account_Number__c = '8569321456';
		bank.Return_Routing_Number__c = '854123678';
		bank.LID__c = '810526';
		update bank;
								 
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new RestClientCalloutMockFactory(200, 'Success', errorMaintCallJson, null));

		String returnAccResp = ps_buttonMethods.callAddReturnAccount(bank.Id);
		Test.stopTest();

		List<PS_Audit_Log__c> auditLogList = [SELECT Id, Call_Type__c, Error_Message__c FROM PS_Audit_Log__c where BankAccount__c = :bank.Id];
		System.assertNotEquals(0, auditLogList.size());
		System.assert('Add Return-Only Account' == auditLogList[0].Call_Type__c);
	}
}