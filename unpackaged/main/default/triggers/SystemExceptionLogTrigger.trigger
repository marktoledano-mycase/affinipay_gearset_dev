trigger SystemExceptionLogTrigger on System_Exception_Log__c (
    before insert, 
    before update, 
    before delete, 
    after insert, 
    after update, 
    after delete, 
    after undelete) {
        new SystemExceptionLogTriggerHandler().run();
}