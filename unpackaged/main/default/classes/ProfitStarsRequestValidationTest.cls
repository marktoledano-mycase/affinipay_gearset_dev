/*
* Test class for the ProfitStarsRequestValidation class.
*/
@isTest
private class ProfitStarsRequestValidationTest {

	private static Account a;
	private static ValuePlus__c vp;
	private static Map<String, sObject> requiredFields;
	private static ValuePlus__c record;
	private static String action;

	@TestSetup
    public static void createTestData(){
    	TestDataFactory.createCustomSettings();
    }

	//Positive cases for velocity, fieldupdate, bank_account, location and enrollment
	static testmethod void validVelocityCallTest(){
		setup('velocity');

		Test.startTest();
		Boolean result = ProfitStarsRequestValidation.validate(record, requiredFields, action, null);
		Test.stopTest();
		system.assert(result, 'Expected this test to pass validation.');
	}

	static testmethod void validFieldUpdateCallTest(){
		setup('field update');

		Test.startTest();
		Boolean result = ProfitStarsRequestValidation.validate(record, requiredFields, action, null);
		Test.stopTest();
		system.assert(result, 'Expected this test to pass validation.');
	}

	static testmethod void validBankAccountCallTest(){
		setup('bank account');

		Test.startTest();
		Boolean result = ProfitStarsRequestValidation.validate(record, requiredFields, action, null);
		Test.stopTest();
		system.assert(result, 'Expected this test to pass validation.');
	}

	static testmethod void validLocationCallTest(){
		setup('Location');

		Test.startTest();
		Boolean result = ProfitStarsRequestValidation.validate(record, requiredFields, action, null);
		Test.stopTest();
		system.assert(result, 'Expected this test to pass validation.');
	}

	static testmethod void validEnrollmentCallTest(){
		setup('enrollment');

		Test.startTest();
		Boolean result = ProfitStarsRequestValidation.validate(record, requiredFields, action, null);
		Test.stopTest();
		system.assert(result, 'Expected this test to pass validation.');
	}

	static testmethod void completeEnrollWithoutBankCallTest(){
		TestUtils.genTestSettings(true);
		TestUtils.genEnrollmentCustomSettings();
		
		action = 'enrollment';
		a = TestUtils.genAccount(true);
		vp = TestUtils.genValuePlus(true, a.id);

		a.ShippingStreet = '44th St S';
		a.ShippingCity = 'Goleta';
		a.Ownership_Type__c = null;
		a.Principal_1_Ownership__c = 25;
		update a;

		vp.Stage__c = 'Sold/Not Started';
		update vp;

		List<Bank_Account__c> bankList = TestDataFactory.createBankAccountList(1, vp.Id, false);
		bankList[0].RoutingNo__c = '053000196';
		bankList[0].AccountNo__c = '1234567891';
		bankList[0].Account_Type__c = '0';
		insert bankList;

		requiredFields = ProfitStarsUtils.getRequiredFieldsForCall(action);
		record = ProfitStarsRequestBuilder.getRecord(vp.id, requiredFields, action, null);

		Test.startTest();
		Boolean result = ProfitStarsRequestValidation.validate(record, requiredFields, action, null);
		Test.stopTest();
		system.assert(result, 'Expected this test to pass validation.');
	}

	static testmethod void completeEnrollWithBankCallTest(){
		TestUtils.genTestSettings(true);
		TestUtils.genEnrollmentCustomSettings();
		
		action = 'enrollment';
		a = TestUtils.genAccount(true);
		vp = TestUtils.genValuePlus(true, a.id);

		a.ShippingStreet = '44th St S';
		a.ShippingCity = 'Goleta';
		a.Ownership_Type__c = null;
		a.Principal_1_Ownership__c = 25;
		update a;

		vp.Stage__c = 'Sold/Not Started';
		update vp;

		List<Bank_Account__c> bankList = TestDataFactory.createBankAccountList(1, vp.Id, false);
		bankList[0].RoutingNo__c = '053000196';
		bankList[0].AccountNo__c = '1234567891';
		bankList[0].Account_Type__c = '0';
		bankList[0].Ready_for_push_to_ProfitStars__c = true;
		bankList[0].ps_LocationUpdateRequired__c = true;
		insert bankList;

		requiredFields = ProfitStarsUtils.getRequiredFieldsForCall(action);
		record = ProfitStarsRequestBuilder.getRecord(vp.id, requiredFields, action, null);

		Test.startTest();
		Boolean result = ProfitStarsRequestValidation.validate(record, requiredFields, action, null);
		Test.stopTest();
		system.assert(result, 'Expected this test to pass validation.');
	}

	//Negative cases for velocity, fieldupdate, bank_account, location and enrollment
	static testmethod void errorVelocityCallTest(){
		Boolean didFail = false;
		setup('velocity');

		record.Phone_Verified__c = null;

		Test.startTest();

		try{
			Boolean result = ProfitStarsRequestValidation.validate(record, requiredFields, action, null);
		} catch(ProfitStarsRequestValidation.ProfitStarsValidationException e){
			didFail = true;
		}
		System.assert(didFail, 'Expected a validation error, but didn\'t get one');

		Test.stopTest();
	}

	static testmethod void errorFieldUpdateCallTest(){
		Boolean didFail = false;
		setup('field update');

		record.Phone_Verified__c = null;

		Test.startTest();

		try{
			Boolean result = ProfitStarsRequestValidation.validate(record, requiredFields, action, null);
		} catch(ProfitStarsRequestValidation.ProfitStarsValidationException e){
			didFail = true;
		}
		System.assert(didFail, 'Expected a validation error, but didn\'t get one');

		Test.stopTest();
	}

	static testmethod void errorBankAccountCallTest(){
		Boolean didFail = false;
		setup('bank account');

		record.Phone_Verified__c = null;

		Test.startTest();

		try{
			Boolean result = ProfitStarsRequestValidation.validate(record, requiredFields, action, null);
		} catch(ProfitStarsRequestValidation.ProfitStarsValidationException e){
			didFail = true;
		}
		System.assert(didFail, 'Expected a validation error, but didn\'t get one');

		Test.stopTest();
	}

	static testmethod void errorLocationCallTest(){
		Boolean didFail = false;
		setup('Location');

		record.Phone_Verified__c = null;

		Test.startTest();

		try{
			Boolean result = ProfitStarsRequestValidation.validate(record, requiredFields, action, null);
		} catch(ProfitStarsRequestValidation.ProfitStarsValidationException e){
			didFail = true;
		}
		System.assert(didFail, 'Expected a validation error, but didn\'t get one');

		Test.stopTest();
	}

	static testmethod void errorEnrollmentCallTest(){
		Boolean didFail = false;
		setup('enrollment');

		record.Phone_Verified__c = null;

		Test.startTest();

		try{
			Boolean result = ProfitStarsRequestValidation.validate(record, requiredFields, action, null);
		} catch(ProfitStarsRequestValidation.ProfitStarsValidationException e){
			didFail = true;
		}
		System.assert(didFail, 'Expected a validation error, but didn\'t get one');

		Test.stopTest();
	}

	static testmethod void invalidCustomSettingTest(){
		Boolean didFail = false;
		setup('enrollment');

		record.Phone_Verified__c = null;

		Test.startTest();

		try{
			Boolean result = ProfitStarsRequestValidation.validate(record, requiredFields, 'invalid', null);
		} catch(Exception e){
			didFail = true;
		}
		System.assert(didFail, 'Expected a validation error, but didn\'t get one');

		Test.stopTest();
	}

	static testmethod void requestTestsPSIS(){
		String validCallJson = '{"CaseNumber": "00001720", "Success": "true"}';
		Test.setMock(HttpCalloutMock.class, new RestClientCalloutMockFactory(200, 'Success', validCallJson, null));

		TestUtils.genTestSettings(true);
		a = TestUtils.genAccount(true);
		vp = TestUtils.genValuePlus(true, a.id);

		List<String> responses = new List<String>();
		ProfitStarsIntegrationService ps = new ProfitStarsIntegrationService();

		vp.ProfitStars_Merchant_ID__c = '234432';
		update vp;

		Test.startTest();

		responses.add(ps.makeGetAllLocationsRequest(vp.Id, null));
		responses.add(ps.makeGetLocationByLocationIdRequest(vp.Id, null));
		responses.add(ps.makeGetVelocitySettingsByLocationIdRequest(vp.Id, null));

		Test.stopTest();

		System.assertNotEquals(0, responses.size());
	}

	//Setup Helper method.
	private static void setup(String incomingAction){
		action = incomingAction;
		TestUtils.addRequiredFieldToCustomSetting(incomingAction);
		a = TestUtils.genAccount(true);
		vp = TestUtils.genValuePlus(true, a.id);
		requiredFields = ProfitStarsUtils.getRequiredFieldsForCall(incomingAction);
		record = ProfitStarsRequestBuilder.getRecord(vp.id, requiredFields, incomingAction, null);
	}
}