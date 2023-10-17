/******************************************************************************************************
* copyright © 2015
*
* File		: ProfitStarsUtils.cls
*
* Purpose	: This is a Utility class. This class is used to retrieve configs, create logs and emails
*
* Referred from 	: 10+ Classes
*
* Test class: ProfitStarsUtilsTest
*-----------------------------------------------------------------------------
*
*Release Date		Request 	Updated By			Description
*----------------------------------------------------------------------------------------------------------------------
*06/24/2015			Nill							Initial Creation
*07/21/2015			R151866		Venkat Araveeti		MyCase Integration
*08/28/2015			R152441		Venkat Araveeti		Create a method to read auto approval response from ProfitStars
*09/29/2015			R152543		Venkat Araveeti		Updated other call type to send dynamic subject, description
*******************************************************************************************************/

public with sharing class ProfitStarsUtils{

	public class PSUtilsException extends exception{}
	/*
	  ALL METHODS STATIC
	 */
	
	public static ProfitStarsIntegration__c getConfig(String application, String product){
		String config = application;
		System.debug('BizSys : Application Product ' + application + ' -- ' + product);
		if(application != null && product != null){
			config = application+' '+product;
		}

		Map<String, ProfitStarsIntegration__c> configOptions = ProfitStarsIntegration__c.getAll();
		for(ProfitStarsIntegration__c i : configOptions.values()){
			if(config != null && config.equalsIgnoreCase(i.Name) && i.Active__c){
				System.debug('Reached inside condition');
				return ProfitStarsIntegration__c.getInstance(i.Name);
				break;
			}
		}
		System.debug('Could not Reach inside condition');
		//safety value
		return null;
	}

	/**
	 * Enforces that the final character of a string is /
	 * @param  input inputString
	 * @return       String with / at the end
	 */
	public static String ensureTrailingSlash(String input){
		if(!input.endsWith('/')){
			input = input + '/';
		}
		return input;
	}

	/**
	 * Returns profit stars acceptable formatted string.
	 * @param  input string of text representing phone #
	 * @return       Profit Stars formatted phone string: ###-###-####
	 */
	public static String formatPhoneNumber(String input){
		String y = input.replaceAll('[^0-9]+', ''); // Replace non digit numbers with -
		return y.substring(0, 3) + '-' + y.substring(3, 6) + '-' + y.substring(6);
	}

	/**
	 * Returns Profit Stars acceptable formatted String.
	 * @param  input SSN string, as stored in sfdc
	 * @return       Return formatted as XXX-XX-XXXX
	 */
	public static String formatSSN(String input){
		String digitsOnly = input.replaceAll('[^0-9]+', '');
		return digitsOnly.substring(0, 3) + '-' + digitsOnly.substring(3, 5) + '-' + digitsOnly.substring(5);
	}

	public static String formatDate(string input){
		//return Date.valueOf(input).format();
		return DateTime.valueOf(input).format('yyyy-MM-dd');
	}

	public static String formatTaxId(string input){
		return input.replaceAll('[^0-9]+', '');
	}

	public static String formatWebsiteUrl(String input){
		input = input.toLowerCase();
		string ret;
		try{
			ret = new URL(input).getHost();
		} catch(StringException e){
			if(e.getMessage().toLowerCase().contains('no protocol')){
				ret = new URL('http://' + input).getHost();
			} else{
				string[] y = input.split('/');

				for(string z : y){
					if(z.contains('\\.')){
						string[] a = z.split('\\.');
						a.remove(0);
						ret = String.join(a, '.');
					}
				}
				string[] split = input.split('.', 2);
			}
		}
		return ret.replaceFirst('www.', '');
	}

	public static String formatBoolean(String x){
		return (x.toLowerCase() == 'true') ? '1' : '0';
	}

	public static String formatCustomerName(String x){
		if(x.length() > 50){
			return x.substring(0, 49);
		} else{
			return x;
		}
	}
	
    /*
    *	Request #R152543 - Created this method to retrive encrypted data from records
    *				as the same can't be achieved using formula
    */	
	public static String profitStarsFormat(String fieldName, String data, ValuePlus__c record, String product){
		String lowercase = fieldName.toLowerCase();
		
		if(lowercase == 'description' && data != null){
			String valueFromObject = ProfitStarsUtils.extractRelatedField(data, record, product);
			if(valueFromObject != null){
				return valueFromObject;
			}					
		}
		else{
			return profitStarsFormat(fieldName, data);
		}
		return data;
	}
	
		
	public static String profitStarsFormat(String fieldName, String data){
		if(data == null || data.trim() == ''){
			return data;
		}

		String lowercase = fieldName.toLowerCase();
		if(lowercase == 'state'){
			return data.substring(0, 2);
		} else if(lowercase == 'phonenumber' || lowercase == 'faxnumber' || lowercase == 'customerservicephonenumber' || lowercase == 'primarycontactphonenumber' || lowercase == 'secondarycontactphonenumber'){
			return formatPhoneNumber(data);
		} else if(lowercase == 'websiteurl'){
			return formatWebsiteUrl(data);
		} else if(lowercase.contains('officerssn')){
			return formatSSN(data);
		} else if(lowercase == 'applicationcertificationagreement'){
			return formatBoolean(data);
		} else if(lowercase.endsWith('dob') && data != null){
			return formatDate(data);
		} else if(lowercase == 'federaltaxid' && data != null){
			return formatTaxId(data);
		} else if(lowercase == 'customer_name' && data != null){
			return formatCustomerName(data);
		} else if(lowercase == 'subject' && data != null){										//Request #R152543 - Added to update subject
			return data + ' Change';
		} else{
			return data;
		}
	}

	public static PS_Audit_Log__c generateAuditLogForValuePlus(String action, String errorMessage, String stackTraceString, Id valuePlusId, String applicationType){		//request #R151866 Updated the method to insert application type
		PS_Audit_Log__c l = new PS_Audit_Log__c();
		l.Call_type__c = action;
		l.Error_Message__c = errorMessage;
		l.Raw_Json__c = stackTraceString;
		l.Value_Plus__c = valuePlusId;
		l.Application_Type__c = applicationType;		//request #R151866 Updated the method to insert application type
		return l;
	}

	public static PS_Audit_Log__c generateAuditLogForBankAccount(String action, String errorMessage, String stackTraceString, Id bankAccId, String applicationType){
		PS_Audit_Log__c l = new PS_Audit_Log__c();
		l.Call_type__c = action;
		l.Error_Message__c = errorMessage;
		l.Raw_Json__c = stackTraceString;
		l.BankAccount__c = bankAccId;
		l.Application_Type__c = applicationType;
		return l;
	}

	public static PS_Audit_Log__c generateAuditLogForAccount(String action, String errorMessage, String stackTraceString, Id accountId, String updateField, String applicationType){		//request #R151866 Updated the method to insert application type
		PS_Audit_Log__c l = new PS_Audit_Log__c();
		l.Call_type__c = action;
		if(action == 'Field Update' || action == 'Field Update in Outbound' || action == 'Pre-call Validation' || action == 'Pre-call Validation for Outbound'){
			l.Update_Field__c = updateField;
		}
		l.Error_Message__c = errorMessage;
		l.Raw_Json__c = stackTraceString;
		l.Account__c = accountId;
		l.Application_Type__c = applicationType;		//request #R151866 Updated the method to insert application type
		return l;
	}

	public static void createAuditLog(String action, Id valuePlus, String response, String faultCode, String applicationType){			//request #R151866 Updated the method to insert application type
		PS_Audit_Log__c log = new PS_Audit_Log__c();
		log.Call_type__c = action;
		log.Error_Message__c = faultCode;
		log.Raw_Json__c = response;
		log.Value_Plus__c = valuePlus;
		log.Application_Type__c = applicationType;			//request #R151866 Updated the method to insert application type
		String jsonTxt = JSON.serialize(log);
		ProfitStarsUtils.writeAuditLog(jsonTxt);
	}

	public static void createAuditLogInRealtime(String action, Id valuePlus, String response, String faultCode, String applicationType){			//request #R151866 Updated the method to insert application type
		PS_Audit_Log__c logs = new PS_Audit_Log__c();
		logs.Call_type__c = action;
		logs.Error_Message__c = faultCode;
		logs.Raw_Json__c = response;
		logs.Value_Plus__c = valuePlus;
		logs.Application_Type__c = applicationType;			//request #R151866 Updated the method to insert application type
		try{
			insert logs;
		} catch(Exception e){
			System.debug(e.getMessage());
			SystemExceptionLogger.insertSystemExceptionLogEntry(e, 'ProfitStarsUtils', 'createAuditLogInRealtime', SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, e.getMessage(), false);
		}
	}

	/**
	 * Actually persist the audit log sometime in the future.
	 * @param  jsonTxt json encoded string of the object
	 */
	@future @TestVisible
	public static void writeAuditLog(String jsonTxt){
		PS_Audit_Log__c log = (PS_Audit_Log__c) JSON.deserialize(jsonTxt, PS_Audit_Log__c.class);
		try{
			insert log;
		} catch(DmlException e){
			System.debug(e.getMessage());
			SystemExceptionLogger.insertSystemExceptionLogEntry(e, 'ProfitStarsUtils', 'writeAuditLog', SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, e.getMessage(), false);
		}
	}

	/**
	 * prefixes all apex keywords with san_
	 * @param  jsonTxt incoming json string
	 * @return         sanitized json
	 */
	public static String sanitizeJson(String jsonTxt){
		String reservedWordsString = 'abstract and array as asc autonomous blob break bulk by catch class commit continue convertcurrency decimal delete desc do else enum exception extends false final finally for from future global if implements insert instanceof interface int last_90_days last_month last_n_days last_week like limit list long map merge new next_90_days next_month next_n_days next_week not null nulls on or override package private protected public return rollback savepoint select set sort static super system testmethod this this_week throw today tolabel tomorrow trigger true try undelete update upsert using virtual webservice where while yesterday';
		String[] reservedWords = reservedWordsString.split(' ');

		for(String rw : reservedWords){
			if (jsonTxt.contains(rw)){
				jsonTxt = jsonTxt.replaceAll('"' + rw + '"', '"san_' + rw + '"');
			}
		}
		return jsonTxt;
	}

	/**
	 * Returns the list of fieldSetMembers that corespond to the call being made.
	 * @param  call a string representing the call being made, that coresponds to the fieldset
	 * @return      List of Fields in the fieldset OR NULL.
	 */
	public static Map<String, sObject> getRequiredFieldsForCall(String call){
		Map<String, sObject> requiredFields;

		if(call.toLowerCase() == 'bank account'){
			requiredFields = ps_bank_account__c.getAll();
		} else if(call.toLowerCase() == 'field update' || call.toLowerCase() == 'ownership update'){
			requiredFields = ps_field_update__c.getAll();
		} else if(call.toLowerCase() == 'location'){
			requiredFields = ps_location__c.getAll();
		} else if(call.toLowerCase() == 'velocity'){
			requiredFields = ps_velocity__c.getAll();
		} else if(call.toLowerCase() == 'enrollment'){
			requiredFields = ps_enrollment__c.getAll();
		} else if(call.toLowerCase() == 'midlid'){
			requiredFields = ps_mid_lid__c.getAll();
		}

		if(requiredFields == null){
			throw new PSUtilsException('Unable to pull field mappings for this call from custom setting ' + call);
		}
		return requiredFields;
	}

	public static String extractRelatedField(String path, sObject record, String product){
		String retVal;
		String actualPath = path;

		if(product != null && product == 'echeck'){
			List<profitstars_echeck_fields__c> replacementFields = profitstars_echeck_fields__c.getAll().values();
			Map<String, String> fieldMap = new Map<String, String>();

			for(profitstars_echeck_fields__c field : replacementFields){
				fieldMap.put(field.ActualField__c, field.replacement_field__c);
			}
			System.debug('The product is echeck '+fieldMap.get(ProfitStarsUtils.formatCustomSettingName(actualPath)));
			if(fieldMap.get(ProfitStarsUtils.formatCustomSettingName(actualPath)) != null){
				actualPath = fieldMap.get(ProfitStarsUtils.formatCustomSettingName(actualPath));
			}			
		}

		try{
			if(actualPath.indexOf('.') >= 0){             // ex: ValuePlus:Account__r.Name
				String[] parts = actualPath.split('\\.', 2);  // [Account__r, Name]
				return ProfitStarsUtils.extractRelatedField(parts[1], record.getSObject(parts[0]), product);
			} else{
				retval = String.ValueOf(record.get(actualPath));
			}
		} catch(SObjectException soe){
			log.error('***** ERROR ***** : Caught an SObjectException while trying to extract a related field. Record given was not queried with appropriate fields', soe, '****ERROR****');
			retval = null;
			throw soe;
		}
		return retVal;
	}

	public static void log(String tag, object x){
		System.debug('\n\n\n###########################################\n' + tag + ': ' + x + '\n###########################################\n\n\n');
	}
	
	/*
		request #R151866 added to send failure email if the email address is available in
		profit stars integration configuration
	*/
	public static void sendErrorEmail(ValuePlus__c valuePlus, String requestType, String errorMessage, String stackTrace, String product){
	  // Step 1: Create a new Email
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    
      // Step 2: Set list of people who should get the email
      List<String> sendTo = new List<String>();
      ProfitStarsIntegration__c integration = ProfitStarsUtils.getConfig(valuePlus.recordType.Name, product);
      if((String)integration.get('ProfitStar_Error_Email__c') != null){
		   String emailAddress = (String) integration.get('ProfitStar_Error_Email__c');
		   sendTo.add(emailAddress);
	       mail.setToAddresses(sendTo);
	       
	       // Step 3: Set who the email is sent from
	       mail.setReplyTo(System.Label.Salesforce_Support_Email);
	       mail.setSenderDisplayName('Salesforce Support');
	       
	       // (Optional) Set list of people who should be CC'ed
	     /* List<String> ccTo = new List<String>();
	      ccTo.add();
	      mail.setCcAddresses(ccTo); */
	      
	      // Step 4. Set email contents - you can use variables!
	      
	      mail.setSubject('Profit stars '+requestType+' request failed for '+valuePlus.Account__r.Name);
	      
	      String body = 'Hello,';
	      body += '<br><br> Profit Stars Update failed for value plus record '+System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+valuePlus.Id;
	      body += '<br><br> <b>Error Message	: </b>'+errorMessage;
	      body += '<br><br> <b>Exception	: </b>\n'+stackTrace;
	
		  mail.setHtmlBody(body);
		  mail.setSaveAsActivity(false);
	      System.debug('the email sample is '+ mail);
	      
	      if(!Test.isRunningTest()){
		      Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
		  }
		}
	}
	/*
		request #R151866 added to send failure email if the email address is available in
		profit stars integration configuration
	*/
	public static void sendAddOnErrorEmail(Bank_Account__c bankAccount, String requestType, String errorMessage, String stackTrace, String product){
	  // Step 1: Create a new Email
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    
      // Step 2: Set list of people who should get the email
      List<String> sendTo = new List<String>();
      ProfitStarsIntegration__c integration = ProfitStarsUtils.getConfig(bankAccount.ValuePlus__r.recordType.Name, product);
      if((String)integration.get('ProfitStar_Error_Email__c') != null){
		   String emailAddress = (String) integration.get('ProfitStar_Error_Email__c');
		   sendTo.add(emailAddress);
	       mail.setToAddresses(sendTo);
	       
	       // Step 3: Set who the email is sent from
	       mail.setReplyTo(System.Label.Salesforce_Support_Email);
	       mail.setSenderDisplayName('Salesforce Support');
	       
	       // (Optional) Set list of people who should be CC'ed
	     /* List<String> ccTo = new List<String>();
	      ccTo.add();
	      mail.setCcAddresses(ccTo); */
	      
	      // Step 4. Set email contents - you can use variables!
	      
	      mail.setSubject('Profit stars '+requestType+' request failed for '+bankAccount.ValuePlus__r.Account__r.Name);
	      
	      String body = 'Hello,';
	      body += '<br><br> Profit Stars Update failed to add bank account record '+System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+bankAccount.Id;
	      body += '<br><br> <b>Error Message	: </b>'+errorMessage;
	      body += '<br><br> <b>Exception	: </b>\n'+stackTrace;
	
		  mail.setHtmlBody(body);
		  mail.setSaveAsActivity(false);
	      System.debug('the email sample is '+ mail);
	      
	      if(!Test.isRunningTest()){
		      Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
		  }
		}
	}
	
	public static void fetchBankAccountToUpdate(Bank_Account__c ba, String response){
		List<String> exceptions = new List<String>();

		ps_GuidResp.GetLocationByLocationNameResults parseResult = (ps_GuidResp.GetLocationByLocationNameResults) System.JSON.deserialize(response, ps_GuidResp.GetLocationByLocationNameResults.class);

		if(parseResult != null && parseResult.getLocationByLocationName != null && parseResult.getLocationByLocationName.getLocationByLocationNameResult != null){
			try{
				Integer statusCode = Integer.valueOf(parseResult.httpStatusCode.trim());
				if(200 == statusCode && parseResult.getLocationByLocationName.getLocationByLocationNameResult.locationId != null){
					ba.Location_Add_Status__c = 'Approved';
					ba.LID__c = parseResult.getLocationByLocationName.getLocationByLocationNameResult.locationId.trim();
				} else{
					ba.Location_Add_Status__c = 'Submitted';
				}
				ba.ps_LocationUpdateRequired__c = false;
				ba.Ready_for_push_to_ProfitStars__c = false;
			} catch(Exception e){
				ba.Location_Add_Status__c = 'Submitted';
				ba.Ready_for_push_to_ProfitStars__c = false;
				exceptions.add('An unexpected error occurred while reading response from Profitstars ' + '\r\n' + parseResult);
				SystemExceptionLogger.insertSystemExceptionLogEntry(e, 'ProfitStarsUtils', 'fetchBankAccountToUpdate', SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, e.getMessage(), false);
			}
		} else{
			ba.Location_Add_Status__c = 'Submitted';
			ba.Ready_for_push_to_ProfitStars__c = false;

			if(parseResult != null && parseResult.errorMessage != null){
				exceptions.add('The following error occurred while retriving the LID from Profitstars: '+ '\n' + parseResult.errorMessage);
			} else{
				exceptions.add('Unable to read results from profitstars!');
			}
		}

		System.debug('the bank account to update is ' + ba);
		if(exceptions.size() > 0){
			throw new PSUtilsException(exceptions[0]);
		}
	}

	public static void fetchBankAccountToUpdateOutbound(Bank_Account__c ba, String response){

		List<String> exceptions = new List<String>();

		ps_GuidResp.GetLocationByLocationNameResults parseResult = (ps_GuidResp.GetLocationByLocationNameResults) System.JSON.deserialize(response, ps_GuidResp.GetLocationByLocationNameResults.class);

		if(parseResult != null && parseResult.getLocationByLocationName != null && parseResult.getLocationByLocationName.getLocationByLocationNameResult != null){
			try{
				Integer statusCode = Integer.valueOf(parseResult.httpStatusCode.trim());
				if(200 == statusCode && parseResult.getLocationByLocationName.getLocationByLocationNameResult.locationId != null){
					ba.Outbound_LID__c = parseResult.getLocationByLocationName.getLocationByLocationNameResult.locationId.trim();
					ba.Outbound_Location_Add_Status__c = 'Approved';
				}
				else{
					ba.Outbound_Location_Add_Status__c = 'Submitted';
				}
			} catch(Exception e){
				ba.Outbound_Location_Add_Status__c = 'Submitted';
				exceptions.add('An unexpected error occurred while reading response from Profitstars ' +'\r\n' + parseResult);
				SystemExceptionLogger.insertSystemExceptionLogEntry(e, 'ProfitStarsUtils', 'fetchBankAccountToUpdateOutbound', SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, e.getMessage(), false);
			}
		}
		else{
			ba.Outbound_Location_Add_Status__c = 'Submitted';
			
			if(parseResult != null && parseResult.errorMessage != null){
				exceptions.add('The following error occurred while retriving the outbound LID from Profitstars: '+ '\n' + parseResult.errorMessage);
			} else{
				exceptions.add('Unable to read results from profitstars!');
			}
		}

		System.debug('the bank account to update is ' + ba);
		if(exceptions.size() > 0){
			throw new PSUtilsException(exceptions[0]);
		}
	}
	
	public static String formatCustomSettingName(String input){
		return input.replaceAll('[.]+', '');
	}

	public static String sendToAWSQueue(String recordId, String operation){
		ps_eCheckButtonMethods.buttonResult res = new ps_eCheckButtonMethods.buttonResult();
		AwsSQSImplementation.AwsMessageWrapper msgWrapper = new AwsSQSImplementation.AwsMessageWrapper();
		msgWrapper.recordId = recordId;
		msgWrapper.operation = operation;
		try{
			AwsSQSImplementation.sendMessageToPSQueue(JSON.Serialize(msgWrapper));
			res.didPass = true;
			res.result = 'success';
		} catch(AwsBase.AWSServiceException ex){
			SystemExceptionLogger.fireSystemExceptionLogEvent(ex, 'sendToAWSQueue', 'AWSServiceException', SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, ex.getMessage(), 'ValuePlus__c', recordId, false);
			PSUtilsException vpException = new PSUtilsException(ex.getMessage());
			vpException.setMessage(ex.getMessage());
			throw vpException;
		}
		return JSON.serialize(res);
	}
}