@isTest
public class VantivTestUtils {
	
	public static string legalEntitySuccessResponse = '<legalEntityCreateResponse xmlns="http://psp.litle.com/api/merchant/onboard"><transactionId>82917020908422742</transactionId><legalEntityId>82916971912152256'+
														+'</legalEntityId><responseCode>10</responseCode><responseDescription>Approved</responseDescription><principal><principalId>1</principalId><firstName>venkat</firstName>'+
														+'<lastName>araveeti</lastName></principal></legalEntityCreateResponse>';
														
	public static String legalEntityFailedResponse = '<errorResponse xmlns="http://psp.litle.com/api/merchant/onboard"><transactionId>82917277836821250</transactionId><errors>'+
														+'<error>Error in request: bankRoutingNumber:Value 785541145 is invalid;</error></errors></errorResponse>';
	
	public static String legalEntityDuplicateResponse = '<legalEntityCreateResponse duplicate="true" xmlns="http://psp.litle.com/api/merchant/onboard"> <transactionId>82917277591143981</transactionId><responseCode>36</responseCode>+'
															+'<responseDescription>Duplicate</responseDescription><originalLegalEntity><legalEntityName>Venkat Test4</legalEntityName><legalEntityType>PARTNERSHIP</legalEntityType>+'
															+'<doingBusinessAs>Venkat Test4</doingBusinessAs><taxId>987567455</taxId><contactPhone>2103316951</contactPhone><annualCreditCardSalesVolume>10000</annualCreditCardSalesVolume>+'
															+'<hasAcceptedCreditCards>true</hasAcceptedCreditCards><address><streetAddress1>50 Castillian Dr</streetAddress1><city>Goleta</city><stateProvince>CA</stateProvince>+'
															+'<postalCode>93117</postalCode><countryCode>USA</countryCode></address><principal><principalId>1</principalId><firstName>venkat</firstName><lastName>tet1</lastName>+'
															+'<ssn>987567456</ssn><dateOfBirth>2000-02-01</dateOfBirth><address><streetAddress1>6690 Abrego Rd</streetAddress1><city>Isla Vista</city><stateProvince>AL</stateProvince>+'
															+'<postalCode>93117</postalCode><countryCode>USA</countryCode></address></principal><yearsInBusiness>4</yearsInBusiness><legalEntityId>82917263511961744</legalEntityId>+'
															+'<responseCode>10</responseCode><responseDescription>Approved</responseDescription><transactionId>82917263763703745</transactionId>+'
															+'<updateDate>2016-02-01T17:10:50.382-05:00</updateDate><tinValidationStatus>Pending</tinValidationStatus></originalLegalEntity><principal><firstName>venkat</firstName>+'
															+'<lastName>tet1</lastName></principal></legalEntityCreateResponse>';
															
	public static String subMerchantSuccessResponse = '<subMerchantCreateResponse xmlns="http://psp.litle.com/api/merchant/onboard"><transactionId>82917128551712226</transactionId><subMerchantId>82917128596111582</subMerchantId>'+
														+'<merchantIdentString>01172252</merchantIdentString><paypageCredentials><paypageCredential><username>MYCASE</username> <paypageId>3ipdPLxNjWKN9ms2</paypageId></paypageCredential>'+
														+'</paypageCredentials></subMerchantCreateResponse>';
														
	public static String subMerchantFailedResponse = '<errorResponse xmlns="http://psp.litle.com/api/merchant/onboard"><transactionId>82917277836821250</transactionId><errors>'+
														+'<error>Error in request: bankRoutingNumber:Value 785541145 is invalid;</error></errors></errorResponse>';
	
	public static String  subMerchantDuplicateResponse = '<subMerchantCreateResponse duplicate="true" xmlns="http://psp.litle.com/api/merchant/onboard"><transactionId>82917277591143890</transactionId><originalSubMerchant>+'
														  +'<merchantName>Venkat Test4</merchantName><url>https://www.appfolio.com</url><customerServiceNumber>2103316951</customerServiceNumber>+'
														  +'<hardCodedBillingDescriptor>Venkat Test4</hardCodedBillingDescriptor><maxTransactionAmount>10000</maxTransactionAmount><purchaseCurrency>USD</purchaseCurrency>+'
														  +'<merchantCategoryCode>4812</merchantCategoryCode><bankRoutingNumber>111000025</bankRoutingNumber><bankAccountNumber>XXXXXXXXX-5312</bankAccountNumber><pspMerchantId>BA-00045555</pspMerchantId>+'
														  +'<fraud enabled="true" /><address><streetAddress1>50 Castillian Dr</streetAddress1><streetAddress2 /><city>Goleta</city><stateProvince>CA</stateProvince>+'
														  +'<postalCode>93117</postalCode><countryCode>USA</countryCode></address><primaryContact /><eCheck enabled="false" /><subMerchantFunding enabled="true">+'
														  +'<feeProfile>MyCase Fee Profile</feeProfile></subMerchantFunding><settlementCurrency>USD</settlementCurrency><subMerchantId>82917276301148579</subMerchantId>+'
														 +'<amexSellerId>82917276474245426</amexSellerId><disabled>false</disabled><transactionId>82917277591143890</transactionId><merchantIdentString>01176235</merchantIdentString>+'
														 +'<paypageCredentials><paypageCredential><username>MYCASE</username><paypageId>6qdK5KFrkyQKzU8c</paypageId></paypageCredential></paypageCredentials>+'
														 +'<updateDate>2016-02-03T12:27:28.058-05:00</updateDate></originalSubMerchant></subMerchantCreateResponse>';
	
	public static vantiv_integration__c genTestSettings(Boolean doInsert) {
		vantiv_integration__c vi = new vantiv_integration__c();
		vi.Name = 'MyCase Payments';
		vi.IsActive__c = true;
		vi.Merchant_Category_Code__c = VantivTestUtils.genRandomNumber(4).format();
		vi.Password__c = 'testPassword';
		vi.Endpoint__c = 'http://example.com/' + VantivTestUtils.genRandomNumber(10) + '/' + VantivTestUtils.genRandomNumber(50);
		vi.Username__c = 'testUserName';
		vi.Fee_Profile__c = '123456987';
		if (doInsert) {
			insert vi;
		}
		return vi;
	}
	
	public static void genRootElement() {
		List<vantiv_rootelement__c> listVR = new List<vantiv_rootelement__c>();
		
		listVr.add(addRecordToRootElement('LegalEntityCreateRequest', 'xmlns','http://payfac.vantivcnp.com/api/merchant/onboard','legalEntityCreateRequest'));
		listVr.add(addRecordToRootElement('LegalEntityPrincipalCreateRequest', 'xmlns','http://payfac.vantivcnp.com/api/merchant/onboard','legalEntityPrincipalCreateRequest'));
		listVr.add(addRecordToRootElement('LegalEntityPrincipal3Create', 'xmlns','http://payfac.vantivcnp.com/api/merchant/onboard','legalEntityPrincipalCreateRequest'));				
		listVr.add(addRecordToRootElement('LegalEntityPrincipal4Create', 'xmlns','http://payfac.vantivcnp.com/api/merchant/onboard','legalEntityPrincipalCreateRequest'));
		
		listVr.add(addRecordToRootElement('LegalEntityUpdateRequest', 'xmlns','http://payfac.vantivcnp.com/api/merchant/onboard','legalEntityUpdateRequest'));
		listVr.add(addRecordToRootElement('SubMerchantCreateRequest', 'xmlns','http://payfac.vantivcnp.com/api/merchant/onboard','subMerchantCreateRequest'));
		listVr.add(addRecordToRootElement('SubMerchantUpdateRequest', 'xmlns','http://payfac.vantivcnp.com/api/merchant/onboard','subMerchantUpdateRequest'));
		listVr.add(addRecordToRootElement('subMerchantFunding', 'enabled','true','subMerchantFunding'));
		listVr.add(addRecordToRootElement('fraud', 'enabled','true','fraud'));
		
		insert listVR;
	}
	
	public static vantiv_rootelement__c addRecordToRootElement(String name, String aName, String aValue, String rElement)
	{
		vantiv_rootelement__c vr = new vantiv_rootelement__c();
		vr.Name = name;
		vr.Attribute_Name__c=aName;
		vr.Attribute_Value__c=aValue;
		vr.Root_Element__c=rElement;
		
		return vr;
		
	}
	
	public static void genVantivEntityType()
	{
		List<vantiv_entitytype__c> listVE = new List<vantiv_entitytype__c>();
		listVE.add(new vantiv_entitytype__c(Name='Corporation', Value__c='CORPORATION', EntityOwnershipType__c='PUBLIC'));
		listVE.add(new vantiv_entitytype__c(Name='Limited Liability Partnership', Value__c='LIMITED_PARTNERSHIP', EntityOwnershipType__c='PUBLIC'));
		listVE.add(new vantiv_entitytype__c(Name='LLC', Value__c='LIMITED_LIABILITY_COMPANY', EntityOwnershipType__c='PRIVATE'));
		listVE.add(new vantiv_entitytype__c(Name='Partnership', Value__c='PARTNERSHIP', EntityOwnershipType__c='PUBLIC'));
		listVE.add(new vantiv_entitytype__c(Name='Sole Proprietor', Value__c='INDIVIDUAL_SOLE_PROPRIETORSHIP', EntityOwnershipType__c='PRIVATE'));
		
		insert listVE;
	}
	
	public static Integer genRandomNumber(Integer size) {
		Double d = math.random() * size;
		return d.intValue();
	}
	
	public static Id getRecordTypeIdFromSObjectAndName(String sObjectName, String recordTypeName) {
		return [SELECT id FROM RecordType WHERE sObjectType = :sObjectName AND Name = :recordTypeName].Id;
	}
	
	public static sObject addFieldToCustomSetting(String settingName, String name, String tagName, String fpath, String hardcoded, Boolean req, boolean subquery, Integer sequence) {
		settingName = 'vantiv_' + settingName.replaceAll(' ', '_') + '__c';
		System.debug('Setting name is: ' + settingName);
		Schema.SObjectType targetType = Schema.getGlobalDescribe().get(settingName);
		sObject cSetting = targetType.newSobject();
		cSetting.put('Name', name);
		cSetting.put('Error_Message__c', name);
		cSetting.put('Tag_Name__c', tagName);
		cSetting.put('Field_Path__c', fpath );
		cSetting.put('Is_Required__c', req);
		cSetting.put('Hardcoded_Value__c', hardcoded);
		cSetting.put('Part_of_a_Subquery__c', subquery);
		cSetting.put('Sequence__c', sequence);
		system.debug('cSetting is: ' + cSetting);
		return cSetting;
	}
	
	public static sObject addNodeStartToCustomSetting(String settingName, String name, String tagName, String fpath, String hardcoded, Boolean req, Boolean subquery, Integer sequence) {
		settingName = 'vantiv_' + settingName.replaceAll(' ', '_') + '__c';
		System.debug('Setting name is: ' + settingName);
		Schema.SObjectType targetType = Schema.getGlobalDescribe().get(settingName);
		sObject cSetting = targetType.newSobject();
		cSetting.put('Name', name);
		cSetting.put('Error_Message__c', name);
		cSetting.put('Tag_Name__c', tagName);
		cSetting.put('Field_Path__c', fpath );
		cSetting.put('Is_Required__c', req);
		cSetting.put('Hardcoded_Value__c', hardcoded);
		cSetting.put('Part_of_a_Subquery__c', subquery);
		cSetting.put('Sequence__c', sequence);
		cSetting.put('Is_Branch_Node_Start__c', true);
		system.debug('cSetting is: ' + cSetting);
		return cSetting;
	}
	
	public static sObject addNodeEndToCustomSetting(String settingName, String name, String tagName, String fpath, String hardcoded, Boolean req, Boolean subquery, Integer sequence) {
		settingName = 'vantiv_' + settingName.replaceAll(' ', '_') + '__c';
		System.debug('Setting name is: ' + settingName);
		Schema.SObjectType targetType = Schema.getGlobalDescribe().get(settingName);
		sObject cSetting = targetType.newSobject();
		cSetting.put('Name', name);
		cSetting.put('Error_Message__c', name);
		cSetting.put('Tag_Name__c', tagName);
		cSetting.put('Field_Path__c', fpath );
		cSetting.put('Is_Required__c', req);
		cSetting.put('Hardcoded_Value__c', hardcoded);
		cSetting.put('Part_of_a_Subquery__c', subquery);
		cSetting.put('Sequence__c', sequence);
		cSetting.put('Is_Branch_Node_End__c', true);
		system.debug('cSetting is: ' + cSetting);
		return cSetting;
	}
	
	public static sObject addChildNodeToCustomSetting(String settingName, String name, String tagName, String fpath, String hardcoded, Boolean req, Boolean subquery, Integer sequence) {
		settingName = 'vantiv_' + settingName.replaceAll(' ', '_') + '__c';
		System.debug('Setting name is: ' + settingName);
		Schema.SObjectType targetType = Schema.getGlobalDescribe().get(settingName);
		sObject cSetting = targetType.newSobject();
		cSetting.put('Name', name);
		cSetting.put('Error_Message__c', name);
		cSetting.put('Tag_Name__c', tagName);
		cSetting.put('Field_Path__c', fpath );
		cSetting.put('Is_Required__c', req);
		cSetting.put('Hardcoded_Value__c', hardcoded);
		cSetting.put('Part_of_a_Subquery__c', subquery);
		cSetting.put('Sequence__c', sequence);
		cSetting.put('Is_Child_Node__c', true);
		system.debug('cSetting is: ' + cSetting);
		return cSetting;
	}
	
	public static Account genAccount(Boolean doInsert, String rType) {
		Account a = new Account();
		//As of 9-15-14, the only required fields for account are:
		// RecordType (Customer Internal Property Management Secure Docs)
		// Name
		a.Name = 'McTesterson Account # ' + VantivTestUtils.genRandomNumber(10);
		a.Phone = '555 867 5309';
		a.Ownership_Type__c='Partnership';
		a.Website = 'https://www.appfolio.com';
		a.BillingStreet = '50 Castilian Dr';
		a.BillingCity = 'Goleta';
		a.BillingState = 'CA';
		a.BillingPostalCode = '93117';
		a.BillingCountry = 'USA';
		a.Year_Established__c = '2000';
		a.Tax_ID__c = '2000';
		a.Principal_1_First_Name__c = 'FName';
		a.Principal_1_Last_Name__c = 'LName';
		a.Principal_1_Street__c = '50 Castilian Dr';
		a.Principal_1_City__c = 'Goleta';
		a.Principal_1_State__c = 'CA';
		a.Principal_1_Zip__c = '93117';
		a.Principal_1_SSN__c = '111-11-1111';
		a.Principal_1_DOB__c = date.valueOf('1971-01-01');
		// a.RecordTypeId = VantivTestUtils.getRecordTypeIdFromSObjectAndName('Account', rType);
		if (doInsert) {
			insert a;
		}
		return a;
	}
	
	public static contact genContactForAccount(Account a, Boolean doInsert) {
		Contact c = new Contact();
		c.lastName = 'McTesterson';
		c.email = 'test@mcTesterson.com';
		c.firstName = 'Test';
		c.AccountId = a.Id;
		if (doInsert) {
			insert c;
		}
		return c;
	}
	
	
	public static ValuePlus__c genValuePlus(Boolean doInsert, Id accountId, Id verticalId,  String rType) {
		//As of 9-15-14, the required fields for a value Plus obj are:
		// RecordType (APM Insurance APM Payments APM Screening APM Website MyCase Websites)
		// AccountID
		ValuePlus__c vp = new ValuePlus__c(
			Account__c = accountId,
			Phone_Verified__c = 'yes',
			Annual_CreditCard_Volume__c = 20000,
			Has_Accepted_CreditCards__c = 'Yes',
			CreditCard_Single_Trans_Amount__c = 1000,
			ACH_Type__c = '1',
			Tax_ID__c='845212457',
			MC_Principal_1_First_Name__c = 'principalFirstName',
			MC_Principal_1_Last_Name__c = 'principalLastName',
			MC_Principal_1_SSN__c = '963852147',
			MC_Principal_1_DOB__c = Date.Today().addYears(-35),
			MC_Principal_1_Street__c = '50 Castilian Dr',
			MC_Principal_1_City__c = 'Goleta',
			MC_Principal_1_State__c = 'CA',
			MC_Principal_1_Zip__c = '93117',
			
			MC_Principal_2_First_Name__c = 'principalFirstName',
			MC_Principal_2_Last_Name__c = 'principalLastName',
			MC_Principal_2_SSN__c = '963852147',
			MC_Principal_2_DOB__c = Date.Today().addYears(-35),
			MC_Principal_2_Street__c = '50 Castilian Dr',
			MC_Principal_2_City__c = 'Goleta',
			MC_Principal_2_State__c = 'CA',
			MC_Principal_2_Zip__c = '93117',
			MC_Principal_2_Ownership__c = 20,

			MC_Principal_3_First_Name__c = 'principalFirstName',
			MC_Principal_3_Last_Name__c = 'principalLastName',
			MC_Principal_3_SSN__c = '963852147',
			MC_Principal_3_DOB__c = Date.Today().addYears(-35),
			MC_Principal_3_Street__c = '50 Castilian Dr',
			MC_Principal_3_City__c = 'Goleta',
			MC_Principal_3_State__c = 'CA',
			MC_Principal_3_Zip__c = '93117',
			MC_Principal_3_Ownership__c = 20,

			MC_Principal_4_First_Name__c = 'principalFirstName',
			MC_Principal_4_Last_Name__c = 'principalLastName',
			Principal_4_SSN__c = '963852147',
			MC_Principal_4_DOB__c = Date.Today().addYears(-35),
			Principal_4_Street__c = '50 Castilian Dr',
			MC_Principal_4_City__c = 'Goleta',
			MC_Principal_4_State__c = 'CA',
			MC_Principal_4_Zip__c = '93117',
			MC_Principal_4_Ownership__c = 20,

			recordTypeId = VantivTestUtils.getRecordTypeIdFromSObjectAndName('ValuePlus__c', rType),
			Vantiv_Onboarding_Status__c = 'Ready To Transmit'
		);
		if (doInsert) {
			insert vp;
		}
		return vp;
	}
	
	public static ValuePlus__c genValuePlusWithLegalId(Boolean doInsert, Id accountId, Id verticalId,  String rType) {
		//As of 9-15-14, the required fields for a value Plus obj are:
		// RecordType (APM Insurance APM Payments APM Screening APM Website MyCase Websites)
		// AccountID
		ValuePlus__c vp = new ValuePlus__c(
			Account__c = accountId,
			Phone_Verified__c = 'yes',
			Annual_CreditCard_Volume__c = 20000,
			Has_Accepted_CreditCards__c = 'Yes',
			CreditCard_Single_Trans_Amount__c = 1000,
			ACH_Type__c = '1',
			Tax_ID__c='845212457',
			MC_Principal_1_First_Name__c = 'principalFirstName',
			MC_Principal_1_Last_Name__c = 'principalLastName',
			MC_Principal_1_SSN__c = '963852147',
			MC_Principal_1_DOB__c = Date.Today().addYears(-35),
			MC_Principal_1_Street__c = '50 Castilian Dr',
			MC_Principal_1_City__c = 'Goleta',
			MC_Principal_1_State__c = 'CA',
			MC_Principal_1_Zip__c = '93117',

			MC_Principal_2_First_Name__c = 'principalFirstName',
			MC_Principal_2_Last_Name__c = 'principalLastName',
			MC_Principal_2_SSN__c = '963852147',
			MC_Principal_2_DOB__c = Date.Today().addYears(-35),
			MC_Principal_2_Street__c = '50 Castilian Dr',
			MC_Principal_2_City__c = 'Goleta',
			MC_Principal_2_State__c = 'CA',
			MC_Principal_2_Zip__c = '93117',
			MC_Principal_2_Ownership__c = 20,

			MC_Principal_3_First_Name__c = 'principalFirstName',
			MC_Principal_3_Last_Name__c = 'principalLastName',
			MC_Principal_3_SSN__c = '963852147',
			MC_Principal_3_DOB__c = Date.Today().addYears(-35),
			MC_Principal_3_Street__c = '50 Castilian Dr',
			MC_Principal_3_City__c = 'Goleta',
			MC_Principal_3_State__c = 'CA',
			MC_Principal_3_Zip__c = '93117',
			MC_Principal_3_Ownership__c = 20,

			MC_Principal_4_First_Name__c = 'principalFirstName',
			MC_Principal_4_Last_Name__c = 'principalLastName',
			Principal_4_SSN__c = '963852147',
			MC_Principal_4_DOB__c = Date.Today().addYears(-35),
			Principal_4_Street__c = '50 Castilian Dr',
			MC_Principal_4_City__c = 'Goleta',
			MC_Principal_4_State__c = 'CA',
			MC_Principal_4_Zip__c = '93117',
			MC_Principal_4_Ownership__c = 20,
			recordTypeId = VantivTestUtils.getRecordTypeIdFromSObjectAndName('ValuePlus__c', rType),
			Vantiv_Enrolled_Date__c = Date.today(),
			Vantiv_Onboarding_Status__c = 'Approved',
			Vantiv_Legal_Entity_Id__c = '82916971912152256',
			Vantiv_Legal_Entity_Update_Status__c = 'Ready To Update'
		);
		if (doInsert) {
			insert vp;
		}
		return vp;
	}
	
	
	public static Bank_Account__c genBankAccount(Boolean doInsert, Id valuePlusId) {
		Bank_Account__c ba = new Bank_Account__c();
		ba.RoutingNo__c = '053000196';
		ba.AccountNo__c = '053000196';
		ba.Account_Label__c = 'testBankAccount';
		ba.ValuePlus__c = valuePlusId;
		if (doInsert) {
			insert ba;
		}

		return ba;
	}
	
	public static Bank_Account__c genBankAccountWithSubmerchantId(Boolean doInsert, Id valuePlusId) {
		Bank_Account__c ba = new Bank_Account__c();
		ba.RoutingNo__c = '053000196';
		ba.AccountNo__c = '053000196';
		ba.Account_Label__c = 'testBankAccount';
		ba.Vantiv_Sub_Merchant_Id__c = '123456789';
		ba.Vantiv_Bank_Account_Update_Status__c = 'Ready To Update';
		ba.Vantiv_Bank_Account_Onboarding_Status__c = 'Approved';
		ba.ValuePlus__c = valuePlusId;
		if (doInsert) {
			insert ba;
		}

		return ba;
	}
	
	public static void genCreatePrincipal2Entity()
	{
		List<sObject> cSetting = new List<sObject>();
		//(String settingName, String name, String tagName, String fpath, String hardcoded, Boolean req, boolean subquery, Integer sequence)
		cSetting.add(VantivTestUtils.addNodeEndToCustomSetting('LegalEntityPrincipalCreateRequest', 'addressend', 'address', 'Id', '', false, false, 12));
		cSetting.add(VantivTestUtils.addNodeStartToCustomSetting('LegalEntityPrincipalCreateRequest', 'addressStart', 'address', 'Id', '', false, false, 6));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityPrincipalCreateRequest', 'city', 'city', 'MC_Principal_2_City__c', '', true, false, 8));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityPrincipalCreateRequest', 'countryCode', 'countryCode', 'Account__r.BillingCountry', 'USA', true, false, 11));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityPrincipalCreateRequest', 'dateOfBirth', 'dateOfBirth', 'MC_Principal_2_DOB__c', '', true, false, 5));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityPrincipalCreateRequest', 'firstName', 'firstName', 'MC_Principal_2_First_Name__c', '', true, false, 2));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityPrincipalCreateRequest', 'lastName', 'lastName', 'MC_Principal_2_Last_Name__c', '', true, false, 3));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityPrincipalCreateRequest', 'postalCode', 'postalCode', 'MC_Principal_2_Zip__c', '', true, false, 10));
		cSetting.add(VantivTestUtils.addNodeEndToCustomSetting('LegalEntityPrincipalCreateRequest', 'principalend', 'principal', 'Id', '', false, false, 145));
		cSetting.add(VantivTestUtils.addNodeStartToCustomSetting('LegalEntityPrincipalCreateRequest', 'principalstart', 'principal', 'Id', '', false, false, 75));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityPrincipalCreateRequest', 'ssn', 'ssn', '	MC_Principal_2_SSN__c', '', true, false, 4));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityPrincipalCreateRequest', 'stakePercent', 'stakePercent', 'MC_Principal_2_Ownership__c', '', true, false, 13));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityPrincipalCreateRequest', 'stateProvince', 'stateProvince', 'MC_Principal_2_State__c', '', true, false, 9));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityPrincipalCreateRequest', 'streetAddress1', 'streetAddress1', 'MC_Principal_2_Street__c', '', true, false, 7));

		
		insert cSetting;
	}
	
	public static void genCreatePrincipal3Entity()
	{
		List<sObject> cSetting = new List<sObject>();
		//(String settingName, String name, String tagName, String fpath, String hardcoded, Boolean req, boolean subquery, Integer sequence)
		cSetting.add(VantivTestUtils.addNodeEndToCustomSetting('LegalEntityPrincipal3Create', 'addressend', 'address', 'Id', '', false, false, 12));
		cSetting.add(VantivTestUtils.addNodeStartToCustomSetting('LegalEntityPrincipal3Create', 'addressStart', 'address', 'Id', '', false, false, 6));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityPrincipal3Create', 'city', 'city', 'MC_Principal_3_City__c', '', true, false, 8));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityPrincipal3Create', 'countryCode', 'countryCode', 'Account__r.BillingCountry', 'USA', true, false, 11));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityPrincipal3Create', 'dateOfBirth', 'dateOfBirth', 'MC_Principal_3_DOB__c', '', true, false, 5));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityPrincipal3Create', 'firstName', 'firstName', 'MC_Principal_3_First_Name__c', '', true, false, 2));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityPrincipal3Create', 'lastName', 'lastName', 'MC_Principal_3_Last_Name__c', '', true, false, 3));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityPrincipal3Create', 'postalCode', 'postalCode', 'MC_Principal_3_Zip__c', '', true, false, 10));
		cSetting.add(VantivTestUtils.addNodeEndToCustomSetting('LegalEntityPrincipal3Create', 'principalend', 'principal', 'Id', '', false, false, 145));
		cSetting.add(VantivTestUtils.addNodeStartToCustomSetting('LegalEntityPrincipal3Create', 'principalstart', 'principal', 'Id', '', false, false, 75));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityPrincipal3Create', 'ssn', 'ssn', '	MC_Principal_3_SSN__c', '', true, false, 4));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityPrincipal3Create', 'stakePercent', 'stakePercent', 'MC_Principal_3_Ownership__c', '', true, false, 13));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityPrincipal3Create', 'stateProvince', 'stateProvince', 'MC_Principal_3_State__c', '', true, false, 9));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityPrincipal3Create', 'streetAddress1', 'streetAddress1', 'MC_Principal_3_Street__c', '', true, false, 7));

		
		insert cSetting;
	}	

	public static void genCreatePrincipal4Entity()
	{
		List<sObject> cSetting = new List<sObject>();
		//(String settingName, String name, String tagName, String fpath, String hardcoded, Boolean req, boolean subquery, Integer sequence)
		cSetting.add(VantivTestUtils.addNodeEndToCustomSetting('LegalEntityPrincipal4Create', 'addressend', 'address', 'Id', '', false, false, 12));
		cSetting.add(VantivTestUtils.addNodeStartToCustomSetting('LegalEntityPrincipal4Create', 'addressStart', 'address', 'Id', '', false, false, 6));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityPrincipal4Create', 'city', 'city', 'MC_Principal_4_City__c', '', true, false, 8));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityPrincipal4Create', 'countryCode', 'countryCode', 'Account__r.BillingCountry', 'USA', true, false, 11));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityPrincipal4Create', 'dateOfBirth', 'dateOfBirth', 'MC_Principal_4_DOB__c', '', true, false, 5));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityPrincipal4Create', 'firstName', 'firstName', 'MC_Principal_4_First_Name__c', '', true, false, 2));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityPrincipal4Create', 'lastName', 'lastName', 'MC_Principal_4_Last_Name__c', '', true, false, 3));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityPrincipal4Create', 'postalCode', 'postalCode', 'MC_Principal_4_Zip__c', '', true, false, 10));
		cSetting.add(VantivTestUtils.addNodeEndToCustomSetting('LegalEntityPrincipal4Create', 'principalend', 'principal', 'Id', '', false, false, 145));
		cSetting.add(VantivTestUtils.addNodeStartToCustomSetting('LegalEntityPrincipal4Create', 'principalstart', 'principal', 'Id', '', false, false, 75));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityPrincipal4Create', 'ssn', 'ssn', '	Principal_4_SSN__c', '', true, false, 4));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityPrincipal4Create', 'stakePercent', 'stakePercent', 'MC_Principal_4_Ownership__c', '', true, false, 13));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityPrincipal4Create', 'stateProvince', 'stateProvince', 'MC_Principal_4_State__c', '', true, false, 9));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityPrincipal4Create', 'streetAddress1', 'streetAddress1', 'Principal_4_Street__c', '', true, false, 7));
		
		insert cSetting;
	}
	public static void genCreateLegalEntity()
	{
		List<sObject> cSetting = new List<sObject>();
		//(String settingName, String name, String tagName, String fpath, String hardcoded, Boolean req, boolean subquery, Integer sequence)
		cSetting.add(VantivTestUtils.addFieldToCustomSetting('LegalEntityCreateRequest', 'legalEntityName', 'legalEntityName', 'Account__r.Account_Legal_Name__c', '', true, false, 0));
		cSetting.add(VantivTestUtils.addFieldToCustomSetting('LegalEntityCreateRequest', 'legalEntityType', 'legalEntityType', 'Account__r.Ownership_Type__c', '', true, false, 5));
		cSetting.add(VantivTestUtils.addFieldToCustomSetting('LegalEntityCreateRequest', 'doingBusinessAs', 'doingBusinessAs', 'Account__r.Account_DBA_Name__c', '', true, false, 10));
		cSetting.add(VantivTestUtils.addFieldToCustomSetting('LegalEntityCreateRequest', 'taxId', 'taxId', 'Account__r.Tax_ID__c', '', true, false, 15));
		cSetting.add(VantivTestUtils.addFieldToCustomSetting('LegalEntityCreateRequest', 'contactPhone', 'contactPhone', 'Account__r.Phone', '', false, false, 20));
		cSetting.add(VantivTestUtils.addFieldToCustomSetting('LegalEntityCreateRequest', 'annualCreditCardSalesVolume', 'annualCreditCardSalesVolume', 'Annual_CreditCard_Volume__c', '', true, false, 25));
		cSetting.add(VantivTestUtils.addFieldToCustomSetting('LegalEntityCreateRequest', 'hasAcceptedCreditCards', 'hasAcceptedCreditCards', 'Has_Accepted_CreditCards__c', '', true, false, 30));
		cSetting.add(VantivTestUtils.addNodeStartToCustomSetting('LegalEntityCreateRequest', 'address', 'address', 'Id', '', false, false, 35));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityCreateRequest', 'streetAddress1', 'streetAddress1', 'Account__r.BillingStreet', '', true, false, 40));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityCreateRequest', 'city', 'city', 'Account__r.BillingCity', '', true, false, 45));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityCreateRequest', 'stateProvince', 'stateProvince', 'Account__r.BillingState', '', true, false, 50));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityCreateRequest', 'postalCode', 'postalCode', '	Account__r.BillingPostalCode	', '', true, false, 55));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityCreateRequest', 'countryCode', 'countryCode', 'Account__r.BillingCountry', 'USA', true, false, 60));
		cSetting.add(VantivTestUtils.addNodeEndToCustomSetting('LegalEntityCreateRequest', 'addressend', 'address', 'Id', '', false, false, 70));
		cSetting.add(VantivTestUtils.addNodeStartToCustomSetting('LegalEntityCreateRequest', 'principalstart', 'principal', 'Id', '', false, false, 75));
		//VantivTestUtils.addChildNodeToCustomSetting('LegalEntityCreateRequest', 'title', 'title', 'Id', '', true, false, 80));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityCreateRequest', 'firstName', 'firstName', 'Account__r.Principal_1_First_Name__c', '', true, false, 85));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityCreateRequest', 'lastName', 'lastName', 'Account__r.Principal_1_Last_Name__c', '', true, false, 90));
		//VantivTestUtils.addChildNodeToCustomSetting('LegalEntityCreateRequest', 'emailAddress', 'emailAddress', 'Id', '', true, false, 95));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityCreateRequest', 'ssn', 'ssn', '	Account__r.Principal_1_SSN__c', '', true, false, 100));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityCreateRequest', 'dateOfBirth', 'dateOfBirth', 'Account__r.Principal_1_DOB__c', '', true, false, 105));
		cSetting.add(VantivTestUtils.addNodeStartToCustomSetting('LegalEntityCreateRequest', 'address2', 'address', 'Id', '', false, false, 110));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityCreateRequest', 'streetAddress12', 'streetAddress1', 'Account__r.Principal_1_Street__c', '', true, false, 115));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityCreateRequest', 'city2', 'city', 'Account__r.Principal_1_City__c', '', true, false, 120));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityCreateRequest', 'stateProvince2', 'stateProvince', 'Account__r.Principal_1_State__c', '', true, false, 125));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityCreateRequest', 'postalCode2', 'postalCode', '	Account__r.Principal_1_Zip__c', '', true, false, 130));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityCreateRequest', 'countryCode2', 'countryCode', 'Id', 'USA', false, false, 135));
		cSetting.add(VantivTestUtils.addNodeEndToCustomSetting('LegalEntityCreateRequest', 'address2end', 'address', 'Id', '', false, false, 140));
		cSetting.add(VantivTestUtils.addNodeEndToCustomSetting('LegalEntityCreateRequest', 'principalend', 'principal', 'Id', '', false, false, 145));
		cSetting.add(VantivTestUtils.addFieldToCustomSetting('LegalEntityCreateRequest', 'yearsInBusiness', 'yearsInBusiness', 'Account__r.Year_Established__c', '', false, false, 150));
		
		insert cSetting;
	}
	
	public static void genCreateSubMerchant()
	{
		List<sObject> cSetting = new List<sObject>();
		cSetting.add(VantivTestUtils.addFieldToCustomSetting('SubMerchantCreateRequest', 'merchantName', 'merchantName', 'ValuePlus__r.Account__r.Account_Legal_Name__c	', '', true, false, 0));
		cSetting.add(VantivTestUtils.addFieldToCustomSetting('SubMerchantCreateRequest', 'url', 'url', 'Id', 'https://www.appfolio.com', true, false, 10));
		cSetting.add(VantivTestUtils.addFieldToCustomSetting('SubMerchantCreateRequest', 'customerServiceNumber', 'customerServiceNumber', 'ValuePlus__r.Account__r.Phone', '', true, false, 15));
		cSetting.add(VantivTestUtils.addFieldToCustomSetting('SubMerchantCreateRequest', 'hardCodedBillingDescriptor', 'hardCodedBillingDescriptor', 'ValuePlus__r.Account__r.Account_DBA_Name__c', '', true, false, 20));
		cSetting.add(VantivTestUtils.addFieldToCustomSetting('SubMerchantCreateRequest', 'maxTransactionAmount', 'maxTransactionAmount', 'ValuePlus__r.CreditCard_Single_Trans_Amount__c	', '', true, false, 25));
		cSetting.add(VantivTestUtils.addFieldToCustomSetting('SubMerchantCreateRequest', 'purchaseCurrency', 'purchaseCurrency', 'Id', 'USD', true, false, 30));
		cSetting.add(VantivTestUtils.addFieldToCustomSetting('SubMerchantCreateRequest', 'merchantCategoryCode', 'merchantCategoryCode', 'Id', '', false, false, 35));
		cSetting.add(VantivTestUtils.addFieldToCustomSetting('SubMerchantCreateRequest', 'bankRoutingNumber', 'bankRoutingNumber', 'routingNo__c', '', true, false, 40));
		cSetting.add(VantivTestUtils.addFieldToCustomSetting('SubMerchantCreateRequest', 'bankAccountNumber', 'bankAccountNumber', 'AccountNo__c', '', true, false, 45));
		cSetting.add(VantivTestUtils.addFieldToCustomSetting('SubMerchantCreateRequest', 'pspMerchantId', 'pspMerchantId', 'Name', '', true, false, 50));
		cSetting.add(VantivTestUtils.addNodeStartToCustomSetting('SubMerchantCreateRequest', 'fraud', 'fraud', 'Id', '', false, false, 55));
		cSetting.add(VantivTestUtils.addNodeEndToCustomSetting('SubMerchantCreateRequest', 'fraud2', 'fraud', 'Id', '', false, false, 60));
		cSetting.add(VantivTestUtils.addNodeStartToCustomSetting('SubMerchantCreateRequest', 'address1', 'address', 'Id', '', false, false, 65));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('SubMerchantCreateRequest', 'streetAddress1', 'streetAddress1', 'ValuePlus__r.Account__r.BillingStreet', '', true, false, 70));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('SubMerchantCreateRequest', 'city', 'city', 'ValuePlus__r.Account__r.BillingCity', '', true, false, 75));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('SubMerchantCreateRequest', 'stateProvince', 'stateProvince', 'ValuePlus__r.Account__r.BillingState', '', true, false, 80));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('SubMerchantCreateRequest', 'postalCode', 'postalCode', 'ValuePlus__r.Account__r.BillingPostalCode', '', true, false, 85));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('SubMerchantCreateRequest', 'countryCode', 'countryCode', 'ValuePlus__r.Account__r.BillingCountry', 'USD', false, false, 90));
		cSetting.add(VantivTestUtils.addNodeEndToCustomSetting('SubMerchantCreateRequest', 'address2', 'address', 'Id', '', false, false, 95));
		cSetting.add(VantivTestUtils.addFieldToCustomSetting('SubMerchantCreateRequest', 'createCredentials', 'createCredentials', 'Id', 'false', false, false, 100));
		cSetting.add(VantivTestUtils.addNodeStartToCustomSetting('SubMerchantCreateRequest', 'subMerchantFunding1', 'subMerchantFunding', 'Id', '', false, false, 105));
		cSetting.add(VantivTestUtils.addNodeEndToCustomSetting('SubMerchantCreateRequest', 'subMerchantFunding2', 'subMerchantFunding', 'Id', '', false, false, 110));
		cSetting.add(VantivTestUtils.addFieldToCustomSetting('SubMerchantCreateRequest', 'settlementCurrency', 'settlementCurrency', 'Id', 'USD', false, false, 115));
		
		insert cSetting;
	}
	
	public static void genUpdateLegalEntity()
	{
		List<sObject> cSetting = new List<sObject>();
		//(String settingName, String name, String tagName, String fpath, String hardcoded, Boolean req, boolean subquery, Integer sequence)
		
		cSetting.add(VantivTestUtils.addNodeStartToCustomSetting('LegalEntityUpdateRequest', 'address', 'address', 'Id', '', false, false, 0));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityUpdateRequest', 'streetAddress1', 'streetAddress1', 'Account__r.BillingStreet', '', true, false, 5));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityUpdateRequest', 'city', 'city', 'Account__r.BillingCity', '', true, false, 10));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityUpdateRequest', 'stateProvince', 'stateProvince', 'Account__r.BillingState', '', true, false, 15));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityUpdateRequest', 'postalCode', 'postalCode', '	Account__r.BillingPostalCode	', '', true, false, 20));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityUpdateRequest', 'countryCode', 'countryCode', 'Account__r.BillingCountry', 'USA', true, false, 25));
		cSetting.add(VantivTestUtils.addNodeEndToCustomSetting('LegalEntityUpdateRequest', 'addressend', 'address', 'Id', '', false, false, 30));
		cSetting.add(VantivTestUtils.addFieldToCustomSetting('LegalEntityUpdateRequest', 'contactPhone', 'contactPhone', 'Account__r.Phone', '', false, false, 35));
		cSetting.add(VantivTestUtils.addFieldToCustomSetting('LegalEntityUpdateRequest', 'doingBusinessAs', 'doingBusinessAs', 'Account__r.Account_DBA_Name__c', '', true, false, 40));
		cSetting.add(VantivTestUtils.addFieldToCustomSetting('LegalEntityUpdateRequest', 'annualCreditCardSalesVolume', 'annualCreditCardSalesVolume', 'Annual_CreditCard_Volume__c', '', true, false, 45));
		cSetting.add(VantivTestUtils.addFieldToCustomSetting('LegalEntityUpdateRequest', 'hasAcceptedCreditCards', 'hasAcceptedCreditCards', 'Has_Accepted_CreditCards__c', '', true, false, 50));
		cSetting.add(VantivTestUtils.addNodeStartToCustomSetting('LegalEntityUpdateRequest', 'principalstart', 'principal', 'Id', '', false, false, 55));
		cSetting.add(VantivTestUtils.addNodeStartToCustomSetting('LegalEntityUpdateRequest', 'address2', 'address', 'Id', '', false, false, 60));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityUpdateRequest', 'streetAddress12', 'streetAddress1', 'Account__r.Principal_1_Street__c', '', true, false, 65));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityUpdateRequest', 'city2', 'city', 'Account__r.Principal_1_City__c', '', true, false, 70));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityUpdateRequest', 'stateProvince2', 'stateProvince', 'Account__r.Principal_1_State__c', '', true, false, 75));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityUpdateRequest', 'postalCode2', 'postalCode', '	Account__r.Principal_1_Zip__c', '', true, false, 80));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityUpdateRequest', 'countryCode2', 'countryCode', 'Id', 'USA', false, false, 85));
		cSetting.add(VantivTestUtils.addNodeEndToCustomSetting('LegalEntityUpdateRequest', 'address2end', 'address', 'Id', '', false, false, 90));
		cSetting.add(VantivTestUtils.addNodeStartToCustomSetting('LegalEntityUpdateRequest', 'backgroundCheckFieldsstart', 'backgroundCheckFields', 'Id', '', false, false, 95));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityUpdateRequest', 'firstName', 'firstName', 'Account__r.Principal_1_First_Name__c', '', true, false, 100));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityUpdateRequest', 'lastName', 'lastName', 'Account__r.Principal_1_Last_Name__c', '', true, false, 105));
		//VantivTestUtils.addChildNodeToCustomSetting('LegalEntityUpdateRequest', 'emailAddress', 'emailAddress', 'Id', '', true, false, 95));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityUpdateRequest', 'ssn', 'ssn', '	Account__r.Principal_1_SSN__c', '', true, false, 110));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('LegalEntityUpdateRequest', 'dateOfBirth', 'dateOfBirth', 'Account__r.Principal_1_DOB__c', '', true, false, 115));
		cSetting.add(VantivTestUtils.addNodeEndToCustomSetting('LegalEntityUpdateRequest', 'backgroundCheckFieldsend', 'backgroundCheckFields', 'Id', '', false, false, 120));
		cSetting.add(VantivTestUtils.addNodeEndToCustomSetting('LegalEntityUpdateRequest', 'principalend', 'principal', 'Id', '', false, false, 125));
		cSetting.add(VantivTestUtils.addNodeStartToCustomSetting('LegalEntityUpdateRequest', 'backgroundCheckFieldsstart1', 'backgroundCheckFields', 'Id', '', false, false, 130));
		cSetting.add(VantivTestUtils.addFieldToCustomSetting('LegalEntityUpdateRequest', 'legalEntityName', 'legalEntityName', 'Account__r.Account_Legal_Name__c', '', true, false, 135));
		cSetting.add(VantivTestUtils.addFieldToCustomSetting('LegalEntityUpdateRequest', 'legalEntityType', 'legalEntityType', 'Account__r.Ownership_Type__c', '', true, false, 140));
		cSetting.add(VantivTestUtils.addFieldToCustomSetting('LegalEntityUpdateRequest', 'taxId', 'taxId', 'Account__r.Tax_ID__c', '', true, false, 145));
		cSetting.add(VantivTestUtils.addNodeEndToCustomSetting('LegalEntityUpdateRequest', 'backgroundCheckFieldsend2', 'backgroundCheckFields', 'Id', '', false, false, 150));
		cSetting.add(VantivTestUtils.addFieldToCustomSetting('LegalEntityUpdateRequest', 'yearsInBusiness', 'yearsInBusiness', 'Account__r.Year_Established__c', '', false, false, 155));
		
		insert cSetting;
	}
	
	public static void genUpdateSubMerchant()
	{
		List<sObject> cSetting = new List<sObject>();
		cSetting.add(VantivTestUtils.addFieldToCustomSetting('SubMerchantUpdateRequest', 'url', 'url', 'Id', 'https://www.appfolio.com', true, false, 0));
		cSetting.add(VantivTestUtils.addFieldToCustomSetting('SubMerchantUpdateRequest', 'customerServiceNumber', 'customerServiceNumber', 'ValuePlus__r.Account__r.Phone', '', true, false, 5));
		cSetting.add(VantivTestUtils.addFieldToCustomSetting('SubMerchantUpdateRequest', 'hardCodedBillingDescriptor', 'hardCodedBillingDescriptor', 'ValuePlus__r.Account__r.Account_DBA_Name__c', '', true, false, 10));
		cSetting.add(VantivTestUtils.addFieldToCustomSetting('SubMerchantUpdateRequest', 'maxTransactionAmount', 'maxTransactionAmount', 'ValuePlus__r.CreditCard_Single_Trans_Amount__c	', '', true, false, 15));
		cSetting.add(VantivTestUtils.addFieldToCustomSetting('SubMerchantUpdateRequest', 'bankRoutingNumber', 'bankRoutingNumber', 'routingNo__c', '', true, false, 20));
		cSetting.add(VantivTestUtils.addFieldToCustomSetting('SubMerchantUpdateRequest', 'bankAccountNumber', 'bankAccountNumber', 'AccountNo__c', '', true, false, 25));
		cSetting.add(VantivTestUtils.addNodeStartToCustomSetting('SubMerchantUpdateRequest', 'address1', 'address', 'Id', '', false, false, 30));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('SubMerchantUpdateRequest', 'streetAddress1', 'streetAddress1', 'ValuePlus__r.Account__r.BillingStreet', '', true, false, 35));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('SubMerchantUpdateRequest', 'city', 'city', 'ValuePlus__r.Account__r.BillingCity', '', true, false, 40));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('SubMerchantUpdateRequest', 'stateProvince', 'stateProvince', 'ValuePlus__r.Account__r.BillingState', '', true, false, 45));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('SubMerchantUpdateRequest', 'postalCode', 'postalCode', 'ValuePlus__r.Account__r.BillingPostalCode', '', true, false, 50));
		cSetting.add(VantivTestUtils.addChildNodeToCustomSetting('SubMerchantUpdateRequest', 'countryCode', 'countryCode', 'ValuePlus__r.Account__r.BillingCountry', 'USD', false, false, 55));
		cSetting.add(VantivTestUtils.addNodeEndToCustomSetting('SubMerchantUpdateRequest', 'address2', 'address', 'Id', '', false, false, 60));
		cSetting.add(VantivTestUtils.addNodeStartToCustomSetting('SubMerchantUpdateRequest', 'fraud', 'fraud', 'Id', '', false, false, 65));
		cSetting.add(VantivTestUtils.addNodeEndToCustomSetting('SubMerchantUpdateRequest', 'fraud2', 'fraud', 'Id', '', false, false, 70));
		
		insert cSetting;
	}
	
}