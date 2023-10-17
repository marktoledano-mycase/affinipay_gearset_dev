@isTest
public class PostRefreshPNMLogBatchTest {
    
    static testMethod void pnmLogMasking() {
        
        Automation_Log__c log = new Automation_Log__c ();
        log.RawRequest__c = 'a lot of sensitive data';
        log.RawResponse__c = 'a lot more sensitive data';
        insert log;
            
        Test.startTest();
        Id batchJobId = Database.executeBatch(new PostRefreshPNMLogBatch(), 200);
        Test.stopTest();
        
        //if this was run in Prod: 
        if(UserInfo.getOrganizationId() == '00D80000000cytGEAQ'){
            //verify that the log's data was not masked in prod
            log = [SELECT Id, RawRequest__c, RawResponse__c FROM Automation_Log__c where id =:log.Id][0];
            System.assertEquals('a lot of sensitive data', log.RawRequest__c);
            System.assertEquals('a lot more sensitive data', log.RawResponse__c);
            
        }else{
            //verify that the log's data was masked
            log = [SELECT Id, RawRequest__c, RawResponse__c FROM Automation_Log__c where id =:log.Id][0];
            System.assertEquals(null, log.RawRequest__c);
            System.assertEquals(null, log.RawResponse__c);
        }
    }
}