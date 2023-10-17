/*
*
* Class: ValuePlusTriggerMethodHandler
* 
* Test Class: ValuePlusTriggerMethodHandlerTest
*
* Description: Holds all logic used to perform operations on value+ records and related objects records,
*
* Change Log
* Author                    Description         Date
* 
*
*/
public class ValuePlusTriggerMethodHandler {
    private Map<Id, ValuePlus__c> oldValuePlusMap;
    private Map<Id, ValuePlus__c> newValuePlusMap;
    private List<ValuePlus__c> newValuePlusList;
    
    public static Boolean isFromValuePlusRecursion = false;
    
    // private RoundRobinHandler roundRobinHandler;
    // private AutoBoardingValuePlus autoBoardingValuePlus;
    // private UpdateMyCasePaymentOpp updateMyCasePaymentOpp;
    // private ValuePlusTriggerOpportunityHelper  valuePlusTriggerOpportunityHelper;
    // private ValuePlusOnBoardingContactPrimaryContact valuePlusOnBoardingContactPrimaryContact;

    private Set<String> stageToCheckProfitstarsOnboarding = new Set<String> { 'Active', 'Ownership Change', 'Tax ID Change', 'Lost', 'Churned' };
    private Set<String> deferredStages = new Set<String> {'Deferred', 'Multi Site Deferred'};
    private Set<String> stageChangedFromDeferredStages = new Set<String> {'Lost', 'Left APM', 'Cancelled', 'Deferred', 'Multi Site Deferred'};
    private Set<String> myCaseResetMyCaseDaysStages = new Set<String> {'Lost', 'Declined', 'Unresponsive', 'Unable to Provide Docs'};
    
    //12/31/1899 10:00 PM
    //probably not needed as date is out of possibly scope
    //but leaving just in case
    private DateTime myDate = DateTime.newInstance(1899, 12, 31, 22, 0, 0);
    private String today = DateTime.now().format('M/dd/yy');
    
    public void initBeforeInsert(List<sObject> newList){
        if(newList != null){
            newValuePlusList = (List<ValuePlus__c>) newList;
        }   
        
        // valuePlusTriggerOpportunityHelper = new valuePlusTriggerOpportunityHelper();

       //opportunities
        // valuePlusTriggerOpportunityHelper.initBeforeInsert(newValuePlusList);
    }
    
    public void initAfterInsert(List<sObject> newList){
        
        if(newList != null){
            newValuePlusList = (List<ValuePlus__c>) newList;
        }
        
        //contacts
        // valuePlusOnBoardingContactPrimaryContact = new ValuePlusOnBoardingContactPrimaryContact();
    }
    
    public void initBeforeUpdate(Map<Id, sObject> oldMap, Map<Id, sObject> newMap, List<sObject> newList){
        Set<Id> databaseIds = new Set<Id>();

        if(oldMap != null){
            oldValuePlusMap = (Map<Id, ValuePlus__c>) oldMap;
        }
        
        if(newMap != null){
            newValuePlusMap = (Map<Id, ValuePlus__c>) newMap;
        }
        
        if(newList != null){
            newValuePlusList = (List<ValuePlus__c>) newList;
        }
        
        // roundRobinHandler = new RoundRobinHandler();
        // autoBoardingValuePlus = new AutoBoardingValuePlus();

        //value+
        // autoBoardingValuePlus.init(newValuePlusList, oldValuePlusMap.values());
    }
    
    public void initAfterUpdate(Map<Id, sObject> oldMap, Map<Id, sObject> newMap, List<sObject> newList){
        
        
        if(oldMap != null){
            oldValuePlusMap = (Map<Id, ValuePlus__c>) oldMap;
        }
        
        if(newMap != null){
            newValuePlusMap = (Map<Id, ValuePlus__c>) newMap;
        }
        
        if(newList != null){
            newValuePlusList = (List<ValuePlus__c>) newList;
        }
        
        // updateMyCasePaymentOpp = new UpdateMyCasePaymentOpp();
        // valuePlusOnBoardingContactPrimaryContact = new ValuePlusOnBoardingContactPrimaryContact();
    }
    
    private void runBeforeInsert(){
                System.debug('Testing it now');

        for(ValuePlus__c valuePlus : newValuePlusList){
        }
    }
    
    private void runBeforeUpdate(){
        for(ValuePlus__c newValuePlus : newValuePlusList){
            ValuePlus__c oldValuePlus = oldValuePlusMap.get(newValuePlus.Id);
        }
    }
    
    
    private void runAfterInsert(){
        for(ValuePlus__c valuePlus : newValuePlusList){
            // valuePlusOnBoardingContactPrimaryContact.populateCollection(valuePlus, null);
            if (GiactShouldRun.canIRun () && !system.isFuture()){ //leaving if needed
                GiactIdentifyService.processValuePlusRecordsForGiact(valuePlus);
            }
        }  
    }
    
    private void runAfterUpdate(){
        
        for(ValuePlus__c newValuePlus : newValuePlusList){
            ValuePlus__c oldValuePlus = oldValuePlusMap.get(newValuePlus.Id);
            
            // updateMyCasePaymentOpp.populateMap(newValuePlus, oldValuePlus);
            // valuePlusOnBoardingContactPrimaryContact.populateCollection(newValuePlus, oldValuePlus);

            if (GiactShouldRun.canIRun () && !system.isFuture()){ //leaving if needed
                GiactIdentifyService.processValuePlusRecordsForGiact(newValuePlus);
            }
        }
        
    }
    
    public void afterUpdate(){
        runAfterUpdate();
        // updateMyCasePaymentOpp.updateOpps();
        // valuePlusOnBoardingContactPrimaryContact.updateContacts();
        GiactIdentifyService.doCallout();
        GiactShouldRun.stopTrigger(); //leaving if needed
        
    }
    
    public void afterInsert(){
        runAfterInsert();
        // valuePlusOnBoardingContactPrimaryContact.updateContacts();

        GiactIdentifyService.doCallout();
        GiactShouldRun.stopTrigger(); //leaving if needed
    }
    
    public void beforeUpdate(){
        runBeforeUpdate();
        // roundRobinHandler.performDML();
    }
    
    public void beforeInsert(){
        runBeforeInsert();
    }
    
 
 
}