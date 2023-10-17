/**********************************************************************************************************************
* copyright © 2017
* File      : GIACTRestRequestBuilder.cls
* Purpose   : The main purpose of this class is to prepare a request payload which can be passed to GIACT to get 
* the gVerify and gAuthenticate response. This class first fetches the the custom setting based on the action and
* Recordy type. Then it queries the specific bank account record and validates if all the required fields are
* available on the Bank Account record. If required information is missing. This throws the 
* GIACTRequestBuilderException. Else return the GIACTRequest object which is the the parsed into json. 
* 
*
*
* @author Rohit Kumar Malik
* @version 1.0
* @since 2017-10-20
**********************************************************************************************************************/
public without sharing class GIACTRestRequestBuilder {
    public class GIACTRequestBuilderException extends Exception {

    }
   /**
    *@brief GIACTRequest is the class which is corresponding to the GIACT inquiry request. 
    *
    * check this section holds all the check related information. 
    * customer this section holds all the information related to the customer. 
    * All other inforation is generic for all the calls. 
    */    
    public class GIACTRequest {

        public Map <String, String> Check = new Map <String, String> ();
        public Map <String, String> Customer = new Map <String, String> ();

        public String UniqueId;
        public Boolean GVerifyEnabled {get;set;}
        public Boolean GAuthenticateEnabled {get;set;}
        public Boolean GIdentifyEnabled {get; set;}
        public Boolean GOfacScanEnabled {get; set;}

    }

    public class GIACTRequestAPMIdentify {

        public Map <String, String> Customer = new Map <String, String> ();

        public String UniqueId;
        public Boolean GVerifyEnabled {get;set;}
        public Boolean GAuthenticateEnabled {get;set;}
        public Boolean GIdentifyEnabled {get; set;}
        public Boolean GOfacScanEnabled {get; set;}
    }    

    private static Bank_Account__c record;
    private static ValuePlus__c vRecord;
    private static Id myCaseRecTypeId = Schema.SObjectType.ValuePlus__c.getRecordTypeInfosByName().get('MyCase Payments').getRecordTypeId();
    // private static Id apmRecTypeId = Schema.SObjectType.ValuePlus__c.getRecordTypeInfosByName().get('APM Payments').getRecordTypeId();    

    /*
    *@breif This bank account record is used everywhere to modify or to verify the detials about the Bank account record. 
    *@param : action,  action specifies about the type of api we are running with this call. This is required to
    * decide about the type of Custom setting we need to pull. 
    *@param : vp this is the parent value plus record to the bank account record. 
    *@param : product, product specifies if the record we are processing is the MyCase record or the Value Plus record.
    *@param : CustomerType, Customer type is the type of data we are processing for bank account. These values are 
    * Business, First Owner, Second Owner, Third Owner and Fourth Owner. 
    *@return: GIACTRequest, This method returns a GIACTRequest object which is then serialized and passed to GIACT. 
    */   
    Public Static GIACTRequest createGVerifyAndGAuthenticateRequest(Integer index, ValuePlus__c vp, Bank_Account__c ba, String customerType) {
        String customSettingName = findGVerifyCustomSettingName (index, vp, customerType);
        // Retrieve all the files required to process the request
        Map<String, sObject> requiredFields = GIACTUtils.getRequiredFieldsForAPMIdentifyCall(customSettingName, customerType);

        // Let's log all the fields once, It may be required for production debugging. 
        System.debug('***FileName-GIACTRestRequestBuilder\\n ' + requiredFields+'\\n***');

        // NOTE: We can not improve this query as this we need to filter out the information and 
        // Perform the Error handling based on each set of information. 
        record = GIACTRestRequestBuilder.getBankRecord(ba.id, requiredFields);

        // We should not proceed further if record is null now. 
        if (record==null) {
            throw new GIACTRequestBuilderException ('There is not record set to process. Salesforce Administrator needs to check the Custom Settings.');
        }

        GIACTRequestValidation.validate(record, requiredFields); 
        GIACTRequest bodyObj = new GIACTRequest();

        bodyObj.GVerifyEnabled =true;
        bodyobj.GAuthenticateEnabled = true;
        bodyobj.GIdentifyEnabled = false;

        if (customerType.equals ('Business')) {
            bodyobj.customer.put ('EntityType', '0');
        } else {
            bodyobj.customer.put ('EntityType', '1');
        }

        for (String fsm : requiredFields.keyset()) {

            sObject x = requiredFields.get(fsm);
            String value;

            // Retrieve only the data from Bank Account which is coressponding to the Customer Type and It is in active state
            if ((Boolean)x.get ('Disabled__c')==false) {

                // There are multiple fields with Same Giact Name as we Name Filed is unique, 
                // So Giact Name is the actual fields name which goes in the request payload. 
                String giactName = (String)x.get('GIACTName__c');

                // Get the value from the Bank Account Record and Format this value based on the GIACT Accepted format
                if (!String.isEmpty((String)x.get('HardcodedValue__c'))) {
                    value = GIACTUtils.giactFormat(giactName, (String) x.get('HardcodedValue__c'));
                } else {
                    value = GIACTUtils.giactFormat(giactName, GIACTUtils.extractRelatedField((String) x.get('Field_Path__c'), record));
                }

                System.debug ('**********FileName-GIACTRestRequestBuilder\\n  Field Name ' +  fsm + ' Value: ' + value+'\\n**********');

                if (x.get('LevelName__c')=='check') {
                    bodyobj.check.put (giactName, value);
                } else if (x.get('LevelName__c')=='customer') {
                    bodyobj.Customer.put (giactName, value);
                } else {
                    if (giactName.equals('BankName')) {
                        
                        // This is the value which goes into Giact as a unique field
                        Decimal ver = 0.0;
                        if (ba.GiactRequestVersion__c!=null) {
                            ver = ba.GiactRequestVersion__c+1;
                        }

                        // Setting up the Unique Id for the Giact Call
                        bodyObj.UniqueId =ba.Id+'-'+customerType+'-' + String.valueOf(ver);
                    } 
                }
            }
        }

        System.debug('**********FileName-GIACTRestRequestBuilder\\n GIACT Body Object - '+bodyobj+'\\n**********');
        return bodyObj;
    }

    public Static GIACTRequestAPMIdentify createGIdentifyAPMRequest (Integer index, ValuePlus__c vp, String customerType) {
        String customSettingName = findCustomSettingName (index, vp, customerType);

        // Retrieve all the files required to process the request
        Map<String, sObject> requiredFields = GIACTUtils.getRequiredFieldsForAPMIdentifyCall(customSettingName, customerType);
        // Let's log all the fields once, It may be required for production debugging. 
        System.debug('***FileName-GIACTRestRequestBuilder\\n ' + requiredFields+'\\n***');
        // NOTE: We can not improve this query as this we need to filter out the information and 
        // Perform the Error handling based on each set of information. 
        vRecord = GIACTRestRequestBuilder.getRecord(vp.Id, requiredFields);
        // We should not proceed further if record is null now.
        // NOTE: Check this Exception and find where is this being handled
        if (vRecord==null) {
            throw new GIACTRequestBuilderException ('There is not record set to process. Salesforce Administrator needs to check the Custom Settings.');
        }

        GIACTRequestValidation.validate(vRecord, requiredFields);

        //GIACTRequestAPMIdentify bodyObj = new GIACTRequestAPMIdentify();
        GIACTRequestAPMIdentify bodyObj = new GIACTRequestAPMIdentify ();
        bodyObj.GVerifyEnabled =false;
        bodyobj.GAuthenticateEnabled = false;
        bodyobj.GIdentifyEnabled = true;
        bodyObj.GOfacScanEnabled = true;

        if (customerType.equals ('Business')) {
            bodyobj.customer.put ('EntityType', '0');
        } else {
            bodyobj.customer.put ('EntityType', '1');
        }

        for (String fsm : requiredFields.keyset()) {
            sObject x = requiredFields.get(fsm);
            String value;
            System.debug('Giact Name -  ' + ' ' + fsm +  '  '+ x);

            if ((Boolean)x.get ('Disabled__c')==false) {
                String giactName = (String)x.get('GIACTName__c');
                value = GIACTUtils.giactFormat(giactName, GIACTUtils.extractRelatedField((String) x.get('Field_Path__c'), vRecord));

                System.debug('Giact Name -  ' + giactName + ' Value - ' + value);

                bodyobj.Customer.put (giactName, value);
                if (giactName.equals('Country')) {
                    bodyobj.Customer.put (giactName, 'US');
                } 
            }
        }

        System.debug('**********FileName-GIACTRestRequestBuilder\\n GIACT Body Object - '+bodyobj+'\\n**********');
        return bodyObj;
    }

    private static String findGVerifyCustomSettingName (Integer index, ValuePlus__c vp, String customerType) {

        // if (apmRecTypeId==vp.RecordTypeId) {
        //     if (customerType=='Business') {
        //         return 'GVF APM Business';
        //     } else if (index==1) {
        //         return 'GVF APM Principal 1';
        //     } else if (index==2) {
        //         return 'GVF APM Principal 2';
        //     } else if (index==3) {
        //         return 'GVF APM Principal 3';
        //     } else if  (index==4){
        //         return 'GVF APM Principal 4';
        //     }
        // } else {
            if (customerType=='Business') {
                return 'GVF MyCase Business';
            } else if (index==1) {
                return 'GVF MyCase Principal 1';
            } else if (index==2) {
                return 'GVF MyCase Principal 2';
            } else if (index==3) {
                return 'GVF MyCase Principal 3';
            } else if  (index==4){
                return 'GVF MyCase Principal 4';
            }
        // }

        throw new GIACTRequestBuilderException ('Automation could not find the valid custom setting name. Please contact the Business Systems team.');
    }

    private static String findCustomSettingName (Integer index, ValuePlus__c vp, String customerType) {

        // if (apmRecTypeId==vp.RecordTypeId) {
        //     if (customerType=='Business') {
        //         return 'GID APM Business';
        //     } else if (index==1) {
        //         return 'GID APM Principal 1';
        //     } else if (index==2) {
        //         return 'GID APM Principal 2';
        //     } else if (index==3) {
        //         return 'GID APM Principal 3';
        //     } else if  (index==4){
        //         return 'GID APM Principal 4';
        //     }
        // } else {
            if (customerType=='Business') {
                return 'GID MyCase Business';
            } else if (index==1) {
                return 'GID MyCase Principal 1';
            } else if (index==2) {
                return 'GID MyCase Principal 2';
            } else if (index==3) {
                return 'GID MyCase Principal 3';
            } else if  (index==4){
                return 'GID MyCase Principal 4';
            }
        // }

        throw new GIACTRequestBuilderException ('Automation could not find the valid custom setting name. Please contact the Business Systems team.');
    }

    /*
    *@breif : This method is responsible to build the query for the rquired fields map. 
    **/ 
    Public Static ValuePlus__c getRecord(ID id, Map<String, sObject> requiredFields) {
        String query = GIACTRestRequestBuilder.buildQuerySelectClauseFromRequiredFields(requiredFields); 
        query += ' FROM ValuePlus__c WHERE Id = \'' + id + '\' LIMIT 1';
        System.debug('**********FileName-GIACTRestRequestBuilder\\n Giact Query - '+query+'\\n**********');
        ValuePlus__c v = Database.query(query);
        System.debug('*** Queried Value Plus Record - ' + v);

        return v;
    }    


    /**
    *@brief : This method is responsible to build the query based on the required fields map. The Database query then pulls the Bank Account Record
    * and fields. 
    *
    *@param : Id this is the bank Account Id which we need to query. 
    *@param : requiredFields is a map of all the custom setting records Name and records. 
    *@return : Returns the queried Bank account Record. 
    */    
    Public Static Bank_Account__c getBankRecord(Id id, Map<String, sObject> requiredFields) {

        // Call the method to build the query from the required fields. 
        String query = GIACTRestRequestBuilder.BuildQuerySelectClauseFromRequiredFields(requiredFields);
        query += ' FROM Bank_Account__c WHERE Id = \'' + id + '\' LIMIT 1';
        System.debug('FileName-GIACTRestRequestBuilder: the full query is '+query);
        
        List<Bank_Account__c> bankList;
        Bank_Account__c b;
        bankList  = Database.query(query);

        // Check if the Bank Account List is empty
        if (bankList==null || bankList.isEmpty()) {
            throw new GIACTRequestBuilderException ('FileName-GIACTRestRequestBuilder: the full query is '+ query + '\n Query did not return any valid Record.');
        }
        b = bankList[0];

        return b;
    }

    /**
    *@brief : This method constructs the query based on the required fields. This method builds the query and the subquery to query all the required data.
    *
    *@param : requiredFields is a map of all the custom setting records Name and records. 
    *@return : Returns query which is a query string.
    */      
    Public Static String BuildQuerySelectClauseFromRequiredFields(Map<String, sObject> requiredFields) {
        
        String query = 'SELECT ';
        String subQuery = '(SELECT ';
        Boolean hasSubquery = false;
        boolean isFirstPath = true;
        for (String f : requiredFields.keyset()) {
            sObject x = requiredFields.get(f);
            Boolean dealtWith = false;
            hasSubquery = true;
            if (!String.isEmpty((string) x.get('Field_Path__c'))) {
                if (!query.contains((string) x.get('Field_Path__c')) && !isFirstPath) {
                    query += ', ';
                    query += (string) x.get('Field_Path__c');
                } else {
                    query += (string) x.get('Field_Path__c');
                    isFirstPath = false;
                }
            }
        }
        
        return query;
    }
}