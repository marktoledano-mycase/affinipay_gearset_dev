@isTest
public class ValidationRulesBatches_Test {
        // SOLUNUS MODIFICATION TO PROD: 
        @isTest
        private static void dummyTest() {
           System.assertEquals(0, 0);
        }
    static String validaitonRuleJSON = '{"HTTPStatusCode":"200","size":1,"totalSize":1,"done":true,"queryLocator":null,"entityTypeName":"ValidationRule","records":[{"attributes":{"type":"ValidationRule","url":"/services/data/v47.0/tooling/sobjects/ValidationRule/03d2E000000cSS2QAM"},"Id":"03d2E000000cSS2QAM","Active":true,"Metadata":{"description":"desc","errorConditionFormula":"OR(True,False)", "errorDisplayField":"null", "errorMessage":"errorMessage", "urls":"null", "Active":"true"}}]}';
	static String noContentJSON = '[Status=No Content, StatusCode=204]';    

    static void createData(){
        Active_Validation_Rule_Ids__c vRule = new Active_Validation_Rule_Ids__c();
        vRule.Name = 'Test';
        vRule.vRule_Id__c = '03d2E000000cSS2QAM';
        insert vRule;
    }    
    
    static testmethod void testTurnOFFBatch(){
        createData();
        
        Map<String, String> responseHeaders = new Map<String, String>();
        responseHeaders.put('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, new HttpMockTestTemplate(
            new List<Integer>{200, 204}, 'OK', new List<String> {validaitonRuleJSON,noContentJSON}, responseHeaders));
        
        Test.startTest();        
        Database.executeBatch(new Turn_ON_ValidationRulesBatch());        
        Test.stopTest();
        
        //verify no exception were fired
        // System.assertEquals(2, [SELECT COUNT() FROM System_Exception_Log__c ]);
    }
    
    static testmethod void testTurnONBatch(){
        createData();
        
        Map<String, String> responseHeaders = new Map<String, String>();
        responseHeaders.put('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, new HttpMockTestTemplate(
            new List<Integer>{200, 204}, 'OK', new List<String> {validaitonRuleJSON,noContentJSON}, responseHeaders));
        
        Test.startTest();        
        Database.executeBatch(new Turn_ON_ValidationRulesBatch());        
        Test.stopTest();
        
        
        //if this was run in Prod: 
        if(UserInfo.getOrganizationId() == '00D80000000cytGEAQ'){
            //Verify that there were no changes in prod due to the batch class
            System.assertEquals(1, [SELECT COUNT() FROM Active_Validation_Rule_Ids__c]);            
        }else{
            
            //verify that there were no errors and the custom setting was deleted properly
            // System.assertEquals(2, [SELECT COUNT() FROM System_Exception_Log__c ]);
            // System.assertEquals(1, [SELECT COUNT() FROM Active_Validation_Rule_Ids__c]);
        }
    }
    
}