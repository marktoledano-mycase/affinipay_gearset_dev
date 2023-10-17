/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 *
 * Test class for the ps_eCheckButtonMethods class.
 */
@isTest
private class ps_eCheckButtonMethodsTest{

    static String validEnrollCallJson = '{"transaction_id":"006M000000JcyDsIAJ","result":"Application Created","message":"Success","code":"200","application_id":"00000939"}';
    static String errorEnrollCallJson = '{"transaction_id":null,"result":"Error","message":"Failed","code":"400","application_id":null}';
    static String validMaintCallJson = '{"CaseNumber": "00001720", "Success": "true"}';
    static String errorMaintCallJson = '{"CaseNumber": null, "Success": "false", "ErrorMessage": "Error error!", "ErrorCode": "FIELD_CUSTOM_VALIDATION_EXCEPTION"}';
    static String validVelocitySettingCallJson = '{"GetVelocityByMerchant":{"GetVelocitySettingsByMerchantIdResult":{"WSVelocitySettings":[{"CustServProviderId":"214726","DailyPercentageWarning":"0.00","Description":"ACH, Debit","EntityId":"589885","Location":"Merchant Default Location (0)","MaxPeriodAmount":"1150.00","MaxPeriodCount":"2","MaxSingleDayAmount":"1150.00","MaxSingleDayCount":"1","MaxSingleTransactionAmount":"1100.00","MerchantName":"MC PS Test 1-a1l4D00000074qDQAQ","PeriodPercentageWarning":"0.00","SingleAmountPercentageWarning":"0.00","VSID":"2942693","VelocityEnabled":true,"ACHTransactionTypes":[{"WSACHTransactionType":"ARC"},{"WSACHTransactionType":"RCK"},{"WSACHTransactionType":"BOC"},{"WSACHTransactionType":"TEL"},{"WSACHTransactionType":"PPD__CCD"},{"WSACHTransactionType":"WEB"},{"WSACHTransactionType":"POP"},{"WSACHTransactionType":"CTX"}],"EnabledExceptions":[{"WSVelocityExceptions":"Show_Exceptions"}],"OperationType":[{"WSOperationType":"credit"}],"SettlementType":[{"WSSettlementType":"ACH"}]},{"CustServProviderId":"214726","DailyPercentageWarning":"0.00","Description":"ACH, Refund","EntityId":"589885","Location":"Merchant Default Location (0)","MaxPeriodAmount":"945.00","MaxPeriodCount":"5","MaxSingleDayAmount":"945.00","MaxSingleDayCount":"5","MaxSingleTransactionAmount":"900.00","MerchantName":"MC PS Test 1-a1l4D00000074qDQAQ","PeriodPercentageWarning":"0.00","SingleAmountPercentageWarning":"0.00","VSID":"2942697","VelocityEnabled":true,"ACHTransactionTypes":[{"WSACHTransactionType":"ARC"},{"WSACHTransactionType":"RCK"},{"WSACHTransactionType":"BOC"},{"WSACHTransactionType":"TEL"},{"WSACHTransactionType":"PPD__CCD"},{"WSACHTransactionType":"WEB"},{"WSACHTransactionType":"POP"},{"WSACHTransactionType":"CTX"}],"EnabledExceptions":[{"WSVelocityExceptions":"Show_Exceptions"}],"OperationType":[{"WSOperationType":"Refund"}],"SettlementType":[{"WSSettlementType":"ACH"}]}]}},"HTTPStatusCode":"200"}';
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
        dm.valueplusList[0].Outbound_Period_Amount__c = 2000; 
        dm.valueplusList[0].Outbound_Period_Count__c = 5;
        dm.valueplusList[0].Outbound_Single_Day_Amount__c = 1000; 
        dm.valueplusList[0].Outbound_Single_Day_Count__c = 1;
        dm.valueplusList[0].Outbound_Single_Trans_Amount__c = 500;
        INSERT(dm.valuePlusList[0]);

        //insert bank accounts
        dm.bankAccountList[0].ValuePlus__c = dm.valueplusList[0].Id;
        dm.bankAccountList[0].RoutingNo__c = '053000196';
        dm.bankAccountList[0].AccountNo__c = '1234567891';
        dm.bankAccountList[0].Account_Type__c = '0';
        INSERT(dm.bankAccountList[0]);
    }

    static testmethod void outboundEnrollmentTest(){

        Test.setMock(HttpCalloutMock.class, new RestClientCalloutMockFactory(200, 'Success', validEnrollCallJson, null));
        TestUtils.genOutboundTestSettings(true);
        TestUtils.genEnrollmentCustomSettings();
        TestUtils.genEcheckFieldsTestSettings(true);

        ValuePlus__c vp = [Select Id from ValuePlus__c where Account__r.Name = 'Test Account0' limit 1];
                                 
        Test.startTest();
        String enrollResp = ps_eCheckButtonMethods.callEnrollment(vp.Id);
        Test.stopTest();

        List<PS_Audit_Log__c> auditLogList = [SELECT Id, Call_Type__c, Error_Message__c FROM PS_Audit_Log__c where Value_plus__c = :vp.Id];
        System.assertNotEquals(0, auditLogList.size());
        System.assert('Enroll Outbound' == auditLogList[0].Call_Type__c);
        System.assertEquals('Success', auditLogList[0].Error_Message__c);
    }

    static testmethod void outboundEnrollmentErrorTest(){

        Test.setMock(HttpCalloutMock.class, new RestClientCalloutMockFactory(400, 'Failure', errorEnrollCallJson, null));
        TestUtils.genOutboundTestSettings(true);
        TestUtils.genEnrollmentCustomSettings();
        TestUtils.genEcheckFieldsTestSettings(true);

        ValuePlus__c vp = [Select Id from ValuePlus__c where Account__r.Name = 'Test Account0' limit 1];
                                 
        Test.startTest();
        String enrollResp = ps_eCheckButtonMethods.callEnrollment(vp.Id);
        Test.stopTest();

        List<PS_Audit_Log__c> auditLogList = [SELECT Id, Call_Type__c, Error_Message__c FROM PS_Audit_Log__c where Value_plus__c = :vp.Id];
        System.assertNotEquals(0, auditLogList.size());
        System.assert('Enroll Outbound' == auditLogList[0].Call_Type__c);
        System.assertEquals('Failure', auditLogList[0].Error_Message__c);
    }

    static testmethod void outboundEnrollmentExceptionTest(){

        Test.setMock(HttpCalloutMock.class, new RestClientCalloutMockFactory(400, 'Failure', exceptionJson, null));
        TestUtils.genOutboundTestSettings(true);
        TestUtils.genEcheckFieldsTestSettings(true);
        TestUtils.addRequiredFieldToCustomSetting('enrollment');

        ValuePlus__c vp = [Select Id, Phone_Verified__c from ValuePlus__c where Account__r.Name = 'Test Account0' limit 1];
        vp.Phone_Verified__c = null;
        update vp;
                                 
        Test.startTest();
        String enrollResp = ps_eCheckButtonMethods.callEnrollment(vp.Id);
        Test.stopTest();

        List<PS_Audit_Log__c> auditLogList = [SELECT Id, Call_Type__c, Error_Message__c FROM PS_Audit_Log__c where Value_plus__c = :vp.Id];
        System.assertNotEquals(0, auditLogList.size());
        System.assert('Enroll Outbound' == auditLogList[0].Call_Type__c);
    }

    static testmethod void outboundVelocityTest(){

        TestUtils.genOutboundTestSettings(true);
        TestUtils.genEcheckFieldsTestSettings(true);
        TestUtils.genVelocityCustomSetting();

        ValuePlus__c vp = [Select Id, Outbound_MID__c from ValuePlus__c where Account__r.Name = 'Test Account0' limit 1];
        vp.Outbound_MID__c = '343434';
        update vp;

        Bank_Account__c bank = [Select Id, Outbound_LID__c from Bank_Account__c where Account_Label__c = 'Test Bank Account0'];
        bank.Outbound_LID__c = '898989';
        update bank;
                                 
        Test.startTest();
        Map<String, String> responseHeaders = new Map<String, String>();
        responseHeaders.put('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, new HttpMockTestTemplate(
            new List<Integer>{200, 200}, 'OK', new List<String> {validVelocitySettingCallJson, 
            validMaintCallJson}, responseHeaders));

        String velocityResp = ps_eCheckButtonMethods.callVelocity(vp.Id);
        Test.stopTest();

        List<PS_Audit_Log__c> auditLogList = [SELECT Id, Call_Type__c, Error_Message__c FROM PS_Audit_Log__c where Value_plus__c = :vp.Id];
        System.assertNotEquals(0, auditLogList.size());
        System.assert('Velocity Update Outbound' == auditLogList[0].Call_Type__c);
        System.assertEquals('Success', auditLogList[0].Error_Message__c);
    }

    static testmethod void outboundVelocityErrorTest(){

        TestUtils.genOutboundTestSettings(true);
        TestUtils.genEcheckFieldsTestSettings(true);
        TestUtils.genVelocityCustomSetting();

        ValuePlus__c vp = [Select Id, Outbound_MID__c from ValuePlus__c where Account__r.Name = 'Test Account0' limit 1];
        vp.Outbound_MID__c = '343434';
        update vp;

        Bank_Account__c bank = [Select Id, Outbound_LID__c from Bank_Account__c where Account_Label__c = 'Test Bank Account0'];
        bank.Outbound_LID__c = '898989';
        update bank;
                                 
        Test.startTest();
        Map<String, String> responseHeaders = new Map<String, String>();
        responseHeaders.put('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, new HttpMockTestTemplate(
            new List<Integer>{200, 200}, 'OK', new List<String> {validVelocitySettingCallJson, 
            errorMaintCallJson}, responseHeaders));

        String velocityResp = ps_eCheckButtonMethods.callVelocity(vp.Id);
        Test.stopTest();

        List<PS_Audit_Log__c> auditLogList = [SELECT Id, Call_Type__c, Error_Message__c FROM PS_Audit_Log__c where Value_plus__c = :vp.Id];
        System.assertNotEquals(0, auditLogList.size());
        System.assert('Velocity Update Outbound' == auditLogList[0].Call_Type__c);
        System.assertEquals('Failure', auditLogList[0].Error_Message__c);
    }

    static testmethod void outboundVelocityExceptionTest(){

        TestUtils.genOutboundTestSettings(true);
        TestUtils.genEcheckFieldsTestSettings(true);
        TestUtils.genVelocityCustomSetting();

        ValuePlus__c vp = [Select Id, Outbound_MID__c from ValuePlus__c where Account__r.Name = 'Test Account0' limit 1];
        vp.Outbound_MID__c = '343434';
        update vp;

        Bank_Account__c bank = [Select Id, Outbound_LID__c from Bank_Account__c where Account_Label__c = 'Test Bank Account0'];
        bank.Outbound_LID__c = '898989';
        update bank;
                                 
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new RestClientCalloutMockFactory(200, 'Success', validMaintCallJson, null));

        String velocityResp = ps_eCheckButtonMethods.callVelocity(vp.Id);
        Test.stopTest();

        List<PS_Audit_Log__c> auditLogList = [SELECT Id, Call_Type__c, Error_Message__c FROM PS_Audit_Log__c where Value_plus__c = :vp.Id];
        System.assertNotEquals(0, auditLogList.size());
        System.assert('Velocity Update Outbound' == auditLogList[0].Call_Type__c);
    }

    static testmethod void outboundLocationTest(){

        TestUtils.genOutboundTestSettings(true);
        TestUtils.genEcheckFieldsTestSettings(true);
        TestUtils.genLocationCustomSetting();

        ValuePlus__c vp = [Select Id, Outbound_MID__c from ValuePlus__c where Account__r.Name = 'Test Account0' limit 1];
        vp.Outbound_MID__c = '343434';
        update vp;

        Bank_Account__c bank = [Select Id from Bank_Account__c where Account_Label__c = 'Test Bank Account0'];
                                 
        Test.startTest();
        Map<String, String> responseHeaders = new Map<String, String>();
        responseHeaders.put('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, new HttpMockTestTemplate(
            new List<Integer>{200, 200}, 'OK', new List<String> {validMaintCallJson, 
            validLocByLocNameCallJson}, responseHeaders));

        String locationResp = ps_eCheckButtonMethods.callLocation(bank.Id);
        Test.stopTest();

        List<PS_Audit_Log__c> auditLogList = [SELECT Id, Call_Type__c, Error_Message__c FROM PS_Audit_Log__c where BankAccount__c = :bank.Id];
        System.assertNotEquals(0, auditLogList.size());
        System.assert('Add Location to Outbound' == auditLogList[0].Call_Type__c);
        System.assertEquals('Success', auditLogList[0].Error_Message__c);
    }

    static testmethod void outboundLocationErrorTest(){

        TestUtils.genOutboundTestSettings(true);
        TestUtils.genEcheckFieldsTestSettings(true);
        TestUtils.genLocationCustomSetting();

        ValuePlus__c vp = [Select Id, Outbound_MID__c from ValuePlus__c where Account__r.Name = 'Test Account0' limit 1];
        vp.Outbound_MID__c = '343434';
        update vp;

        Bank_Account__c bank = [Select Id from Bank_Account__c where Account_Label__c = 'Test Bank Account0'];
                                 
        Test.startTest();
        Map<String, String> responseHeaders = new Map<String, String>();
        responseHeaders.put('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, new HttpMockTestTemplate(
            new List<Integer>{200}, 'OK', new List<String> {errorMaintCallJson}, responseHeaders));

        String locationResp = ps_eCheckButtonMethods.callLocation(bank.Id);
        Test.stopTest();

        List<PS_Audit_Log__c> auditLogList = [SELECT Id, Call_Type__c, Error_Message__c FROM PS_Audit_Log__c where BankAccount__c = :bank.Id];
        System.assertNotEquals(0, auditLogList.size());
        System.assert('Add Location to Outbound' == auditLogList[0].Call_Type__c);
        System.assertEquals('Failure', auditLogList[0].Error_Message__c);
    }

    static testmethod void outboundLocationPSExceptionTest(){

        TestUtils.genEcheckFieldsTestSettings(true);
        TestUtils.genLocationCustomSetting();

        ValuePlus__c vp = [Select Id, Outbound_MID__c from ValuePlus__c where Account__r.Name = 'Test Account0' limit 1];
        vp.Outbound_MID__c = '343434';
        update vp;

        Bank_Account__c bank = [Select Id from Bank_Account__c where Account_Label__c = 'Test Bank Account0'];
                                 
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new RestClientCalloutMockFactory(200, 'Success', validMaintCallJson, null));

        String locationResp = ps_eCheckButtonMethods.callLocation(bank.Id);
        Test.stopTest();

        List<PS_Audit_Log__c> auditLogList = [SELECT Id, Call_Type__c, Error_Message__c FROM PS_Audit_Log__c where BankAccount__c = :bank.Id];
        System.assertNotEquals(0, auditLogList.size());
        System.assert('Add Location to Outbound' == auditLogList[0].Call_Type__c);
    }

    static testmethod void outboundLocationExceptionTest(){

        Test.setMock(HttpCalloutMock.class, new RestClientCalloutMockFactory(400, 'Failure', exceptionJson, null));
        TestUtils.genOutboundTestSettings(true);
        TestUtils.addRequiredFieldToCustomSetting('Location');

        ValuePlus__c vp = [Select Id, Phone_Verified__c from ValuePlus__c where Account__r.Name = 'Test Account0' limit 1];
        vp.Phone_Verified__c = null;
        update vp;

        Bank_Account__c bank = [Select Id from Bank_Account__c where Account_Label__c = 'Test Bank Account0'];
                                 
        Test.startTest();
        String enrollResp = ps_eCheckButtonMethods.callLocation(bank.Id);
        Test.stopTest();

        List<PS_Audit_Log__c> auditLogList = [SELECT Id, Call_Type__c, Error_Message__c FROM PS_Audit_Log__c where BankAccount__c = :bank.Id];
        System.assertNotEquals(0, auditLogList.size());
        System.assert('Add Location to Outbound' == auditLogList[0].Call_Type__c);
    }
}