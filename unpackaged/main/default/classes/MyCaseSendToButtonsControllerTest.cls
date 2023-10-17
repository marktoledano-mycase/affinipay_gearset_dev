@isTest
private class MyCaseSendToButtonsControllerTest {
    @TestSetup
    static void makeData(){
        TestDataFactory.createCustomSettings();
        TestDataFactory.DataModel dm = new TestDataFactory.DataModel(1, false);
        INSERT(dm.accountList);
        TestDataFactory.createEntitlements(dm.accountList[0].Id, true);
        
        for(Contact con : dm.contactList){
            con.AccountId = dm.accountList[0].Id;
        }
        INSERT(dm.contactList);

        for(Case c : dm.caseList){
            c.Subject = 'Test Case for Send To';
            c.AccountId = dm.accountList[0].Id;
            c.ContactId = dm.contactList[0].Id;
            c.Status = 'In Progress';
        }
        INSERT(dm.caseList);
        // CaseTriggerHandler.runBeforeUpdate = true;
        // CaseTriggerHandler.runAfterUpdate = true;
    }

    private static Case getCase(){
        return [SELECT Id, Status, Type, DontAssign__c, Reason, Send_To__c, Contract_Case__c, Case_Sub_Reason__c, OwnerId, RecordTypeId 
            FROM Case LIMIT 1];
    }
    
    private static Contact getContact(){
        return [SELECT Id FROM Contact LIMIT 1];
    }

    //test routeCase switch options
    private static testMethod void testOwnThisCase(){
        Test.startTest();
        Case c = getCase();
        MyCaseSendToButtonsController.routeCase(c.Id, 'ownThisCase');
        c = getCase();
        Test.stopTest();
        System.assertEquals(UserInfo.getUserId(), c.OwnerId);
    }

    private static testMethod void testOwnThisCaseCSRep(){
        Profile p = [SELECT Id FROM Profile WHERE Name='MyCase Service'];
        User u = new User(Alias = 'CSRep', Email='cs-rep@testorg.com', 
                    EmailEncodingKey='UTF-8', FirstName='CsRep', LastName='MyCase', LanguageLocaleKey='en_US', 
                    LocaleSidKey='en_US', ProfileId = p.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='cs-rep@testorg.com');
        INSERT u;
        Case c = getCase();
        c.OwnerId = u.Id;
        UPDATE c;

        Test.startTest();
        MyCaseSendToButtonsController.routeCase(c.Id, 'ownThisCase');
        Test.stopTest();
        
        c = getCase();
        // System.assertEquals(UserInfo.getUserId(), c.OwnerId);
    }
    
    private static testMethod void testSendToCS(){
        Test.startTest();
        Case c = getCase();
        MyCaseSendToButtonsController.routeCase(c.Id, 'sendToCS');
        c = getCase();
        Test.stopTest();
        System.assertEquals('New', c.Status);
    }   

    private static testMethod void testCloseAsSpam(){
        Test.startTest();
        Case c = getCase();
        MyCaseSendToButtonsController.routeCase(c.Id, 'closeAsSpam');
        c = getCase();
        Test.stopTest();
        System.assertEquals('Closed', c.Status);
    }   

    private static testMethod void testEscalate(){
        Test.startTest();
        Case c = getCase();
        MyCaseSendToButtonsController.routeCase(c.Id, 'escalate');
        c = getCase();
        Test.stopTest();
    }
    
    private static testMethod void testOwnEscalation(){
        Test.startTest();
        Case c = getCase();
        MyCaseSendToButtonsController.routeCase(c.Id, 'ownEscalation');
        c = getCase();
        Test.stopTest();
    }

    private static testMethod void testSendToSalesMycase(){
        Test.startTest();
        Case c = getCase();
        MyCaseSendToButtonsController.routeCase(c.Id, 'sendToSalesMycase');
        c = getCase();
        Test.stopTest();
        System.assertEquals('Closed', c.Status);
    }

    private static testMethod void testSendToPayments(){
        Test.startTest();
        Case c = getCase();
        MyCaseSendToButtonsController.routeCase(c.Id, 'sendToPayments');
        c = getCase();
        Test.stopTest();
        System.assertEquals('New', c.Status);
    }
    
    private static testMethod void testSendToBilling(){
        Test.startTest();
        Case c = getCase();
        MyCaseSendToButtonsController.routeCase(c.Id, 'sendToBilling');
        c = getCase();
        Test.stopTest();
    }

    private static testMethod void testBillingCase(){
        Test.startTest();
        Case c = getCase();
        MyCaseSendToButtonsController.routeCase(c.Id, 'billingCase');
        c = getCase();
        Test.stopTest();
        System.assertEquals('MyCase Billing', c.Reason);
    }

    private static testMethod void testSendToWebsites(){
        Test.startTest();
        Case c = getCase();
        MyCaseSendToButtonsController.routeCase(c.Id, 'sendToWebsites');
        c = getCase();
        Test.stopTest();
        System.assertEquals('New', c.Status);
    }

    private static testMethod void testCloseAsAdminDupe(){
        Test.startTest();
        Case c = getCase();
        MyCaseSendToButtonsController.routeCase(c.Id, 'adminDupe');
        c = getCase();
        Test.stopTest();
        System.assertEquals('Closed', c.Status);
    } 
}