/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This is the batch job for removing sensitive data on PNM audit logs after snadbox refresh
* 
* @test           PostRefreshPNMLogBatchTest
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
public class PostRefreshPNMLogBatch implements Database.Batchable<sObject> {
    
    String query;
    
    public Database.QueryLocator start(Database.BatchableContext context) {
        query = 'SELECT Id, RawRequest__c, RawResponse__c  FROM Automation_Log__c';
        
        //If this is running in production, STOP. This should not run in production
        if(UserInfo.getOrganizationId() == '00D80000000cytGEAQ'){
            query += ' Limit 0';
        }
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext context, List<sObject> scope) {
        List<Automation_Log__c> logList = scope;
        List<Automation_Log__c> updateLogList = new List<Automation_Log__c>();
        
        for(Automation_Log__c log : logList){
            
            //mask sensitive info in the request and response
            log.RawRequest__c = '';
            log.RawResponse__c = '';
			            
            updateLogList.add(log);
            
            
        }
        if (!updateLogList.isEmpty()){
            //Update the logs
            UPDATE(updateLogList);
        }
    }
    
    public void finish(Database.BatchableContext context) {
        if(!Test.isRunningTest()){
            Database.executeBatch(new Turn_ON_ValidationRulesBatch(), 1);
        }
    }
   
    
    
}