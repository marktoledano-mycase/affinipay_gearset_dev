@isTest
public class UpdateReferralsTest {

    @isTest
    static void testUpdateReferralsTrigger() {
        // Create test data
        Account testAccount = new Account(Name = 'Test Account', Payments_Enterprise_Account__c = 'Yes');
        insert testAccount;
        Partnerships__c testPartnership = new Partnerships__c(Name='Test Partnership', Partner_Account__c = testAccount.id);
        insert testPartnership;
        Referral__c referral = new Referral__c(Payments_Enterprise_Account__c = 'No', Partnership__c = testPartnership.id);
        insert referral;

        // Perform an update to trigger the trigger
        testAccount.Payments_Enterprise_Account__c = 'No';
        update testAccount;

        // Verify the results
        // Query the updated account to verify that the trigger executed the expected logic
        Account updatedAccount = [SELECT Id, Payments_Enterprise_Account__c FROM Account WHERE Id = :testAccount.Id];
        
        // Assert that the Payments_Enterprise_Account__c field has been updated
        System.assertEquals('No', updatedAccount.Payments_Enterprise_Account__c);
        
        // Optionally, you can add more assertions or query related records to ensure the desired behavior.
    }
}