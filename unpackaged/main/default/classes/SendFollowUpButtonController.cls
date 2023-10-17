/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This class is the apex controller to the SendFollowUpButton component on the Case object. 
* The purpose of this class is to modify fields on case when the user wihses to send a follow up message.
* 
* @test           SendFollowUpButtonControllerTest
* Referred from   SendFollowUpButton.cmp
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Ryan Kleinberg   <ryan.kleinberg@appfolio.com>
* @modifiedBy     Ryan Kleinberg   <ryan.kleinberg@appfolio.com>
* @maintainedBy   Ryan Kleinberg   <ryan.kleinberg@appfolio.com>
* @version        1.1
* @created        2019-05-28
* @modified       2019-05-28

* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* v1.2            vijay.reddy@appfolio.com
* 2019-11-07      Added the sendFollowUpNoRepsonse method
*
* v1.1            ryan.kleinberg@appfolio.com
* 2019-05-28      This change adds the comment header to the class
*        
*
* v1.0			  ryan.kleinberg@appfolio.com
* 2019-05-28	  Provides functionality for the button: SendFollowUp on case
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/

global without sharing class SendFollowUpButtonController {
    
    @AuraEnabled
    public static Boolean sendFollowUp(String recordId) {	
        try{
            //query the case from the given case Id
            Case c = [SELECT Id, Reason, Type, Case_Sub_Reason__c, ContactId, RecordTypeId, Send_To__c, Status FROM Case WHERE Id =: recordId];
            

            //If fields are left as null prompt the user to populate them
            if(c.Reason == Null || c.Case_Sub_Reason__c == Null || c.ContactId == Null || c.Type == Null){
                //Throwing an AuraHandledExpeption would not display the message, but custom exception does
                String m = 'Please populate the case reason, sub-reason and Type and confirm that a contact is associated before sending a follow-up';
                AuraHandledException e = new AuraHandledException(m);
                e.setMessage(m);
                throw e;
                
            }else{
                //update appropriate fields 
                c.Status = 'Waiting to Close';
                c.Send_To__c = 'Followup';
            }
            
            
            
           	//update the case object
            Database.SaveResult sr = Database.UPDATE(c);   
            if (sr.isSuccess()){
                return true;
            } else {
                return false;
            }
            
        }catch(Exception ex){
            //if an exception was thrown, log and throw it
            SystemExceptionLogger.fireSystemExceptionLogEvent (ex, 'SendFollowUpButtonController', 'sendFollowUp', 
                                                                   SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, ex.getMessage(), 'Case', null, false);
            if(Test.isRunningTest()){
                return false;
            }else{
                throw new AuraHandledException(ex.getMessage());
            }  
        }
    }

    @AuraEnabled
    public static Boolean sendFollowUpNoRepsonse(String recordId){	
        try{
            //query the case from the given case Id
            Case c = [SELECT Id, Reason, Type, Case_Sub_Reason__c, ContactId, RecordTypeId, Send_To__c, Status FROM Case WHERE Id =: recordId];
            

            //If fields are left as null prompt the user to populate them
            if(c.Reason == null || c.Case_Sub_Reason__c == null || c.ContactId == null || c.Type == Null){
                //Throwing an AuraHandledExpeption would not display the message, but custom exception does
                String m = 'Please populate the case reason, sub-reason and Type and confirm that a contact is associated before sending a follow-up';
                AuraHandledException e = new AuraHandledException(m);
                e.setMessage(m);
                throw e;
                
            }else{
                //update appropriate fields 
                c.Status = 'Waiting to Close - No Response';
                c.Send_To__c = 'Followup';
            }
            
           	//update the case object
            Database.SaveResult sr = Database.UPDATE(c);   
            if (sr.isSuccess()){
                return true;
            } else{
                return false;
            }  
        } catch(Exception ex){
            //if an exception was thrown, log and throw it
            SystemExceptionLogger.fireSystemExceptionLogEvent (ex, 'SendFollowUpButtonController', 'sendFollowUpNoRepsonse', 
                                                                   SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, ex.getMessage(), 'Case', null, false);
            if(Test.isRunningTest()){
                return false;
            } else{
                throw new AuraHandledException(ex.getMessage());
            }  
        }
    } 
}