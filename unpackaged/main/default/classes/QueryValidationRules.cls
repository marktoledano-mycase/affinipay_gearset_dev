/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This class holds methods to use for turning Validation Rules on and off via batch classes (Turn_OFF_ValidationRulesBatch, Turn_ON_ValidationRulesBatch)
* 
* @test           QueryValidationRulesTest
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         
* @modifiedBy     ryan Kleinberg <ryan.kleinberg@appfolio.com>
* @maintainedBy   
* @version        1.1
* @created        2019-12-18
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* v1.0            ryan.kleinberg@appfolio.com
* 2019-12-18      Creation - R1918759 
*
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
public class QueryValidationRules {
    
    public class QueryValidationRulesException extends Exception {}
    public static List<Id> vRuleIds = new List<id>();
    public static Map<Id,metadata> metaMap = new Map<Id, metadata>();
    
    
    // ------------------------------------------------------- BEGIN SUB CLASSES ----------------------------------------------------------------------
    
    /*
     *	This sub-class holds the Validation Rule data that is returned from the tooling api REST call 
     */ 
    public class vrule{
        Public attribute attributes;
        Public Id rId; 
        Public String Active;
        Public metadata metadata;
        
        public vrule(attribute vattributes, Id vId, String vActive, metadata vMetadata){
            attributes = vattributes;
            rId = vId;
            Active = vActive;
            metadata = vMetadata;
        }
    }
    
    /*
     *	This sub-class holds the attribute data that is returned from the tooling api REST call on Validation rules
     */ 
    public class attribute{
        Public String type;
        Public String url;
        
        public attribute(String ty, String ur){
            type = ty;
            url=ur;
        }
        
       
        /*
         * Method getId
         *  Purpose: returns the id of the validtion rule by getting it from the URL in the attributes object, which is returned from the REST callout
         */
        public string getId(){
            return url.substringAfterLast('/');
        }
    }
    
    
    
    /*
     *	This sub-class holds the metadata info that is returned from the tooling api REST call on Validation rules
     */ 
    public class metadata{
        Public String description;
		Public String errorConditionFormula;
		Public String errorDisplayField;
		Public String errorMessage;
		Public String urls;
		Public String active;
        
        public metadata(String description, String errorCon, String errorDis, String errorMess, String urls, String active){
            description = description;
            errorConditionFormula = errorCon.replaceAll('\"', '\'').replaceAll('\n', ' ');
            errorDisplayField = errorDis.replaceAll('\"', '\'').replaceAll('\n', ' ');
            errorMessage = errorMess.replaceAll('\"', '\'').replaceAll('\n', ' ');
            urls = urls;
            active = active;
           
        }
        
    }
    // ------------------------------------------------------- END SUB CLASSES ----------------------------------------------------------------------
    
    
    
    /*
    * Method queryValidationRules
    *  Purpose: gets all active validation rule ids (using REST callout) and returns them in a list
    */
    public static List<Id> queryValidationRules(){
        vRuleIds = new List<Id>();
        
        try{ 
            
            HttpRequest req = new HttpRequest();
            req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
            req.setHeader('Content-Type', 'application/json');        
            
            //get the current Org's base url and check to make sure it is in the .full sandbox
            String baseURL = URL.getSalesforceBaseUrl().toExternalForm();
            if(!baseURL.containsIgnoreCase('devpro')){
                throw new QueryValidationRulesException('URL endpoint does not contain \'Full\' make sure you are running in the .Full sandbox environment');
			}
            req.setEndpoint(baseURL + '/services/data/v47.0/tooling/query/?q=Select+id,active,NamespacePrefix+from+ValidationRule+where+active=true+and+NamespacePrefix=null');
            req.setMethod('GET');
            
            Http h = new Http();
            HttpResponse res = h.send(req);
            system.debug(res.getBody()); 
            if(res.getStatusCode() != 200){
                throw new QueryValidationRulesException(res.getStatus() + ' code: ' + res.getStatusCode());
            }
            
            integer count = 0;
            JSONParser parser = JSON.createParser(res.getBody());
            while(parser.nextToken() != null){
                System.debug(parser.getCurrentToken() + ' - ' + parser.getText());
                if(parser.getCurrentToken() == JSONToken.START_ARRAY){
                    while(parser.nextToken() != null){
                        System.debug(parser.getCurrentToken() + ' - ' + parser.getText());
                        if(parser.getCurrentToken() == JSONToken.START_OBJECT){
                            vrule r = (vrule) parser.readValueAs(vrule.class);
                            vRuleIds.add((Id) r.attributes.getId());
                            
                            count+=1;
                            parser.skipChildren();
                        }
                        
                    }
                }
            }
            System.debug('!!Ids: ' + vRuleIds);
            
            
        } catch (Exception ex){
            SystemExceptionLogger.fireSystemExceptionLogEvent (ex, 'QueryValidationRules', 'queryValidationRules', 
                                                               SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, ex.getMessage(), 'ValidationRule', null, false);
        }
        
        return vRuleIds;
    }



    /*
    * Method populateActiveVrules
    *  Purpose: populates active validation Rule Id's as custom settings
    */
    public static List<Active_Validation_Rule_Ids__c> populateActiveVrules(){
        List<Active_Validation_Rule_Ids__c > cSettingList = new List<Active_Validation_Rule_Ids__c >();
        
        try{
            
            for(Id i : queryValidationRules()){
                Active_Validation_Rule_Ids__c  vRule = new Active_Validation_Rule_Ids__c ();
                vRule.vRule_Id__c  = i;
                vRule.Name = i;
                cSettingList.add(vRule);
            }
            
            insert cSettingList;
            
        } catch (Exception ex){
            SystemExceptionLogger.fireSystemExceptionLogEvent (ex, 'QueryValidationRules', 'queryValidationRules', 
                                                               SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, ex.getMessage(), 'ValidationRule', null, false);
        }
        return cSettingList;
    }    
    

    
    /*
    * Method getMetadata
    *  Purpose: Gets metadata from one validation rule and puts it in the static map
    *  Note: Careful with bulkification, 1 web callout is needed for each validation rule to get metadata with the tooling api
    * @param: validId - the Id of the validation rule we want to retreive 
    */
    public static metadata getMetadata(Id validId){
        
        try{
            
            HttpRequest req = new HttpRequest();
            req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
            req.setHeader('Content-Type', 'application/json');        
            
            //get the current Org's base url and check to make sure it is in the .full sandbox
            String baseURL = URL.getSalesforceBaseUrl().toExternalForm();
            if(!baseURL.containsIgnoreCase('devpro')){
                throw new QueryValidationRulesException('URL endpoint does not contain \'Full\' make sure you are running in the .Full sandbox environment');
			}
            req.setEndpoint(baseURL + '/services/data/v47.0/tooling/query/?q=Select+id,active,metadata+from+ValidationRule+where+id=\''+validId+'\'');
            req.setMethod('GET');
            
            Http h = new Http();
            HttpResponse res = h.send(req);
            system.debug(res.getBody()); 
            if(res.getStatusCode() != 200){
                throw new QueryValidationRulesException(res.getStatus() + ' code: ' + res.getStatusCode());
            }
            
            JSONParser parser = JSON.createParser(res.getBody());
            while(parser.nextToken() != null){
                System.debug(parser.getCurrentToken() + ' - ' + parser.getText());
                if(parser.getCurrentToken() == JSONToken.START_ARRAY){
                    while(parser.nextToken() != null){
                        if(parser.getCurrentToken() == JSONToken.START_OBJECT){
                            vrule r = (vrule) parser.readValueAs(vrule.class);
                            metaMap.put(validId, r.metadata);
                            System.debug(r);
                            parser.skipChildren();
                        }
                        
                    }
                }
            }
            
        } catch (Exception ex){
            SystemExceptionLogger.fireSystemExceptionLogEvent (ex, 'QueryValidationRules', 'queryValidationRules', 
                                                               SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, ex.getMessage(), 'ValidationRule', validId, false);
        }
        System.debug('!!Metamap: ' + metaMap);
        return metaMap.get(validId);
    }
    

    
    
    /*
    * Method setStatus
    *  Purpose: sets the active variable to true/false for given id
    * Note: Careful with bulkification, 1 web callout is needed for each validation rule to update through the tooling api
    * 
    * @param: validId - Id of the validation rule we want to update
    * 		  activeStatus - What value we want to change the active field to on the validation rule (true/false)
    */
    public static boolean setStatus(Id validId, Boolean activeStatus){
        boolean success = false;
        try{
            metadata md = metaMap.get(validId);
            if(md == null){
                system.debug('!!!NULL VAL IN metaMAP');
                md = getMetadata(validId);
            }
            
            HttpRequest req = new HttpRequest();
            req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
            req.setHeader('Content-Type', 'application/json');
            
            //get the current Org's base url and check to make sure it is in the .full sandbox
            String baseURL = URL.getSalesforceBaseUrl().toExternalForm();
            if(!baseURL.containsIgnoreCase('devpro')){
                throw new QueryValidationRulesException('URL endpoint does not contain \'Full\' make sure you are running in the .Full sandbox environment');
			}
            req.setEndpoint(baseURL + '/services/data/v47.0/tooling/sobjects/ValidationRule/' + validId + '?_HttpMethod=PATCH');
            
            //replace " and new line chars in the error formula so it can be passed to tooling api. 
            //Multiple new line replacement types bc the new line char varries per OS
            String errorForm = md.errorConditionFormula.replaceAll('\r\n', ' ');
            errorForm = errorForm.replaceAll('\n', ' ');
            errorForm = errorForm.replaceAll('\r', ' ');
            errorForm = errorForm.replaceAll('\"', '\'');
            errorForm = errorForm.replaceAll('\t',' ');
            
            String errorMsg = md.errorMessage.replaceAll('\"', '\'');
            errorMsg = errorMsg.replaceAll('\r\n', ', ');
            errorMsg = errorMsg.replaceAll('\n', ', ');
            errorMsg = errorMsg.replaceAll('\r', ', ');
            errorMsg = errorMsg.replaceAll('\t',' ');
            req.setBody(' {"metadata":{"active" : "' + activeStatus + '", "errorConditionFormula" : "' +  errorForm + '", "errorMessage" : "' + errorMsg + '"} }');
            
            
            System.debug('!! condition formula: ' + JSON.serialize(errorForm));
            
            system.debug('!!Body: ' + JSON.serialize(req.getBody()));
            
            req.setMethod('GET');
            
            Http h = new Http();
            HttpResponse res = h.send(req);
            system.debug('!!res: ' + res);
            
            if(res.getStatusCode() != 200 && res.getStatusCode() != 204){
                throw new QueryValidationRulesException(res.getStatus() + ', code: ' + res.getStatusCode() + ', ' + res.getBody());
            }else{
                success=true;
            }
            
        } catch (Exception ex){
            SystemExceptionLogger.fireSystemExceptionLogEvent (ex, 'QueryValidationRules', 'queryValidationRules', 
                                                               SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, ex.getMessage(), 'ValidationRule', validId, false);
        }
        
        return success;
    }   
    
    

    
    

    /*
    * Method methodName
    *  Purpose: reactivates validation Rules after post refresh batch has finished. Queries info (Validation rule Ids) from custom settings
    * @params: rules - list of custom setting records that contain Ids to validation rules that have been shut off
    * 		   active - boolean to set validation rule to active or inactive
    * 		   doDelete - boolean to determine to delete validation rules
    */
    public static void updateRules(List<Active_Validation_Rule_Ids__c> rules, boolean active, boolean doDelete){
        boolean wasSuccess = false;
        
        for(Active_Validation_Rule_Ids__c rule : rules){
            wasSuccess = setstatus(rule.vRule_Id__c, active);
        }
        if(doDelete && wasSuccess){
            delete rules;
        }        
    }
}