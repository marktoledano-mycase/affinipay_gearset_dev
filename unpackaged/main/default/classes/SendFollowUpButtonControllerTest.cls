@isTest
public class SendFollowUpButtonControllerTest{

    //Test without returning error
    private static testMethod void testSendFollowUpNoError(){
        test.startTest();
        TestDataFactory.DataModel dm = createData(True);
    
        Case c = dm.caseList[0];
        
        //Run Controller method and query updated case
        Boolean success = sendFollowUpButtonController.sendFollowUp(c.Id);
        Case newC = [Select Id, Send_To__c, Status FROM Case Where Id = :c.Id LIMIT 1];
        test.stopTest();
        
        System.assertEquals(True, success);
        System.assertEquals('Waiting to Close', newC.Status);
        //Not testing the Send_To__c field becuase in some record types the field is reset to null and will fail the test 
    }
    

    //Test when condition are met that fire an exception
    private static testMethod void testSendFollowUpWithError(){
        test.startTest();
        
        //Leave the appropriate fields (Reason, Case_Sub_Reason, and ContactId) blank 
        //This should have an exception thrown to prompt the user to fill in the required fields
        TestDataFactory.DataModel dm = createData(false);
        Case c = dm.caseList[0];
      
        
        //Test for an exception
        Boolean successful = sendFollowUpButtonController.sendFollowUp(c.Id);
        test.stopTest();
        
        List<System_Exception_Log__c> logList = [SELECT id FROM System_Exception_Log__c];
        System.assertNotEquals(0, logList.size());
    }

    private static testMethod void testSendFollowUpNoRepsonse(){
        Test.startTest();
        TestDataFactory.DataModel dm = createData(True);
    
        Case c = dm.caseList[0];
        
        //Run Controller method and query updated case
        Boolean success = sendFollowUpButtonController.sendFollowUpNoRepsonse(c.Id);
        Case newC = [Select Id, Send_To__c, Status FROM Case Where Id = :c.Id LIMIT 1];
        Test.stopTest();
        
        System.assertEquals(true, success);
        System.assertEquals('Waiting to Close - No Response', newC.Status);
    }

    private static testMethod void testSendFollowUpNoRepsonseError(){
        Test.startTest();
        
        TestDataFactory.DataModel dm = createData(false);
        Case c = dm.caseList[0];
      
        //Test for an exception
        Boolean success = sendFollowUpButtonController.sendFollowUpNoRepsonse(c.Id);
        Test.stopTest();
        
        List<System_Exception_Log__c> logList = [SELECT id FROM System_Exception_Log__c];
        System.assertNotEquals(0, logList.size());
    }
 
    //Set up dataFactory 
	static TestDataFactory.DataModel createData(Boolean addInfo){
        TestDataFactory.createCustomSettings();
        TestDataFactory.DataModel dm = new TestDataFactory.DataModel(1, false);
		
        INSERT(dm.accountList);
		INSERT(dm.contactList);

        if(addInfo){
            for(Case c : dm.caseList){
			    c.ContactId = dm.contactList[0].id;
                c.Type = 'Other';
                c.Status = 'New';
                c.Reason = 'Admin/Duplicates';
                c.Case_Sub_Reason__c = 'Admin/Duplicates';
		    }
        }
		
		INSERT(dm.caseList);
    
		return dm;
    }
}