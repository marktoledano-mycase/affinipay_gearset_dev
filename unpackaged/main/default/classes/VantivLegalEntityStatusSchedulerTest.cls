@isTest
private class VantivLegalEntityStatusSchedulerTest {

    static testMethod void testScheduler() {
        Account account1 = VantivTestUtils.genAccount(true, 'MyCase Account');
        ValuePlus__c vp1 = new ValuePlus__c(
			Account__c = account1.Id,
			Phone_Verified__c = 'yes',
			Annual_CreditCard_Volume__c = 20000,
			Has_Accepted_CreditCards__c = 'Yes',
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
		account2.Name = 'McTesterson Account # ' + VantivTestUtils.genRandomNumber(10);
		account2.Phone = '555 678 9999';
		account2.Ownership_Type__c='Partnership';
		account2.Website = 'https://www.mycase.com';
		account2.BillingStreet = '9201 Spectrum Center Blvd., Suite 100';
		account2.BillingCity = 'San Diego';
		account2.BillingState = 'CA';
		account2.BillingPostalCode = '92123';
		account2.BillingCountry = 'USA';
		account2.Year_Established__c = '2000';
		// account2.RecordTypeId = VantivTestUtils.getRecordTypeIdFromSObjectAndName('Account', 'MyCase Account');
		insert account2;
		
		ValuePlus__c vp2 = new ValuePlus__c(
			Account__c = account2.Id,
			Phone_Verified__c = 'yes',
			Annual_CreditCard_Volume__c = 20000,
			Has_Accepted_CreditCards__c = 'Yes',
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
		VantivTestUtils.genRootElement();
		VantivTestUtils.genCreateLegalEntity();
		VantivTestUtils.genVantivEntityType();
		
		System.debug(vp1);
		System.debug(vp2);
		
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new VantivMockResponse(VantivTestUtils.legalEntitySuccessResponse, 200));
		VantivLegalEntityStatusScheduler sch = new VantivLegalEntityStatusScheduler();
		sch.execute(null);
		Test.stopTest();
    }
}