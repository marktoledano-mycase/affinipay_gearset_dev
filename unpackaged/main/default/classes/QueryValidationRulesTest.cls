@isTest
public class QueryValidationRulesTest {
    
    
    static String validaitonRuleJSON = '{"HTTPStatusCode":"200","size":1,"totalSize":1,"done":true,"queryLocator":null,"entityTypeName":"ValidationRule","records":[{"attributes":{"type":"ValidationRule","url":"/services/data/v47.0/tooling/sobjects/ValidationRule/03d2E000000cSS2QAM"},"Id":"03d2E000000cSS2QAM","Active":true,"Metadata":{"description":"desc","errorConditionFormula":"OR(True,False)", "errorDisplayField":"null", "errorMessage":"errorMessage", "urls":"null", "Active":"true"}}]}';
    static String noContentJSON = '[Status=No Content, StatusCode=204]';
    static String badJSON = '{"HTTPStatusCode":"400"}';
    
    
    public static testmethod void testVruleSubclasses(){
        
        Test.startTest();
        
        QueryValidationRules.attribute atr = new QueryValidationRules.attribute('ValidationRule', '/ValidationRule/03d2E000000cSS2QAM');
        QueryValidationRules.metadata md = new QueryValidationRules.metadata('desc', 'OR(True, False', 'null', 'errorMessage', 'null', 'true');
        QueryValidationRules.vrule vr = new QueryValidationRules.vrule(atr, '03d2E000000cSS2QAM', 'true', md);
        
        Test.stopTest();
        
        
        System.assertEquals('03d2E000000cSS2QAM', vr.attributes.getId());  
        System.assertEquals(md, vr.metadata);
        
    }
    
    
    public static testmethod void testGetValidRuels(){
        
        Test.startTest();
        Map<String, String> responseHeaders = new Map<String, String>();
		responseHeaders.put('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, new HttpMockTestTemplate(
			new List<Integer>{200}, 'OK', new List<String> {validaitonRuleJSON}, responseHeaders));
        
        List<Active_Validation_Rule_Ids__c> rules = QueryValidationRules.populateActiveVrules();
        Test.stopTest();
        
        if(!URL.getSalesforceBaseUrl().toExternalForm().containsIgnoreCase('devpro')){
            //verify nothing happens if not in full
            System.assertEquals(rules.size(), 0);              
        }else{
            System.assert(rules.size() > 0, 'Failed to make Validation Rule custom setting');
        }
    }
    
   
    public static testmethod void testGetMetadata(){
        
        Test.startTest();
        Map<String, String> responseHeaders = new Map<String, String>();
		responseHeaders.put('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, new HttpMockTestTemplate(
			new List<Integer>{200}, 'OK', new List<String> {validaitonRuleJSON}, responseHeaders));
        
        QueryValidationRules.metadata md = QueryValidationRules.getMetadata('a7W8A000000Db52UAC');
        Test.stopTest();
        
        if(!URL.getSalesforceBaseUrl().toExternalForm().containsIgnoreCase('full')){
            //verify nothing happens if not in full
            // System.assertEquals(null, md);
        }else{
            // System.assertNotEquals(null, md);
            // System.assertEquals('desc', md.description);
            // System.assertEquals('OR(True,False)', md.errorConditionFormula);
        }
    }
    
    
    public static testmethod void testSetStatus(){
        
        
        Test.startTest();
        Map<String, String> responseHeaders = new Map<String, String>();
		responseHeaders.put('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, new HttpMockTestTemplate(
			new List<Integer>{200, 204}, 'OK', new List<String> {validaitonRuleJSON, noContentJSON}, responseHeaders));
        
        Boolean success = QueryValidationRules.setStatus('03d2E000000cSS2QAM', false);
        Test.stopTest();
        
        if(!URL.getSalesforceBaseUrl().toExternalForm().containsIgnoreCase('devpro')){
            //verify nothing happens if not in full
            System.assertEquals(false, success);
        }else{
            System.assertEquals(true, success);
        }
    }
    
    
    public static testmethod void testUpdateRules(){
        Active_Validation_Rule_Ids__c vr = new Active_Validation_Rule_Ids__c(name='03d2E000000cSS2QAM', vRule_Id__c = '03d2E000000cSS2QAM');
        insert vr;
        
        
        Test.startTest();
        Map<String, String> responseHeaders = new Map<String, String>();
		responseHeaders.put('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, new HttpMockTestTemplate(
			new List<Integer>{200, 204}, 'OK', new List<String> {validaitonRuleJSON, noContentJSON}, responseHeaders));
        QueryValidationRules.updateRules(new List<Active_Validation_Rule_Ids__c>{vr}, true, true);
        
        
        test.stopTest();
        if(!URL.getSalesforceBaseUrl().toExternalForm().containsIgnoreCase('full')){
            //verify nothing happens if not in full
            // System.assertEquals(1, [SELECT Id FROM Active_Validation_Rule_Ids__c].Size());
        }else{
            // System.assertEquals(0, [SELECT Id FROM Active_Validation_Rule_Ids__c].Size());
        }
    }
    
    public static testmethod void testException1(){
        
        Test.startTest();
        Map<String, String> responseHeaders = new Map<String, String>();
		responseHeaders.put('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, new HttpMockTestTemplate(
			new List<Integer>{400}, 'OK', new List<String> {noContentJSON}, responseHeaders));
        
        List<Active_Validation_Rule_Ids__c> rules = QueryValidationRules.populateActiveVrules();
        Test.stopTest();
        
        // System.assert([SELECT COUNT() FROM System_Exception_Log__c ] > 0, 'No Exception Logs Created');
        
    }
    
    
    public static testmethod void testException2(){
        
        Test.startTest();
        Map<String, String> responseHeaders = new Map<String, String>();
		responseHeaders.put('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, new HttpMockTestTemplate(
			new List<Integer>{400}, 'OK', new List<String> {validaitonRuleJSON}, responseHeaders));
        
        QueryValidationRules.metadata md = QueryValidationRules.getMetadata('03d75000000H1nhAAC');
        Test.stopTest();
        
        // System.assert([SELECT COUNT() FROM System_Exception_Log__c ] > 0, 'No Exception Logs Created');
    }
    
    
    public static testmethod void testException3(){
        
        Test.startTest();
        Map<String, String> responseHeaders = new Map<String, String>();
        responseHeaders.put('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, new HttpMockTestTemplate(
			new List<Integer>{200, 400}, 'OK', new List<String> {validaitonRuleJSON, noContentJSON}, responseHeaders));
        
        Boolean success = QueryValidationRules.setStatus('03d2E000000cSS2QAM', false);
        Test.stopTest();
        
        System.assertEquals(false, success);
        // System.assert([SELECT COUNT() FROM System_Exception_Log__c ] > 0, 'No Exception Logs Created');
    }
    
}