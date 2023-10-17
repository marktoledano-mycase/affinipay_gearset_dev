/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This is the controller class for different VF pages used for creating alerts for various objects.
* 
* @test           CustomerAlertsTest
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Rohit Malik
* @version        1.0
* @created        2016-02-23
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* v1.1            vijay.reddy@appfolio.com
* 2020-02-11      Updated the account alerts to include the Plus Client alert and added a new 
*                 method (getAlertsforAsset) for Asset alerts - R2023876
*
* v1.2            ryan.kleinberg@appfolio.com
* 2020-21-04      Adding 2 new alert banner types: Key Account and RPM - R2026370
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
public class CustomerAlerts {
    
    public  List<String> warningMessages{get; set;}
    public Boolean isMyCaseRecord {get; set;}
    public String fraudMsg {get; set;}
    public String plusClientMsg {get; set;}
    public static Id myCaseCustomerRTId = InformationStrings.accountCustomerId;
    public static List<Asset> plusAssets;
    
    
    public CustomerAlerts(ApexPages.StandardController controller)
    {
        String type = controller.getRecord().getSObjectType().getDescribe().getName();
                
        if('Account'.equalsIgnoreCase(type))
        {
            getAlertsforAccount((Account) controller.getRecord());
        }
        else if('ValuePlus__c'.equalsIgnoreCase(type))
        {
            getAlertsforValuePlus((ValuePlus__c) controller.getRecord());
        }
        else if('Case'.equalsIgnoreCase(type))
        {
            getAlertsforCase((Case) controller.getRecord());
        }
        else if('Opportunity'.equalsIgnoreCase(type))
        {
            getAlertsforOpportunity((Opportunity) controller.getRecord());
        }
        else if('Asset'.equalsIgnoreCase(type))
        {
            getAlertsforAsset((Asset) controller.getRecord());
        }
    }
    
    public void getAlertsforAccount(Account acc)
    {
        warningMessages = new List<String>();
        isMyCaseRecord = false;

        try{
            //Check if the RecordType of the Account is related to MyCase (Customer)
            if(acc.RecordTypeId == myCaseCustomerRTId){
                // isMyCaseRecord = true;
            }

            if(!isMyCaseRecord) {

                List<Case> cases = [select RecordType.Name, Reason, Case_Sub_Reason__c, Priority, Owner.Name
                                    from Case
                                    where AccountId = :acc.Id and recordType.Name = 'Risk' and (not Status like 'Closed%')
                                    order by CreatedDate DESC];

                for (Case c : cases) {
                    warningMessages.clear();
                    if ('Request to Cancel'.equalsIgnoreCase(c.Priority)) {
                        warningMessages.add(getRTCMessage(c.Id));
                        break;
                    }
                    warningMessages.add(getOpenCaseMessage(c.Id));
                }

                Account currAcc = [Select name, RPM__c, (Select Id, Dedicated_Success_Manager__c, Dedicated_Success_Manager__r.Name, Strategic_Relationship_Manager__c, 
                                    // Strategic_Relationship_Manager__r.Name, Key_Account__c, status, Customer_APM_Version__c from Assets where RecordTypeId = :InformationStrings.assetPropertyManagementId) 
                                    Strategic_Relationship_Manager__r.Name, Key_Account__c, status, Customer_APM_Version__c from Assets) 
                                    from Account where Id = :acc.Id];


                if(currAcc.RPM__c){
                    plusClientMsg = 'RPM Client: All Sales and V+ engagements should be coordinated through ' + System.Label.RPMClientCoordinator;
                }

                if(!currAcc.Assets.isEmpty()){
                    plusAssets = new List<Asset>();

                    for(Asset ast : currAcc.Assets){

                        
                        if(ast.Status == 'Customer' && ast.Customer_APM_Version__c == 'APM+' && (ast.Dedicated_Success_Manager__c != null || ast.Strategic_Relationship_Manager__c != null)){
                            plusAssets.add(ast);
                        }else{
                            //Check for key_Account or RPM Assets to mark banner
                            if(ast.Key_Account__c){
                                plusClientMsg = 'Key Account Client: All engagements must be coordinated through ';
                                if(ast.Dedicated_Success_Manager__r.Name != null){
                                    plusClientMsg += ast.Dedicated_Success_Manager__r.Name;
                                }else{
                                    plusClientMsg += 'the Dedicated Success Manager';
                                }
                            }
                        }


                    }
                    
                    //Check for APM+ assets, if there are they should over-write the KA,RPM message
                    if(!plusAssets.isEmpty()){
                        plusClientMsg = 'PLUS Client: All engagements MUST be coordinated through ';

                        if(currAcc.Assets[0].Dedicated_Success_Manager__c != null){
                            plusClientMsg += currAcc.Assets[0].Dedicated_Success_Manager__r.Name;
    
                            if(currAcc.Assets[0].Strategic_Relationship_Manager__c != null){
                                plusClientMsg += ' and ' + currAcc.Assets[0].Strategic_Relationship_Manager__r.Name;
                            }
                        } else {
                            plusClientMsg += currAcc.Assets[0].Strategic_Relationship_Manager__r.Name;
                        }
    
                        plusClientMsg += '. Please & Thank you!';
                    }
                }
            }
        } catch(Exception exp) {
            SystemExceptionLogger.insertSystemExceptionLogEntry(exp, 'CustomerAlerts', 'Alerts for Account',
                    SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, exp.getMessage(), false);
        }
    }
    
    public void getAlertsforValuePlus(ValuePlus__c vPlus)
    {
        warningMessages = new List<String>();
        isMyCaseRecord = false;

        try {
            //Check if the RecordType of the related Account record is related to MyCase
            if (vPlus.Account__r.RecordTypeId == myCaseCustomerRTId) {
                isMyCaseRecord = true;
            }

            if (!isMyCaseRecord) {

                List<Case> cases = [
                        select RecordType.Name, Reason, Case_Sub_Reason__c, Priority, Owner.Name
                        from Case
                        where AccountId = :vPlus.Account__c and recordType.Name = 'Risk' and (not Status like 'Closed%')
                        order by CreatedDate DESC
                ];

                for (Case c : cases) {
                    warningMessages.clear();
                    if ('Request to Cancel'.equalsIgnoreCase(c.Priority)) {
                        warningMessages.add(getRTCMessage(c.Id));
                        break;
                    }
                    warningMessages.add(getOpenCaseMessage(c.Id));
                }
            }

            for(GIdentifyEntityInformation__c entityInfo : [Select Id, name, GIACTIdentifyResponse__r.name, GIACTIdentifyResponse__r.ValuePlus__r.Fraud_Review_Approved__c from 
                GIdentifyEntityInformation__c where Fraud_Activity_Found__c = true and GIACTIdentifyResponse__r.ValuePlus__c = :vPlus.Id]){
                
                if (entityInfo.GIACTIdentifyResponse__r.ValuePlus__r.Fraud_Review_Approved__c==false){
                    if(String.isEmpty(fraudMsg)){
                        fraudMsg = 'This record has been marked for fraud activity in GIACT response ' + 
                        entityInfo.GIACTIdentifyResponse__r.name + ' for ' + entityInfo.name;
                    } else{
                        fraudMsg += ', and in ' + entityInfo.GIACTIdentifyResponse__r.name + ' for ' + entityInfo.name;
                    }
                }     
            }

            if(!String.isEmpty(fraudMsg)){
                fraudMsg += '. Please contact paymentsonboarding@appfolio.com for more information.';
            }

        } catch(Exception exp) {
            SystemExceptionLogger.insertSystemExceptionLogEntry(exp, 'CustomerAlerts', 'Alerts for ValuePlus',
                    SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, exp.getMessage(), false);
        }
    }
    
    public void getAlertsforCase(Case ca)
    {
        warningMessages = new List<String>();
        isMyCaseRecord = false;

        try {
            //Check if the RecordType of the related Account record is related to MyCase
            if (ca.Account.RecordTypeId == myCaseCustomerRTId || ca.AccountId == null) {
                isMyCaseRecord = true;
            }

            if (!isMyCaseRecord) {

                List<Case> cases = [
                        select RecordType.Name, Reason, Case_Sub_Reason__c, Priority, Owner.Name
                        from Case
                        where AccountId = :ca.AccountId and recordType.Name = 'Risk' and (not Status like 'Closed%')
                        order by CreatedDate DESC
                ];

                for (Case c : cases) {
                    warningMessages.clear();
                    if ('Request to Cancel'.equalsIgnoreCase(c.Priority)) {
                        warningMessages.add(getRTCMessage(c.Id));
                        break;
                    }
                    warningMessages.add(getOpenCaseMessage(c.Id));
                }
            }
        } catch(Exception exp) {
            SystemExceptionLogger.insertSystemExceptionLogEntry(exp, 'CustomerAlerts', 'Alerts for Case',
                    SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, exp.getMessage(), false);
        }
    }

    public void getAlertsforOpportunity(Opportunity opp){
        isMyCaseRecord = false;

        try {
            //Check if the RecordType of the related Account record is related to MyCase
            if (opp.Account.RecordTypeId == myCaseCustomerRTId) {
                isMyCaseRecord = true;
            }
        } catch(Exception exp) {
            SystemExceptionLogger.insertSystemExceptionLogEntry(exp, 'CustomerAlerts', 'Alerts for Opportunity',
                    SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, exp.getMessage(), false);
        }
    }

    public void getAlertsforAsset(Asset ast){

        try{
            // if(ast.RecordTypeId == InformationStrings.assetPropertyManagementId){
                // Asset currAst = [Select Id, Dedicated_Success_Manager__c, Dedicated_Success_Manager__r.Name, Strategic_Relationship_Manager__c, 
                //                 Strategic_Relationship_Manager__r.Name, Status, Customer_APM_Version__c from Asset where Id = :ast.Id];
                
                // if(currAst.Status == 'Customer' && currAst.Customer_APM_Version__c == 'APM+' && (currAst.Dedicated_Success_Manager__c != null || currAst.Strategic_Relationship_Manager__c != null)){
                //     plusClientMsg = 'PLUS Client: All engagements MUST be coordinated through ';

                //     if(currAst.Dedicated_Success_Manager__c != null){
                //         plusClientMsg += currAst.Dedicated_Success_Manager__r.Name;

                //         if(currAst.Strategic_Relationship_Manager__c != null){
                //             plusClientMsg += ' and ' + currAst.Strategic_Relationship_Manager__r.Name;
                //         }
                //     } else {
                //         plusClientMsg += currAst.Strategic_Relationship_Manager__r.Name;
                //     }

                //     plusClientMsg += '. Please & Thank you!';
                // }
            // }
        } catch(Exception exp){
            SystemExceptionLogger.insertSystemExceptionLogEntry(exp, 'CustomerAlerts', 'Alerts for Asset',
                    SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, exp.getMessage(), false);
        }
    }
    
    private string getOpenCaseMessage(Id id)
    {
        return 'Customer has an open risk case, contact <a href="/'+id +'" target="_blank">case</a> owner for details.';
    }
    private string getRTCMessage(Id id)
    {
        return 'Customer has requested to cancel.  Please contact <a href="/'+id +'" target="_blank">case</a> owner before contacting customer.';
    }

}