public with sharing class UpdateReferralsHandler {

    @Future
    public static void UpdateReferralsHandler(String account_id, String picklist_value) {

        // Get Referral Records
        system.debug('Referral Search Parameters: ' + account_id + ' ' + picklist_value);
        List<Referral__c> update_ref = new List<Referral__c>();
        for(Referral__c r : [SELECT Id, Payments_Enterprise_Account__c FROM Referral__c WHERE Partnership__r.Partner_Account__c = : account_id]){
            r.Payments_Enterprise_Account__c = picklist_value;
            update_ref.add(r);
        }
        update update_ref;
    }
}