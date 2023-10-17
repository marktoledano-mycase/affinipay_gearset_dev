/******************************************************************************************************
* copyright © 2015
*
* File      : ProfitStarsRequestBuilder.cls
*
* Purpose   : This class builds the request to profit stars based on the request type and configurations 
*
* Referred from     : ProfitStarsIntegrationService.cls
*
* Test Classes: ProfitStarsRequestBuilderTest
                PS_OutboundBankAccountUpdatesTest
*               ProfitStarsRequestValidation_Tests
*               PS_BatchBankAccountUpdatesTest
*               ps_buttonMethodsTest
*               PS_BatchFieldUpdatesTest
*               PS_BatchFieldUpdatesForOutboundTest
*               ps_eCheckButtonMethodsTest
*-----------------------------------------------------------------------------
*
*Release Date       Request     Updated By          Description
*----------------------------------------------------------------------------------------------------------------------
*06/24/2015          Nill                            Initial Creation
*
*07/21/2015          R151866     Venkat Araveeti     MyCase Integration
*08/15/2015          R152280     Venkat Araveeti     Updated the request builder to velocity request for one LID
*09/29/2015          R152543     Venkat Araveeti     Updated other call type to send dynamic subject, description
*******************************************************************************************************/
public with sharing class ProfitStarsRequestBuilder{

    public class ProfitStarsRequestBuilderException extends Exception{}
    /**
     * Generates the object and json needed to make a valid call.
     * @param  id     RecordId
     * @return        ConsoleContent object to be json serialized.
     */
    public static ProfitStarsRequest createEnrollmentRequestFromActionAndRecordId(Id id, String product){
        Map<String, sObject> requiredFields = ProfitStarsUtils.getRequiredFieldsForCall('enrollment');
        ValuePlus__c record = getRecord(id, requiredFields, 'enrollment', product); //request #R151866 Updated to retrieve recordtype from record
        ProfitStarsRequestValidation.validate(record, requiredFields, 'enrollment', product);
        system.debug('requiredFields: ' + requiredFields);
        system.debug('Record: ' + record);

        // Block handles hardcoded values, indexed key fields and
        ProfitStarsRequest bodyObj = new ProfitStarsRequest();
        
        ProfitStarsIntegrationService.recordType = record.recordType.Name; //request #R151866 created to pass the record type to service class
        
        //Check to see if we want 1 day processing on the value+
        if(record.Payment_Processing_Days__c == '0 Days'){
            ProfitStarsIntegrationService.oneDayProcessing = true;
        }
        
        for(String fsm : requiredFields.keyset()){
            sObject x = requiredFields.get(fsm);
            
            String hardcodedValue = (String)x.get('Hardcoded_Value__c');
            String fieldPath = (String) x.get('Field_Path__c');
            String objName = fsm.substringBefore(':');
            String fieldName = fsm.substringAfter(':');
            System.debug('Field Name: ' + fsm);


            if(objName == 'Account'){
                if(fieldName.equalsIgnoreCase('custServProviderId') || fieldName.equalsIgnoreCase('RequestEmail') || fieldName.equalsIgnoreCase('ClassificationCode')){
                    continue;
                }

                if(fieldName.equalsIgnoreCase('WebsiteURL')){
                    String webUrl = ProfitStarsUtils.extractRelatedField(fieldPath, record, product);

                    if(!String.isEmpty(webUrl)){
                        bodyObj.APIIntegration.Account.put(fieldName, ProfitStarsUtils.profitStarsFormat(fieldName, webUrl));
                    } else{
                        bodyObj.APIIntegration.Account.put(fieldName, 'NA');
                    }
                    continue;
                }

                if(!String.isEmpty(hardcodedValue)){
                    bodyObj.APIIntegration.Account.put(fieldName, ProfitStarsUtils.profitStarsFormat(fieldName, hardcodedValue));
                }
                else if(!String.isEmpty(fieldPath)){
                    bodyObj.APIIntegration.Account.put(fieldName, ProfitStarsUtils.profitStarsFormat(fieldName, ProfitStarsUtils.extractRelatedField(fieldPath, record, product)));
                }
            }else if(objName == 'Cont'){
                String innerObjName = fieldName.substringBefore(':');
                String innerObjFieldName = fieldName.substringAfter(':');
                String fieldValue = '';
                String innerObjAPIName;

                if(!String.isEmpty(hardcodedValue)){
                    fieldValue = ProfitStarsUtils.profitStarsFormat(innerObjFieldName, hardcodedValue);
                }
                else if(!String.isEmpty(fieldPath)){
                    fieldValue = ProfitStarsUtils.profitStarsFormat(innerObjFieldName, ProfitStarsUtils.extractRelatedField(fieldPath, record, product));
                    System.debug('fieldValue: ' + fieldValue);
                }

                switch on innerObjName{
                    when 'PC'{
                        innerObjAPIName = 'PrimaryContact';
                    }
                    when 'SC'{
                        innerObjAPIName = 'SecondaryContact';
                    }
                    when 'PO'{
                        innerObjAPIName = 'PrimaryOfficer';
                    }
                    when 'SO'{
                        innerObjAPIName = 'SecondaryOfficer';
                    }
                    when 'TO'{
                        innerObjAPIName = 'TertiaryOfficer';
                    }
                    when 'QO'{
                        innerObjAPIName = 'QuaternaryOfficer';
                    }
                }

                if(!String.isEmpty(innerObjAPIName)){
                    if(bodyObj.APIIntegration.Contacts.get(innerObjAPIName) == null){
                        bodyObj.APIIntegration.Contacts.put(innerObjAPIName, new Map<String, String>{innerObjFieldName => fieldValue});
                    }else{
                        bodyObj.APIIntegration.Contacts.get(innerObjAPIName).put(innerObjFieldName, fieldValue);
                    }
                }
            }else if(objName == 'Opty'){
                if(fieldName.equalsIgnoreCase('RecordType') || (fieldName.containsIgnoreCase('merchcredit') && product == null) 
                    || (fieldName.containsIgnoreCase('merchdebit') && product != null && product == 'echeck')){
                    continue;
                }
                
                
                if(!String.isEmpty(hardcodedValue)){
                    bodyObj.APIIntegration.Opportunity.put(fieldName, ProfitStarsUtils.profitStarsFormat(fieldName, hardcodedValue));
                }else if(!String.isEmpty(fieldPath)){
                    bodyObj.APIIntegration.Opportunity.put(fieldName, ProfitStarsUtils.profitStarsFormat(fieldName, ProfitStarsUtils.extractRelatedField(fieldPath, record, product)));
                }
            }
        }

        Map<String, String> loc;
        for(Bank_Account__c ba : record.Bank_Accounts__r){
            loc = new Map<String, String>();
            String accType = (ba.Account_Type__c != null && ba.Account_Type__c == '0') ? '0~Checking' : '1~Savings';
            loc.put('BankName', ba.Account_Label__c);
            loc.put('RoutingNumber', ba.RoutingNo__c);
            loc.put('AccountNumber', ba.AccountNo__c);
            loc.put('AccountType', accType);
            bodyObj.APIIntegration.CustomerLocations.Location.add(loc);
        }
        
        return bodyObj;
    }

    //A Bank Request is used to update a bank account for an existing merchant.
    //A Location Request is used to add a location for an existing merchant with velocity set at the merchant level.
    //A Velocity Request will update velocity for an existing merchant and location.
    public static Map<String, String> createBankLocationVelocityReqFromActionAndRecordId(String action, Id id, Id bankId, String product){
        Map<String, sObject> requiredFields = ProfitStarsUtils.getRequiredFieldsForCall(action);

        ValuePlus__c record = getRecord(id, requiredFields, action, product);
        System.debug('the result record is '+ record);
        ProfitStarsRequestValidation.validate(record, requiredFields, action, product);
        ProfitStarsIntegrationService.recordType = record.recordType.Name;

        Bank_Account__c bankAccRecord;
        if(action.toLowerCase() == 'location' && bankId != null){
            for(Bank_Account__c ba : record.getSobjects('Bank_Accounts__r')){
                if(ba.Id == bankId){
                    bankAccRecord = ba;
                    break;
                }
            }
        } else{
            for(Bank_Account__c ba : record.getSobjects('Bank_Accounts__r')){
                if(product == null && !String.isEmpty(ba.LID__c)){
                    bankAccRecord = ba;
                    break;
                } else if(product != null && product == 'echeck' && !String.isEmpty(ba.Outbound_LID__c)){
                    bankAccRecord = ba;
                    break;
                }
            }
        }

        Map<String, String> bodyMap = new Map<String, String>();

        for(String fsm : requiredFields.keyset()){
            sObject x = requiredFields.get(fsm);
            String hardcodedValue = (String) x.get('Hardcoded_Value__c');
            String fieldPath = (String) x.get('Field_Path__c');
            Boolean isSub = (Boolean) x.get('Part_of_a_Subquery__c');
            System.debug('Field Name: ' + fsm);

            if(fsm.equalsIgnoreCase('custServProviderId') || fsm.equalsIgnoreCase('request_email')){
                continue;
            }

            if(!String.isEmpty(hardcodedValue)){
                bodyMap.put(fsm, ProfitStarsUtils.profitStarsFormat(fsm, hardcodedValue));
            } else if(isSub != null && isSub) {
                String fp = (String) x.get('Field_Path__c');
                String[] parts = fp.split('\\.', 2);
                if(bankAccRecord != null){
                    bodyMap.put(fsm, ProfitStarsUtils.profitStarsFormat(fsm, ProfitStarsUtils.extractRelatedField(parts[1], bankAccRecord, product)));
                } /*else{
                    bodyMap.put(fsm, ProfitStarsUtils.profitStarsFormat(fsm, ProfitStarsUtils.extractRelatedField(parts[1], record.getSobjects('Bank_Accounts__r')[0], product)));
                }*/
            } else if(!String.isEmpty(fieldPath)){
                bodyMap.put(fsm, ProfitStarsUtils.profitStarsFormat(fsm, ProfitStarsUtils.extractRelatedField(fieldPath, record, product)));
            }
        }

        return bodyMap;
    }

    //create multiple requests for multiple bank accounts, location requests
    public static Map<Id, Map<String, String>> createMultipleMaintenanceReqFromActionAndRecordId(String action, Id id, String product){
        Map<String, sObject> requiredFields = ProfitStarsUtils.getRequiredFieldsForCall(action);

        ValuePlus__c record = getRecord(id, requiredFields, action, product);
        System.debug('the result record is '+ record);
        ProfitStarsRequestValidation.validate(record, requiredFields, action, product);
        ProfitStarsIntegrationService.recordType = record.recordType.Name;
        //List<Map<String, String>> requests = new List<Map<String, String>>();
        Map<Id, Map<String, String>> bankIdToReqMap = new Map<Id, Map<String, String>>();

        for(Bank_Account__c ba : record.getSobjects('Bank_Accounts__r')){
            Map<String, String> bodyMap = new Map<String, String>();

            if(action != 'velocity' && product != 'echeck'){
                if((ba.ps_BankAccountUpdateRequired__c == false && ba.ps_LocationUpdateRequired__c == false) || ba.Ready_for_push_to_ProfitStars__c == false){
                    continue;
                }
            }

            if(action == 'bank account' && product != 'echeck' && (ba.LID__c == null || ba.Ready_for_push_to_ProfitStars__c == false || ba.ps_BankAccountUpdateRequired__c == false)){
                continue;
            }

            if(action == 'bank account' && product == 'echeck' && ba.Outbound_Location_Update_Status__c != 'Ready To Update'){
                continue;
            }

            if(action == 'location' && ba.LID__c != null){
                continue;
            }

            for(String fsm : requiredFields.keyset()){
                sObject x = requiredFields.get(fsm);
                String hardcodedValue = (String) x.get('Hardcoded_Value__c');
                String fieldPath = (String) x.get('Field_Path__c');
                Boolean isSub = (Boolean) x.get('Part_of_a_Subquery__c');
                System.debug('Field Name: ' + fsm);

                if(fsm.equalsIgnoreCase('custServProviderId') || fsm.equalsIgnoreCase('request_email')){
                    continue;
                }

                if(!String.isEmpty(hardcodedValue)){
                    bodyMap.put(fsm, ProfitStarsUtils.profitStarsFormat(fsm, hardcodedValue));
                } else if(isSub != null && isSub) {
                    String fp = (String) x.get('Field_Path__c');
                    String[] parts = fp.split('\\.', 2);
                    bodyMap.put(fsm, ProfitStarsUtils.profitStarsFormat(fsm, ProfitStarsUtils.extractRelatedField(parts[1], ba, product)));
                } else if(!String.isEmpty(fieldPath)){
                    bodyMap.put(fsm, ProfitStarsUtils.profitStarsFormat(fsm, ProfitStarsUtils.extractRelatedField(fieldPath, record, product)));
                }
            }
            //requests.add(bodyMap);
            bankIdToReqMap.put(ba.Id, bodyMap);
        }

        //return requests;
        return bankIdToReqMap;
    }

    // An Other Request is used as a custom request to update an address, phone number, or any 
    // information other than a velocity, location, or bank account for an existing merchant.
    public static Map<String, String> createMaintOtherReqFromActionAndRecordId(String action, Id id, String product){
        Map<String, sObject> requiredFields = ProfitStarsUtils.getRequiredFieldsForCall(action);

        ValuePlus__c record = getRecord(id, requiredFields, action, product);
        System.debug('the result record is '+ record);
        ProfitStarsRequestValidation.validate(record, requiredFields, action, product);
        ProfitStarsIntegrationService.recordType = record.recordType.Name;

        Map<String, String> bodyMap = new Map<String, String>();

        if(action.toLowerCase() == 'ownership update'){
            String description = buildDescriptionForOwnership(record, product);
            bodyMap.put('description', description);
        }

        for(String fsm : requiredFields.keyset()){
            sObject x = requiredFields.get(fsm);
            String hardcodedValue = (String) x.get('Hardcoded_Value__c');
            String fieldPath = (String) x.get('Field_Path__c');
            System.debug('Field Name: ' + fsm);

            if(fsm.equalsIgnoreCase('FederalTaxID') || fsm.containsIgnoreCase('Owner') || (action.toLowerCase() == 'ownership update' && fsm.equalsIgnoreCase('description'))){
                continue;
            }

            if(!String.isEmpty(hardcodedValue)){
                bodyMap.put(fsm, ProfitStarsUtils.profitStarsFormat(fsm, hardcodedValue));
            } else if(!String.isEmpty(fieldPath)){
                String fieldValue = ProfitStarsUtils.profitStarsFormat(fsm, ProfitStarsUtils.extractRelatedField(fieldPath, record, product));
                if(fieldValue.equalsIgnoreCase('Account__r.Tax_ID__c')){
                    bodyMap.put(fsm, fieldValue + ': ' + ProfitStarsUtils.profitStarsFormat(fsm, ProfitStarsUtils.extractRelatedField('Account__r.Tax_ID__c', record, product)));
                } else if(fieldValue.equalsIgnoreCase('Account_DBA_Name__c')){
                    bodyMap.put(fsm, fieldValue + ': ' + ProfitStarsUtils.profitStarsFormat(fsm, ProfitStarsUtils.extractRelatedField('Account_DBA_Name__c', record, product)));
                } else{
                    bodyMap.put(fsm, fieldValue);
                }
            }
        }

        bodyMap.put('case_reason', action);

        return bodyMap;
    }

    private static String buildDescriptionForOwnership(ValuePlus__c vPlus, String product){
        String description = 'Ownership update:';

        description += addOwnerDetails('1', vPlus, product);

        if(vPlus.SecondaryCondition1__c){
            description += ', ' + addOwnerDetails('2', vPlus, product);
        }

        if(vPlus.TertiaryCondition1__c){
            description += ', ' + addOwnerDetails('3', vPlus, product);
        }

        if(vPlus.QuaternaryCondition1__c){
            description += ', ' + addOwnerDetails('4', vPlus, product);
        }

        return description;
    }

    private static String addOwnerDetails(String ownerNumber, ValuePlus__c vPlusRec, String product){
        String details = ' Owner ' + ownerNumber + ': ';
        details += 'Name = ' + ProfitStarsUtils.extractRelatedField('Account__r.Principal_' + ownerNumber + '_Name__c', vPlusRec, product) + 
            ', Address = ' + ProfitStarsUtils.extractRelatedField('Account__r.Principal_' + ownerNumber + '_Street__c', vPlusRec, product) + 
            ', ' + ProfitStarsUtils.extractRelatedField('Account__r.Principal_' + ownerNumber + '_City__c', vPlusRec, product) + 
            ', ' + ProfitStarsUtils.extractRelatedField('Account__r.Principal_' + ownerNumber + '_State__c', vPlusRec, product) +
            ' ' + ProfitStarsUtils.extractRelatedField('Account__r.Principal_' + ownerNumber + '_Zip__c', vPlusRec, product) + 
            ', SSN = ' + ProfitStarsUtils.profitStarsFormat('officerssn', ProfitStarsUtils.extractRelatedField('Account__r.Principal_' + ownerNumber + '_SSN__c', vPlusRec, product)) + 
            ', DOB = ' + ProfitStarsUtils.profitStarsFormat('dob', ProfitStarsUtils.extractRelatedField('Account__r.Principal_' + ownerNumber + '_DOB__c', vPlusRec, product)) + 
            ', Ownership Percent = ' + ProfitStarsUtils.extractRelatedField('Account__r.Principal_' + ownerNumber + '_Ownership__c', vPlusRec, product);

        return details;
    }

    //This request is specifically for adding a 'Return-Only' Bank Account to ProfitStars
    public static Map<String, String> createReturnOnlyBankReqFromActionAndRecordId(String action, Id id, String product){

        Bank_Account__c record = [select Id, ValuePlus__c, Account_Label__c, ValuePlus__r.ProfitStars_Merchant_ID__c, ValuePlus__r.recordType.Name, ValuePlus__r.Account_DBA_Name__c, 
                                    Return_Account_Number__c, Return_Routing_Number__c, LID__c  
                                    from Bank_Account__c where Id = : id LIMIT 1];

        ProfitStarsIntegrationService.recordType = record.ValuePlus__r.recordType.Name;
        String subject = 'ADD Return-Only Account';
        String description = subject + ': location_id = ' + record.LID__c + ', location_name = ' + record.Account_Label__c;
        description += ', routing_number = ' + record.Return_Routing_Number__c + ', account_number = ' + record.Return_Account_Number__c + ', account_type = checking';

        Map<String, String> bodyMap = new Map<String, String>();

        bodyMap.put('entity_id', record.ValuePlus__r.ProfitStars_Merchant_ID__c);
        bodyMap.put('customer_name', record.ValuePlus__r.Account_DBA_Name__c);
        bodyMap.put('case_reason', subject);
        bodyMap.put('subject', subject);
        bodyMap.put('description', description);

        return bodyMap;
    }

    /////////////////////////// Helper Methods //////////////////////////////////
    public Static ValuePlus__c getRecord(ID id, Map<String, sObject> requiredFields, String action, String product) { //request #R151866 Updated to retrieve recordtype from record
        String query = ProfitStarsRequestBuilder.buildQuerySelectClauseFromRequiredFields(requiredFields, action, product); //request #R151866 Updated to retrieve recordtype from record
        query += ', Payment_Processing_Days__c FROM ValuePlus__c WHERE Id = \'' + id + '\' LIMIT 1';
        
        System.debug('Query Formed ' + query);
        System.debug('Action ' + action + ' ' + product);
        System.debug('Required Fields ' + requiredFields);        

        ValuePlus__c v = Database.query(query);
        return v;
    }

    public Static Bank_Account__c getBankRecord(Id id, Map<String, sObject> requiredFields, String product) {
        String query = ProfitStarsRequestBuilder.buildQuerySelectClauseFromRequiredFields(requiredFields, 'add on', product); //request #R151866 Updated to retrieve recordtype from record
        query += 'FROM Bank_Account__c WHERE Id = \'' + id + '\' LIMIT 1';
        Bank_Account__c b = Database.query(query);
        return b;
    }

    public Static String buildQuerySelectClauseFromRequiredFields(Map<String, sObject> requiredFields, String action, String product) {  //request #R151866 Updated to retrieve recordtype from record
        String query = 'SELECT ';
        String subQuery = '(SELECT ';
        Boolean hasSubquery = false;
        Boolean isIMRecord = false;

        if(action != null && action.contains('_IM')){
            isIMRecord = true;
        }

        for(String f : requiredFields.keyset()){
            sObject x = requiredFields.get(f);
            Boolean dealtWith = false;
            try{
                if(x.get('Part_of_a_Subquery__c') != null && (Boolean)x.get('Part_of_a_Subquery__c')){
                    dealtWith = true;
                    hasSubquery = true;
                    String fp;

                    if(isIMRecord){
                        fp = (String) x.get('Field_Path_IM__c');
                    } else{
                        fp = (String) x.get('Field_Path__c');
                    }
                    String[] parts = fp.split('\\.', 2);
                    subQuery += parts[1] + ', ';
                }
            } catch(NullPointerException npe){
                System.debug(npe.getMessage());
            } catch(Exception e){
                system.debug(e.getMessage());
            }
            //System.debug('Add_to_Query__c: '+ (Boolean)x.get('Add_to_Query__c'));
            //System.debug('Field_Path__c: '+ (string) x.get('Field_Path__c'));
            if((Boolean)x.get('Add_to_Query__c') && !dealtWith){
                if(isIMRecord && !query.contains((string) x.get('Field_Path_IM__c'))){
                    query += (string) x.get('Field_Path_IM__c') + ', ';
                } else if(!isIMRecord && !query.contains((string) x.get('Field_Path__c'))){
                    query += (string) x.get('Field_Path__c') + ', ';
                }
            }
        }
        if(hasSubquery){
            if(!subQuery.contains('LID__c')){
                subQuery += 'LID__c, ';
            }
            query += subQuery + 'Id, Name, CreatedDate, ps_BankAccountUpdateRequired__c, ps_LocationUpdateRequired__c, Ready_for_push_to_ProfitStars__c, Outbound_LID__c, Outbound_Location_Add_Status__c, Outbound_Location_Update_Status__c FROM Bank_Accounts__r WHERE Status__c != \'Inactive\' ORDER BY CreatedDate DESC), ';
        }
        if(action == 'add on'){
            query += 'Name, ValuePlus__r.recordTypeId, ValuePlus__r.recordType.Name, ValuePlus__r.Outbound_MID__c, Outbound_LID__c '; //request #R151866 Updated to retrieve recordtype from record
        }
        else if(product != null && product == 'echeck'){
            query += 'Name, recordType.Name, Outbound_MID__c, Outbound_Single_Day_Amount__c, Outbound_Single_Day_Count__c, Outbound_Single_Trans_Amount__c, Outbound_Period_Amount__c, Outbound_Period_Count__c, ';
            query+= 'SecondaryCondition1__c, SecondaryCondition2__c, QuaternaryCondition1__c, QuaternaryCondition2__c, TertiaryCondition1__c, TertiaryCondition2__c ';
        }
        else{
            query += 'Name, recordType.Name, '; //request #R151866 Updated to retrieve recordtype from record
            query+= 'SecondaryCondition1__c, SecondaryCondition2__c, QuaternaryCondition1__c, QuaternaryCondition2__c, TertiaryCondition1__c, TertiaryCondition2__c ';
        }
           
        System.debug('the query is '+query);
        return query;
    }

    /////////////////////////// Inner Classes ///////////////////////////////////
    public Class CustomerLocationsInnerClass {
        public List<Map<String, String>>  Location;
        public CustomerLocationsInnerClass() {
            //Location = new List <Map<String, String>>{new Map<String, String>()};
            Location = new List<Map<String, String>>();

        }
    }

    public Class APIIntegrationInnerClass {
        public Map<String, String> Account;
        public Map<String, Map<String, String>> Contacts;
        public Map<String, String> Opportunity;
        public CustomerLocationsInnerClass CustomerLocations;           

        public APIIntegrationInnerClass() {
            Account = new Map<String, String>();
            Contacts = new Map<String, Map<String, String>>();
            Opportunity = new Map<String, String>();
            CustomerLocations = new CustomerLocationsInnerClass();
        }
    }

    public Class ProfitStarsRequest {
        public APIIntegrationInnerClass APIIntegration;
        public ProfitStarsRequest() {
            APIIntegration = new APIIntegrationInnerClass();
        }
    }
}