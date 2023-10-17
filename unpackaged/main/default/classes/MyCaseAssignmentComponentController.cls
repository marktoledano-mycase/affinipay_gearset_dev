/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This class is the apex controller to the MyCaseAssignment component. 
* 
* @test           MyCaseAssignmentComponentControllerTest
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Vijay  <vijay.reddy@appfolio.com>
* @version        1.0
* @created        2020-07-27
* 
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* v1.0            vijay.reddy@appfolio.com
* 2020-07-27      Initial Creation
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
public without sharing class MyCaseAssignmentComponentController{

    public class MyCaseAssignmentComponentControllerException extends Exception {}

    @AuraEnabled
    public static List<Case> getCaseData(){
        List<Case> availableCases = new List<Case>();

        try{
            Group myCaseTeamQ = [select Id from Group where Type = 'Queue' and Name = 'MyCase Team' limit 1];

            availableCases = [select Id, OwnerId, CaseNumber, ContactId, Contact.Name, Priority, Status, CreatedDate, Subject,
                            Total_Users__c from Case where OwnerId = :myCaseTeamQ.Id and RecordTypeId = :InformationStrings.caseMyCaseSupportId 
                            and Status LIKE '%New%' ORDER BY CreatedDate ASC];

        } catch(Exception ex){
            SystemExceptionLogger.fireSystemExceptionLogEvent(ex, 'MyCaseAssignmentComponentController', 'getCaseData',
			 	SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, ex.getMessage(), 'Case', null, false);
        }

        return availableCases;
    }

    @AuraEnabled
    public static void assignNext(){
        List<Case> allCases = new List<Case>();
        Case caseToAssign;

        try{
            Group myCaseTeamQ = [select Id from Group where Type = 'Queue' and Name = 'MyCase Team' limit 1];

            allCases = [select Id, OwnerId, CaseNumber, ContactId, Contact.Name, Priority, Status, CreatedDate, Subject,
                            Total_Users__c, Origin from Case where OwnerId = :myCaseTeamQ.Id and RecordTypeId = :InformationStrings.caseMyCaseSupportId 
                            and Status LIKE '%New%' ORDER BY CreatedDate ASC];
            
            if(!allCases.isEmpty()){
                for(Case cs: allCases){
                    if(cs.Origin == 'Voicemail'){
                        caseToAssign = cs;
                        break;
                    }
                }

                if(caseToAssign == null){
                    caseToAssign = allCases[0];
                }

                if(!(String.valueOf(caseToAssign.OwnerId)).startsWith('005')){
                    caseToAssign.OwnerId = UserInfo.getUserId();
                    update caseToAssign;
                }
            }
        } catch(Exception ex){
            SystemExceptionLogger.fireSystemExceptionLogEvent(ex, 'MyCaseAssignmentComponentController', 'assignNext',
			 	SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, ex.getMessage(), 'Case', (caseToAssign != null ? caseToAssign.Id : null), false);
        }
    }
}