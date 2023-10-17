/*
* Test class for the MyCasePaymentsButtonsController class
*/
@isTest
public class MyCasePaymentsButtonsControllerTest {
    static String validEnrollCallJson = '{"transaction_id":"006M000000JcyDsIAJ","result":"Application Created","message":"Success","code":"200","application_id":"00000939"}';
	static String validVelocitySettingCallJson = '{"GetVelocityByMerchant":{"GetVelocitySettingsByMerchantIdResult":{"WSVelocitySettings":[{"CustServProviderId":"214726","DailyPercentageWarning":"0.00","Description":"ACH, Debit","EntityId":"589885","Location":"Merchant Default Location (0)","MaxPeriodAmount":"1150.00","MaxPeriodCount":"2","MaxSingleDayAmount":"1150.00","MaxSingleDayCount":"1","MaxSingleTransactionAmount":"1100.00","MerchantName":"MC PS Test 1-a1l4D00000074qDQAQ","PeriodPercentageWarning":"0.00","SingleAmountPercentageWarning":"0.00","VSID":"2942693","VelocityEnabled":true,"ACHTransactionTypes":[{"WSACHTransactionType":"ARC"},{"WSACHTransactionType":"RCK"},{"WSACHTransactionType":"BOC"},{"WSACHTransactionType":"TEL"},{"WSACHTransactionType":"PPD__CCD"},{"WSACHTransactionType":"WEB"},{"WSACHTransactionType":"POP"},{"WSACHTransactionType":"CTX"}],"EnabledExceptions":[{"WSVelocityExceptions":"Show_Exceptions"}],"OperationType":[{"WSOperationType":"credit"}],"SettlementType":[{"WSSettlementType":"ACH"}]},{"CustServProviderId":"214726","DailyPercentageWarning":"0.00","Description":"ACH, Refund","EntityId":"589885","Location":"Merchant Default Location (0)","MaxPeriodAmount":"945.00","MaxPeriodCount":"5","MaxSingleDayAmount":"945.00","MaxSingleDayCount":"5","MaxSingleTransactionAmount":"900.00","MerchantName":"MC PS Test 1-a1l4D00000074qDQAQ","PeriodPercentageWarning":"0.00","SingleAmountPercentageWarning":"0.00","VSID":"2942697","VelocityEnabled":true,"ACHTransactionTypes":[{"WSACHTransactionType":"ARC"},{"WSACHTransactionType":"RCK"},{"WSACHTransactionType":"BOC"},{"WSACHTransactionType":"TEL"},{"WSACHTransactionType":"PPD__CCD"},{"WSACHTransactionType":"WEB"},{"WSACHTransactionType":"POP"},{"WSACHTransactionType":"CTX"}],"EnabledExceptions":[{"WSVelocityExceptions":"Show_Exceptions"}],"OperationType":[{"WSOperationType":"Refund"}],"SettlementType":[{"WSSettlementType":"ACH"}]}]}},"HTTPStatusCode":"200"}';
    static String validMaintCallJson = '{"CaseNumber": "00001720", "Success": "true"}';
    static String exceptionJson = '{}';
    
    @TestSetup
	static void createData(){
		TestDataFactory.createCustomSettings();
		TestDataFactory.DataModel dm = new TestDataFactory.DataModel(1, false);

		for(Account a : dm.accountList){
			a.RecordTypeId = InformationStrings.accountCustomerId;
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
            v.RecordTypeId = InformationStrings.vPlusMycasePaymentsId;
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
		}
		INSERT(dm.bankAccountList);
    }
    
    private static ValuePlus__c getVPlus(){
		return [SELECT Id, PMT_ProfitStars_On_Boarding_Status__c, Successfully_Enrolled_in_Profit_Stars_at__c, ProfitStars_Merchant_ID__c FROM ValuePlus__c LIMIT 1];
	}
     /* SOLUNUS MODIFICATION TO PROD: 
    static testMethod void psEnrollInboundTest(){
		Test.setMock(HttpCalloutMock.class, new RestClientCalloutMockFactory(200, 'Success', validEnrollCallJson, null));
		TestUtils.genMyCaseInboundTestSettings(true);
		TestUtils.genEnrollmentCustomSettings();

		ValuePlus__c vplusRec = getVPlus();

		Test.startTest();
		String r = MyCasePaymentsButtonsController.processVPlusRecord(vplusRec.Id, 'psInbound');
		Test.stopTest();

		vplusRec = getVPlus();

		Map<String, Object> res = (Map<String, Object>) JSON.deserializeUntyped(r);
		System.assertEquals(true, res.get('didPass'));
		System.assertEquals('Transmitted', vplusRec.PMT_ProfitStars_On_Boarding_Status__c);
		System.assertNotEquals(null, vplusRec.Successfully_Enrolled_in_Profit_Stars_at__c);
	}
    */
    static testmethod void velocityInboundTest(){
		validVelocitySettingCallJson = '{"GetVelocityByMerchant":{"GetVelocitySettingsByMerchantIdResult":{"WSVelocitySettings":[{"CustServProviderId":"214726","DailyPercentageWarning":"0.00","Description":"ACH, Debit","EntityId":"589885","Location":"Merchant Default Location (0)","MaxPeriodAmount":"1150.00","MaxPeriodCount":"2","MaxSingleDayAmount":"1150.00","MaxSingleDayCount":"1","MaxSingleTransactionAmount":"1100.00","MerchantName":"MC PS Test 1-a1l4D00000074qDQAQ","PeriodPercentageWarning":"0.00","SingleAmountPercentageWarning":"0.00","VSID":"2942693","VelocityEnabled":true,"ACHTransactionTypes":[{"WSACHTransactionType":"ARC"},{"WSACHTransactionType":"RCK"},{"WSACHTransactionType":"BOC"},{"WSACHTransactionType":"TEL"},{"WSACHTransactionType":"PPD__CCD"},{"WSACHTransactionType":"WEB"},{"WSACHTransactionType":"POP"},{"WSACHTransactionType":"CTX"}],"EnabledExceptions":[{"WSVelocityExceptions":"Show_Exceptions"}],"OperationType":[{"WSOperationType":"Sale"}],"SettlementType":[{"WSSettlementType":"ACH"}]},{"CustServProviderId":"214726","DailyPercentageWarning":"0.00","Description":"ACH, Refund","EntityId":"589885","Location":"Merchant Default Location (0)","MaxPeriodAmount":"945.00","MaxPeriodCount":"5","MaxSingleDayAmount":"945.00","MaxSingleDayCount":"5","MaxSingleTransactionAmount":"900.00","MerchantName":"MC PS Test 1-a1l4D00000074qDQAQ","PeriodPercentageWarning":"0.00","SingleAmountPercentageWarning":"0.00","VSID":"2942697","VelocityEnabled":true,"ACHTransactionTypes":[{"WSACHTransactionType":"ARC"},{"WSACHTransactionType":"RCK"},{"WSACHTransactionType":"BOC"},{"WSACHTransactionType":"TEL"},{"WSACHTransactionType":"PPD__CCD"},{"WSACHTransactionType":"WEB"},{"WSACHTransactionType":"POP"},{"WSACHTransactionType":"CTX"}],"EnabledExceptions":[{"WSVelocityExceptions":"Show_Exceptions"}],"OperationType":[{"WSOperationType":"Refund"}],"SettlementType":[{"WSSettlementType":"ACH"}]}]}},"HTTPStatusCode":"200"}';
		TestUtils.genTestSettings(true);
        TestUtils.genMyCaseInboundTestSettings(true);
		TestUtils.genVelocityCustomSetting();

		ValuePlus__c vp = getVPlus();
		vp.ProfitStars_Merchant_ID__c = '343434';
		update vp;

		Bank_Account__c bank = [Select Id, LID__c from Bank_Account__c where ValuePlus__c = :vp.Id];
		bank.LID__c = '898989';
		update bank;
								 
		Test.startTest();
		Map<String, String> responseHeaders = new Map<String, String>();
		responseHeaders.put('Content-Type', 'application/json');
		Test.setMock(HttpCalloutMock.class, new HttpMockTestTemplate(
			new List<Integer>{200, 200}, 'OK', new List<String> {validVelocitySettingCallJson, 
			validMaintCallJson}, responseHeaders));

		String velocityResp = MyCasePaymentsButtonsController.processVPlusRecord(vp.Id, 'veloInbound');
		Test.stopTest();

		List<PS_Audit_Log__c> auditLogList = [SELECT Id, Call_Type__c, Error_Message__c FROM PS_Audit_Log__c where Value_plus__c = :vp.Id];
		System.assertNotEquals(0, auditLogList.size());
		System.assert('Batch Velocity Update' == auditLogList[0].Call_Type__c);
		// System.assertEquals('Success', auditLogList[0].Error_Message__c);
	}
     /* SOLUNUS MODIFICATION TO PROD: 
    static testmethod void vantivEnrollTest(){
		VantivTestUtils.genTestSettings(true);
		VantivTestUtils.genCreateLegalEntity();
		VantivTestUtils.genRootElement();
		VantivTestUtils.genVantivEntityType();
		
		Test.setMock(HttpCalloutMock.class, new VantivMockResponse(VantivTestUtils.legalEntitySuccessResponse, 200));
		
		ValuePlus__c vp = getVPlus();
        vp.Vantiv_Onboarding_Status__c = 'Ready To Transmit';
        vp.Phone_Verified__c = 'yes';
        vp.Annual_CreditCard_Volume__c = 20000;
        vp.Has_Accepted_CreditCards__c = 'Yes';
        vp.CreditCard_Single_Trans_Amount__c = 1000;
        vp.ACH_Type__c = '1';
        vp.Tax_ID__c = '845212457';
        update vp;
        
        Test.startTest();
		String result = MyCasePaymentsButtonsController.processVPlusRecord(vp.Id, 'vantivEnroll');
		Test.stopTest();
        
        Map<String, Object> res = (Map<String, Object>) JSON.deserializeUntyped(result);
		System.assertEquals(true, res.get('didPass'));
	}
    */
    static testmethod void testException(){
        ValuePlus__c vp = getVPlus();
        
        Test.startTest();
		String result = MyCasePaymentsButtonsController.processVPlusRecord(vp.Id, 'testException');
		Test.stopTest();
        
        System.assert(result.contains('error thrown:'));
    }
}