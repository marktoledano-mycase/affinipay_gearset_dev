trigger BankAccountTrigger on Bank_Account__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    new BankAccountTriggerHandler().run();
}