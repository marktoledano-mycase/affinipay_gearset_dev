@isTest
public class ValuePlusTriggerMethodHandlerTest {
    
    @testSetup
    static void testSetup(){
        TestDataFactory.createCustomSettings();
        List<Account> accounts = createAccount(62, true);

    }

    public static List<Opportunity> createOpportunity(List<Account> accounts, Boolean doInsert){
        List<Opportunity> opps = new List<Opportunity>();

        for(Account account : accounts){
            opps.add(new Opportunity(Name = 'opp ' + account.Name, AccountId = account.Id, StageName = 'Demo', CloseDate = Date.today().addDays(50)));
        }

        if(doInsert){
             //just create the opps, don't need to run account trigger
            TriggerHandler.runBeforeInsert = false;
            TriggerHandler.runAfterInsert = false;
            insert opps;
        }

        return opps;
    }

    public static void createOnBoardingSpecialist(){
        User_List_Default__c onBoardingSpecialist = new User_List_Default__c(name = 'ValuePlusPaymentScreeningAssignment', user_id__c = UserInfo.getUserId());
        insert onBoardingSpecialist;
    }
    public static List<Contact> createContacts(Integer num, Boolean doInsert){
        List<Contact> contacts = new List<Contact>();
        for(Integer i = 0; i < num; i++){
            contacts.add(new Contact(LastName = 'lname' + i));
        }
        if(doInsert){
            insert contacts;
        }
        return contacts;
    }

    public static List<Account> createAccount(Integer num, Boolean doInsert){
        List<Account> accounts = TestDataFactory.createAccountList(num, false);
        for(Integer i = 0; i < num; i++){
            accounts[i].name = 'VP Test # ' + i;
        }

        if(doInsert){
                    //just create the accounts, don't need to run account trigger
            insert accounts;
        }
        return accounts;
    }



    public static List<ValuePlus__c> createValuePlus(Integer num, Boolean doInsert ){
        List<Account> accounts = [SELECT id FROM Account];

        List<ValuePlus__c> vpList = new List<ValuePlus__c>();
        for(Integer i = 0; i < num; i++){
                 vpList.add(new ValuePlus__c(Account__c = accounts[i].Id, Stage__c='Ready to Transmit to Giact'));
        }

        if(doInsert){
            insert vpList;

        }

        return vpList;
    }



    static testMethod void testBeforeInsert(){
        List<ValuePlus__c> vpList = createValuePlus(55, false);

        test.startTest();
        insert vpList;
        test.stopTest();

    }


    static testMethod void testBeforeUpdate(){
        List<ValuePlus__c> vpList = createValuePlus(62, false);

        //minor stage setup for some cases
        for(Integer i = 0;  i < 10; i++){
            vpList[i].Stage__c = i < 5 ? 'Deferred' : 'Lost';
        }

        insert vpList;

        for(Integer i = 0; i < 5; i++){
            vpList[i].Stage__c = 'Sold/Not Started';
            vpList[i].TIN_Match__c ='Ready To Transmit';

        }

        test.startTest();
        update vpList;
        test.stopTest();
       
    }
    
   
  
    private static List<ValuePlus__c> createData(String type){    
        TestDataFactory.DataModel dm = new TestDataFactory.DataModel(1, false);
        
        INSERT(dm.accountList);

        for(Asset ast : dm.assetList){
            ast.AccountId = dm.accountList[0].Id;
        }
        INSERT(dm.assetList);

        INSERT(dm.valueplusList);

        return dm.valueplusList;
    }

    private static testMethod void testException1(){
        Test.startTest();
        ValuePlusTriggerMethodHandler handler = new ValuePlusTriggerMethodHandler();
     
        Test.stopTest();
    }

  
}