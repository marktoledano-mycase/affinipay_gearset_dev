trigger SystemExceptionLoggerEventTrigger on System_Exception_Logger_Event__e (after Insert) {
    
    // there should only be 1 new record within the trigger context
    // there is no need for recusive checks, as the the trigger will only get executed one time 
        for(System_Exception_Logger_Event__e evt : Trigger.new){
           SystemExceptionLogger.insertSystemExceptionLogEntry(evt.Name__c,
                                                        evt.Source_Application__c,
                                                        evt.Exception_Level__c,
                                                        evt.Object_Name__c,
                                                        evt.Object_Reference__c,
                                                        evt.Exception_Type__c,
                                                        evt.Exception_Message__c,
                                                        evt.Exception_Cause__c,
                                                        evt.Exception_Line_Number__c,
                                                        evt.Exception_Stack_Trace__c,
                                                        evt.Dml_Exception_Type__c,
                                                        evt.Support_Data__c,
                                                        evt.Exception_Run_As_User__c,
                                                        evt.Store_Data_As_Attachment__c
                                                        );
        }

}