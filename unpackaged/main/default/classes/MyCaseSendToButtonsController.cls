/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This is the apex controller for the MycaseSendToButtons component
* 
* @test           MyCaseSendToButtonsControllerTest
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         
* @modifiedBy     Hunter Hamaker <hunter.hamaker@appfolio.com>
* @maintainedBy   
* @version        1.1
* @created        2020-07-01
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* v1.1            hunter.hamaker@appfolio.com
* 2020-07-01      Initial Build - R2027861  
*
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
public class MyCaseSendToButtonsController {

    public class MyCaseSendToButtonsControllerException extends Exception {}

    @AuraEnabled
    public static Boolean routeCase(String recordId, String caseQueue) {    
        try {
            Map<String, Id> recordtypeMap = new Map<String, Id>();
            Map<String, Id> queueMap = new Map<String, Id>();

            //get all record types and put them into map
            List<RecordType> recordTypeList = [SELECT Id, DeveloperName FROM RecordType WHERE SobjectType = 'Case'];
            for(RecordType rt  : recordTypeList){
                recordtypeMap.put(rt.DeveloperName, rt.Id);
                System.debug('recordType Dev Name: ' + rt.DeveloperName + ' Id: ' + rt.Id);
            }
            
            //get all queues and put them into map
            List<Group> queueList = [SELECT Id, DeveloperName FROM Group WHERE Type = 'Queue'];
            for(Group queue : queueList){
                queueMap.put(queue.DeveloperName, queue.Id);
                System.debug('Name: ' + queue.DeveloperName + ' id: ' + queue.Id);
            }
            
            Case c = [SELECT Id, RecordTypeId, Status, Type, Reason, Case_Sub_Reason__c, ContactId, OwnerId FROM Case WHERE Id =: recordId];
            
            Map<Id, User> userMap = new Map<Id, User>([SELECT Id, Profile.Name, UserRoleId FROM User WHERE Id =: UserInfo.getUserId() OR Id =: c.OwnerId]);

            User currentUser = userMap.get(UserInfo.getUserId());
            User currentOwner = userMap.get(c.OwnerId);

            switch on caseQueue{
                when 'ownThisCase'{
                    // R2030368 - This condition is a temporary fix to restrict CS reps from owning each others' cases. Waiting for Salesforce Support to get back with a permanent fix.
                    // if(c.OwnerId != null && currentOwner != null){
                        // throw new MyCaseSendToButtonsControllerException('You don’t have permission to take that action on this record or related records. For help, contact your Salesforce admin.');
                    // } else {
                        c.OwnerId = currentUser.Id;
                        c.Status = 'In Progress';
                        c.DontAssign__c = TRUE;
                    // }
                }
                when 'sendToCS'{
                    c.Status = 'New';
                    c.OwnerID = queueMap.get('MyCase_Team');
                    c.RecordTypeID = recordtypeMap.get('MyCase_Support');
                    c.DontAssign__c = TRUE;
                }
                when 'closeAsSpam'{
                    if(c.RecordTypeId == recordtypeMap.get('MyCase_Support') && c.Status == 'New' && c.OwnerId == queueMap.get('MyCase_Team')){
                        throw new MyCaseSendToButtonsControllerException('Please own the case first!');
                    } else {
                        c.Status = 'Closed';
                        c.Reason = 'Admin/Duplicates';
                        c.DontAssign__c = TRUE;
                    }
                }
                when 'escalate' {
                    if(c.RecordTypeId == recordtypeMap.get('MyCase_Support') && c.Status == 'New' && c.OwnerId == queueMap.get('MyCase_Team')){
                        throw new MyCaseSendToButtonsControllerException('Please own the case first!');
                    } else {
                        
                        if(c.Status != 'Escalated'){
                            c.Status = 'Escalated';
                            c.Priority = 'Escalated';
                            c.Escalation_Status__c = 'New';
	                        c.DontAssign__c = TRUE;
                        }else{
                            throw new MyCaseSendToButtonsControllerException('This case is already in Escalated status');
                        }
                    }
                }
                when 'ownEscalation' {
                    // if(currentUser.Profile.Name != 'MyCase Developer'&&currentUser.Profile.Name != 'MyCase Service'){
                    //     throw new MyCaseSendToButtonsControllerException('Only MyCase Developers Can Own Escalations');
                    // } else if(currentUser.Profile.Name == 'MyCase Developer'||currentUser.Profile.Name == 'MyCase Service')
                    // {
                        c.Escalation_Assignee__c = currentUser.Id;
                        c.Escalation_Status__c = 'Investigating';
                        c.DontAssign__c = TRUE;
                    // }
                }
                when 'sendToSalesMycase' {
                    c.Status = 'Closed';
                    c.Reason = 'Sent to Sales';
                    c.DontAssign__c = TRUE;
                }
                when 'sendToPayments' {
                    c.OwnerId = queueMap.get('MyCase_Payments');
                    c.RecordTypeId = recordtypeMap.get('MyCase');
                    c.Status = 'New';
                    c.DontAssign__c = TRUE;
                }
                when 'sendToBilling' {
					if(c.Case_Sub_Reason__c == 'Refund/Credit'){
                        throw new MyCaseSendToButtonsControllerException('Cases with Sub Reason of "Refund/Credit" need to be approved, please cancel and click "Submit for Approval.');
                    }

                    if(String.isEmpty(c.ContactId)){
                    	throw new MyCaseSendToButtonsControllerException('You must associated a contact with the case before it can be sent to Billing.');
                    }
                    c.RecordTypeId = recordtypeMap.get('Billing_MyCase');
                    c.OwnerId = queueMap.get('MyCase_Billing');
					c.Status = 'New';
                    c.DontAssign__c = TRUE;
                }
                when 'sendToWebsites' {
                    c.OwnerId = queueMap.get('MyCase_Websites');
                    c.RecordTypeId = recordtypeMap.get('MyCase_Websites');
					c.Status = 'New';
                    c.DontAssign__c = TRUE;
                }
                when 'billingCase' {
                    c.RecordTypeId = recordtypeMap.get('Billing_MyCase');
					c.Reason = 'MyCase Billing';
                }
                when 'adminDupe'{
                    c.Status = 'Closed';
                    c.Reason = 'Admin/Duplicates';
                    c.Type = 'Other';
                    c.DontAssign__c = TRUE;
                    if(c.RecordTypeId == recordtypeMap.get('Risk')){
                        c.Case_Resolution__c = 'Admin/Duplicate';
                    }
                }
                when 'sendToAccounting' {
                    system.debug('Send to Accounting Queue: ' + recordId);
                    c.Id = recordId;
                    c.RecordTypeId = recordtypeMap.get('MyCase_Support');
                    c.Status = 'New';
                    c.OwnerId = queueMap.get('MyCase_Accounting');


                }
            }
            
            Database.SaveResult sr = Database.UPDATE(c);
            if (sr.isSuccess()){
                return true;
            } else {
                return false;
            }
        } catch(Exception e) {
            //throw all other exception message
            if(!Test.isRunningTest()){
                AuraHandledException auraEx = new AuraHandledException(e.getMessage());
                auraEx.setMessage(e.getMessage());
                throw auraEx;
            } else {
                return false;
            }
        }
    }
}