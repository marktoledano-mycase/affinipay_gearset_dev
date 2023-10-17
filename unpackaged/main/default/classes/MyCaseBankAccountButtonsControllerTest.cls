/*
* Test class for the MyCaseBankAccountButtonsController class
*/
@isTest
public class MyCaseBankAccountButtonsControllerTest {
    
    static String validMaintCallJson = '{"CaseNumber": "00001720", "Success": "true"}';
    static String validLocByLocNameCallJson = '{"HTTPStatusCode":"200","GetLocationByLocationName":{"GetLocationByLocationNameResult":{"AccountNumberLast4":"7891","AccountType":"Checking","CustServProviderId":"654321","CustomerLocationNumber":"true","EntityId":"589885","LocationEnabled":true,"LocationId":"4140829","LocationName":"Test Bank Account0","MerchantName":"Test Account0-a1l4D00000074qDQAQ","RoutingNumber":"053000196"}}}';
    
    @TestSetup
	static void createData(){
		TestDataFactory.createCustomSettings();
		TestDataFactory.DataModel dm = new TestDataFactory.DataModel(1, false);

		for(Account a : dm.accountList){
			// a.RecordTypeId = InformationStrings.accountCustomerId;
			a.Website = 'https://www.appfolio.com';
			a.BillingStreet = '50 Castilian Dr';
			a.BillingCity = 'Goleta';
			a.BillingState = 'CA';	
			a.BillingPostalCode = '93117';
			a.BillingCountry = 'USA';
			a.Year_Established__c = '2000';
		}
		INSERT(dm.accountList);

		TestDataFactory.createEntitlements(dm.accountList[0].Id, true);

		for(ValuePlus__c v : dm.valuePlusList){
			v.Account__c = dm.accountList[0].Id;
            // v.RecordTypeId = InformationStrings.vPlusMycasePaymentsId;
            v.MC_Principal_1_First_Name__c = 'MyCase';
            v.MC_Principal_1_Last_Name__c = 'EnrollTest';
            v.MC_Principal_1_Ownership__c = 100;
            v.MC_Principal_1_SSN__c = '963852147';
			v.MC_Principal_1_DOB__c = Date.Today().addYears(-35);
			v.MC_Principal_1_Street__c = '50 Castilian Dr';
			v.MC_Principal_1_City__c = 'Goleta';
			v.MC_Principal_1_State__c = 'CA';
			v.MC_Principal_1_Zip__c = '93117';
            v.Period_Amount__c = 2000; 
            v.Period_Count__c = 5;
            v.Single_Day_Amount__c = 1000; 
            v.Single_Day_Count__c = 1;
            v.Single_Trans_Amount__c = 500;
		}
		INSERT(dm.valuePlusList);

		for(Bank_Account__c ba : dm.bankAccountList){
			ba.ValuePlus__c = dm.valuePlusList[0].Id;
            ba.RoutingNo__c = '053000196';
			ba.AccountNo__c = '1234567891';
			ba.Account_Type__c = '0';
		}
		INSERT(dm.bankAccountList);
    }
    
    static testmethod void pushBankToPSTest(){
		TestUtils.genTestSettings(true);
        TestUtils.genMyCaseInboundTestSettings(true);
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

		String result = MyCaseBankAccountButtonsController.processBankRecord(bank.Id, 'pushBankToPS');
		Test.stopTest();

		List<PS_Audit_Log__c> auditLogList = [SELECT Id, Call_Type__c, Error_Message__c FROM PS_Audit_Log__c where BankAccount__c = :bank.Id];
		System.assertNotEquals(0, auditLogList.size());
		System.assert('Batch Location Update' == auditLogList[0].Call_Type__c);
		// System.assertEquals('Success', auditLogList[0].Error_Message__c);
	}
    
    static testmethod void addBankToVantivTest(){
		VantivTestUtils.genTestSettings(true);
		VantivTestUtils.genCreateSubMerchant();
		VantivTestUtils.genRootElement();
        
        ValuePlus__c vp = [Select Id from ValuePlus__c where Account__r.Name = 'Test Account0' limit 1];
        vp.Vantiv_Enrolled_Date__c = Date.today();
        vp.Vantiv_Onboarding_Status__c = 'Approved';
        vp.Vantiv_Legal_Entity_Id__c = '82916971912152256';
        vp.Vantiv_Legal_Entity_Update_Status__c = 'Ready To Update';
        update vp;
        
        Bank_Account__c bank = [Select Id from Bank_Account__c where Account_Label__c = 'Test Bank Account0'];
		
		Test.setMock(HttpCalloutMock.class, new VantivMockResponse(VantivTestUtils.subMerchantSuccessResponse, 200));
		
		Test.startTest();
		String result = MyCaseBankAccountButtonsController.processBankRecord(bank.Id, 'addBankToVantiv');
		Test.stopTest();
        
        Map<String, Object> res = (Map<String, Object>) JSON.deserializeUntyped(result);
		System.assertEquals(true, res.get('didPass'));
	}
    
    static testmethod void updateSubMerchantSuccess(){
		VantivTestUtils.genTestSettings(true);
		VantivTestUtils.genUpdateSubMerchant();
		VantivTestUtils.genRootElement();
        
        ValuePlus__c vp = [Select Id from ValuePlus__c where Account__r.Name = 'Test Account0' limit 1];
        vp.Vantiv_Enrolled_Date__c = Date.today();
        vp.Vantiv_Onboarding_Status__c = 'Approved';
        vp.Vantiv_Legal_Entity_Id__c = '82916971912152256';
        vp.Vantiv_Legal_Entity_Update_Status__c = 'Ready To Update';
        update vp;
        
        Bank_Account__c bank = [Select Id from Bank_Account__c where Account_Label__c = 'Test Bank Account0'];
        bank.Vantiv_Sub_Merchant_Id__c = '123456789';
		bank.Vantiv_Bank_Account_Update_Status__c = 'Ready To Update';
		bank.Vantiv_Bank_Account_Onboarding_Status__c = 'Approved';
        update bank;
		
		Test.setMock(HttpCalloutMock.class, new VantivMockResponse(VantivTestUtils.subMerchantSuccessResponse, 200));
		
		Test.startTest();
		String result = MyCaseBankAccountButtonsController.processBankRecord(bank.Id, 'updateBankInVantiv');
		Test.stopTest();
        
        Map<String, Object> res = (Map<String, Object>) JSON.deserializeUntyped(result);
		System.assertEquals(true, res.get('didPass'));
	}
    
    static testmethod void testException(){
        Bank_Account__c bank = [Select Id from Bank_Account__c where Account_Label__c = 'Test Bank Account0'];
        
        Test.startTest();
		String result = MyCaseBankAccountButtonsController.processBankRecord(bank.Id, 'testException');
		Test.stopTest();
        
        System.assert(result.contains('error thrown:'));
    }
}