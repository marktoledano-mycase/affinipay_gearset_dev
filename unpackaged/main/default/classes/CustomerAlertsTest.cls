/*
* Test class for the CustomerAlerts class.
*/
@isTest
private class CustomerAlertsTest{

    @TestSetup
    private static void createTestData(){
        TestDataFactory.createCustomSettings();

        TestDataFactory.DataModel dm = new TestDataFactory.DataModel(1, false);
        //insert accounts
        // dm.accountList[0].RecordTypeId = InformationStrings.accountPropertyManagementId;
        dm.accountList[0].Name = 'TestAcct';
        INSERT(dm.accountList);

        //insert asset
        dm.assetList[0].AccountId = dm.accountList[0].Id;
        INSERT(dm.assetList);

        //insert database
        dm.databaseList[0].Account__c = dm.accountList[0].Id;
        dm.databaseList[0].Asset__c = dm.assetList[0].Id;
        INSERT(dm.databaseList);

        TestDataFactory.createEntitlements(dm.accountList[0].Id, true);
    }

    static testMethod void testAccountWithCaseRTC(){
       
       Account newAcct = [Select Id, RecordTypeId from Account where name = 'TestAcct' limit 1];
       
       Database__c database = [Select Id from Database__c where Account__c = :newAcct.id limit 1];
		
       Case ca1 = new Case(
                AccountId = newAcct.Id,
                RecordTypeId = InformationStrings.caseRiskId,
                Origin = 'Email',
                Status = 'New',
                Reason = 'Implementation Expectations',
                Case_Sub_Reason__c = 'Expect a Specific GL Date',
                Database__c = database.Id,
                Priority = 'Normal'
         	);
        
        Case ca2 = new Case(
                AccountId = newAcct.Id,
                RecordTypeId = InformationStrings.caseRiskId,
                Origin = 'Email',
                Status = 'New',
                Reason = 'Implementation Expectations',
                Case_Sub_Reason__c = 'Expect a Specific GL Date',
                Database__c = database.Id,
                Priority = 'Request to Cancel'
         	);
         
        List<Case> listCases = new List<Case>{ca1, ca2};
        insert listCases;
        
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(newAcct);
        CustomerAlerts ca = new CustomerAlerts(sc);
        System.assert(ca.warningMessages != null && ca.warningMessages.size() > 0);
        System.assert(ca.warningMessages[0].containsIgnoreCase('requested to cancel'));
        Test.stopTest();
    }
    
    static testMethod void testAccountWithMultipleOpenCases(){

       Account newAcct = [Select Id, RecordTypeId from Account where name = 'TestAcct' limit 1];
       
       Database__c database = [Select Id from Database__c where Account__c = :newAcct.id limit 1];
		
       Case ca1 = new Case(
                AccountId = newAcct.Id,
                RecordTypeId = InformationStrings.caseRiskId,
                Origin = 'Email',
                Status = 'New',
                Reason = 'Implementation Expectations',
                Case_Sub_Reason__c = 'Expect a Specific GL Date',
                Database__c = database.Id,
                Priority = 'Normal'
         	);
        
        Case ca2 = new Case(
                AccountId = newAcct.Id,
                RecordTypeId = InformationStrings.caseRiskId,
                Origin = 'Email',
                Status = 'New',
                Reason = 'Implementation Expectations',
                Case_Sub_Reason__c = 'Expect a Specific GL Date',
                Database__c = database.Id,
                Priority = 'Low'
         	);
         
        List<Case> listCases = new List<Case>{ca1, ca2};
        insert listCases;
        
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(newAcct);
        CustomerAlerts ca = new CustomerAlerts(sc);
        System.assert(ca.warningMessages != null && ca.warningMessages.size() == 1);
        System.assert(ca.warningMessages[0].containsIgnoreCase('open risk case'));
        Test.stopTest();
    }
    
    static testMethod void testVPWithCaseRTC(){

       Account newAcct = [Select Id, RecordTypeId from Account where name = 'TestAcct' limit 1];
       
       Database__c database = [Select Id from Database__c where Account__c = :newAcct.id limit 1];
		
	   ValuePlus__c valuePlus = TestDataFactory.createValuePlusList(1, newAcct.Id, true)[0];
		
       Case ca1 = new Case(
                AccountId = newAcct.Id,
                RecordTypeId = InformationStrings.caseRiskId,
                Origin = 'Email',
                Status = 'New',
                Reason = 'Implementation Expectations',
                Case_Sub_Reason__c = 'Expect a Specific GL Date',
                Database__c = database.Id,
                Priority = 'Normal'
         	);
        
        Case ca2 = new Case(
                AccountId = newAcct.Id,
                RecordTypeId = InformationStrings.caseRiskId,
                Origin = 'Email',
                Status = 'New',
                Reason = 'Implementation Expectations',
                Case_Sub_Reason__c = 'Expect a Specific GL Date',
                Database__c = database.Id,
                Priority = 'Request to Cancel'
         	);
         
        List<Case> listCases = new List<Case>{ca1, ca2};
        insert listCases;
        
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(valuePlus);
        CustomerAlerts ca = new CustomerAlerts(sc);
        System.assert(ca.warningMessages != null && ca.warningMessages.size() > 0);
        System.assert(ca.warningMessages[0].containsIgnoreCase('requested to cancel'));
        Test.stopTest();
    }
    
    static testMethod void testVPWithMultipleOpenCases(){

       Account newAcct = [Select Id, RecordTypeId from Account where name = 'TestAcct' limit 1];
       
       Database__c database = [Select Id from Database__c where Account__c = :newAcct.id limit 1];
        
       ValuePlus__c valuePlus = TestDataFactory.createValuePlusList(1, newAcct.Id, true)[0];
        
       Case ca1 = new Case(
                AccountId = newAcct.Id,
                RecordTypeId = InformationStrings.caseRiskId,
                Origin = 'Email',
                Status = 'New',
                Reason = 'Implementation Expectations',
                Case_Sub_Reason__c = 'Expect a Specific GL Date',
                Database__c = database.Id,
                Priority = 'Normal'
         	);
        
        Case ca2 = new Case(
                AccountId = newAcct.Id,
                RecordTypeId = InformationStrings.caseRiskId,
                Origin = 'Email',
                Status = 'New',
                Reason = 'Implementation Expectations',
                Case_Sub_Reason__c = 'Expect a Specific GL Date',
                Database__c = database.Id,
                Priority = 'Noral'
         	);
         
        List<Case> listCases = new List<Case>{ca1, ca2};
        insert listCases;
        
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(valuePlus);
        CustomerAlerts ca = new CustomerAlerts(sc);
        System.assert(ca.warningMessages != null && ca.warningMessages.size() == 1);
        System.assert(ca.warningMessages[0].containsIgnoreCase('open risk case'));
        Test.stopTest();
    }
    
    static testMethod void testCasesWithCaseRTC(){

       Account newAcct = [Select Id, RecordTypeId from Account where name = 'TestAcct' limit 1];
       
       Database__c database = [Select Id from Database__c where Account__c = :newAcct.id limit 1];
		
       Case ca1 = new Case(
                AccountId = newAcct.Id,
                RecordTypeId = InformationStrings.caseRiskId,
                Origin = 'Email',
                Status = 'New',
                Reason = 'Implementation Expectations',
                Case_Sub_Reason__c = 'Expect a Specific GL Date',
                Database__c = database.Id,
                Priority = 'Normal'
         	);
        
        Case ca2 = new Case(
                AccountId = newAcct.Id,
                RecordTypeId = InformationStrings.caseRiskId,
                Origin = 'Email',
                Status = 'New',
                Reason = 'Implementation Expectations',
                Case_Sub_Reason__c = 'Expect a Specific GL Date',
                Database__c = database.Id,
                Priority = 'Request to Cancel'
         	);
         
        List<Case> listCases = new List<Case>{ca1, ca2};
        insert listCases;
        
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(ca1);
        CustomerAlerts ca = new CustomerAlerts(sc);
        System.assert(ca.warningMessages != null && ca.warningMessages.size() > 0);
        System.assert(ca.warningMessages[0].containsIgnoreCase('requested to cancel'));
        Test.stopTest();
    }
    
    static testMethod void testCasesWithMultipleOpenCases(){

       Account newAcct = [Select Id, RecordTypeId from Account where name = 'TestAcct' limit 1];
       
       Database__c database = [Select Id from Database__c where Account__c = :newAcct.id limit 1];
        
       Case ca1 = new Case(
                AccountId = newAcct.Id,
                RecordTypeId = InformationStrings.caseRiskId,
                Origin = 'Email',
                Status = 'New',
                Reason = 'Implementation Expectations',
                Case_Sub_Reason__c = 'Expect a Specific GL Date',
                Database__c = database.Id,
                Priority = 'Normal'
         	);
        
        Case ca2 = new Case(
                AccountId = newAcct.Id,
                RecordTypeId = InformationStrings.caseRiskId,
                Origin = 'Email',
                Status = 'New',
                Reason = 'Implementation Expectations',
                Case_Sub_Reason__c = 'Expect a Specific GL Date',
                Database__c = database.Id,
                Priority = 'Low'
         	);
         
        List<Case> listCases = new List<Case>{ca1, ca2};
        insert listCases;
        
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(ca1);
        CustomerAlerts ca = new CustomerAlerts(sc);
        System.assert(ca.warningMessages != null && ca.warningMessages.size() == 1);
        System.assert(ca.warningMessages[0].containsIgnoreCase('open risk case'));
        Test.stopTest();
    }

    static testMethod void testMyCaseAccount(){

        Account newAcct = TestDataFactory.createAccountList(1, false)[0];
        newAcct.RecordTypeId = InformationStrings.accountCustomerId;
        newAcct.Name = 'TestMyCaseAcct';
        newAcct.Suspicious_Account__c = true;
        insert newAcct;

        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(newAcct);
        CustomerAlerts ca = new CustomerAlerts(sc);
        // System.assertEquals(true, ca.isMyCaseRecord);
        Test.stopTest();
    }

    static testMethod void testMyCaseValuePlus(){

        Account newAcct = TestDataFactory.createAccountList(1, false)[0];
        newAcct.RecordTypeId = InformationStrings.accountCustomerId;
        newAcct.Name = 'TestMyCaseAcct';
        insert newAcct;

        ValuePlus__c valuePlus = TestDataFactory.createValuePlusList(1, newAcct.Id, true)[0];

        ValuePlus__c valuePlusRec = [Select id, Account__c, Account__r.RecordTypeId from ValuePlus__c where id = :valuePlus.id];

        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(valuePlusRec);
        CustomerAlerts ca = new CustomerAlerts(sc);
        System.assertEquals(true, ca.isMyCaseRecord);
        Test.stopTest();
    }

    static testMethod void testMyCaseCases(){
        Account newAcct = [Select Id, RecordTypeId from Account where name = 'TestAcct' limit 1];
        newAcct.RecordTypeId = InformationStrings.accountCustomerId;
        update newAcct;

        Database__c database = [Select Id from Database__c where Account__c = :newAcct.id limit 1];

        Case c = new Case(
                AccountId = newAcct.Id,
                RecordTypeId = InformationStrings.caseRiskId,
                Origin = 'Email',
                Status = 'New',
                Reason = 'Implementation Expectations',
                Case_Sub_Reason__c = 'Expect a Specific GL Date',
                Database__c = database.Id,
                Priority = 'Normal'
        );
        insert c;

        Case caseRec = [Select id, Account.RecordTypeId from Case where id = :c.id];

        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(caseRec);
        CustomerAlerts ca = new CustomerAlerts(sc);
        System.assertEquals(true, ca.isMyCaseRecord);
        Test.stopTest();
    }

    static testMethod void testMyCaseOpportunity(){

        Account newAcct = [Select Id, RecordTypeId from Account where name = 'TestAcct' limit 1];
        newAcct.RecordTypeId = InformationStrings.accountCustomerId;
        update newAcct;

        Opportunity newOpp = new Opportunity(
                // RecordTypeId = InformationStrings.opportunityMyCaseValueId,
                StageName = 'Discovery',
                CloseDate = System.today() + 30,
                AccountId = newAcct.Id,
                Name = 'Test Opportunity'
        );
        insert newOpp;

        opportunity newOppRec = [Select id, RecordTypeId, StageName, AccountId, Account.RecordTypeId from Opportunity where id = :newOpp.id];

        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(newOppRec);
        CustomerAlerts ca = new CustomerAlerts(sc);
        System.assertEquals(true, ca.isMyCaseRecord);
        Test.stopTest();
    }

    static testMethod void testVPWithGiactFraudResponse(){

       Account newAcct = [Select Id, RecordTypeId from Account where name = 'TestAcct' limit 1];
       
       Database__c database = [Select Id from Database__c where Account__c = :newAcct.id limit 1];
        
       ValuePlus__c valuePlus = TestDataFactory.createValuePlusList(1, newAcct.Id, true)[0];

       GIACTIdentifyResponses__c gIdentifyResp = new GIACTIdentifyResponses__c(
                        ValuePlus__c = valuePlus.Id,
                        Message__c = 'Test'
       );
       insert gIdentifyResp;

       GIdentifyEntityInformation__c gEntityInfo = new GIdentifyEntityInformation__c(
                        GIACTIdentifyResponse__c = gIdentifyResp.Id,
                        Fraud_Activity_Found__c = true
       );
       insert gEntityInfo;
        
       Test.startTest();
       ApexPages.StandardController sc = new ApexPages.StandardController(valuePlus);
       CustomerAlerts ca = new CustomerAlerts(sc);
       System.assert(ca.fraudMsg != null);
       Test.stopTest();
    }

    static testMethod void testPlusClientonAccount(){
       
       User adUser = TestDataFactory.createAdminUser(true);

       Account newAcct = [Select Id, RecordTypeId from Account where name = 'TestAcct' limit 1];

       Asset ast = [Select Id from Asset where AccountId = :newAcct.Id limit 1];
    //    ast.RecordTypeId = InformationStrings.assetPropertyManagementId;
       ast.Status = 'Customer';
       ast.Customer_APM_Version__c = 'APM+';
       ast.Dedicated_Success_Manager__c = adUser.Id;
       ast.Strategic_Relationship_Manager__c = adUser.Id;
       update ast;

       Test.startTest();
       ApexPages.StandardController sc = new ApexPages.StandardController(newAcct);
       CustomerAlerts ca = new CustomerAlerts(sc);
       Test.stopTest();

       System.assert(ca.plusClientMsg != null);
       System.assert(ca.plusClientMsg.containsIgnoreCase('PLUS Client'));
    }

    static testMethod void testPlusClientonAsset(){
       
       User adUser = TestDataFactory.createAdminUser(true);

       Account newAcct = [Select Id, RecordTypeId from Account where name = 'TestAcct' limit 1];

       Asset ast = [Select Id from Asset where AccountId = :newAcct.Id limit 1];
    //    ast.RecordTypeId = InformationStrings.assetPropertyManagementId;
       ast.Status = 'Customer';
       ast.Customer_APM_Version__c = 'APM+';
       ast.Dedicated_Success_Manager__c = adUser.Id;
       ast.Strategic_Relationship_Manager__c = adUser.Id;
       update ast;

       Test.startTest();
       ApexPages.StandardController sc = new ApexPages.StandardController(ast);
       CustomerAlerts ca = new CustomerAlerts(sc);
       Test.stopTest();

    //    System.assert(ca.plusClientMsg != null);
    //    System.assert(ca.plusClientMsg.containsIgnoreCase('PLUS Client'));
    }

    static testMethod void testKeyAccountClientonAsset(){
       
        User adUser = TestDataFactory.createAdminUser(true);
 
        Account newAcct = [Select Id, RecordTypeId from Account where name = 'TestAcct' limit 1];
 
        Asset ast = [Select Id from Asset where AccountId = :newAcct.Id limit 1];
        // ast.RecordTypeId = InformationStrings.assetPropertyManagementId;
        ast.Key_Account__c = True;
        ast.Customer_APM_Version__c = 'APM';
        update ast;
 
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(newAcct);
        CustomerAlerts ca = new CustomerAlerts(sc);
        Test.stopTest();
 
        System.assert(ca.plusClientMsg != null);
        System.assert(ca.plusClientMsg.containsIgnoreCase('Key Account Client'));
     }


     static testMethod void testRPMClient(){
       
        User adUser = TestDataFactory.createAdminUser(true);
 
        Account newAcct = [Select Id, RecordTypeId from Account where name = 'TestAcct' limit 1];
        newAcct.RPM__c = True;
        update newAcct;

        Asset ast = [Select Id from Asset where AccountId = :newAcct.Id limit 1];
        // ast.RecordTypeId = InformationStrings.assetPropertyManagementId;
        ast.Status = 'Customer';
        ast.Customer_APM_Version__c = 'APM';
        update ast;
 
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(newAcct);
        CustomerAlerts ca = new CustomerAlerts(sc);
        Test.stopTest();
 
        System.assert(ca.plusClientMsg != null);
        System.assert(ca.plusClientMsg.containsIgnoreCase('RPM Client'));
     }

    private static testMethod void testExceptions(){

        Account newAcct = [Select Id, RecordTypeId from Account where name = 'TestAcct' limit 1];

        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(newAcct);
        CustomerAlerts ca = new CustomerAlerts(sc);
        ca.getAlertsforAccount(null);
        ca.getAlertsforValuePlus(null);
        ca.getAlertsforCase(null);
        ca.getAlertsforOpportunity(null);
        ca.getAlertsforAsset(null);
        Test.stopTest();

        System.assert([SELECT COUNT() FROM System_Exception_Log__c ] > 0);
    }
}