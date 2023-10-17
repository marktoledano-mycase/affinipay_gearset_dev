/*
* Test class for the ProfitStarsUtils class.
*/
@isTest
private class ProfitStarsUtils_Tests{

	// static String validCallJson = '{"CaseNumber": "00001720", "Success": "true"}';
	// static String validLocByLocNameCallJson = '{"HTTPStatusCode":"200","GetLocationByLocationName":{"GetLocationByLocationNameResult":{"AccountNumberLast4":"7891","AccountType":"Checking","CustServProviderId":"654321","CustomerLocationNumber":"true","EntityId":"589885","LocationEnabled":true,"LocationId":"4140829","LocationName":"Test Bank Account0","MerchantName":"Test Account0-a1l4D00000074qDQAQ","RoutingNumber":"053000196"}}}';
	// static String exceptionLocByLocNameCallJson = '{"HTTPStatusCode":null,"GetLocationByLocationName":{"GetLocationByLocationNameResult":{"AccountNumberLast4":"7891","AccountType":"Checking","CustServProviderId":"654321","CustomerLocationNumber":"true","EntityId":"589885","LocationEnabled":true,"LocationId":"4140829","LocationName":"Test Bank Account0","MerchantName":"Test Account0-a1l4D00000074qDQAQ","RoutingNumber":"053000196"}}}';
	// static String emptyJson = '{}';

	// @TestSetup
    // public static void createTestData(){
    // 	TestDataFactory.createCustomSettings();
    // }

	// static testmethod void test_getConfig_Positive(){
	// 	ProfitStarsIntegration__c a = TestUtils.genTestSettings(true);
		
	// 	Test.startTest();
	// 	ProfitStarsIntegration__c config = ProfitStarsUtils.getConfig('APM Payments', null);
	// 	Test.stopTest();
	// 	System.assertNotEquals(config, null, 'Expected to find a valid ProfitStarsIntegration__c object');
	// }

	// static testmethod void test_getConfig_Negative(){
	// 	ProfitStarsIntegration__c a = TestUtils.genTestSettings(true);
		
	// 	Test.startTest();
	// 	ProfitStarsIntegration__c config = ProfitStarsUtils.getConfig('', null);
	// 	Test.stopTest();
	// 	System.assertEquals(config, null, 'Expected to not find a valid ProfitStarsIntegration__c object');
	// }

	// static testmethod void test_ensureTrailingSlash(){
	// 	Test.startTest();
	// 	String withSlash = ProfitStarsUtils.ensureTrailingSlash('this is a test/');
	// 	String withoutSlash = ProfitStarsUtils.ensureTrailingSlash('this is a test');
	// 	Test.stopTest();

	// 	System.assertEquals(withSlash, 'this is a test/');
	// 	System.assertEquals(withoutSlash, 'this is a test/');
	// }

	// static testmethod void test_createAuditLogInRealtime(){
	// 	// going to need valuePlus object, and the object json
	// 	Account a = TestUtils.genAccount(true);
	// 	ValuePlus__c vp = TestUtils.genValuePlus(true, a.id);
	// 	//ps_KeyValueResponse response = ps_KeyValueResponse.parse(ps_KeyValueResp_Tests.json);

	// 	Test.startTest();
	// 	ProfitStarsUtils.createAuditLogInRealtime('velocity', vp.id, JSON.serialize(validCallJson), 'success', 'APM Payments');
	// 	Test.stopTest();

	// 	List<PS_Audit_Log__c> logs = [SELECT Id, Call_type__c, Raw_Json__c, Value_Plus__c, Error_Message__c FROM PS_Audit_Log__c WHERE Value_Plus__c = :vp.id];

	// 	System.assertEquals(1, logs.size());
	// 	TestUtils.assertEqualsCaseIndifferent('Velocity', logs[0].Call_type__c, 'Expected to see calltype of velocity');
	// 	System.assertEquals(vp.id, logs[0].Value_Plus__c, 'Log not properly linked to the value+ object');
	// }

	// static testmethod void test_generateAuditLogForValuePlus(){
		
	// 	Account a = TestUtils.genAccount(true);
	// 	ValuePlus__c vp = TestUtils.genValuePlus(true, a.id);

	// 	Test.startTest();
	// 	PS_Audit_Log__c log = ProfitStarsUtils.generateAuditLogForValuePlus('velocity', 'success', JSON.serialize(validCallJson), vp.Id, 'APM Payments');
	// 	insert log;
	// 	Test.stopTest();

	// 	List<PS_Audit_Log__c> logs = [SELECT Id, Call_type__c, Raw_Json__c, Value_Plus__c, Error_Message__c FROM PS_Audit_Log__c WHERE Value_Plus__c = :vp.id];

	// 	System.assertEquals(1, logs.size());
	// 	TestUtils.assertEqualsCaseIndifferent('Velocity', logs[0].Call_type__c, 'Expected to see calltype of velocity');
	// 	System.assertEquals(vp.id, logs[0].Value_Plus__c, 'Log not properly linked to the value+ object');
	// }

	// static testmethod void test_generateAuditLogForBankAccount(){
		
	// 	Account a = TestUtils.genAccount(true);
	// 	ValuePlus__c vp = TestUtils.genValuePlus(true, a.id);
	// 	Bank_Account__c bank = TestUtils.genBankAccount(true, vp.Id);
	// 	TestUtils.genTestSettings(true);

	// 	Bank_Account__c bankRec = [Select Id, ValuePlus__r.recordType.Name, ValuePlus__r.Account__r.Name from Bank_Account__c where Account_Label__c = 'Test Bank Account0'];

	// 	Test.startTest();
	// 	PS_Audit_Log__c log = ProfitStarsUtils.generateAuditLogForBankAccount('Bank update', 'success', JSON.serialize(validCallJson), bank.Id, 'APM Payments');
	// 	insert log;

	// 	ProfitStarsUtils.sendAddOnErrorEmail(bankRec, 'Bank update', 'success', '200', null);
	// 	Test.stopTest();

	// 	List<PS_Audit_Log__c> logs = [SELECT Id, Call_type__c, Raw_Json__c, BankAccount__c, Error_Message__c FROM PS_Audit_Log__c WHERE BankAccount__c = :bank.id];

	// 	System.assertEquals(1, logs.size());
	// 	TestUtils.assertEqualsCaseIndifferent('Bank update', logs[0].Call_type__c, 'Expected to see calltype of Bank update');
	// 	System.assertEquals(bank.id, logs[0].BankAccount__c, 'Log not properly linked to the bank object');
	// }

	// static testmethod void test_generateAuditLogForAccount(){
		
	// 	Account a = TestUtils.genAccount(true);

	// 	Test.startTest();
	// 	PS_Audit_Log__c log = ProfitStarsUtils.generateAuditLogForAccount('Field Update', 'success', JSON.serialize(validCallJson), a.Id, 'Address', 'APM Payments');
	// 	insert log;
	// 	Test.stopTest();

	// 	List<PS_Audit_Log__c> logs = [SELECT Id, Call_type__c, Raw_Json__c, Account__c, Error_Message__c FROM PS_Audit_Log__c WHERE Account__c = :a.id];

	// 	System.assertEquals(1, logs.size());
	// 	TestUtils.assertEqualsCaseIndifferent('Field Update', logs[0].Call_type__c, 'Expected to see calltype of Bank update');
	// 	System.assertEquals(a.id, logs[0].Account__c, 'Log not properly linked to the account object');
	// }

	// static testmethod void test_createAuditLog(){
		
	// 	Account a = TestUtils.genAccount(true);
	// 	ValuePlus__c vp = TestUtils.genValuePlus(true, a.id);
	// 	TestUtils.genTestSettings(true);

	// 	ValuePlus__c vpRec = [Select Id, recordType.Name, Account__r.Name from ValuePlus__c where Account__r.Name = 'Test Account0' limit 1];

	// 	Test.startTest();
	// 	ProfitStarsUtils.createAuditLog('velocity', vp.Id, 'success', '200', 'APM Payments');
	// 	ProfitStarsUtils.sendErrorEmail(vpRec, 'velocity', 'success', '200', null);
	// 	Test.stopTest();

	// 	List<PS_Audit_Log__c> logs = [SELECT Id, Call_type__c, Raw_Json__c, Value_Plus__c, Error_Message__c FROM PS_Audit_Log__c WHERE Value_Plus__c = :vp.id];

	// 	System.assertEquals(1, logs.size());
	// 	TestUtils.assertEqualsCaseIndifferent('Velocity', logs[0].Call_type__c, 'Expected to see calltype of velocity');
	// 	System.assertEquals(vp.id, logs[0].Value_Plus__c, 'Log not properly linked to the value+ object');
	// }

	// static testmethod void test_sanitizeJson(){
	// 	Test.startTest();
	// 	String sanitized = ProfitStarsUtils.sanitizeJson(ps_KeyValueResp_Tests.json);
	// 	Test.stopTest();

	// 	System.assertNotEquals(sanitized, ps_KeyValueResp_Tests.json, 'Failed to find matching sanitized json');
	// 	System.assert(sanitized.contains('san_'), 'Failed to find sanitization prefix in string representation of json');
	// }

	// static testmethod void test_getRequiredFieldsForCall_valid(){
	// 	TestUtils.addRequiredFieldToCustomSetting('velocity');
	// 	TestUtils.addRequiredFieldToCustomSetting('bank account');
	// 	TestUtils.addRequiredFieldToCustomSetting('location');
	// 	TestUtils.addRequiredFieldToCustomSetting('enrollment');
	// 	Test.startTest();
	// 	Map<String, sObject> reqFieldsVel = ProfitStarsUtils.getRequiredFieldsForCall('velocity');
	// 	Map<String, sObject> reqFieldsBank = ProfitStarsUtils.getRequiredFieldsForCall('bank account');
	// 	Map<String, sObject> reqFieldsLoc = ProfitStarsUtils.getRequiredFieldsForCall('location');
	// 	Map<String, sObject> reqFieldsEnroll = ProfitStarsUtils.getRequiredFieldsForCall('enrollment');
	// 	Test.stopTest();

	// 	System.assert(reqFieldsVel.keyset().size() > 0, 'Failed to acquire fieldset members. Fieldset exists?');
	// 	System.assert(reqFieldsBank.keyset().size() > 0, 'Failed to acquire fieldset members. Fieldset exists?');
	// 	System.assert(reqFieldsLoc.keyset().size() > 0, 'Failed to acquire fieldset members. Fieldset exists?');
	// 	System.assert(reqFieldsEnroll.keyset().size() > 0, 'Failed to acquire fieldset members. Fieldset exists?');
	// }

	// static testmethod void test_getRequiredFieldsForCall_invalid(){
	// 	Boolean didPass = false;
	// 	Test.startTest();
	// 	try {
	// 		Map<String, sObject> reqFields = ProfitStarsUtils.getRequiredFieldsForCall('FOOBAR');
	// 	} catch (ProfitStarsUtils.PSUtilsException e) {
	// 		didPass = true;
	// 	}
	// 	Test.stopTest();

	// 	System.assert(didPass, 'Failed to catch NullPointerException');
	// }

	// static testmethod void test_extractRelatedField_validRelatedField(){
	// 	Account a = TestUtils.genAccount(true);
	// 	ValuePlus__c vp = TestUtils.genValuePlus(true, a.id);
	// 	TestUtils.addRequiredFieldToCustomSetting('velocity');
	// 	Map<String, sObject> reqFields = ProfitStarsUtils.getRequiredFieldsForCall('velocity');
	// 	ValuePlus__c vp2 = ProfitStarsRequestBuilder.getRecord(vp.id, reqFields, 'velocity', null);

	// 	Test.startTest();
	// 	for(String fsm : reqFields.keyset()){
	// 		sObject x = reqFields.get(fsm);
	// 		String results = ProfitStarsUtils.extractRelatedField((String) x.get('Field_Path__c'), vp2, null);
	// 		system.assertNotEquals(null, results, 'Failed to extract the field ' + fsm);
	// 	}
	// 	Test.stopTest();
	// }

	// static testmethod void test_extractRelatedField_echeck(){
	// 	Account a = TestUtils.genAccount(false);
	// 	a.ProfitStars_Update_Field__c = 'Name';
	// 	insert a;

	// 	ValuePlus__c vp = TestUtils.genValuePlus(false, a.id);
	// 	vp.ProfitStars_Merchant_ID__c = '345678';
	// 	vp.Outbound_MID__c = '876543';
	// 	insert vp;

	// 	TestUtils.genOutboundTestSettings(true);
    //     TestUtils.genEcheckFieldsTestSettings(true);
    //     TestUtils.genFieldCustomSetting();

	// 	Map<String, sObject> reqFields = ProfitStarsUtils.getRequiredFieldsForCall('field update');
	// 	ValuePlus__c vp2 = ProfitStarsRequestBuilder.getRecord(vp.id, reqFields, 'field update', 'echeck');

	// 	Test.startTest();
	// 	for(String fsm : reqFields.keyset()){
	// 		sObject x = reqFields.get(fsm);
	// 		if((Boolean) x.get('Required__c')){
	// 			String results = ProfitStarsUtils.extractRelatedField((String) x.get('Field_Path__c'), vp2, 'echeck');
	// 			system.assertNotEquals(null, results, 'Failed to extract the field ' + fsm);
	// 		}
	// 	}
	// 	Test.stopTest();
	// }

	// static testmethod void test_extractRelatedField_InValidRelatedField(){
	// 	Boolean didPass = false;
	// 	Account a = TestUtils.genAccount(true);
	// 	ValuePlus__c vp = TestUtils.genValuePlus(true, a.id);
	// 	TestUtils.addRequiredFieldToCustomSetting('velocity');
	// 	Map<String, sObject> reqFields = ProfitStarsUtils.getRequiredFieldsForCall('velocity');
	// 	ValuePlus__c vp2 = ProfitStarsRequestBuilder.getRecord(vp.id, reqFields, 'velocity', null);

	// 	Test.startTest();
	// 	try {
	// 		String results = ProfitStarsUtils.extractRelatedField('account__r.foobar__c', vp2, null);
	// 	} catch (SObjectException e) {
	// 		didPass = true;
	// 	}
	// 	Test.stopTest();
	// 	System.assert(didPass, 'Expected an NPE to be thrown by extractRelatedField');
	// }

	// static testmethod void test_extractRelatedField_validDirectField(){
	// 	Account a = TestUtils.genAccount(true);
	// 	ValuePlus__c vp = TestUtils.genValuePlus(true, a.id);
	// 	TestUtils.addRequiredFieldToCustomSetting('velocity');
	// 	Map<String, sObject> reqFields = ProfitStarsUtils.getRequiredFieldsForCall('velocity');
	// 	ValuePlus__c vp2 = ProfitStarsRequestBuilder.getRecord(vp.id, reqFields, 'velocity', null);

	// 	Test.startTest();
	// 	String results = ProfitStarsUtils.extractRelatedField('id', vp2, null);
	// 	Test.stopTest();

	// 	system.assertNotEquals(null, results);
	// }

	// static testmethod void test_formatSSN(){
	// 	String ssn = '555112222';
	// 	String formatted = ProfitStarsUtils.formatSSN(ssn);
	// 	System.assertEquals(formatted, '555-11-2222', 'expected a properly formatted ssn');
	// }

	// static testmethod void test_formatTaxId(){
	// 	String d = '445-55-2525 abc';
	// 	String formatted = ProfitStarsUtils.formatTaxId(d);
	// 	system.assertEquals('445552525', formatted, 'expected a properly formatted taxid - just numbers');
	// }

	// static testmethod void test_formatDate(){
	// 	String d = '2014-01-01 17:00:00';
	// 	String formatted = ProfitStarsUtils.formatDate(d);
	// 	system.assertEquals(formatted, '2014-01-01', 'expected a properly formatted date');
	// }

	// static testmethod void test_formatWebsiteurl(){
	// 	String website = 'http://www.google.com';
	// 	String formatted = ProfitStarsUtils.formatWebsiteUrl(website);
	// 	system.assertEquals('google.com', formatted , 'expected formated url');
	// }

	// static testmethod void test_formatWebsiteurlWithoutProtocol(){
	// 	String website = 'www.google.com';
	// 	String formatted = ProfitStarsUtils.formatWebsiteUrl(website);
	// 	system.assertEquals('google.com', formatted , 'expected formated url');
	// }

	// static testmethod void test_formatCustomerNameLongerThan50Chars(){
	// 	String cname = 'Customer Name longer than 50 characters of doom and ruin';
	// 	String formatted = ProfitStarsUtils.formatCustomerName(cname);
	// 	system.assertEquals('Customer Name longer than 50 characters of doom a', formatted , 'expected formated url');
	// }

	// static testmethod void test_formatPhoneNumber(){
	// 	List<String> PhoneNumbers = new List<String>();
	// 	PhoneNumbers.add('9195555555');
	// 	PhoneNumbers.add('919.555.5555');
	// 	PhoneNumbers.add('919 555 5555');
	// 	PhoneNumbers.add('(919) 555-5555');
	// 	PhoneNumbers.add('919-555-5555');

	// 	for (String phoneNum : PhoneNumbers){
	// 		System.assertEquals(ProfitStarsUtils.formatPhoneNumber(phoneNum), '919-555-5555', 'Expected a properly formatted phone #');
	// 	}
	// }

	// static testmethod void test_formatBoolean(){
	// 	List<String> b = new List<String>();
	// 	b.add('TRUE');
	// 	b.add('True');
	// 	b.add('true');

	// 	for (String x : b){
	// 		System.assertEquals(ProfitStarsUtils.formatBoolean(x), '1');
	// 	}

	// 	b = new List<String>();
	// 	b.add('false');
	// 	b.add('False');
	// 	b.add('FALSE');

	// 	for (String x : b){
	// 		System.assertEquals(ProfitStarsUtils.formatBoolean(x), '0');
	// 	}
	// }
	
	// static testmethod void test_profitStarsFormat1(){

	// 	Account acct = TestUtils.genAccount(false);
	// 	acct.Credit_Card_Stage__c = 'Credentialing Complete';
	// 	acct.Tax_ID__c = '123456789';
	// 	insert acct;

	// 	ValuePlus__c valuePlus = TestUtils.genValuePlus(false, acct.id);
	// 	valuePlus.ActiveDate__c = Date.today();
	// 	insert valuePlus;
		
	// 	ValuePlus__c vp = [select Id, Account__r.Tax_ID__c, Stage__c from ValuePlus__c LIMIT 1];
		
	// 	System.assertEquals(ProfitStarsUtils.profitStarsFormat('description', 'Account__r.Tax_ID__c', vp, null), acct.Tax_ID__c);
	// 	System.assertEquals(ProfitStarsUtils.profitStarsFormat('Stage__c', vp.Stage__c, vp, null), valuePlus.Stage__c);
	// }
	
	// static testmethod void test_profitStarsFormat(){
	// 	Map<String, String> data = new Map<String, String>();
	// 	Map<String, String> results = new Map<String, String>();
	// 	data.put('state', 'Alabama');
	// 	data.put('PhoneNumber', '9193817128');
	// 	data.put('FaxNumber', '9193817128');
	// 	data.put('CustomerServicePhoneNumber', '9193817128');
	// 	data.put('websiteUrl', 'http://www.google.com');
	// 	data.put('PrimaryOfficerSSN', '222114444');
	// 	data.put('SecondaryOfficerSSN', '222114444');
	// 	data.put('ApplicationCertificationAgreement', 'true');
	// 	data.put('PrimaryOfficerDOB', '2014-01-01 17:00:00');
	// 	data.put('SecondaryOfficerDOB', '2013-01-01 17:00:00');

	// 	results.put('state', 'Al');
	// 	results.put('PhoneNumber', '919-381-7128');
	// 	results.put('FaxNumber', '919-381-7128');
	// 	results.put('CustomerServicePhoneNumber', '919-381-7128');
	// 	results.put('websiteUrl', 'google.com');
	// 	results.put('PrimaryOfficerSSN', '222-11-4444');
	// 	results.put('SecondaryOfficerSSN', '222-11-4444');
	// 	results.put('ApplicationCertificationAgreement', '1');
	// 	results.put('PrimaryOfficerDOB', '2014-01-01');
	// 	results.put('SecondaryOfficerDOB', '2013-01-01');

	// 	for (String key : data.keySet()){
	// 		System.assertEquals(
	// 			ProfitStarsUtils.profitStarsFormat(key, data.get(key)),
	// 			results.get(key),
	// 			'Failed to find a properly formatted string!');
	// 	}
	// }

	// static testmethod void fetchBankAccountToUpdateTest(){
	// 	Account a = TestUtils.genAccount(true);
	// 	ValuePlus__c vp = TestUtils.genValuePlus(true, a.id);
	// 	Bank_Account__c bank = TestUtils.genBankAccount(true, vp.Id);

	// 	Bank_Account__c bankRec = [Select Id, Location_Add_Status__c, LID__c, ps_LocationUpdateRequired__c, Ready_for_push_to_ProfitStars__c from Bank_Account__c where Account_Label__c = 'Test Bank Account0'];

	// 	Test.startTest();
	// 	ProfitStarsUtils.fetchBankAccountToUpdate(bankRec, validLocByLocNameCallJson);
	// 	Test.stopTest();

	// 	System.assertEquals('Approved', bankRec.Location_Add_Status__c);
	// }

	// static testmethod void fetchBankAccountToUpdateExceptionTest(){
	// 	Account a = TestUtils.genAccount(true);
	// 	ValuePlus__c vp = TestUtils.genValuePlus(true, a.id);
	// 	Bank_Account__c bank = TestUtils.genBankAccount(true, vp.Id);
	// 	Boolean didPass = false;

	// 	Bank_Account__c bankRec = [Select Id, Location_Add_Status__c, LID__c, ps_LocationUpdateRequired__c, Ready_for_push_to_ProfitStars__c from Bank_Account__c where Account_Label__c = 'Test Bank Account0'];

	// 	Test.startTest();
	// 	try{
	// 		ProfitStarsUtils.fetchBankAccountToUpdate(bankRec, exceptionLocByLocNameCallJson);
	// 	} catch(Exception ex){
	// 		didPass = true;
	// 	}
	// 	Test.stopTest();

	// 	System.assert(didPass, 'Expected an exception to be thrown!');
	// }

	// static testmethod void fetchBankAccountToUpdateEmptyExceptionTest(){
	// 	Account a = TestUtils.genAccount(true);
	// 	ValuePlus__c vp = TestUtils.genValuePlus(true, a.id);
	// 	Bank_Account__c bank = TestUtils.genBankAccount(true, vp.Id);
	// 	Boolean didPass = false;

	// 	Bank_Account__c bankRec = [Select Id, Location_Add_Status__c, LID__c, ps_LocationUpdateRequired__c, Ready_for_push_to_ProfitStars__c from Bank_Account__c where Account_Label__c = 'Test Bank Account0'];

	// 	Test.startTest();
	// 	try{
	// 		ProfitStarsUtils.fetchBankAccountToUpdate(bankRec, emptyJson);
	// 	} catch(Exception ex){
	// 		didPass = true;
	// 	}
	// 	Test.stopTest();

	// 	System.assert(didPass, 'Expected an exception to be thrown!');
	// }

	// static testmethod void fetchBankAccountToUpdateOBTest(){
	// 	Account a = TestUtils.genAccount(true);
	// 	ValuePlus__c vp = TestUtils.genValuePlus(true, a.id);
	// 	Bank_Account__c bank = TestUtils.genBankAccount(true, vp.Id);

	// 	Bank_Account__c bankRec = [Select Id, Outbound_Location_Add_Status__c, Outbound_LID__c from Bank_Account__c where Account_Label__c = 'Test Bank Account0'];

	// 	Test.startTest();
	// 	ProfitStarsUtils.fetchBankAccountToUpdateOutbound(bankRec, validLocByLocNameCallJson);
	// 	Test.stopTest();

	// 	System.assertEquals('Approved', bankRec.Outbound_Location_Add_Status__c);
	// }

	// static testmethod void fetchBankAccountToUpdateOBExceptionTest(){
	// 	Account a = TestUtils.genAccount(true);
	// 	ValuePlus__c vp = TestUtils.genValuePlus(true, a.id);
	// 	Bank_Account__c bank = TestUtils.genBankAccount(true, vp.Id);
	// 	Boolean didPass = false;

	// 	Bank_Account__c bankRec = [Select Id, Outbound_Location_Add_Status__c, Outbound_LID__c from Bank_Account__c where Account_Label__c = 'Test Bank Account0'];

	// 	Test.startTest();
	// 	try{
	// 		ProfitStarsUtils.fetchBankAccountToUpdateOutbound(bankRec, exceptionLocByLocNameCallJson);
	// 	} catch(Exception ex){
	// 		didPass = true;
	// 	}
	// 	Test.stopTest();

	// 	System.assert(didPass, 'Expected an exception to be thrown!');
	// }

	// static testmethod void fetchBankAccountToUpdateOBEmptyExceptionTest(){
	// 	Account a = TestUtils.genAccount(true);
	// 	ValuePlus__c vp = TestUtils.genValuePlus(true, a.id);
	// 	Bank_Account__c bank = TestUtils.genBankAccount(true, vp.Id);
	// 	Boolean didPass = false;

	// 	Bank_Account__c bankRec = [Select Id, Outbound_Location_Add_Status__c, Outbound_LID__c from Bank_Account__c where Account_Label__c = 'Test Bank Account0'];

	// 	Test.startTest();
	// 	try{
	// 		ProfitStarsUtils.fetchBankAccountToUpdateOutbound(bankRec, emptyJson);
	// 	} catch(Exception ex){
	// 		didPass = true;
	// 	}
	// 	Test.stopTest();

	// 	System.assert(didPass, 'Expected an exception to be thrown!');
	// }

	/*static testmethod void PSBatchSchedulable_OmnibusTest(){

		Test.startTest();
		PSBatchSchedulable_Omnibus.start();
		Test.stopTest();

		List<CronTrigger> ctList = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger];
		System.assertNotEquals(0, ctList.size());
	}*/
}