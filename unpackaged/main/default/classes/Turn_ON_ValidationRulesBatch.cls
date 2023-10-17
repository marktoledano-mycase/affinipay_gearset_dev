/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Batch class to turn on all unmanaged validtion rules. To be used before post sanbox refresh classes
* 
* @test           ValidationRulesBatches_Test
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         
* @modifiedBy     ryan Kleinberg <ryan.kleinberg@appfolio.com>
* @maintainedBy   
* @version        1.1
* @created        2019-12-18
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* v1.0            ryan.kleinberg@appfolio.com
* 2019-12-18      Creation - R1918759 
*
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
public class Turn_ON_ValidationRulesBatch implements Database.Batchable<sObject>, Database.AllowsCallouts  {
    
    String query;
    
    public Database.QueryLocator start(Database.BatchableContext context) {
        query = 'select Id, name, vRule_Id__c from Active_Validation_Rule_Ids__c';
        //If this is running in production, STOP. This should not run in production
        if(UserInfo.getOrganizationId() == '00D80000000cytGEAQ'){
            query += ' Limit 0';
        }
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext context, List<sObject> scope) {
        List<Active_Validation_Rule_Ids__c> rules = scope;
        QueryValidationRules.updateRules(rules, true, true);
        
    }
    
    
    public void finish(Database.BatchableContext context) {}

}