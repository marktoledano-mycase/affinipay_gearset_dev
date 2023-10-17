/*
* Test Class: GiactVerifyServiceTest
*/
public with sharing class Giact_AdvancedIdentifyResponse {



        /*********************Parsing Advanced Business Response and Preparing the HTML file String******************/



    public GIACTIntegrationService.PersonSearchResultRecords parsePersonIdentity (HttpResponse response) {

        GIACTIntegrationService.PersonSearchResultRecords personSearchResp = new GIACTIntegrationService.PersonSearchResultRecords ();
        Dom.Document doc = response.getBodyDocument();

        
        Dom.XmlNode root = doc.getRootElement();
        if (root.getName().equals('Errors')) {
            personSearchResp.errors = parseAllErrors(root);
        } else {

            System.debug(' XML Node - ' + root );


            // Below are same which returns the same first matching child. 
            List <Dom.XmlNode> bodyLevelList = root.getChildElements();
            Dom.XmlNode bodyNode;
            if (!bodyLevelList.isEmpty() && bodyLevelList[0].getName()=='body') {
                bodyNode = bodyLevelList[0]; 
            } else {
                return null;
            }

            System.debug(' XML Node - ' + bodyNode.getName());

            List <Dom.XmlNode> personSearchRespNodeList = bodyNode.getChildElements();
            Dom.XmlNode personSearchRespNode;
            if (!personSearchRespNodeList.isEmpty() && personSearchRespNodeList[0].getName()=='PersonSearchResponse') {
                personSearchRespNode = personSearchRespNodeList[0]; 
            } else {
                return null;
            }

            System.debug(' XML Node - ' + personSearchRespNode.getName());


            List <Dom.XmlNode> personSearchResultList = personSearchRespNode.getChildElements();
            Dom.XmlNode personSearchResultNode;
            if (!personSearchResultList.isEmpty() && personSearchResultList[0].getName()=='PersonSearchResult') {
                personSearchResultNode = personSearchResultList[0]; 
            } else {
                return null;
            }


            Dom.XmlNode searchResultRecordsNode;
            // Find the searchResultNode
            for (Dom.XmlNode node : personSearchResultNode.getChildElements()) {
                if (node.getName()=='SearchResultRecords') {
                    searchResultRecordsNode = node;
                    break;
                }
            }


            if (searchResultRecordsNode!=null) {
                System.debug('Hurrey We are on the right node.');
                for (Dom.XmlNode node : searchResultRecordsNode.getChildElements()) {
                    String name = node.getName();
                    System.debug('Current Node Value - ' + name);
                    if (name.equals('IDAdvancedPersonSearchResultRecord')) {
                        GIACTIntegrationService.PersonSearchResultRecord person = parseAdvancedPersonSearchResultRecord (node);
                        if (person!=null) 
                            personSearchResp.listOfLienAndBankruptcies.add(person);
                        }
                 }
            }
        }

        System.debug('Final object - ' + JSON.serialize(personSearchResp));

        return personSearchResp;
    }


    private GIACTIntegrationService.PersonSearchResultRecord parseAdvancedPersonSearchResultRecord (Dom.XmlNode n) {

        GIACTIntegrationService.PersonSearchResultRecord person = new GIACTIntegrationService.PersonSearchResultRecord ();

        for (Dom.XmlNode node : n.getChildElements ()) {
            String name = node.getName ();

            if (name=='Names') {
                person.names = parsePersonNames (node);
            } else if (name=='SSNRecords'){
                person.ssnRecords = parsePersonSSNRecords (node);
            } else if (name=='NumberOfBankruptcies') {
                person.numberOfBankRuptcies = node.getText ();
            } else if (name=='NumberOfLiens') {
                person.numberOfLiens = node.getText();
            } else if (name=='NumberOfJudgements') {
                person.numberOfJudgements = node.getText ();
            }
        }

        return person;
    }

    private List<GIACTIntegrationService.CustomerName> parsePersonNames (Dom.XmlNode n) {

        List<GIACTIntegrationService.CustomerName> personNames = new List<GIACTIntegrationService.CustomerName> ();

        for (Dom.XmlNode node : n.getChildElements ()) {
            if (node.getName ()=='IDAdvancedBasicName') {
                GIACTIntegrationService.CustomerName person = parsePersonName (node);
                if (person!=null) {
                    personNames.add(person);
                }
            }
        }

        return personNames;
    }

    private GIACTIntegrationService.CustomerName parsePersonName (Dom.XmlNode n) {

        GIACTIntegrationService.CustomerName customer = new GIACTIntegrationService.CustomerName ();

        for (Dom.XmlNode node : n.getChildElements ()) {
            if (node.getName ()=='FirstName') {
                customer.fName=node.getText();
            } else  if (node.getName ()=='MiddleName') {
                customer.mName = node.getText();
            } else if (node.getName ()=='LastName') { 
                customer.lName=node.getText();
            }
        }
        return customer;
    } 

    private List<GIACTIntegrationService.SSNRecord> parsePersonSSNRecords (Dom.XmlNode n) {

        List<GIACTIntegrationService.SSNRecord> personSSNRecords = new List<GIACTIntegrationService.SSNRecord> ();

        for (Dom.XmlNode node : n.getChildElements ()) {
            if (node.getName ()=='IDAdvancedSSNRecord') {
                GIACTIntegrationService.SSNRecord personSSNRecord = parsePersonSSNRecord (node);
                if (personSSNRecord!=null) {
                    personSSNRecords.add(personSSNRecord);
                }
            }
        }

        return personSSNRecords;
    }

    private GIACTIntegrationService.SSNRecord parsePersonSSNRecord (Dom.XmlNode n) {

        GIACTIntegrationService.SSNRecord personSSNRecord = new GIACTIntegrationService.SSNRecord ();

        for (Dom.XmlNode node : n.getChildElements ()) {
            if (node.getName ()=='SSN') {
                personSSNRecord.ssn=node.getText();
            } else  if (node.getName ()=='SSNPlaceOfIssue') {
                personSSNRecord.ssnPlaceOfIssue = node.getText();
            } else if (node.getName () == 'SSNIssueYears') { 
                personSSNRecord.ssnIssueYears =node.getText();
            }
        }
        return personSSNRecord;
    } 





        /*********************       END OF FUNCATIONLITY   ******************/




        /*********************Parsing Advanced Business Response and Preparing the HTML file String******************/


    public GIACTIntegrationService.BusinessSearchResultRecords parseBusinessIdentity (HttpResponse response) {
        
        GIACTIntegrationService.BusinessSearchResultRecords businessSearchResp = new GIACTIntegrationService.BusinessSearchResultRecords ();
        Dom.Document doc = response.getBodyDocument();
        
        //String xml = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><BusinessSearchTestResponse xmlns="http://www.giact.com/api/identificationservices/v1.0"><BusinessSearchTestResult><SearchModified>false</SearchModified><NumberOfRecordsFound>8</NumberOfRecordsFound><NumberOfRecordsFoundWithModifiedSearch>0</NumberOfRecordsFoundWithModifiedSearch><AbbreviatedResult>false</AbbreviatedResult><SearchResultRecords><IDAdvancedBusinessSearchResultRecord><BusinessReportKey>testToken</BusinessReportKey><FEINumber>1234567890</FEINumber><BusinessNames><IDAdvancedBusinessName><Name>ABC TEST COMPANY INC.</Name><Type>Primary</Type></IDAdvancedBusinessName><IDAdvancedBusinessName><Name>ABC TEST COMPANY</Name><Type>Primary</Type></IDAdvancedBusinessName></BusinessNames><DomesticWorldFlag>D</DomesticWorldFlag><ParentBusinessReportKey /><ParentDomesticWorldFlag /><GlobalBusinessReportKey /><GlobalDomesticWorldFlag /><HQBusinessReportKey /><HQBusinessDomesticWorldFlag /><Industry>Machine Shop, Jobbing And Repair</Industry><Industries><string>Machine Shop, Jobbing And Repair</string></Industries><Addresses><IDAdvancedAddressRecord><ConfirmedAddress>false</ConfirmedAddress><Address><Line1>12345 MAIN ST</Line1><City>DALLAS</City><State>TX</State><ZipCode>12345</ZipCode></Address><DateFirstSeen><Year>1972</Year></DateFirstSeen><DateLastSeen><Day>20</Day><Month>05</Month><Year>2012</Year></DateLastSeen><PhoneListings><IDAdvancedPhoneListing><Phone>5555555555</Phone><PhoneType>Unknown</PhoneType><ListingName>ABC TEST COMPANY</ListingName><ListingType>Unknown</ListingType><Carrier>TEST TELEPHONE COMPANY</Carrier><CarrierType>LANDLINE</CarrierType><City>DALLAS</City><State>TX</State><County>DALLAS</County><TimeZone>CST</TimeZone></IDAdvancedPhoneListing></PhoneListings></IDAdvancedAddressRecord></Addresses><PrincipalContacts><IDAdvancedBusinessContact><PersonReportKey>testToken</PersonReportKey><Name><FirstName>JIM</FirstName><MiddleName /><LastName>JONES</LastName><NameSuffix /></Name><Title>DIRECTOR; OFFICER; OWNER; PRESIDENT</Title><ContactType>Principal</ContactType><Address><Line1>12345 MAIN ST</Line1><City>DALLAS</City><State>TX</State><ZipCode>12345</ZipCode><Zip4>1234</Zip4></Address></IDAdvancedBusinessContact><IDAdvancedBusinessContact><PersonReportKey /><Name><FirstName>JOHN</FirstName><MiddleName /><LastName>JONES</LastName><NameSuffix /></Name><Title>CHIEF EXECUTIVE OFFICER; DIRECTOR; INCORPORATOR; MANAGER; PRESIDENT; TREASURER</Title><ContactType>Principal</ContactType><Address><Line1>12345 MAIN ST</Line1><City>DALLAS</City><State>TX</State><ZipCode>12345</ZipCode><Zip4>1234</Zip4></Address></IDAdvancedBusinessContact><IDAdvancedBusinessContact><PersonReportKey /><Name><FirstName>JOHN</FirstName><MiddleName /><LastName>JONES</LastName><NameSuffix /></Name><Title>CERTIFIED PUBLIC ACCOUNTANT; VICE PRESIDENT</Title><ContactType>Principal</ContactType><Address><Line1>12345 MAIN ST</Line1><City>DALLAS</City><State>TX</State><ZipCode>12345</ZipCode><Zip4>1234</Zip4></Address></IDAdvancedBusinessContact></PrincipalContacts><OtherContacts><IDAdvancedBusinessContact><PersonReportKey>testToken</PersonReportKey><Name><FirstName>JOHN</FirstName><MiddleName /><LastName>SMITH</LastName><NameSuffix /></Name><Title>REGISTERED AGENT</Title><ContactType>Registered Agent</ContactType><Address><Line1>12345 MAIN ST</Line1><City>DALLAS</City><State>TX</State><ZipCode>12345</ZipCode><Zip4>1234</Zip4></Address></IDAdvancedBusinessContact></OtherContacts><DeedCount>1</DeedCount><ForeclosureCount>2</ForeclosureCount><VehicleCount>3</VehicleCount><AircraftCount>4</AircraftCount><JudgementDebtorCount>5</JudgementDebtorCount><JudgementCreditorCount>6</JudgementCreditorCount><LienHolderCount>8</LienHolderCount><LienDebtorCount>7</LienDebtorCount><BankruptcySubjectCount>9</BankruptcySubjectCount><BankruptcyCreditorCount>10</BankruptcyCreditorCount><PossibleEmployeeCount>11</PossibleEmployeeCount></IDAdvancedBusinessSearchResultRecord></SearchResultRecords></BusinessSearchTestResult></BusinessSearchTestResponse></soap:Body></soap:Envelope>';
        //Dom.Document doc = new Dom.Document();
        //doc.load (xml);

        Dom.XmlNode root = doc.getRootElement();

        if (root.getName().equals('Errors')) {
            businessSearchResp.errors = parseAllErrors(root);
        } else {

            System.debug(' XML Node - ' + root );


            // Below are same which returns the same first matching child. 
            List <Dom.XmlNode> bodyLevelList = root.getChildElements();
            Dom.XmlNode bodyNode;
            if (!bodyLevelList.isEmpty() && bodyLevelList[0].getName()=='body') {
                bodyNode = bodyLevelList[0]; 
            } else {
                return null;
            }

            System.debug(' XML Node - ' + bodyNode.getName());



            List <Dom.XmlNode> personSearchRespNodeList = bodyNode.getChildElements();
            Dom.XmlNode personSearchRespNode;
            if (!personSearchRespNodeList.isEmpty() && personSearchRespNodeList[0].getName() == 'BusinessSearchResponse') {
            //if (!personSearchRespNodeList.isEmpty() && personSearchRespNodeList[0].getName()=='BusinessComboSearchResponse') {
                personSearchRespNode = personSearchRespNodeList[0]; 
            } else {
                return null;
            }

            System.debug(' XML Node - ' + personSearchRespNode.getName());


            List <Dom.XmlNode> personSearchResultList = personSearchRespNode.getChildElements();
            Dom.XmlNode personSearchResultNode;
            if (!personSearchResultList.isEmpty() && personSearchResultList[0].getName() == 'BusinessSearchResult') {
            //if (!personSearchResultList.isEmpty() && personSearchResultList[0].getName()=='BusinessComboSearchResult') {
                personSearchResultNode = personSearchResultList[0]; 
            } else {
                return null;
            }


            Dom.XmlNode searchResultRecordsNode;
            // Find the searchResultNode
            for (Dom.XmlNode node : personSearchResultNode.getChildElements()) {
                if (node.getName()=='SearchResultRecords') {
                    searchResultRecordsNode = node;
                    break;
                }
            }

            if (searchResultRecordsNode!=null) {
                System.debug('Hurrey We are on the right node.');
                for (Dom.XmlNode node : searchResultRecordsNode.getChildElements()) {
                    String name = node.getName();
                    System.debug('Current Node Value - ' + name);
                    if (name.equals('IDAdvancedBusinessSearchResultRecord')) {
                        GIACTIntegrationService.BusinessSearchResultRecord business = parseAdvancedBusinessSearchResultRecord (node);
                        if (business!=null){
                            businessSearchResp.listOfLienAndBankruptcies.add(business);
                        }
                    }
                }
            }

            /*if(searchResultRecordsNode!=null){
                for(Dom.XmlNode node : searchResultRecordsNode.getChildElements()){
                    String name = node.getName();
                    System.debug('Current Node Value - ' + name);
                    if(name.equals('IDAdvancedBusinessComboSearchResultRecord')){
                        for(Dom.XmlNode childNode : node.getChildElements()){
                            if(childNode.getName() == 'CorporateFiling' || childNode.getName() == 'FullBusinessSearchResultRecord'){
                                GIACTIntegrationService.BusinessSearchResultRecord business = parseAdvancedBusinessSearchResultRecord (childNode);
                                if (business!=null){
                                    businessSearchResp.listOfLienAndBankruptcies.add(business);
                                }
                            }
                        }
                    }
                }
            }*/
        }

        System.debug('Final object - ' + JSON.serialize(businessSearchResp));

        return businessSearchResp;
    }

    private GIACTIntegrationService.BusinessSearchResultRecord parseAdvancedBusinessSearchResultRecord (Dom.XmlNode n) {

        GIACTIntegrationService.BusinessSearchResultRecord business = new GIACTIntegrationService.BusinessSearchResultRecord ();

        for (Dom.XmlNode node : n.getChildElements ()) {
            String name = node.getName ();

            if (name=='BusinessNames') {
                business.names = parseBusinessNames (node);
            } else if (name=='JudgementDebtorCount') {
                business.numberOfJudgementDebtorCount = node.getText ();
            } else if (name=='JudgementCreditorCount') {
                business.numberOfJudgementCreditorCount = node.getText();
            } else if (name=='LienHolderCount') {
                business.numberOfLienHolderCount = node.getText ();
            } else if (name=='LienDebtorCount') {
                business.numberOfLienDebtorCount = node.getText();
            } else if (name=='BankruptcySubjectCount') {
                business.numberOfBankruptcySubjectCount = node.getText ();
            } else if (name=='BankruptcyCreditorCount') {
                business.numberOfBankruptcyCreditorCount = node.getText();
            }
        }

        return business;
    }

    private List<GIACTIntegrationService.BusinessName> parseBusinessNames (Dom.XmlNode n) {

        List<GIACTIntegrationService.BusinessName> businessNames = new List<GIACTIntegrationService.BusinessName> ();

        for (Dom.XmlNode node : n.getChildElements ()) {
            if (node.getName ()=='IDAdvancedBusinessName') {
                GIACTIntegrationService.BusinessName businessName = parseBusinessName (node);
                if (businessName!=null) {
                    businessNames.add(businessName);
                }
            }
        }

        return businessNames;
    }

    private GIACTIntegrationService.BusinessName parseBusinessName (Dom.XmlNode n) {

        GIACTIntegrationService.BusinessName businessName = new GIACTIntegrationService.BusinessName ();

        for (Dom.XmlNode node : n.getChildElements ()) {
            if (node.getName ()=='Name') {
                businessName.name=node.getText();
            }
        }
        return businessName;
    } 




    private List<GIACTIntegrationService.Error> parseAllErrors(Dom.XmlNode n) {
        List<GIACTIntegrationService.Error> errors = new List<GIACTIntegrationService.Error>();
        for (Dom.XmlNode node : n.getChildElements()) 
        {
            String name = node.getName();
            
            if (name.equals('Error')) {
                errors.add(parseError(node)); }
        }
        return errors;
    }

    private GIACTIntegrationService.Error parseError(Dom.XmlNode n) {
         GIACTIntegrationService.Error error = new GIACTIntegrationService.Error();
        for (Dom.XmlNode node : n.getChildElements()) {
            String name = node.getName();
            if (name.equals('Source')) {
                error.source = node.getText();
            } else if (name.equals('ReasonCode')) {
                error.reasonCode = node.getText();
            } else if (name.equals('Description')) {
                error.description = node.getText();
            } else if (name.equals('Recoverable')) {
                error.recoverable = node.getText();
            } 
        }
        System.debug('Error '+error);
        return error;
    }    


}