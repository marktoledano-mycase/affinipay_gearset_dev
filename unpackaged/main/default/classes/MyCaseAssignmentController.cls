/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This is the apex controller for MyCaseAssignmentPage.vfp
* 
* @test           MyCaseAssignmentControllerTest
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         
* @modifiedBy     ryan Kleinberg <ryan.kleinberg@appfolio.com>
* @maintainedBy   
* @version        1.1
* @created        2020-4-13
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* v1.1            ryan.kleinberg@appfolio.com
* 2020-4-13       Adding "# of users" column to VF page - R2024907 
*
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/public with sharing class MyCaseAssignmentController {
	public List<Case> availableCases {get;set;}
	public Case nextCase {get;set;}
	Group myCaseTeamQ {get;set;}
	Id myCaseSupportRtId {get;set;}

	public MyCaseAssignmentController(){
		initialize();
		findNextCase();
	}

	void initialize(){
		availableCases = new List<Case>();
		nextCase = new Case();
		myCaseTeamQ = [select Id from Group where Type='Queue' and Name = 'MyCase Team' limit 1];
		// myCaseSupportRtId = InformationStrings.caseMyCaseSupportId;
	}

	private Case findNextCase(){
		availableCases = [select Id,OwnerId,CaseNumber,ContactId,Contact.Name,Priority,Status,CreatedDate,Subject,Total_Users__c  from Case where OwnerId = :myCaseTeamQ.Id and RecordTypeId = :myCaseSupportRtId and Status LIKE '%New%' ORDER BY CreatedDate ASC];
		if(!availableCases.isEmpty()){
			List<Case> vmCases = [select Id,OwnerId,CaseNumber from Case where OwnerId = :myCaseTeamQ.Id and RecordTypeId = :myCaseSupportRtId and Status LIKE '%New%' and Origin = 'Voicemail' ORDER BY CreatedDate ASC];
			if(!vmCases.isEmpty()){
				nextCase = vmCases[0];
			}else{
				nextCase = availableCases[0];
			}
		}
		return nextCase;
	}

	public PageReference assignNext(){
		PageReference page = null;
		if(nextCase != null){
			Case c = [select Id,OwnerId from Case where Id = :nextCase.Id];
			if(!(String.valueOf(c.OwnerId)).startsWith('005')){
				c.OwnerId = UserInfo.getUserId();
				update c;
			}
		}
		return page;
	}

	public PageReference refreshPage(){
		PageReference page = new PageReference('/apex/MyCaseAssignmentPage');
		page.setRedirect(true);
		return page;
	}
}