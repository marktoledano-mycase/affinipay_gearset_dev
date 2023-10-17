public with sharing class VantivUtils 
{
	public class VantivUtilityException extends Exception{}
	
	public static Map<String, sObject> getRequestFields(String action)
	{
		Map<String, sObject> requestFields = new Map<String, sObject>();
		
		/*if('legalentitycreaterequest'.equalsIgnoreCase(action))
		{
			for(vantiv_legalentity__c v : [Select Name, Field_Path__c, Hardcoded_Value__c, Is_Branch_Node_End__c, Is_Branch_Node_Start__c, Is_Child_Node__c, Part_of_a_Subquery__c, Sequence__c, Tag_Name__c, 
												Is_Required__c, Error_Message__c from vantiv_legalentity__c order by Sequence__c ASC])
												{
													requestFields.put(v.Name, v);
												}
		}
		else if('subMerchantCreateRequest'.equalsIgnoreCase(action))
		{
			for(vantiv_submerchant__c v : [Select Name, Field_Path__c, Hardcoded_Value__c, Is_Branch_Node_End__c, Is_Branch_Node_Start__c, Is_Child_Node__c, Part_of_a_Subquery__c, Sequence__c, Tag_Name__c, 
												Is_Required__c, Error_Message__c from vantiv_submerchant__c order by Sequence__c ASC])
												{
													requestFields.put(v.Name, v);
												}
		}
		else if('legalEntityUpdateRequest'.equalsIgnoreCase(action))
		{
			for(vantiv_legalentityupdate__c v : [Select Name, Field_Path__c, Hardcoded_Value__c, Is_Branch_Node_End__c, Is_Branch_Node_Start__c, Is_Child_Node__c, Part_of_a_Subquery__c, Sequence__c, Tag_Name__c, 
												Is_Required__c, Error_Message__c from vantiv_legalentityupdate__c order by Sequence__c ASC])
												{
													requestFields.put(v.Name, v);
												}
		}
		else if('subMerchantUpdateRequest'.equalsIgnoreCase(action))
		{
			for(vantiv_submerchantupdate__c v : [Select Name, Field_Path__c, Hardcoded_Value__c, Is_Branch_Node_End__c, Is_Branch_Node_Start__c, Is_Child_Node__c, Part_of_a_Subquery__c, Sequence__c, Tag_Name__c, 
												Is_Required__c, Error_Message__c from vantiv_submerchantupdate__c order by Sequence__c ASC])
												{
													requestFields.put(v.Name, v);
												}
		}*/
		String name = 'Vantiv_'+action+'__c';
		Schema.sObjectType type= Schema.getGlobalDescribe().get(name);
		Schema.DescribeSObjectResult result = type.getDescribe();
		sObject result1 = type.newSobject();
		System.debug(result.getName());
		String soql = 'Select Name, Field_Path__c, Hardcoded_Value__c, Is_Branch_Node_End__c, Is_Branch_Node_Start__c, Is_Child_Node__c, Part_of_a_Subquery__c, Sequence__c, Tag_Name__c, Is_Required__c, Error_Message__c from '+name+'  order by Sequence__c ASC ';
		System.debug('SOQL for custom settings '+soql);
		for(sObject v : Database.query(soql))
		{
			requestFields.put((String) v.get('Name'), v);
		}

		if(requestFields.isEmpty())
		{
			throw new VantivUtilityException('No Request custom settings found for '+action);
		}
		
		return requestFields;
	}
	
	public static Boolean isNullOrBlank(String text)
	{
		return String.isBlank(text);
	}
	
	public static String extractRelatedField(String path, sObject record) {
		String retVal;
		try {
			if (path.indexOf('.') >= 0) {             
				String[] parts = path.split('\\.', 2);
				return VantivUtils.extractRelatedField(parts[1], record.getSObject(parts[0]));
			} else {
				retval = String.ValueOf(record.get(path));
			}
		} catch (SObjectException soe) {
			log.error('***** ERROR ***** : Caught an SObjectException while trying to extract a related field. Record given was not queried with appropriate fields', soe, '****ERROR****');
			retval = null;
			throw soe;
		}
		return retVal;
	}
	
	public static String vantivFormat(String fieldName, String data) {
		if (data == null || data.trim() == '') {
			return data;
		}
		String lowercase = fieldName.toLowerCase();
		if (lowercase.containsIgnoreCase('stateprovince')) {
			return data.substring(0, 2);
		}  else if (lowercase.endsWith('dateofbirth') && data != null) {
			return formatDate(data);
		} else if ((lowercase == 'taxid' || lowercase.containsIgnoreCase('contactphone') || lowercase == 'ssn' || lowercase == 'customerServiceNumber') && data != null) {
			return formatNumber(data);
		} else if (lowercase == 'legalentityname' && data != null) {
			return formatCustomerName(data);
		} else if(lowercase == 'yearsinbusiness' && data!= null){
			return yearsInBusiness(data);
		} else if('legalentitytype'.equalsIgnoreCase(lowercase) && data!= null){
			return formatLegalEntiryType(data);
		} else if ('legalEntityOwnershipType'.equalsIgnoreCase(lowercase) && data!= null){
			return formatLegalEntityOwnerhipType(data);
		}else if('streetAddress1'.equalsIgnoreCase(lowercase) && data!= null){
			return formatNewLine(data);
		} else if('merchantCategoryCode'.equalsIgnoreCase(lowercase)){
			return getMCC(VantivIntegrationService.recordType);
		} else if('feeProfile'.equalsIgnoreCase(lowercase)){
			return getFeeProfile(VantivIntegrationService.recordType);
		} else if('hasAcceptedCreditCards'.equalsIgnoreCase(lowercase)){
			return getTrueFalse(data);
		}else if('hardCodedBillingDescriptor'.equalsIgnoreCase(lowercase)){
			//R165120: Prefix of MYC* on the Account DBA Name coming over
			String val = 'MCP*' + data;
			//String val = 'MYC*' + data;
			return getSubString(val, 25);
		//R164550: Truncating value to meet character limit requirement of Vantiv			
		}else if('merchantName'.equalsIgnoreCase(lowercase)){
			return getSubString(data, 50);
		}
		else {
			return data;
		}
	}
	
	public static Vantiv_Audit_Logs__c createAuditLog(Id id, String status, String message, string rawResponse, string callType, string applicationType, Boolean isValuePlus)
	{
		Vantiv_Audit_Logs__c log = new Vantiv_Audit_Logs__c();
		if(isValuePlus)
		{
			log.ValuePlus__c = id;
		}
		else
		{
			log.Bank_Account__c = id;
		}
		log.Status__c = status;
		log.Message__c = message;
		log.Raw_Response__c = rawResponse;
		log.Call_Type__c = callType;
		log.Applicaion_Type__c = applicationType;
		
		return log;
	}
	
	public static String formatLegalEntiryType(String data)
	{
		Map<String,vantiv_entitytype__c> mapLegalEntityType = vantiv_entitytype__c.getAll();
		sObject x = mapLegalEntityType.get(data);
		if(x!=null && (String)x.get('Value__c') != null)
		{
			return (String)x.get('Value__c');
		}
		throw new VantivUtilityException('Unable to find corresponding vantiv value for ownership type '+data);
	}

	public static String formatLegalEntityOwnerhipType(String data)
	{
		Map<String,vantiv_entitytype__c> mapLegalEntityType = vantiv_entitytype__c.getAll();
		sObject x = mapLegalEntityType.get(data);
		if(x!=null && (String)x.get('EntityOwnershipType__c') != null)
		{
			return (String)x.get('EntityOwnershipType__c');
		}
		throw new VantivUtilityException('Unable to find corresponding vantiv EntityOwnershipType for ownership type '+data);
	}
	
	public static String yearsInBusiness(String data)
	{
		Integer y = Integer.valueOf(data);
		return (Date.today().year() - y).format(); 
	}
	
	public static String formatCustomerName(String x) {
		if (x.length() > 50) {
			return x.substring(0, 49);
		} else {
			return x;
		}
	}
	
	public static String formatNumber(string input) {
		return input.replaceAll('[^0-9]+', '');
	}
	
	public static String formatDate(string input) {
		Date d = Date.valueOf(input);
		return DateTime.newInstance(d.year(),d.month(),d.day()).format('YYYY-MM-dd');
	}
	
	public static String formatNewLine(string input) {
		input = input.replace('\r\n', ' ');
		input = input.replace('\n', ' ');
		input = input.replace('\r', ' ');
		
		return input;
	}
	
	/**
	 * Enforces that the final character of a string is /
	 * @param  input inputString
	 * @return       String with / at the end
	 */
	public static String ensureTrailingSlash(String input) {
		if (!input.endsWith('/')) {
			input = input + '/';
		}
		return input;
	}
	
	public static String getEndPoint(String endPoint, String action, String legalEntityId, String subMerchantId)
	{
		if(action.containsIgnoreCase('submerchant') || action.containsIgnoreCase('retrieve')  || action.containsIgnoreCase('update'))
		{
			endpoint = VantivUtils.ensureTrailingSlash(endpoint)+legalEntityId;
			if(action.containsIgnoreCase('submerchant'))
			{
			  endpoint = VantivUtils.ensureTrailingSlash(endpoint) +'submerchant';
			}
		}
		if(subMerchantId != null)
		{
			endpoint = VantivUtils.ensureTrailingSlash(endpoint)+subMerchantId;
		}
		return endpoint;
	}
	
	public static String getMCC(String recordType)
	{
		vantiv_integration__c v = vantiv_integration__c.getInstance(recordType);
		if(v != null)
		{
			return v.Merchant_Category_Code__c;
		}
		else
		{
			throw new VantivUtilityException('Unable to retrieve Merchant Category Code for record type '+recordType);
		}
	}
	
	public static String getFeeProfile(String recordType)
	{
		vantiv_integration__c v = vantiv_integration__c.getInstance(recordType);
		if(v != null)
		{
			return v.Fee_Profile__c;
		}
		else
		{
			throw new VantivUtilityException('Unable to retrieve Merchant Category Code for record type '+recordType);
		}
	}
	
	public static String getTrueFalse(String input)
	{
		if('Yes'.equalsIgnoreCase(input)){return 'true';}
		else if('No'.equalsIgnoreCase(input)){return 'false';}
		return null;
	}
	
	public static String getSubString(String input, Integer length)
	{
		return input.left(length);
	}

}