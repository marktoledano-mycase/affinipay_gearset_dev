/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This is the batch job for removing sensitive data on GiactInquiryResponse__c after snadbox refresh
* 
* @test           PostRefreshGIACTLogBatchTest
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         
* @version        1.0
* @created        
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* v1.0            ryan.kleinberg@appfolio.com
* 2020-01-02      Creation - R1918759 
*
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
public class PostRefreshGIACTLogBatch implements Database.Batchable<sObject> {
    
    String query;
    
    public Database.QueryLocator start(Database.BatchableContext context) {
        query = 'SELECT Id, RequestText__c, ResponseText__c FROM GiactInquiryResponse__c';
        
        //If this is running in production, STOP. This should not run in production
        if(UserInfo.getOrganizationId() == '00D80000000cytGEAQ'){
            query += ' Limit 0';
        }
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext context, List<sObject> scope) {
        List<GiactInquiryResponse__c> logList = scope;
        List<GiactInquiryResponse__c> updateLogList = new List<GiactInquiryResponse__c>();
        
        for(GiactInquiryResponse__c log : logList){
            
            //mask sensitive info in the request and response fields
            log.RequestText__c = '';
            log.ResponseText__c = '';
			            
            updateLogList.add(log);
            
            
        }
        if (!updateLogList.isEmpty()){
            //Update the logs
            UPDATE(updateLogList);
        }
    }
    
    public void finish(Database.BatchableContext context) {
        if(!Test.isRunningTest()){
            Database.executeBatch(new PostRefreshPNMLogBatch());
        }
    }
   
    
    
}