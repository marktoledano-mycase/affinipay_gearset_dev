@isTest
private class MyCaseAssignmentComponentControllerTest {

    @testSetup
	static void testSetup(){
		TestDataFactory.createCustomSettings();
		TestDataFactory.DataModel dm = new TestDataFactory.DataModel(1, false);
		for(Account acct : dm.accountList){
			acct.RecordTypeId = InformationStrings.accountCustomerId;
		}
		INSERT(dm.accountList);
		TestDataFactory.createEntitlements(dm.accountList[0].Id, true);

		for(Contact con : dm.contactList){
			con.AccountId = dm.accountList[0].Id;
		}
		INSERT(dm.contactList);

        QueueSObject myCaseQueue = [SELECT Id, QueueId, SObjectType FROM QueueSObject WHERE QueueId in (SELECT Id FROM Group WHERE Name = 'MyCase Team') LIMIT 1];

        for(Case ca : dm.caseList){
			ca.AccountId = dm.accountList[0].Id;
			ca.ContactId = dm.contactList[0].Id;
			ca.Subject = 'Test Case';
			ca.Status = 'New';
			ca.Origin = 'Phone';
			ca.RecordTypeId = InformationStrings.caseMyCaseSupportId;
            ca.OwnerId = myCaseQueue.QueueId;
		    ca.Priority = 'Normal';
		}
		INSERT(dm.caseList);
	}

    static testMethod void getCaseDataTest(){
        
        Test.startTest();
        List<Case> caseList = MyCaseAssignmentComponentController.getCaseData();
        System.assertEquals(1, caseList.size());
		Test.stopTest();
    }

    static testMethod void assignNextTest(){

        Test.startTest();
        MyCaseAssignmentComponentController.assignNext();
		Test.stopTest();

        List<Case> cases = [select Id, OwnerId from Case where RecordTypeId = :InformationStrings.caseMyCaseSupportId];
		System.assertEquals(UserInfo.getUserId(), cases[0].OwnerId);
    }

    private static testMethod void testExceptions(){
        Group myCaseGroup = [SELECT Id, Name FROM Group WHERE Type = 'Queue' and Name = 'MyCase Team' limit 1];
        myCaseGroup.Name = 'MyCase Team Test';
        update myCaseGroup;

        Test.startTest();
        MyCaseAssignmentComponentController.getCaseData();
        MyCaseAssignmentComponentController.assignNext();
        Test.stopTest();

        List<System_Exception_Log__c> logList = [SELECT Id FROM System_Exception_Log__c];
        System.assertNotEquals(0, logList.size());
    }
}