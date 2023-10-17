@isTest
private class VantivLegalEntityStatusBatchTest {

    static testMethod void testSuccess() {
        Account account1 = VantivTestUtils.genAccount(true, 'MyCase Account');
        ValuePlus__c vp1 = new ValuePlus__c(
			Account__c = account1.Id,
			Phone_Verified__c = 'yes',
			Annual_CreditCard_Volume__c = 20000,
			//Has_Accepted_CreditCards__c = true,
			CreditCard_Single_Trans_Amount__c = 10000,
			ACH_Type__c = '1',
			Tax_ID__c='758741745',
			MC_Principal_1_First_Name__c = 'principalFirstName',
			MC_Principal_1_Last_Name__c = 'principalLastName',
			MC_Principal_1_SSN__c = '963852147',
			MC_Principal_1_DOB__c = Date.Today().addYears(-35),
			MC_Principal_1_Street__c = '50 Castilian Dr',
			MC_Principal_1_City__c = 'Goleta',
			MC_Principal_1_State__c = 'CA',
			MC_Principal_1_Zip__c = '93117',
			recordTypeId = VantivTestUtils.getRecordTypeIdFromSObjectAndName('ValuePlus__c', 'MyCase Payments'),
			Vantiv_Onboarding_Status__c = 'Manual Review', 
			Vantiv_Legal_Entity_Id__c = '8291697191215225623',
			Vantiv_Enrolled_Date__c = Date.Today().addDays(-2)
		);
		insert vp1;
		
		Account account2 = new Account();
		//As of 9-15-14, the only required fields for account are:
		// RecordType (Customer Internal Property Management Secure Docs)
		// Name
		account2.Name = 'Testy Account # ' + VantivTestUtils.genRandomNumber(10);
		account2.Phone = '555 555 5555';
		account2.Ownership_Type__c='Partnership';
		account2.Website = 'https://www.appfolio.com';
		account2.BillingStreet = '50 Castilian Dr';
		account2.BillingCity = 'Los Angeles';
		account2.BillingState = 'CA';
		account2.BillingPostalCode = '90039';
		account2.BillingCountry = 'USA';
		account2.Year_Established__c = '2021';
		// account2.RecordTypeId = VantivTestUtils.getRecordTypeIdFromSObjectAndName('Account', 'MyCase Account');
		insert account2;
		
		ValuePlus__c vp2 = new ValuePlus__c(
			Account__c = account2.Id,
			Phone_Verified__c = 'yes',
			Annual_CreditCard_Volume__c = 20000,
			//Has_Accepted_CreditCards__c = true,
			CreditCard_Single_Trans_Amount__c = 10000,
			ACH_Type__c = '1',
			Tax_ID__c='498454585',
			MC_Principal_1_First_Name__c = 'principalFirstName2',
			MC_Principal_1_Last_Name__c = 'principalLastName2',
			MC_Principal_1_SSN__c = '963852147',
			MC_Principal_1_DOB__c = Date.Today().addYears(-25),
			MC_Principal_1_Street__c = '90 Castilian Dr',
			MC_Principal_1_City__c = 'Goleta',
			MC_Principal_1_State__c = 'CA',
			MC_Principal_1_Zip__c = '93117',
			recordTypeId = VantivTestUtils.getRecordTypeIdFromSObjectAndName('ValuePlus__c', 'MyCase Payments'),
			Vantiv_Onboarding_Status__c = 'Manual Review',
			Vantiv_Legal_Entity_Id__c = '82916971912152256',
			Vantiv_Enrolled_Date__c = Date.Today().addDays(-2)
		);
		insert vp2;
		
		
		VantivTestUtils.genTestSettings(true);
		//VantivTestUtils.genCreateLegalEntity();
		VantivTestUtils.genRootElement();
		//VantivTestUtils.genVantivEntityType();
		
		System.debug(vp1);
		System.debug(vp2);
		
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new VantivMockResponse(VantivTestUtils.legalEntitySuccessResponse, 200));
		VantivLegalEntityStatusBatch req = new VantivLegalEntityStatusBatch();
		req.start(null);
		req.execute(null,[Select Id, recordType.Name from ValuePlus__c where Vantiv_Onboarding_Status__c like '%Manual Review%' and Vantiv_Enrolled_Date__c < TODAY and Vantiv_Legal_Entity_Id__c != null]);
		req.finish(null);
		//Database.executeBatch(new VantivLegalEntityStatusBatch());
		//System.assertEquals('Approved', vp1.Vantiv_Onboarding_Status__c);
		//System.assertEquals('Approved', vp2.Vantiv_Onboarding_Status__c);
		Test.stopTest();
    }
    
    static testMethod void testException() {
        Account account1 = VantivTestUtils.genAccount(true, 'MyCase Account');
        ValuePlus__c vp1 = new ValuePlus__c(
			Account__c = account1.Id,
			Phone_Verified__c = 'yes',
			Annual_CreditCard_Volume__c = 20000,
			//Has_Accepted_CreditCards__c = true,
			CreditCard_Single_Trans_Amount__c = 10000,
			ACH_Type__c = '1',
			//Tax_ID__c='758741745',
			MC_Principal_1_First_Name__c = 'principalFirstName',
			MC_Principal_1_Last_Name__c = 'principalLastName',
			MC_Principal_1_SSN__c = '963852147',
			MC_Principal_1_DOB__c = Date.Today().addYears(-35),
			MC_Principal_1_Street__c = '50 Castilian Dr',
			MC_Principal_1_City__c = 'Goleta',
			MC_Principal_1_State__c = 'CA',
			MC_Principal_1_Zip__c = '93117',
			recordTypeId = VantivTestUtils.getRecordTypeIdFromSObjectAndName('ValuePlus__c', 'MyCase Payments'),
			Vantiv_Onboarding_Status__c = 'Manual Review', 
			Vantiv_Legal_Entity_Id__c = '8291697191215225623',
			Vantiv_Enrolled_Date__c = Date.Today().addDays(-2)
		);
		insert vp1;
		
		Account account2 = new Account();
		//As of 9-15-14, the only required fields for account are:
		// RecordType (Customer Internal Property Management Secure Docs)
		// Name
		account2.Name = 'McTesterson Account # ' + VantivTestUtils.genRandomNumber(10);
		account2.Phone = '555 867 5309';
		account2.Ownership_Type__c='Partnership';
		account2.Website = 'https://www.appfolio.com';
		account2.BillingStreet = '50 Castilian Dr';
		account2.BillingCity = 'Goleta';
		account2.BillingState = 'CA';
		account2.BillingPostalCode = '93117';
		account2.BillingCountry = 'USA';
		account2.Year_Established__c = '2000';
		// account2.RecordTypeId = VantivTestUtils.getRecordTypeIdFromSObjectAndName('Account', 'MyCase Account');
		insert account2;
		
		ValuePlus__c vp2 = new ValuePlus__c(
			Account__c = account2.Id,
			Phone_Verified__c = 'yes',
			Annual_CreditCard_Volume__c = 20000,
			//Has_Accepted_CreditCards__c = true,
			CreditCard_Single_Trans_Amount__c = 10000,
			ACH_Type__c = '1',
			Tax_ID__c='498454585',
			MC_Principal_1_First_Name__c = 'principalFirstName2',
			MC_Principal_1_Last_Name__c = 'principalLastName2',
			MC_Principal_1_SSN__c = '963852147',
			MC_Principal_1_DOB__c = Date.Today().addYears(-25),
			MC_Principal_1_Street__c = '90 Castilian Dr',
			MC_Principal_1_City__c = 'Goleta',
			MC_Principal_1_State__c = 'CA',
			MC_Principal_1_Zip__c = '93117',
			recordTypeId = VantivTestUtils.getRecordTypeIdFromSObjectAndName('ValuePlus__c', 'MyCase Payments'),
			Vantiv_Onboarding_Status__c = 'Manual Review',
			Vantiv_Legal_Entity_Id__c = '82916971912152256',
			Vantiv_Enrolled_Date__c = Date.Today().addDays(-2)
		);
		insert vp2;
		
		
		VantivTestUtils.genTestSettings(true);
		//VantivTestUtils.genCreateLegalEntity();
		VantivTestUtils.genRootElement();
		//VantivTestUtils.genVantivEntityType();
		
		System.debug(vp1);
		System.debug(vp2);
		
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new VantivMockResponse(VantivTestUtils.legalEntityFailedResponse, 200));
		VantivLegalEntityStatusBatch req = new VantivLegalEntityStatusBatch();
		req.start(null);
		req.execute(null,[Select Id, recordType.Name from ValuePlus__c where Vantiv_Onboarding_Status__c like '%Manual Review%' and Vantiv_Enrolled_Date__c < TODAY and Vantiv_Legal_Entity_Id__c != null]);
		req.finish(null);
		//Database.executeBatch(new VantivLegalEntityStatusBatch());
		//System.assertEquals('Approved', vp1.Vantiv_Onboarding_Status__c);
		//System.assertEquals('Approved', vp2.Vantiv_Onboarding_Status__c);
		Test.stopTest();
    }
}