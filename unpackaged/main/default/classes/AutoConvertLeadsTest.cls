@isTest
public with sharing class AutoConvertLeadsTest {
    
     static testMethod void AutoConvertLeadsTest() {

        Lead new_lead = new Lead();
        new_lead.FirstName = 'FName';
        new_lead.LastName = 'LName';
        new_lead.Email = 'test@testlead.com';
        new_lead.Company = 'test lead company';
        new_lead.LeadSource='Employee Referral';
        new_lead.Rating='';
        new_lead.Status='';
        insert new_lead;

        Account test_account = new Account();
        test_account.Name = 'Test Account';
        insert test_account;

        Contact test_contact = new Contact();
        test_contact.FirstName = 'FName';
        test_contact.LastName = 'LName';
        test_contact.Account = test_account;
        insert test_contact;

        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];

        User test_user = new User();
        test_user.Alias = 'TUser';
        test_user.Email='userp@testorg.com';
        test_user.EmailEncodingKey='UTF-8';
        test_user.FirstName='Test';
        test_user.LastName='User';
        test_user.LanguageLocaleKey='en_US';
        test_user.LocaleSidKey='en_US';
        test_user.ProfileId = p.Id;
        test_user.TimeZoneSidKey='America/Los_Angeles';
        test_user.UserName='userp@testorg.com';
        insert test_user;

        
        AutoConvertLeads.AutoConvertLeadsRequest params = new AutoConvertLeads.AutoConvertLeadsRequest();
        params.leadId = new_lead.Id;
        params.convertedStatus = 'Qualified';
        params.accountId = test_account.Id;
        params.contactId = test_contact.Id;
        // params.ownerId = test_user.Id;
        params.overWriteLeadSource = FALSE;
        params.createOpportunity = TRUE;
        params.opportunityName = 'Test Auto Created Opportunity';
        params.sendEmailToOwner = FALSE;

        Test.startTest();
        AutoConvertLeads.convertLeads(new List<AutoConvertLeads.AutoConvertLeadsRequest>{params});
        Test.stopTest();
    }
}