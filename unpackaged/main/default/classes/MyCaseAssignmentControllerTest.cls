/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This class tests the functionality of MyCaseAssignmentController.
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Sammy Smooke 		  
* @modifiedBy     Sam Reep			<samuel.reep@appfolio.com>
* @version        1.1
* @created        2016-10-31
* @modified       2019-07-15
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* v1.1            samuel.reep@appfolio.com
* 2019-07-15      Updated to use TestDataFactory/InformationStrings. -R1917447 
*        
* v1.0            rohit.malik@appfolio.com
* 2016-10-31      Class creation.
*
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
@isTest
private class MyCaseAssignmentControllerTest {
	static Account a {get;set;}
	static Contact c {get;set;}
	static Id myCaseRtId {get;set;}
	static Group myCaseTeam {get;set;}
	static QueueSObject q1 {get;set;}

	@TestSetup
	static void testData(){
		TestDataFactory.createCustomSettings();
		TestDataFactory.DataModel dm = new TestDataFactory.DataModel(1, false);
		INSERT dm.accountList;

		for(Contact c : dm.contactList){
			c.AccountId = dm.accountList[0].Id;
			c.LeadSource = 'Web';
			c.Lead_Channel__c = 'Direct';
		}
		INSERT dm.contactList;

		for(Case ca : dm.caseList){
			ca.AccountId = dm.accountList[0].Id;
			ca.ContactId = dm.contactList[0].Id;
			ca.Subject = 'testing';
			ca.Status = 'New';
			ca.Origin = 'Phone';
			// ca.RecordTypeId = InformationStrings.caseMyCaseSupportId;
		}
		INSERT dm.caseList;

	}

    //Assign Case
	static testMethod void testMethod1(){
		QueueSObject q1 = [SELECT Id, QueueId, SObjectType FROM QueueSObject WHERE QueueId in (SELECT Id FROM Group WHERE Name = 'MyCase Team') LIMIT 1];

		Case ca = [SELECT Id, OwnerId, Priority FROM Case LIMIT 1];
		ca.OwnerId = q1.QueueId;
		ca.Priority = 'Normal';
		update ca;

		Test.startTest();
			MyCaseAssignmentController ctrl = new MyCaseAssignmentController();
			ctrl.nextCase = ca;
			ctrl.assignNext();
			ctrl.refreshPage();
		Test.stopTest();

		List<Case> cases = [select Id from Case where OwnerId = :UserInfo.getUserId()];
		System.assert(cases.size()>0,'Did not assign');
	}

    //Assign Case from Voicemail
	static testMethod void testMethod2(){
		QueueSObject q1 = [SELECT Id, QueueId, SObjectType FROM QueueSObject WHERE QueueId in (SELECT Id FROM Group WHERE Name = 'MyCase Team') LIMIT 1];

		Case ca = [SELECT Id, OwnerId, Priority FROM Case LIMIT 1];
		ca.OwnerId = q1.QueueId;
        // ca.RecordTypeId = InformationStrings.caseMyCaseSupportId;
        ca.Status = 'New';
        ca.Origin = 'Voicemail';
		update ca;

		Test.startTest();
			MyCaseAssignmentController ctrl = new MyCaseAssignmentController();
			ctrl.nextCase = ca;
			ctrl.assignNext();
			ctrl.refreshPage();
		Test.stopTest();

		List<Case> cases = [select Id from Case where OwnerId = :UserInfo.getUserId()];
		System.assert(cases.size()>0,'Did not assign');
	}
}