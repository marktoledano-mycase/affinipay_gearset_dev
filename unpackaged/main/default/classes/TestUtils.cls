@isTest
public with sharing class TestUtils {
	public class TestUtilsException extends exception {}

	public static ProfitStarsIntegration__c genTestSettings() {
		return TestUtils.genTestSettings(true);
	}

	public static ProfitStarsIntegration__c genTestSettings(Boolean doInsert) {
		ProfitStarsIntegration__c psi = new ProfitStarsIntegration__c();
		psi.Name = 'MyCase Payments';
		psi.Active__c = true;
		psi.PalId__c = 'PAL-11-111X1X1111X-11XX1XX1';
		psi.Maint_Pal_ID__c = 'PAL-11-111X1X1111X-11XX1XX1';
		psi.Password__c = 's3kret';
		psi.email__c = 'super@awesome.com';
		psi.Url_domain__c = 'http://example.com/' + TestUtils.genRandomNumber(10) + '/' + TestUtils.genRandomNumber(50);
		psi.Username__c = 'Neo0';
		psi.entityId__c = '1234567890';
		psi.Maintenance_Username__c = 'super@awesome.com';
		psi.Record_Type__c = 'test-EPS-268009';
		psi.ProfitStar_Error_Email__c = 'test@test.com';
		psi.Use_SF_Logic__c = false;
		
		if(doInsert){
			insert(psi);
		}
		return psi;
	}
	
	public static void createAWSTestSettings(){
		AmazonSQS__c aws = new AmazonSQS__c();
		aws.Access_Key__c = 'testAccessKey';
		aws.Endpoint__c = 'https://testEndpoint.com/72348234/';
		aws.Queue_Name__c = 'testQueue';
		aws.Region__c = 'region';
		aws.Secret_Key__c = 'testSecret';

		insert(aws);
	}

	public static ProfitStarsIntegration__c genOutboundTestSettings(Boolean doInsert) {
		ProfitStarsIntegration__c psi = new ProfitStarsIntegration__c();
		psi.Name = 'MyCase Payments Echeck';
		psi.Active__c = true;
		psi.PalId__c = 'PAL-11-111X1X1111X-11XX1XX1';
		psi.Maint_Pal_ID__c = 'PAL-11-111X1X1111X-11XX1XX1';
		psi.Password__c = 's3kret';
		psi.email__c = 'super@awesome.com';
		psi.Url_domain__c = 'http://example.com/' + TestUtils.genRandomNumber(10) + '/' + TestUtils.genRandomNumber(50);
		psi.Username__c = 'Neo0';
		psi.entityId__c = '1234567890';
		psi.Maintenance_Username__c = 'super@awesome.com';
		psi.Record_Type__c = 'test-JMC-258030';
		psi.ProfitStar_Error_Email__c = 'test@test.com';
		psi.Use_SF_Logic__c = false;
		if(doInsert){
			insert psi;
		}
		return psi;
	}
	
	public static ProfitStarsIntegration__c genMyCaseInboundTestSettings(Boolean doInsert) {
		ProfitStarsIntegration__c psi = new ProfitStarsIntegration__c();
		psi.Name = 'MyCase Payments';
		psi.Active__c = true;
		psi.PalId__c = 'PAL-11-111X1X1111X-11XX1XX1';
		psi.Maint_Pal_ID__c = 'PAL-11-111X1X1111X-11XX1XX1';
		psi.Password__c = 's3kret';
		psi.email__c = 'super@awesome.com';
		psi.Url_domain__c = 'http://example.com/' + TestUtils.genRandomNumber(10) + '/' + TestUtils.genRandomNumber(50);
		psi.Username__c = 'Neo0';
		psi.entityId__c = '1234567890';
		psi.Maintenance_Username__c = 'super@awesome.com';
		psi.Record_Type__c = 'test-EPS-214726';
		psi.ProfitStar_Error_Email__c = 'test@test.com';
		psi.Use_SF_Logic__c = true;
		if(doInsert){
			insert psi;
		}
		return psi;
	}


	public static List<profitstars_echeck_fields__c> genEcheckFieldsTestSettings(Boolean doInsert){
		List<profitstars_echeck_fields__c> customSettingData = new List<profitstars_echeck_fields__c>();
		customSettingData.add(new profitstars_echeck_fields__c(ActualField__c='Bank_Account__cLID__c', replacement_field__c='Outbound_LID__c', Name='Bank_Account__cLID__c'));
		customSettingData.add(new profitstars_echeck_fields__c(ActualField__c='LID__C', replacement_field__c='Outbound_LID__c', Name='LID__C'));
		customSettingData.add(new profitstars_echeck_fields__c(ActualField__c='LID__c', replacement_field__c='Outbound_LID__c', Name='LID__c'));
		customSettingData.add(new profitstars_echeck_fields__c(ActualField__c='Period_Amount__c', replacement_field__c='Outbound_Period_Amount__c', Name='Period_Amount__c'));
		customSettingData.add(new profitstars_echeck_fields__c(ActualField__c='Period_Count__c', replacement_field__c='Outbound_Period_Count__c', Name='Period_Count__c'));
		customSettingData.add(new profitstars_echeck_fields__c(ActualField__c='ProfitStars_Merchant_ID__c', replacement_field__c='Outbound_MID__c', Name='ProfitStars_Merchant_ID__c'));
		customSettingData.add(new profitstars_echeck_fields__c(ActualField__c='Single_Day_Amount__c', replacement_field__c='Outbound_Single_Day_Amount__c', Name='Single_Day_Amount__c'));
		customSettingData.add(new profitstars_echeck_fields__c(ActualField__c='Single_Day_Count__c', replacement_field__c='Outbound_Single_Day_Count__c', Name='Single_Day_Count__c'));
		customSettingData.add(new profitstars_echeck_fields__c(ActualField__c='Single_Trans_Amount__c', replacement_field__c='Outbound_Single_Trans_Amount__c', Name='Single_Trans_Amount__c'));
		customSettingData.add(new profitstars_echeck_fields__c(ActualField__c='valueplus__rProfitStars_Merchant_ID__c', replacement_field__c='valueplus__r.Outbound_MID__c', Name='valueplus__rProfitStars_Merchant_ID__c'));
		
		if(doInsert){
			insert customSettingData;
		}
		return customSettingData;
	}
	
	//String settingName, String name, String fpath, String hardcoded, Boolean req, Boolean addToQuery, Boolean subquery, String reqIf
	public static void genEnrollmentCustomSettings(){

		List<sObject> customSettings = new List<sObject>();
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('enrollment', 'Account:ClassificationCode', 'ClassificationCode__c', '531311', true, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('enrollment', 'Account:BoardingRefID', 'Id', null, true, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('enrollment', 'Account:CustomerName', 'Account_DBA_Name__c', null, true, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('enrollment', 'Account:', 'Account_DBA_Name__c', null, true, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('enrollment', 'Account:CustomerServicePhoneNumber', 'Account__r.Phone', null, true, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('enrollment', 'Account:custServProviderId', 'DefaultValueField__c', '123456', true, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('enrollment', 'Account:PhysicalAddress1', 'Account__r.ShippingStreet', null, true, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('enrollment', 'Account:PhysicalCity', 'Account__r.ShippingCity', null, true, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('enrollment', 'Account:WebsiteURL', 'Company_Website__c', null, false, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('enrollment', 'CL:Location:AccountNumber', 'Bank_Account__c.AccountNo__c', null, true, true, true, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('enrollment', 'CL:Location:RoutingNumber', 'Bank_Account__c.RoutingNo__c', null, true, true, true, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('enrollment', 'CL:Location:AccountType', 'Bank_Account__c.Account_Type__c', null, true, true, true, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('enrollment', 'CL:Location:BankName', 'Bank_Account__c.Account_Label__c', null, true, true, true, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('enrollment', 'Cont:PC:PrimaryContactName', 'Account__r.Principal_1_Name__c', null, true, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('enrollment', 'Cont:PO:PrimaryOfficerName', 'Account__r.Principal_1_Name__c', null, true, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('enrollment', 'Cont:PO:PrimaryOfficerPercent', 'Account__r.Principal_1_Ownership__c', null, true, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('enrollment', 'Cont:SC:SecondaryContactName', 'DefaultValueField__c',  'TestSecContact', false, false, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('enrollment', 'Cont:SO:SecondaryOfficerName', 'Account__r.Principal_2_Name__c',  null, false, true, false, 'SecondaryCondition1__c'));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('enrollment', 'Cont:SO:SecondaryOfficerPercent', 'Account__r.Principal_2_Ownership__c', null, false, true, false, 'SecondaryCondition2__c'));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('enrollment', 'Cont:TO:TertiaryOfficerName', 'Account__r.Principal_3_Name__c', null, false, true, false, 'TertiaryCondition1__c'));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('enrollment', 'Cont:QO:QuaternaryOfficerName', 'Account__r.Principal_4_Name__c', null, false, true, false, 'QuaternaryCondition1__c'));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('enrollment', 'Opty:RecordType', 'DefaultValueField__c', 'test-EPS-268009', true, false, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('enrollment', 'Opty:MerchCreditPeriodAmount', 'Period_Amount__c', null, false, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('enrollment', 'Opty:MerchCreditPeriodCount', 'Period_Count__c', null, false, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('enrollment', 'Opty:MerchCreditSingleDayAmount', 'Single_Day_Amount__c', null, false, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('enrollment', 'Opty:MerchCreditSingleDayCount', 'Single_Day_Count__c', null, false, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('enrollment', 'Opty:MerchCreditSingleTransAmount', 'Single_Trans_Amount__c', null, false, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('enrollment', 'Opty:MerchDebitPeriodAmount', 'Period_Amount__c', null, false, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('enrollment', 'Opty:MerchDebitPeriodCount', 'Period_Count__c', null, false, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('enrollment', 'Opty:MerchDebitSingleDayAmount', 'Single_Day_Amount__c', null, false, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('enrollment', 'Opty:MerchDebitSingleDayCount', 'Single_Day_Count__c', null, false, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('enrollment', 'Opty:MerchDebitSingleTransAmount', 'Single_Trans_Amount__c', null, false, true, false, null));

		insert customSettings;
	}
	
	//String settingName, String name, String fpath, String hardcoded, Boolean req, Boolean addToQuery, Boolean subquery, String reqIf
	public static void genVelocityCustomSetting(){
		List<sObject> customSettings = new List<sObject>();

		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('velocity', 'case_reason', 'Account__r.Churn_Reason__c', 'APPFOLIO - UPDATE', true, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('velocity', 'customer_name', 'UniqueAccountDBAName__c', null, true, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('velocity', 'custServProviderId', 'DefaultValueField__c', '123456', true, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('velocity', 'entity_id', 'ProfitStars_Merchant_ID__c', null, true, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('velocity', 'location_id', 'Bank_Account__c.LID__c', null, true, true, true, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('velocity', 'location_name', 'Bank_Account__c.Account_Label__c', null, true, true, true, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('velocity', 'max_period_amount', 'Period_Amount__c', null, false, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('velocity', 'max_period_count', 'Period_Count__c', null, false, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('velocity', 'max_single_day_amount', 'Single_Day_Amount__c', null, false, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('velocity', 'max_single_day_count', 'Single_Day_Count__c', null, false, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('velocity', 'max_single_trans_amount', 'Single_Trans_Amount__c', null, false, true, false, null));

		insert customSettings;
	}
	
	//String settingName, String name, String fpath, String hardcoded, Boolean req, Boolean addToQuery, Boolean subquery, String reqIf
	public static void genLocationCustomSetting(){
		List<sObject> customSettings = new List<sObject>();

		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('Location', 'account_number', 'Bank_Account__r.AccountNo__c', null, true, true, true, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('Location', 'account_type', 'Bank_Account__r.Account_Type__c', 'Checking', true, true, true, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('Location', 'case_reason', 'Bank_Account__r.Request_Reason__c', 'Test- Add new location', false, true, true, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('Location', 'customer_name', 'UniqueAccountDBAName__c', null, true, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('Location', 'custServProviderId', 'DefaultValueField__c', '654321', true, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('Location', 'entity_id', 'ProfitStars_Merchant_ID__c', null, true, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('Location', 'location_name', 'Bank_Account__r.Account_Label__c', null, true, true, true, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('Location', 'routing_number', 'Bank_Account__r.RoutingNo__c', null, true, true, true, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('Location', 'use_custom_ach_company_name', 'DefaultValueField__c', 'false', true, true, false, null));

		insert customSettings;
	}

	public static void genLocationCustomSettingIM(){
		List<sObject> customSettings = new List<sObject>();
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('Location', 'account_number', 'Bank_Account__r.AccountNo__c', null, true, true, true, null, 'Bank_Account__r.AccountNo__c'));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('Location', 'account_type', 'Bank_Account__r.Account_Type__c', 'Checking', true, true, true, null, 'Bank_Account__r.Account_Type__c'));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('Location', 'case_reason', 'Bank_Account__r.Request_Reason__c', 'Test- Add new location', false, true, true, null, 'Bank_Account__r.Request_Reason__c'));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('Location', 'customer_name', 'UniqueAccountDBAName__c', null, true, true, false, null, 'IM_DBA_Name__c'));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('Location', 'custServProviderId', 'DefaultValueField__c', '654321', true, true, false, null, 'DefaultValueField__c'));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('Location', 'entity_id', 'ProfitStars_Merchant_ID__c', null, true, true, false, null, 'ProfitStars_Merchant_ID__c'));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('Location', 'location_name', 'Bank_Account__r.Account_Label__c', null, true, true, true, null, 'Bank_Account__r.Account_Label__c'));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('Location', 'routing_number', 'Bank_Account__r.RoutingNo__c', null, true, true, true, null, 'Bank_Account__r.RoutingNo__c'));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('Location', 'use_custom_ach_company_name', 'DefaultValueField__c', 'false', true, true, false, null, 'DefaultValueField__c'));
		insert customSettings;
	}
	
	public static void genFieldCustomSetting(){
		List<sObject> customSettings = new List<sObject>();
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('field update', 'description', 'Account__r.ProfitStars_Update_Description__c', null, true, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('field update', 'customer_name', 'UniqueAccountDBAName__c', null, true, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('field update', 'entity_id', 'ProfitStars_Merchant_ID__c', null, true, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('field update', 'FederalTaxID', 'Account__r.Tax_ID__c', null, true, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('field update', 'subject', 'Account__r.ProfitStars_Update_Field__c', null, true, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('field update', 'Owner 1 Name', 'Account__r.Principal_1_Name__c', null, false, true, false, 'true'));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('field update', 'Owner 1 SSN', 'Account__r.Principal_1_SSN__c', null, false, true, false, 'true'));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('field update', 'Owner 1 City', 'Account__r.Principal_1_City__c', null, false, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('field update', 'Owner 1 DOB', 'Account__r.Principal_1_DOB__c', null, false, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('field update', 'Owner 1 Percent', 'Account__r.Principal_1_Ownership__c', null, false, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('field update', 'Owner 1 State', 'Account__r.Principal_1_State__c', null, false, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('field update', 'Owner 1 Street', 'Account__r.Principal_1_Street__c', null, false, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('field update', 'Owner 1 Zip', 'Account__r.Principal_1_Zip__c', null, false, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('field update', 'Owner 2 Name', 'Account__r.Principal_2_Name__c', null, false, true, false, 'SecondaryCondition1__c'));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('field update', 'Owner 2 SSN', 'Account__r.Principal_2_SSN__c', null, false, true, false, 'SecondaryCondition1__c'));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('field update', 'Owner 2 City', 'Account__r.Principal_2_City__c', null, false, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('field update', 'Owner 2 DOB', 'Account__r.Principal_2_DOB__c', null, false, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('field update', 'Owner 2 Percent', 'Account__r.Principal_2_Ownership__c', null, false, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('field update', 'Owner 2 State', 'Account__r.Principal_2_State__c', null, false, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('field update', 'Owner 2 Street', 'Account__r.Principal_2_Street__c', null, false, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('field update', 'Owner 2 Zip', 'Account__r.Principal_2_Zip__c', null, false, true, false, null));

		insert customSettings;
	}

	public static void genBankAccCustomSetting(){
		List<sObject> customSettings = new List<sObject>();
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('bank account', 'account_number', 'Bank_Account__c.AccountNo__c', null, true, true, true, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('bank account', 'account_type', 'Bank_Account__c.Account_Type__c', 'Checking', true, true, true, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('bank account', 'case_reason', 'Bank_Account__c.Request_Reason__c', 'update', false, true, true, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('bank account', 'customer_name', 'UniqueAccountDBAName__c', null, true, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('bank account', 'custServProviderId', 'DefaultValueField__c', '268009', true, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('bank account', 'entity_id', 'ProfitStars_Merchant_ID__c', null, true, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('bank account', 'location_id', 'Bank_Account__c.LID__c', null, true, true, true, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('bank account', 'location_name', 'Bank_Account__c.Account_Label__c', null, true, true, true, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('bank account', 'request_email', 'DefaultValueField__c', 'bizsys@appfolio.com', true, true, false, null));
		customSettings.add(TestUtils.addRequiredFieldToCustomSettings('bank account', 'routing_number', 'Bank_Account__c.RoutingNo__c', null, true, true, true, null));

		insert customSettings;
	}

	public static Bank_Account__c genBankAccount(Boolean doInsert, Id valuePlusId) {
		List<Bank_Account__c> baList = TestDataFactory.createBankAccountList(1, valuePlusId, false);
		// There is logic surrounding the validity of a routing #
		// this one is Bank of America's Direct Deposit Routing #
		baList[0].RoutingNo__c = '053000196';
		baList[0].AccountNo__c = '053000196';

		if(doInsert){
			insert baList;
		}

		return baList[0];
	}

	public static Bank_Account__c genBankAccount(Boolean doInsert, Id valuePlusId, String lid) {
		List<Bank_Account__c> baList = TestDataFactory.createBankAccountList(1, valuePlusId, false);
		// There is logic surrounding the validity of a routing #
		// this one is Bank of America's Direct Deposit Routing #
		baList[0].RoutingNo__c = '053000196';
		baList[0].AccountNo__c = '053000196';
		baList[0].ValuePlus__c = valuePlusId;
		baList[0].LID__c = lid;

		if(doInsert){
			insert baList;
		}

		return baList[0];
	}

	public static double genRandomNumber(Integer size) {
		Double d = math.random() * size;
		return d.intValue();
	}

	public static Id getRecordTypeIdFromSObjectAndName(String sObjectName, String recordTypeName) {
		return [SELECT id FROM RecordType WHERE sObjectType = :sObjectName AND Name = :recordTypeName].Id;
	}

	public static Account genAccount(Boolean doInsert) {

		List<Account> accList = TestDataFactory.createAccountList(1, false);
		
		// accList[0].RecordTypeId = TestUtils.getRecordTypeIdFromSObjectAndName('Account', 'MyCase Account');

		if(doInsert){
			insert accList;
		}
		return accList[0];
	}

	public static Contact genContactForAccount(Account a, Boolean doInsert) {

		List<Contact> conList = TestDataFactory.createContactList(1, a.Id, doInsert);
		
		return conList[0];
	}

	public static ValuePlus__c genValuePlus(Boolean doInsert, Id accountId) {
		
		List<ValuePlus__c> vpList = TestDataFactory.createValuePlusList(1, accountId, false);

		vpList[0].RecordTypeId = TestUtils.getRecordTypeIdFromSObjectAndName('ValuePlus__c', 'MyCase Payments');
		vpList[0].Successfully_Enrolled_in_Profit_Stars_at__c = Date.today();
		
		if(doInsert) {
			insert vpList;
		}
		return vpList[0];
	}

	public static void assertEqualsCaseIndifferent(String expected, String actual, String throwMessage) {
		System.assertEquals(expected.toLowerCase(), actual.toLowerCase(), throwMessage);
	}

	public static void addRequiredFieldToCustomSetting(String settingName) {
		
		if(settingName == 'enrollment'){
			sObject cs = TestUtils.addRequiredFieldToCustomSettings(settingName, 'For Testing Purposes Only', 'Phone_Verified__c', null, true, true, false, null);
			insert cs;
		} else{
			TestUtils.addRequiredFieldToCustomSetting(settingName, 'For Testing Purposes Only', 'Phone_Verified__c', true);
		}
	}

	public static void addRequiredFieldToCustomSetting(String settingName, String name, String fpath, Boolean req) {
		settingName = 'ps_' + settingName.replaceAll(' ', '_') + '__c';
		System.debug('Setting name is: ' + settingName);
		Schema.SObjectType targetType = Schema.getGlobalDescribe().get(settingName);
		sObject cSetting = targetType.newSobject();
		cSetting.put('Name', name);
		cSetting.put('Custom_Error_Msg__c', name);
		cSetting.put('Field_Path__c', fpath );
		cSetting.put('Required__c', req);
		cSetting.put('Required_If__c', '');

		system.debug('cSetting is: ' + cSetting);
		insert cSetting;
	}

	public static void addRequiredFieldToCustomSetting(String settingName, String name, String fpath, Boolean subquery, Boolean req) {
		settingName = 'ps_' + settingName.replaceAll(' ', '_') + '__c';
		System.debug('Setting name is: ' + settingName);
		Schema.SObjectType targetType = Schema.getGlobalDescribe().get(settingName);
		sObject cSetting = targetType.newSobject();
		cSetting.put('Name', name);
		cSetting.put('Custom_Error_Msg__c', name);
		cSetting.put('Field_Path__c', fpath );
		cSetting.put('Required__c', req);
		cSetting.put('Part_of_a_Subquery__c', subquery);
		cSetting.put('indexed__c', subquery);
		system.debug('cSetting is: ' + cSetting);
		insert cSetting;
	}

	public static void addRequiredFieldToCustomSetting(String settingName, String name, String fpath, Boolean subquery, String hardcoded, Boolean req, boolean indexed) {
		settingName = 'ps_' + settingName.replaceAll(' ', '_') + '__c';
		System.debug('Setting name is: ' + settingName);
		Schema.SObjectType targetType = Schema.getGlobalDescribe().get(settingName);
		sObject cSetting = targetType.newSobject();
		cSetting.put('Name', name);
		cSetting.put('Custom_Error_Msg__c', name);
		cSetting.put('Field_Path__c', fpath );
		cSetting.put('Required__c', req);
		cSetting.put('Hardcoded_Value__c', hardcoded);
		cSetting.put('indexed__c', true);
		cSetting.put('Part_of_a_Subquery__c', subquery);
		system.debug('cSetting is: ' + cSetting);
		insert cSetting;
	}

	public static void addRequiredFieldToCustomSetting(String settingName, String name, String fpath, String hardcoded, Boolean req) {
		settingName = 'ps_' + settingName.replaceAll(' ', '_') + '__c';
		System.debug('Setting name is: ' + settingName);
		Schema.SObjectType targetType = Schema.getGlobalDescribe().get(settingName);
		sObject cSetting = targetType.newSobject();
		cSetting.put('Name', name);
		cSetting.put('Custom_Error_Msg__c', name);
		cSetting.put('Field_Path__c', fpath );
		cSetting.put('Required__c', req);
		cSetting.put('Hardcoded_Value__c', hardcoded);
		//cSetting.put('Required_If__c', '');

		system.debug('cSetting is: ' + cSetting);
		insert cSetting;
	}
    
    public static sObject addRequiredFieldToCustomSettings(String settingName, String name, String fpath, String hardcoded, Boolean req, Boolean addToQuery, Boolean subquery, String reqIf) {
		settingName = 'ps_' + settingName.replaceAll(' ', '_') + '__c';
		System.debug('Setting name is: ' + settingName);
		Schema.SObjectType targetType = Schema.getGlobalDescribe().get(settingName);
		sObject cSetting = targetType.newSobject();
		cSetting.put('Name', name);
		cSetting.put('Custom_Error_Msg__c', name);
		cSetting.put('Field_Path__c', fpath);
		cSetting.put('Required__c', req);
		cSetting.put('Hardcoded_Value__c', hardcoded);
		cSetting.put('Required_If__c', reqIf);
		cSetting.put('Add_to_Query__c', addToQuery);
		cSetting.put('Part_of_a_Subquery__c', subquery);
		if(settingName == 'ps_enrollment__c'){
			cSetting.put('Description__c', 'Test Description');
		}

		system.debug('cSetting is: ' + cSetting);
		return cSetting;
	}

    public static sObject addRequiredFieldToCustomSettings(String settingName, String name, String fpath, String hardcoded, Boolean req, Boolean addToQuery, Boolean subquery, String reqIf, String imFieldPath) {
		settingName = 'ps_' + settingName.replaceAll(' ', '_') + '__c';
		System.debug('Setting name is: ' + settingName);
		Schema.SObjectType targetType = Schema.getGlobalDescribe().get(settingName);
		sObject cSetting = targetType.newSobject();
		cSetting.put('Name', name);
		cSetting.put('Custom_Error_Msg__c', name);
		cSetting.put('Field_Path__c', fpath);
		cSetting.put('Field_Path_IM__c', imFieldPath);
		cSetting.put('Required__c', req);
		cSetting.put('Hardcoded_Value__c', hardcoded);
		cSetting.put('Required_If__c', reqIf);
		cSetting.put('Add_to_Query__c', addToQuery);
		cSetting.put('Part_of_a_Subquery__c', subquery);
		if(settingName == 'ps_enrollment__c'){
			cSetting.put('Description__c', 'Test Description');
		}

		system.debug('cSetting is: ' + cSetting);
		return cSetting;
	}

	public static User genUser(String profileName, Boolean doInsert) {
		User u;
		try {
			ID profileID = [SELECT ID FROM Profile WHERE Name = :profileName].ID;
			u = new User(
				ProfileID =  profileID,
				Username = (math.random() + '@fake.domain.com'),
				LastName = ('testLName' + math.random()),
				Email = (math.random() + '@fake.domain.com'),
				Alias = String.valueOf(math.random()).right(6),
				CommunityNickname = ('testComName' + math.random()),
				TimeZoneSidKey = 'America/New_York',
				LocaleSidKey = 'en_GB',
				EmailEncodingKey = 'UTF-8',
				LanguageLocaleKey = 'en_US'
			);
			if (doInsert) {
				insert u;
			}
		} catch (Exception e) {
			throw new TestUtilsException('Failed to generate test user: ' + e.getMessage());
		}
		return u;
	}

}