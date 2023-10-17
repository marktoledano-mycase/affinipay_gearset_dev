/**
 * Provides utility methods for testing such as methods for creating lists of SObjects.
 *
 * @author Vijay Reddy
 */

@IsTest
public with sharing class TestDataFactory {

    /**
     * Creates a list of Account records.
     *
     * @param recordCount
     *          the number of records to create
     * @param doInsert
     *          Indicates whether or not the record(s) should be inserted within this method
     *
     * @return the list of newly created records
     */
    public static List<Account> createAccountList(final Integer recordCount, final Boolean doInsert) {

        List<Account> accountList = new List<Account>();
        for(Integer i = 0; i < recordCount; i++) {
            accountList.add(new Account(Name = 'Test Account' + i,
            BillingStreet = i + ' 44th St S',
            Phone = '123-123-1234',
            ShippingPostalCode = '99999',
            BillingPostalCode = '99999',
            BillingState = 'CA',
            BillingCity = 'Goleta',
            BillingCountry = 'USA',
            Ownership_Type__c = 'Sole Proprietor',
            State_of_Ownership__c = 'California',
            Year_Established__c = '1088',
            Principal_1_First_Name__c = 'Testy',
            Principal_1_Last_Name__c = 'McTesterson',
            Tax_ID__c = '123123123',
            Principal_First_Name__c = 'Testy',
            Principal_Last_Name__c = 'McTesterson'
            ));
        }

        if(doInsert) {
            insert accountList;
        }

        return accountList;
    }

    /**
     * Creates a list of Contact records.
     *
     * @param recordCount
     *          the number of records to create
     * @param accountId
     *          ID of the Account to relate the records to
     * @param doInsert
     *          Indicates whether or not the record(s) should be inserted within this method
     *
     * @return the list of newly created records
     */
    public static List<Contact> createContactList(final Integer recordCount, final Id accountId, final Boolean doInsert) {

        List<Contact> contactList = new List<Contact>();
        for(Integer i = 0; i < recordCount; i++) {
            contactList.add(new Contact(FirstName = 'Rick' + i, LastName = 'Ross' + i, Email = 'TestAddress@Address.com' , Title = 'TestContactTitle',
                    AccountId = accountId, MailingCity ='Goleta', MailingCountry = 'USA', MailingPostalCode = '99999', MailingStreet = i + ' 44th St S'));
        }

        if(doInsert) {
            insert contactList;
        }

        return contactList;
    }

    /**
     * Creates a list of ValuePlus records.
     *
     * @param recordCount
     *          the number of records to create
     * @param accountId
     *          ID of the Account to relate the records to
     * @param doInsert
     *          Indicates whether or not the record(s) should be inserted within this method
     *
     * @return the list of newly created records
     */
    public static List<ValuePlus__c> createValuePlusList(final Integer recordCount, final Id accountId, final Boolean doInsert) {

        List<ValuePlus__c> valuePlusList = new List<ValuePlus__c>();
        for(Integer i = 0; i < recordCount; i++) {
            valuePlusList.add(new ValuePlus__c(
                Account__c = accountId, 
                Phone_Verified__c = 'yes', 
                Period_Amount__c = 2000, 
                Period_Count__c = 5,
                Single_Day_Amount__c = 1000, 
                Single_Day_Count__c = 1, 
                Single_Trans_Amount__c = 500, 
                ACH_Type__c = '1', 
                Stage__c='Active',
                MC_Principal_1_First_Name__c='Testy',
                MC_Principal_1_Last_Name__c='McTesterson',
                Tax_ID__c = '123123123',
                TIN_Match__c='Ready to Transmit'
                ));
        }

        if(doInsert) {
            insert valuePlusList;
        }

        return valuePlusList;
    }

    /**
     * Creates a list of Database records.
     *
     * @param recordCount
     *          the number of records to create
     * @param accountId
     *          ID of the Account to relate the records to
     * @param doInsert
     *          Indicates whether or not the record(s) should be inserted within this method
     *
     * @return the list of newly created records
     */
    public static List<Database__c> createDatabaseList(final Integer recordCount, final Id accountId, final id assetId, final Boolean doInsert) {

        List<Database__c> databaseList = new List<Database__c>();
        for(Integer i = 0; i < recordCount; i++) {
            databaseList.add(new Database__c(Account__c = accountId, Asset__c = assetId,  vhost__c = 'test' + i, Type__c = 'Production', Active_Units__c= 9 + i));
        }

        if(doInsert) {
            insert databaseList;
        }

        return databaseList;
    }

    /**
     * Creates a list of Case records.
     *
     * @param recordCount
     *          the number of records to create
     * @param accountId
     *          ID of the Account to relate the records to
     * @param doInsert
     *          Indicates whether or not the record(s) should be inserted within this method
     *
     * @return the list of newly created records
     */
    public static List<Case> createCaseList(final Integer recordCount, final Id accountId, final Boolean doInsert) {

        List<Case> caseList = new List<Case>();
        for(Integer i = 0; i < recordCount; i++) {
            caseList.add(new Case(AccountId = accountId, Origin = 'Email', Status = 'New', Priority = 'Normal', Description = 'Test Case description ' + i));
        }

        if(doInsert) {
            insert caseList;
        }

        return caseList;
    }

    /**
     * Creates a list of Opportunity records.
     *
     * @param recordCount
     *          the number of records to create
     * @param accountId
     *          ID of the Account to relate the records to
     * @param doInsert
     *          Indicates whether or not the record(s) should be inserted within this method
     *
     * @return the list of newly created records
     */
    public static List<Opportunity> createOpportunityList(final Integer recordCount, final Id accountId, final Boolean doInsert) {

        List<Opportunity> opportunityList = new List<Opportunity>();
        for(Integer i = 0; i < recordCount; i++) {
            opportunityList.add(new Opportunity(AccountId = accountId, Name = 'Test opportunity' + i, StageName = 'Discovery', CloseDate = System.today() + 30));
        }

        if(doInsert) {
            insert opportunityList;
        }

        return opportunityList;
    }

    /**
     * Creates a list of Lead records.
     *
     * @param recordCount
     *          the number of records to create
     * @param doInsert
     *          Indicates whether or not the record(s) should be inserted within this method
     *
     * @return the list of newly created records
     */
    public static List<Lead> createLeadList(final Integer recordCount, final Boolean doInsert) {

        List<Lead> leadList = new List<Lead>();
        for(Integer i = 0; i < recordCount; i++) {
            leadList.add(new Lead(FirstName = 'TestFN', LastName = 'TestLN' + i, Company = 'Test Lead', Phone = '9632587412'));
        }

        if(doInsert) {
            insert leadList;
        }

        return leadList;
    }

    /**
     * Creates a list of Bank Account records.
     *
     * @param recordCount
     *          the number of records to create
     * @param valuePlusId
     *          ID of the valuePlus record to relate the records to
     * @param doInsert
     *          Indicates whether or not the record(s) should be inserted within this method
     *
     * @return the list of newly created records
     */
    public static List<Bank_Account__c> createBankAccountList(final Integer recordCount, final Id valuePlusId, final Boolean doInsert) {

        List<Bank_Account__c> bankAccountList = new List<Bank_Account__c>();
        for(Integer i = 0; i < recordCount; i++) {
            bankAccountList.add(new Bank_Account__c(ValuePlus__c = valuePlusId, Account_Label__c = 'Test Bank Account' + i, RoutingNo__c = '123456789',
                    AccountNo__c = '12345678912345678', Status__c = 'Active', Bank_Name__c = 'testBankName'));
        }


        if(doInsert) {
            insert bankAccountList;
        }

        return bankAccountList;
    }

    /**
     * Creates a list of Metrics records.
     *
     * @param recordCount
     *          the number of records to create
     * @param accountId
     *          ID of the Account to relate the records to
     * @param doInsert
     *          Indicates whether or not the record(s) should be inserted within this method
     *
     * @return the list of newly created records
     */
    public static List<Metrics__c> createMetricsList(final Integer recordCount, final Id accountId, final Boolean doInsert) {

        List<Metrics__c> metricsList = new List<Metrics__c>();
        for(Integer i = 0; i < recordCount; i++) {
            metricsList.add(new Metrics__c(Name = 'TestMetrics' + i, Account__c = accountId));
        }

        if(doInsert) {
            insert metricsList;
        }

        return metricsList;
    }

    /**
     * Creates a list of Product records.
     *
     * @param recordCount
     *          the number of records to create
     * @param doInsert
     *          Indicates whether or not the record(s) should be inserted within this method
     *
     * @return the list of newly created records
     */
    public static List<Product2> createProductList(final Integer recordCount, final Boolean doInsert) {

        List<Product2> productList = new List<Product2>();
        for(Integer i = 0; i < recordCount; i++) {
            productList.add(new Product2(Description = 'Test Product Description', Name = 'Test Product' + i));
        }

        if(doInsert) {
            insert productList;
        }

        return productList;
    }

    // /**
    //  * Creates a list of ZProduct (zqu__ZProduct__c) records.
    //  *
    //  * @param recordCount
    //  *          the number of records to create
    //  * @param doInsert
    //  *          Indicates whether or not the record(s) should be inserted within this method
    //  *
    //  * @return the list of newly created records
    //  */
    // public static List<zqu__ZProduct__c> createZProductList(final Integer recordCount, final Boolean doInsert) {

    //     List<zqu__ZProduct__c> zProductList = new List<zqu__ZProduct__c>();
    //     for(Integer i = 0; i < recordCount; i++) {
    //         zProductList.add(new zqu__ZProduct__c(Name = 'Test ZProduct' + i, zqu__SKU__c = '0', zqu__ZuoraId__c = 'idProduct' + i));
    //     }

    //     if(doInsert) {
    //         insert zProductList;
    //     }

    //     return zProductList;
    // }

    // /**
    //  * Creates a list of Product Rate Plan (zqu__ProductRatePlan__c) records.
    //  *
    //  * @param recordCount
    //  *          the number of records to create
    //  * @param zProductId
    //  *          ID of the ZProduct record to relate the records to
    //  * @param doInsert
    //  *          Indicates whether or not the record(s) should be inserted within this method
    //  *
    //  * @return the list of newly created records
    //  */
    // public static List<zqu__ProductRatePlan__c> createProductRatePlanList(final Integer recordCount, final Id zProductId, final Boolean doInsert) {

    //     List<zqu__ProductRatePlan__c> productRatePlanList = new List<zqu__ProductRatePlan__c>();
    //     for(Integer i = 0; i < recordCount; i++) {
    //         productRatePlanList.add(new zqu__ProductRatePlan__c(Name = 'Test Product Rate Plan ' + i, zqu__ZProduct__c = zProductId,
    //                 zqu__ZuoraId__c = 'idProductRatePlan' + i));
    //     }

    //     if(doInsert) {
    //         insert productRatePlanList;
    //     }

    //     return productRatePlanList;
    // }

    // /**
    //  * Creates a list of Product Rate Plan Charge (zqu__ProductRatePlanCharge__c) records.
    //  *
    //  * @param recordCount
    //  *          the number of records to create
    //  * @param doInsert
    //  *          Indicates whether or not the record(s) should be inserted within this method
    //  *
    //  * @return the list of newly created records
    //  */
    // public static List<zqu__ProductRatePlanCharge__c> createProductRatePlanChargeList(final Integer recordCount, final Boolean doInsert) {

    //     List<zqu__ProductRatePlanCharge__c> productRatePlanChargeList = new List<zqu__ProductRatePlanCharge__c>();
    //     for(Integer i = 0; i < recordCount; i++) {
    //         productRatePlanChargeList.add(new zqu__ProductRatePlanCharge__c(Name = 'Test Product Rate Plan Charge ' + i, zqu__ZuoraId__c = 'idProductRatePlanCharge' + i));
    //     }

    //     if(doInsert) {
    //         insert productRatePlanChargeList;
    //     }

    //     return productRatePlanChargeList;
    // }

    // /**
    //  * Creates a list of Quote (zqu__Quote__c) records.
    //  *
    //  * @param recordCount
    //  *          the number of records to create
    //  * @param contactId
    //  *          ID of the Contact record to relate the records to
    //  * @param doInsert
    //  *          Indicates whether or not the record(s) should be inserted within this method
    //  *
    //  * @return the list of newly created records
    //  */
    // public static List<zqu__Quote__c> createQuoteList(final Integer recordCount, final Id contactId, final Boolean doInsert) {

    //     List<zqu__Quote__c> quoteList = new List<zqu__Quote__c>();
    //     for(Integer i = 0; i < recordCount; i++) {
    //         quoteList.add(new zqu__Quote__c(Name = 'TestQuote' + i, Billing_Frequency__c = 'Annual', zqu__SubscriptionType__c = 'New Subscription',
    //                 zqu__BillToContact__c = contactId, zqu__SoldToContact__c = contactId));
    //     }

    //     if(doInsert) {
    //         insert quoteList;
    //     }

    //     return quoteList;
    // }

    // /**
    //  * Creates a list of Subscription (Zuora__Subscription__c) records.
    //  *
    //  * @param recordCount
    //  *          the number of records to create
    //  * @param doInsert
    //  *          Indicates whether or not the record(s) should be inserted within this method
    //  *
    //  * @return the list of newly created records
    //  */
    // public static List<Zuora__Subscription__c> createSubscriptionList(final Integer recordCount, final Boolean doInsert) {

    //     List<Zuora__Subscription__c> subscriptionList = new List<Zuora__Subscription__c>();
    //     for(Integer i = 0; i < recordCount; i++) {
    //         subscriptionList.add(new Zuora__Subscription__c(Name = 'A-S0000000' + i, Zuora__AutoRenew__c = false));
    //     }

    //     if(doInsert) {
    //         insert subscriptionList;
    //     }

    //     return subscriptionList;
    // }
    
    // /**
    //  * Creates a list of Zuora__SubscriptionProductCharge__c (Zuora__SubscriptionProductCharge__c) records.
    //  *
    //  * @param recordCount
    //  *          the number of records to create
    //  * @param doInsert
    //  *          Indicates whether or not the record(s) should be inserted within this method
    //  *
    //  * @return the list of newly created records
    //  */
    // public static List<Zuora__SubscriptionProductCharge__c> createSubscriptionProductChargeList(final Integer recordCount, final Id subscriptionId, final Boolean doInsert) {

    //     List<Zuora__SubscriptionProductCharge__c> subscriptionProductChargeList = new List<Zuora__SubscriptionProductCharge__c>();
    //     for(Integer i = 0; i < recordCount; i++) {
    //         subscriptionProductChargeList.add(new Zuora__SubscriptionProductCharge__c(Name = 'A-S0000000' + i, Zuora__Subscription__c = subscriptionId));
    //     }

    //     if(doInsert) {
    //         insert subscriptionProductChargeList;
    //     }

    //     return subscriptionProductChargeList;
    // }


    /**
     * Creates a list of EmailMessage records.
     *
     * @param recordCount
     *          the number of records to create
     * @param doInsert
     *          Indicates whether or not the record(s) should be inserted within this method
     *
     * @return the list of newly created records
     */
    public static List<EmailMessage> createEMailMessageList(final Integer recordCount, final Id caseId, final Boolean doInsert) {

        List<EmailMessage> emailMessageList = new List<EmailMessage>();
        for(Integer i = 0; i < recordCount; i++) {
            emailMessageList.add(new EmailMessage(Subject = 'Test EmailMessage' + i, ParentId = caseId));
        }

        if(doInsert) {
            insert emailMessageList;
        }

        return emailMessageList;
    }

    /**
     * Creates a list of Task records.
     *
     * @param recordCount
     *          the number of records to create
     * @param doInsert
     *          Indicates whether or not the record(s) should be inserted within this method
     *
     * @return the list of newly created records
     */
    public static List<Task> createTaskList(final Integer recordCount, final Boolean doInsert) {

        List<Task> taskList = new List<Task>();
        for(Integer i = 0; i < recordCount; i++) {
            taskList.add(new Task(Subject = 'Test Task' + i));
        }

        if(doInsert) {
            insert taskList;
        }

        return taskList;
    }        

/**
     * Creates a list of Assets records.
     *
     * @param recordCount
     *          the number of records to create
     * @param doInsert
     *          Indicates whether or not the record(s) should be inserted within this method
     *
     * @return the list of newly created records
     */
    public static List<Asset> createAssetList(final Integer recordCount, final Id accountId, final Boolean doInsert) {

        List<Asset> assetList = new List<Asset>();
        for(Integer i = 0; i < recordCount; i++) {
            assetList.add(new Asset(Name = 'Test Asset' + i, AccountId = accountId));
        }

        if(doInsert) {
            insert assetList;
        }

        return assetList;
    }

    // /**
    //  * Creates a list of Real Estate Onboarding records.
    //  *
    //  * @param recordCount
    //  *          the number of records to create
    //  * @param accountId
    //  *          ID of the Account record to relate the records to
    //  * @param assetId
    //  *          ID of the Asset record to relate the records to
    //  * @param oppId
    //  *          ID of the Opportunity record to relate the records to
    //  * @param doInsert
    //  *          Indicates whether or not the record(s) should be inserted within this method
    //  *
    //  * @return the list of newly created records
    //  */
    // public static List<Real_Estate_Onboarding__c> createREOList(final Integer recordCount, final Id accountId, final Id assetId, final Id oppId, final Boolean doInsert) {

    //     List<Real_Estate_Onboarding__c> reoList = new List<Real_Estate_Onboarding__c>();
    //     for(Integer i = 0; i < recordCount; i++) {
    //         reoList.add(new Real_Estate_Onboarding__c(Account__c = accountId, Asset__c = assetId, Opportunity_Name__c = oppId, 
    //             Data_Migration_Stage__c = 'Kick Off Call', Project_Type__c = 'New Business'));
    //     }

    //     if(doInsert) {
    //         insert reoList;
    //     }

    //     return reoList;
    // }   
    
    /**
     * Creates a list of Assets records.
     *
     * @param recordCount
     *          the number of records to create
     * @param accountId
     *          the account to link each survey to
     * @param contactId
     *          the contact to link each survey to
     * @param doInsert
     *          Indicates whether or not the record(s) should be inserted within this method
     *
     * @return the list of newly created records
     */
    public static List<Survey__c> createSurveyList(final Integer recordCount, final Id accountId, final Id contactId, final Boolean doInsert){
        List<Survey__c> surveyList = new List<Survey__c>();
        for(Integer i = 0; i < recordCount; i++){
            surveyList.add(new Survey__c(Contact__c = contactId, Account__c = accountId));
        }
        
        if(doInsert) {
            insert surveyList;
        }

        return surveyList;
    }

    /*
    * Creates assignment groups needed for round robin testing
    * @params 
    *   groupName - indicates the groupName of the assignment group we are going to create
    *   user - user creating the assignment groups
    *   type - object for the assignment group
    */
    public static void createAssignmentGroups(String groupName, User user, String type){
        createAssignmentGroups(groupName, user, type, null);
    }

    public static void createAssignmentGroups(String groupName, User user, String type, String variableString){
        System.runAs(user){
            Assignment_Group_Name__c assignmentGroup = new Assignment_Group_Name__c(Name = groupName, Type__c = type);
            INSERT(assignmentGroup);
            
            List<Assignment_Groups__c> groupMembers = new List<Assignment_Groups__c>();
            Assignment_Groups__c member1 = new Assignment_Groups__c(Group_Name__c=assignmentGroup.Id, User__c=user.id, Minimum_Units_Managed__c = 0, Active__c = 'True',
                Last_Assignment__c=datetime.now(), AssignmentVariable__c = variableString);
            groupMembers.add(member1);
            Assignment_Groups__c member2 = new Assignment_Groups__c(Group_Name__c=assignmentGroup.Id, User__c=user.id, Minimum_Units_Managed__c = 200, Active__c = 'True', 
                Last_Assignment__c = datetime.Now(), AssignmentVariable__c = variableString);
            groupMembers.add(member2);
            Assignment_Groups__c member3 = new Assignment_Groups__c(Group_Name__c=assignmentGroup.Id, User__c=user.id, Minimum_Units_Managed__c = 900, Active__c = 'True', 
                Last_Assignment__c = datetime.Now(), AssignmentVariable__c = variableString);
            groupMembers.add(member3);
            INSERT(groupMembers);
        }
    }
    /**
    * Creates a user record with the system administrator user profile.
    *
    * @param doInsert
    *       Indicates whether or not the user record should be inserted within this method
    *
    * @return The user record that was created
    */
    public static User createAdminUser(final Boolean doInsert) {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        String rando = generateRandomString(10);
        User u = new User(ProfileId = p.Id, LastName = 'Smith',
                Username = 'testAdminUserName@test' + rando + '.com', Email = 'testAdminUser@test.com', Alias = 'admu',
                TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US');

        if(doInsert) {
            insert u;
        }

        return u;
    }

    /**
    * Creates a user record with a specified user profile.
    *
    * @param profileName
    *       Name of the profile to associate the user to
    * @param doInsert
    *       Indicates whether or not the user record should be inserted within this method
    *
    * @return The user record that was created
    */
    public static User createUser(final String profileName, final Boolean doInsert) {
        Profile p = [SELECT Id FROM Profile WHERE Name = :profileName];
        String rando = generateRandomString(10);
        User u = new User(ProfileId = p.Id, LastName = 'Webb',
                Username = 'testUserName@test' + rando + '.com', Email = 'testUser@test.com', Alias = 'test',
                TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US');

        if(doInsert) {
            insert u;
        }

        return u;
    }

    public static Request__c createRequest(final Boolean doInsert){
        Id userId = Userinfo.getuserid();
        Request__c request = new Request__c(
            Requester__c = userId, 
			Subject__c = 'test Subject',
			Description__c = 'test Description',
			Severity__c = '1 - Systems are not accessible for 2+ users.',
			System_s_Impacted__c = 'Salesforce');
        
        if(doInsert) {
            insert request;
        }
        return request;
    }

    /*
    *   Creates the entitlement records needed for the org.
    */
    public static List<Entitlement> createEntitlements(Id accountId, final Boolean doInsert){
        List<Entitlement> entitlementList = new List<Entitlement>();
        Map<String, Id> processMap = new Map<String, Id>();

        for(SlaProcess p : [SELECT Id, description, name From SlaProcess]){
            processMap.put(p.Name, p.Id);
        }
        
        entitlementList.add(new Entitlement(Name = 'Appfolio Basic', Type = 'Phone Support', AccountId = accountId,
         SlaProcessId = processMap.get('Old Entitlement Process'), StartDate = Date.today().addDays(-100)));
        entitlementList.add(new Entitlement(Name = 'Alaska Repsonse Time', Type = 'Phone Support', AccountId = accountId,
           SlaProcessId = processMap.get('Pacific Entitlement Process'), StartDate = Date.today().addDays(-100)));
        entitlementList.add(new Entitlement(Name = 'Central Response Time', Type = 'Phone Support', AccountId = accountId,
          SlaProcessId = processMap.get('Central Entitlement Process'), StartDate = Date.today().addDays(-100)));
        entitlementList.add(new Entitlement(Name = 'Eastern Response Time', Type = 'Phone Support', AccountId = accountId,
          SlaProcessId = processMap.get('Eastern Entitlement Process'), StartDate = Date.today().addDays(-100)));
        entitlementList.add(new Entitlement(Name = 'Guam Response Time', Type = 'Phone Support', AccountId = accountId,
           SlaProcessId = processMap.get('Pacific Entitlement Process'), StartDate = Date.today().addDays(-100)));
        entitlementList.add(new Entitlement(Name = 'Hawaii Response Time', Type = 'Phone Support', AccountId = accountId,
           SlaProcessId = processMap.get('Pacific Entitlement Process'), StartDate = Date.today().addDays(-100)));
        entitlementList.add(new Entitlement(Name = 'Mountain Response Time', Type = 'Phone Support', AccountId = accountId,
          SlaProcessId = processMap.get('Mountain Process'), StartDate = Date.today().addDays(-100)));
        entitlementList.add(new Entitlement(Name = 'Pacific Response Time', Type = 'Phone Support', AccountId = accountId,
           SlaProcessId = processMap.get('Pacific Entitlement Process'), StartDate = Date.today().addDays(-100)));
        entitlementList.add(new Entitlement(Name = 'Arizona Response Time', Type = 'Phone Support', AccountId = accountId,
          SlaProcessId = processMap.get('Mountain Entitlement Process'), StartDate = Date.today().addDays(-100)));
        entitlementList.add(new Entitlement(Name = 'APM+', Type = 'Phone Support', AccountId = accountId,
          SlaProcessId = processMap.get('APM+ Entitlement'), StartDate = Date.today().addDays(-100)));
        entitlementList.add(new Entitlement(Name = 'MyCase', Type = 'Phone Support', AccountId = accountId,
          SlaProcessId = processMap.get('MyCase Entitlement'), StartDate = Date.today().addDays(-100)));
        entitlementList.add(new Entitlement(Name = 'MyCase Website', Type = 'Phone Support', AccountId = accountId,
          SlaProcessId = processMap.get('MyCase Website'), StartDate = Date.today().addDays(-100)));
        entitlementList.add(new Entitlement(Name = 'APM: Websites', Type = 'Web Support', AccountId = accountId,
          SlaProcessId = processMap.get('Pacific Entitlement Process'), StartDate = Date.today().addDays(-100)));

        if (doInsert){
            INSERT(entitlementList);
        }
        return entitlementList;
    }

    /**
    * Creates Custom setting data.   
    **/
    public static void createCustomSettings(){
        //PAYNEARME SECTION
        // List<PayNearMe_EndPoint__c> pnmList = new List<PayNearMe_EndPoint__c>();
		// PayNearMe_EndPoint__c pnm1 = new PayNearMe_EndPoint__c(Name = 'CreateSettlement', endpoint__c = 'https://www.paynearme-sillyURL.com/json-api/add_settlement_method?');
		// pnmList.add(pnm1);
		// PayNearMe_EndPoint__c pnm2 = new PayNearMe_EndPoint__c(Name = 'CreateSite', endpoint__c = 'https://www.paynearme-sillyURL.com/json-api/add_settlement_method?');
		// pnmList.add(pnm2);
		// PayNearMe_EndPoint__c pnm3 = new PayNearMe_EndPoint__c(Name = 'QuerySite', endpoint__c = 'https://www.paynearme-sillyURL.com/json-api/add_settlement_method?');
		// pnmList.add(pnm3);
		// PayNearMe_EndPoint__c pnm4 = new PayNearMe_EndPoint__c(Name = 'ReplaceSettlement', endpoint__c = 'https://www.paynearme-sillyURL.com/json-api/add_settlement_method?');
		// pnmList.add(pnm4);
		// INSERT(pnmList);
      
        // List<Zuora_Product_Mapping__c> zpmList = new List<Zuora_Product_Mapping__c>();
        // Zuora_Product_Mapping__c zpm1 = new Zuora_Product_Mapping__c(Name='OVE', ProductName__c='Owner Vendor eCheck', ProductRatePlanName__c='Owner Vendor eCheck', 
        //     ProductSKU__c = 'SKU-A-00000001');
        // zpmList.add(zpm1);
        // Zuora_Product_Mapping__c zpm2 = new Zuora_Product_Mapping__c(Name='PremiumLeads', ProductName__c='Premium Leads', ProductRatePlanName__c='Premium Leads', 
        //     ProductSKU__c = 'SKU-A-00000002');
        // zpmList.add(zpm2);
        // Zuora_Product_Mapping__c zpm3 = new Zuora_Product_Mapping__c(Name='MailingService', ProductName__c='Mailing Service', ProductRatePlanName__c='Mailing Service', 
        //     ProductSKU__c = 'SKU-A-00000003');
        // zpmList.add(zpm3);
        // INSERT(zpmList);

        // List<ZuoraPriceList__c> zplList = new List<ZuoraPriceList__c>();
        // ZuoraPriceList__c zpl1 = new ZuoraPriceList__c(Name = 'APM Monthly Minimum Balance', Price__c = 1500);
        // zplList.add(zpl1);
        // ZuoraPriceList__c zpl2 = new ZuoraPriceList__c(Name = 'IM Onboarding Fee Multiplier', Price__c = 4);
        // zplList.add(zpl2);
        // INSERT(zplList);

        // ZuoraRestIntegration__c testRestIntegration = new ZuoraRestIntegration__c (Name='Zuora APM Integration', Active__c=TRUE, Password__c='FakePASSWORD', UserName__c='FAKEUSERNAME', ZuoraEntityId__c='NOENTITYID', ZuoraEntityName__c='NOENTITYNAME', ZuoraRestEndPoint__c='https:\\www.dummyzuora.com');
		// insert testRestIntegration;

        List<User_List_Default__c> defaultUserList = new List<User_List_Default__c>();
        String userId = UserInfo.getUserId();
        User_List_Default__c defaultUser1 = new User_List_Default__c(Name = 'Auto Create Engagement Case User', User_Id__c = userId);
        defaultUserList.add(defaultUser1);
        User_List_Default__c defaultUser2 = new User_List_Default__c(Name = 'Update Implementation Fields Users', User_Id__c = userId);
        defaultUserList.add(defaultUser2);
        User_List_Default__c defaultUser3 = new User_List_Default__c(Name = 'Central/East Assign To', User_Id__c = userId);
        defaultUserList.add(defaultUser3);
        User_List_Default__c defaultUser4 = new User_List_Default__c(Name = 'Not Central/East Assign To', User_Id__c = userId);
        defaultUserList.add(defaultUser4);
        User_List_Default__c defaultUser5 = new User_List_Default__c(Name = 'East/Central Assign To', User_Id__c = userId);
        defaultUserList.add(defaultUser5);
        User_List_Default__c defaultUser6 = new User_List_Default__c(Name = 'Not East/Central Assign To', User_Id__c = userId);
        defaultUserList.add(defaultUser6);
        User_List_Default__c defaultUser7 = new User_List_Default__c(Name = 'ValuePlusPaymentScreeningAssignment', User_Id__c = userId);
        defaultUserList.add(defaultUser7);
        User_List_Default__c defaultUser8 = new User_List_Default__c(Name = 'PM Product Requests Owner', User_Id__c = userId);
        defaultUserList.add(defaultUser8);
        User_List_Default__c defaultUser9 = new User_List_Default__c(Name = 'MyCase Churn Task User', User_Id__c = userId);
        defaultUserList.add(defaultUser9);
        User_List_Default__c defaultUser10 = new User_List_Default__c(Name = 'Early Adoption Task User', User_Id__c = userId);
        defaultUserList.add(defaultUser10);
        User_List_Default__c defaultUser11 = new User_List_Default__c(Name = 'APM+ SU Task Owner', User_Id__c = userId);
        defaultUserList.add(defaultUser11);
        User_List_Default__c defaultUser12 = new User_List_Default__c(Name = 'Screening Engagement Case Owner', User_Id__c = userId);
        defaultUserList.add(defaultUser12);
        INSERT(defaultUserList);

        // ALNAPIKey__c apiKey = new ALNAPIKey__c(Name = 'ALN', apiKey__c = 'testAPIKey');
        // INSERT(apiKey);
    }
    /**
    * Provides a data model for test classes.
    */
    public class DataModel {

        public List<Account> accountList {get; set;}
        public List<Contact> contactList {get; set;}
        public List<ValuePlus__c> valuePlusList {get; set;}
        public List<Database__c> databaseList {get; set;}
        public List<Case> caseList {get; set;}
        public List<Opportunity> opportunityList {get; set;}
        public List<Lead> leadList {get; set;}
        public List<Bank_Account__c> bankAccountList {get; set;}
        public List<Metrics__c> metricsList {get; set;}
        public List<Product2> productList {get; set;}
        // public List<zqu__ZProduct__c> zProductList {get; set;}
        // public List<zqu__ProductRatePlan__c> productRatePlanList {get; set;}
        // public List<zqu__ProductRatePlanCharge__c> productRatePlanChargeList {get; set;}
        // public List<zqu__Quote__c> quoteList {get; set;}
        // public List<Zuora__Subscription__c> subscriptionList {get; set;}
        // public List<Zuora__SubscriptionProductCharge__c> subscriptionProductChargeList{get; set;}
        public List<EmailMessage> emailMessageList {get; set;}
        public List<Task> taskList {get; set;}         
        public List<Asset> assetList {get; set;}         
        public List<Entitlement> entitlementList {get; set;}
        // public List<Real_Estate_Onboarding__c> reoList {get; set;}
        public List<Survey__c> surveyList {get; set;}
        /**
        * Default constructor.
        */
        public DataModel() {
        }

        /**
        * Constructs a data model and fills its fields in.
        *
        * @param recordCount
        *          represents the number of records to create for each list of SObjects
        * @param doInsertAll
        *          Indicates whether or not the record(s) should be inserted
        */
        public DataModel(final Integer recordCount, final Boolean doInsertAll) {

            this.accountList = TestDataFactory.createAccountList(recordCount, doInsertAll);
            this.entitlementList = TestDataFactory.createEntitlements(accountList.get(0).Id, doInsertAll);
            this.assetList =  TestDataFactory.createAssetList(recordCount, accountList.get(0).Id, doInsertAll);
            this.contactList = TestDataFactory.createContactList(recordCount, accountList.get(0).Id, doInsertAll);
            this.valuePlusList = TestDataFactory.createValuePlusList(recordCount, accountList.get(0).Id, doInsertAll);
            this.databaseList = TestDataFactory.createDatabaseList(recordCount, accountList.get(0).Id, assetList.get(0).Id, doInsertAll);
            this.caseList = TestDataFactory.createCaseList(recordCount, accountList.get(0).Id, doInsertAll);
            this.opportunityList = TestDataFactory.createOpportunityList(recordCount, accountList.get(0).Id, doInsertAll);
            this.leadList = TestDataFactory.createLeadList(recordCount, doInsertAll);
            this.bankAccountList = TestDataFactory.createBankAccountList(recordCount, valuePlusList.get(0).Id, doInsertAll);
            this.metricsList = TestDataFactory.createMetricsList(recordCount, accountList.get(0).Id, doInsertAll);
            this.productList = TestDataFactory.createProductList(recordCount, doInsertAll);
            // this.zProductList = TestDataFactory.createZProductList(recordCount, doInsertAll);
            // this.productRatePlanList = TestDataFactory.createProductRatePlanList(recordCount, zProductList.get(0).Id, doInsertAll);
            // this.productRatePlanChargeList = TestDataFactory.createProductRatePlanChargeList(recordCount, doInsertAll);
            // this.quoteList = TestDataFactory.createQuoteList(recordCount, contactList.get(0).Id, doInsertAll);
            // this.subscriptionList = TestDataFactory.createSubscriptionList(recordCount, doInsertAll);
            // this.subscriptionProductChargeList = TestDataFactory.createSubscriptionProductChargeList(recordCount, subscriptionList.get(0).Id, doInsertAll);
            this.emailMessageList = TestDataFactory.createEmailMessageList(recordCount, caseList.get(0).Id, doInsertAll);
            this.taskList =  TestDataFactory.createTaskList(recordCount, doInsertAll);
            // this.reoList = TestDataFactory.createREOList(recordCount, accountList.get(0).Id, assetList.get(0).Id, opportunityList.get(0).Id, doInsertAll);
            this.surveyList = TestDataFactory.createSurveyList(recordCount, accountList.get(0).Id, contactList.get(0).Id, doInsertAll);
        }
    }

    //needed for for creating users
    public static String generateRandomString(Integer len){
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < len) {
        Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
        randStr += chars.substring(idx, idx+1);
        }
        return randStr; 
    }
}