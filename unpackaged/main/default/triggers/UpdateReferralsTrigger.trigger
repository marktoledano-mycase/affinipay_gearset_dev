trigger UpdateReferralsTrigger on Account (after update) {
    
    // Iterate over the trigger newMap to find changes
    for (Account newAccount : Trigger.new) {
        Account oldAccount = Trigger.oldMap.get(newAccount.Id);
        system.debug('Old Value: ' + oldAccount.Payments_Enterprise_Account__c);
        system.debug('New Value: ' + newAccount.Payments_Enterprise_Account__c);
        // Check if Payments_Enterprise_Partner__c field has changed
        if (newAccount.Payments_Enterprise_Account__c != oldAccount.Payments_Enterprise_Account__c) {
            system.debug('RUN REFERRALS HANDLER AND SET TO: ' + string.valueof(newAccount.Payments_Enterprise_Account__c));
            UpdateReferralsHandler.UpdateReferralsHandler(newAccount.Id, string.valueof(newAccount.Payments_Enterprise_Account__c));
        }
    }    
}