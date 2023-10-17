/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This is the class containing the methods to facilitate the Vantiv/WorldPay Integration.
* 
* @test           VantivRequestBuilderTest
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Rohit Malik
* @version        1.0
* @created        2016-02-23
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* v1.0            rohit.malik@appfolio.com
* 2016-02-23      Initial Create
*
* v1.1			  vijay.reddy@appfolio.com
* 2019-10-11	  Added logic to facilitate AMEX OptBlue functionality
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
public with sharing class VantivRequestBuilder 
{
	public class VantivRequestBuilderException extends Exception {}
	
	public static String createRequestBody(String action, Id id)
	{
		 Map<String, sObject> requestFields = VantivUtils.getRequestFields(action);
		 ValuePlus__c record = getRecord(requestFields, action, Id);
		 
		 System.debug('Value Plus record for request '+record);
		 
		 VantivIntegrationService.recordType = record.recordType.Name;
		 VantivIntegrationService.legalEntityId = record.Vantiv_Legal_Entity_Id__c;
		 
		 VantivRequestValidation.validate(record, requestFields, action);
		 
		 String requestBody = BuildRequestBodyFromRecord(requestFields, record, action);
		 
		 return requestBody;
		 
	}

	public static String createPrincipalRequestBody(String action, Id id)
	{
		 Map<String, sObject> requestFields = VantivUtils.getRequestFields(action);
		 ValuePlus__c record = getRecord(requestFields, action, Id);
		 System.debug('Value Plus record for request '+record);
		 VantivIntegrationService.recordType = record.recordType.Name;
		 VantivIntegrationService.legalEntityId = record.Vantiv_Legal_Entity_Id__c;
		 
		 VantivRequestValidation.validate(record, requestFields, action);
		 
		 String requestBody = BuildRequestBodyFromRecord(requestFields, record, action);
		 
		 return requestBody;
		 
	}
	
	public static String createSubMerchantRequestBody(String action, Id id)
	{
		 Map<String, sObject> requestFields = VantivUtils.getRequestFields(action);
		 
		 Bank_Account__c record = getBankRecord(requestFields, action, Id);
		 
		 System.debug('Value Plus record for request '+record);
		 
		 VantivIntegrationService.recordType = record.ValuePlus__r.recordType.Name;
		 VantivIntegrationService.legalEntityId = record.ValuePlus__r.Vantiv_Legal_Entity_Id__c;
		 VantivIntegrationService.subMerchantId = record.Vantiv_Sub_Merchant_Id__c;
		 
		 VantivRequestValidation.validate(record, requestFields, action);
		 
		 String requestBody = BuildRequestBodyFromRecord(requestFields, record, action);
		 
		 return requestBody;
		 
	}
	
	public static String createGetRequestBody(String action, Id id)
	{
		if(action.containsIgnoreCase('submerchant'))
		{
			 Bank_Account__c record = getBankRecord(null, action, Id);
			  VantivIntegrationService.recordType = record.ValuePlus__r.recordType.Name;
		 	  VantivIntegrationService.legalEntityId = record.ValuePlus__r.Vantiv_Legal_Entity_Id__c;
		 	  VantivIntegrationService.subMerchantId = record.Vantiv_Sub_Merchant_Id__c;
		}
		else
		{
			ValuePlus__c record = getRecord(null, action, Id);
			VantivIntegrationService.recordType = record.recordType.Name;
			VantivIntegrationService.legalEntityId = record.Vantiv_Legal_Entity_Id__c;
		}
		return null;
	}
	
	public static ValuePlus__c getRecord(Map<String, sObject> requestFields, String action, Id id)
	{
		String query = BuildQueryFromRequestFields(requestFields, action);
		query += 'From ValuePlus__c where recordType.Name like \'%Payments%\' and Id =\''+id+'\'';
		System.debug('query is '+query);
		return Database.query(query);
	}
	
	public Static Bank_Account__c getBankRecord(Map<String, sObject> requestFields, String action, Id id) {
        String query = BuildQueryFromRequestFields(requestFields, action); 
        query += 'FROM Bank_Account__c WHERE Id = \'' + id + '\' LIMIT 1';
        Bank_Account__c b = Database.query(query);
        return b;
    }
    
	public static string BuildQueryFromRequestFields(Map<String, sObject> requestFields, String action)
	{
		String query = 'SELECT ';
        String subQuery = '(SELECT ';
        Boolean hasSubquery = false;
        if(requestFields != null){
        for (String f : requestFields.keyset()) {
            sObject x = requestFields.get(f);
            Boolean dealtWith = false;
            try {
            	if((Boolean)x.get('Is_Branch_Node_Start__c') || (Boolean)x.get('Is_Branch_Node_End__c'))
            	{
            		continue;
            	}
                if (x.get('Part_of_a_Subquery__c') != null && (Boolean)x.get('Part_of_a_Subquery__c')) {
                    dealtWith = true;
                    hasSubquery = true;
                    String fp = (String) x.get('Field_Path__c');
                    String[] parts = fp.split('\\.', 2);
                    subQuery += parts[1] + ', ';
                }
            } catch (NullPointerException npe) {
                System.debug(npe.getMessage());
            } catch (Exception e) {
                system.debug(e.getMessage());
            }
            if (!query.contains((string) x.get('Field_Path__c')) && !dealtWith) {
                query += (string) x.get('Field_Path__c') + ', ';
            }
        }}
        if (hasSubquery) {
            query += subQuery + 'Name, CreatedDate, Vantiv_Sub_Merchant_Id__c, Vantiv_Bank_Account_Onboarding_Status__c FROM Bank_Accounts__r WHERE Status__c != \'Inactive\' ORDER BY CreatedDate DESC), Vantiv_Legal_Entity_Id__c, Vantiv_Onboarding_Status__c ';
        }
        else if(action.containsIgnoreCase('submerchant'))
        {
            query += 'Name, ValuePlus__r.recordTypeId, ValuePlus__r.recordType.Name, ValuePlus__r.Vantiv_Legal_Entity_Id__c, ValuePlus__r.Vantiv_Onboarding_Status__c, ValuePlus__r.AMEX_OptBlue__c, Vantiv_Sub_Merchant_Id__c, Vantiv_Bank_Account_Onboarding_Status__c '; 
        }
        else
        {
            query += 'Name, recordType.Name, Vantiv_Legal_Entity_Id__c, Vantiv_Onboarding_Status__c ';
        }
        return query;
	}
	
	public static String BuildRequestBodyFromRecord(Map<String, sObject> requestFields, sObject record, String action)
	{
		String requestBody='';
		vantiv_rootelement__c root =  vantiv_rootelement__c.getInstance(action);
		if(root == null)
		{
			throw new VantivRequestBuilderException('Invalid root element for action '+action);
		}
		
		Xmlstreamwriter req = new Xmlstreamwriter();
		req.writeStartDocument('utf-8','1.0');
		req.writeStartElement(null,root.Root_Element__c, null);
		req.writeDefaultNamespace(root.Attribute_Value__c);
		for(String fsm : requestFields.keyset())
		{
			
			sObject x = requestFields.get(fsm);
			System.debug('Tag Name '+(String)x.get('Tag_Name__c'));
			Boolean isSub = (Boolean)x.get('Part_of_a_Subquery__c');
			Boolean isBranchNodeStart = (Boolean)x.get('Is_Branch_Node_Start__c');
			Boolean isBranchNodeEnd = (Boolean)x.get('Is_Branch_Node_End__c');
			Boolean isRequired = (Boolean)x.get('Is_Required__c');
			if(isBranchNodeStart)
			{
				vantiv_rootelement__c attribute = vantiv_rootelement__c.getInstance((String)x.get('Tag_Name__c'));
				req.writeStartElement(null, (String)x.get('Tag_Name__c'), null);
				if(attribute != null)
				{
					if(attribute.name.equalsIgnoreCase('amexAcquired')){
						req.writeAttribute(null, null, attribute.Attribute_Name__c, VantivUtils.extractRelatedField((String) attribute.Attribute_Value__c, record));
					} else{
						req.writeAttribute(null, null, attribute.Attribute_Name__c, attribute.Attribute_Value__c);
					}
				}
			}
			else if(isBranchNodeEnd)
			{
				req.writeEndElement();
			}
			else if(isSub != null && isSub)
			{
				if (x.get('Hardcoded_Value__c') != null && x.get('Hardcoded_Value__c') != '')
				{
					if(VantivUtils.vantivFormat(fsm,(String) x.get('Hardcoded_Value__c')) != null)
					{
						req.writeStartElement(null, (String)x.get('Tag_Name__c'), null);
						req.writeCharacters(VantivUtils.vantivFormat(fsm,(String) x.get('Hardcoded_Value__c')));
						req.writeEndElement();
					}
				}
				else
				{
					/*String fp = (String) x.get('Field_Path__c');
                	String[] parts = fp.split('\\.', 2);
                	req.writeStartElement(null, (String)x.get('Tag_Name__c'), null);
                	req.writeCharacters(Vantiv_Utils.extractRelatedField(parts[1], record.Bank_Accounts__r[i]));
                	req.writeEndElement();
                	*/
				}
			}
			else if (x.get('Hardcoded_Value__c') != null && x.get('Hardcoded_Value__c') != '')
			{
				req.writeStartElement(null, (String)x.get('Tag_Name__c'), null);
				if(VantivUtils.vantivFormat(fsm,(String) x.get('Hardcoded_Value__c')) != null)
				{
					req.writeCharacters(VantivUtils.vantivFormat(fsm,(String) x.get('Hardcoded_Value__c')));
				}
				req.writeEndElement();
			}
			else
			{
				if(VantivUtils.extractRelatedField((String) x.get('Field_Path__c'), record) != null)
				{
					String value = VantivUtils.vantivFormat(fsm,VantivUtils.extractRelatedField((String) x.get('Field_Path__c'), record));
					if(!isRequired && VantivUtils.isNullOrBlank(value))
					{
						continue;
					}
					req.writeStartElement(null, (String)x.get('Tag_Name__c'), null);
					req.writeCharacters(value);
					req.writeEndElement();
				}
			}
			System.debug(LoggingLevel.ERROR, 'Rohit - Request XML '+req.getXmlString());
		}
		req.writeEndElement();
		requestBody = req.getXmlString();
		System.debug(LoggingLevel.ERROR, 'Rohit 1 - Request XML '+requestBody);
		req.close();
		
		return requestBody;
	}
}