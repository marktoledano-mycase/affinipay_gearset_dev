@isTest
public class PostRefreshGIACTLogBatchTest {
    
    static testMethod void giactLogMasking() {
        
        GiactInquiryResponse__c log = new GiactInquiryResponse__c ();
        log.RequestText__c = 'a lot of sensitive data';
        log.ResponseText__c = 'a lot more sensitive data';
        insert log;
            
        Test.startTest();
        Id batchJobId = Database.executeBatch(new PostRefreshGIACTLogBatch(), 200);
        Test.stopTest();
        
        
        //if this was run in Prod: 
        if(UserInfo.getOrganizationId() == '00D80000000cytGEAQ'){
            //verify that the log's data was not masked in prod
            log = [SELECT Id, RequestText__c, ResponseText__c FROM GiactInquiryResponse__c where id =:log.Id][0];
            System.assertEquals('a lot of sensitive data', log.RequestText__c);
            System.assertEquals('a lot more sensitive data', log.ResponseText__c);
            
        }else{
            //Assert the log's data was masked
            log = [SELECT Id, RequestText__c, ResponseText__c FROM GiactInquiryResponse__c where id =:log.Id][0];
            System.assertEquals(null, log.RequestText__c);
            System.assertEquals(null, log.ResponseText__c);
        }
    }
}