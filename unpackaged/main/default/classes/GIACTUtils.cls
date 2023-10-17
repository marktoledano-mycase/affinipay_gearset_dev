/**********************************************************************************************************************
* copyright © 2017
* File      : GIACTUtils.cls
* Purpose   : The main purpose of this class is to provide all the utility functions. 
* 
*
*
* @author Rohit Kumar Malik
* @version 1.0
* @since 2017-10-20
**********************************************************************************************************************/
global with sharing class GIACTUtils {
	public class GIACTUtilsException extends exception {}

	/**
	 * Enforces that the final character of a string is /
	 * @param  input inputString
	 * @return       String with / at the end
	 */	 
	Public Static String ensureTrailingSlash(String input) {
		if (!input.endsWith('/')) {
			input = input + '/';
		}
		return input;
	}

	/**
	 * Returns GIACT acceptable formatted String.
	 * @param  input SSN string, as stored in sfdc
	 * @return       Return formatted as XXX-XX-XXXX
	 */ 
	Public static String formatTaxId(string input) {
		return input.replaceAll('[^0-9]+', '');
	}
			
	Public Static String giactFormat(String fieldName, String data) {
		
		if (String.isEmpty(data) || String.isEmpty(data.trim())) {
			return data;
		}

		String lowercase = fieldName.toLowerCase();

		if (lowercase == 'state') {
			return data.substring(0, 2);
		} else if (lowercase == 'TaxId' && data != null) {
			return formatTaxId(data);
		} else {
			return data;
		}
	}

	Public Static String sanitizeJson(String jsonTxt) {
		String reservedWordsString = 'abstract and array as asc autonomous blob break bulk by catch class commit continue convertcurrency decimal delete desc do else enum exception extends false final finally for from future global if implements insert instanceof interface int last_90_days last_month last_n_days last_week like limit list long map merge new next_90_days next_month next_n_days next_week not null nulls on or override package private protected public return rollback savepoint select set sort static super system testmethod this this_week throw today tolabel tomorrow trigger true try undelete update upsert using virtual webservice where while yesterday';
		String[] reservedWords = reservedWordsString.split(' ');

		for (String rw : reservedWords) {
			if (jsonTxt.contains(rw)) {
				jsonTxt = jsonTxt.replaceAll('"' + rw + '"', '"san_' + rw + '"');
			}
		}
		return jsonTxt;
	}

	public Static Map<String, sObject> getRequiredFieldsForAPMIdentifyCall(String customSettingName, String customerType) {
		Map<String, sObject> requiredFields;
		if (customSettingName.toLowerCase()=='GID APM Business') {
			requiredFields = GID_APM_Business__c.getAll ();
		} else if (customSettingName.toLowerCase()=='GID APM Principal 1') {
			requiredFields = GID_APM_Principal_1__c.getAll ();			
		} else if (customSettingName.toLowerCase()=='GID APM Principal 2') {
			requiredFields = GID_APM_Principal_2__c.getAll ();			
		} else if (customSettingName.toLowerCase()=='GID APM Principal 3') {
			requiredFields = GID_APM_Principal_3__c.getAll ();			
		} else if (customSettingName.toLowerCase()=='GID APM Principal 4') {
			requiredFields = GID_APM_Principal_4__c.getAll ();			
		} else if (customSettingName.toLowerCase()=='GID MyCase Business') {
			requiredFields = GID_MyCase_Business__c.getAll ();			
		} else if (customSettingName.toLowerCase()=='GID MyCase Principal 1') {
			requiredFields = GID_MyCase_Principal_1__c.getAll ();			
		} else if (customSettingName.toLowerCase()=='GID MyCase Principal 2') {
			requiredFields = GID_MyCase_Principal_2__c.getAll ();			
		} else if (customSettingName.toLowerCase()=='GID MyCase Principal 3') {
			requiredFields = GID_MyCase_Principal_3__c.getAll ();			
		} else if (customSettingName.toLowerCase()=='GID MyCase Principal 4') {
			requiredFields = GID_MyCase_Principal_4__c.getAll ();
		}else if (customSettingName.toLowerCase()=='GVF APM Business') {
			requiredFields = GVF_APM_Business__c.getAll ();
		} else if (customSettingName.toLowerCase()=='GVF APM Principal 1') {
			requiredFields = GVF_APM_Principal_1__c.getAll ();			
		} else if (customSettingName.toLowerCase()=='GVF APM Principal 2') {
			requiredFields = GVF_APM_Principal_2__c.getAll ();			
		} else if (customSettingName.toLowerCase()=='GVF APM Principal 3') {
			requiredFields = GVF_APM_Principal_3__c.getAll ();			
		} else if (customSettingName.toLowerCase()=='GVF APM Principal 4') {
			requiredFields = GVF_APM_Principal_4__c.getAll ();			
		} else if (customSettingName.toLowerCase()=='GVF MyCase Business') {
			requiredFields = GVF_MyCase_Business__c.getAll ();			
		} else if (customSettingName.toLowerCase()=='GVF MyCase Principal 1') {
			requiredFields = GVF_MyCase_Principal_1__c.getAll ();			
		} else if (customSettingName.toLowerCase()=='GVF MyCase Principal 2') {
			requiredFields = GVF_MyCase_Principal_2__c.getAll ();			
		} else if (customSettingName.toLowerCase()=='GVF MyCase Principal 3') {
			requiredFields = GVF_MyCase_Principal_3__c.getAll ();			
		} else if (customSettingName.toLowerCase()=='GVF MyCase Principal 4') {
			requiredFields = GVF_MyCase_Principal_4__c.getAll ();
		} else {
			throw new GIACTUtilsException('Automation could not find the valid custom setting name. Please contact the Business Systems team.');
		}

		System.debug('***Custom Setting Name : ' + customSettingName + ' CustomerType ' + customerType + ' ***');
		System.debug('***Retrieving all the gIdentifyInquiry Custom Setting fields*** ' + requiredFields);

		if (requiredFields == null) {
			throw new GIACTUtilsException('Unable to pull field mappings for this call from custom setting ' + customSettingName );
		} 
		System.debug ('***Filetered fields ' + requiredFields);
		return requiredFields;
	}

    /*
    * M6
    */
	Public Static String extractRelatedField(String path, sObject record) {
		String retVal;
		String actualPath = path;

		try {
			if (actualPath.indexOf('.') >= 0) {
				String[] parts = actualPath.split('\\.', 2); 
				return GIACTUtils.extractRelatedField(parts[1], record.getSObject(parts[0]));
			} else {
				retval = String.ValueOf(record.get(actualPath));
			}
			retval = String.ValueOf(record.get(actualPath));
		} catch (SObjectException soe) {
			log.error('***** ERROR ***** : Caught an SObjectException while trying to extract a related field. Record given was not queried with appropriate fields', soe, '****ERROR****');
			retval = null;
			throw soe;
		}
		return retVal;
	}

    public static GiactInquiryResponse__c generateGiactAuditLogForValuePlus(String action, String errorMessage, String stackTraceString, ValuePlus__c vp, String applicationType) {

    	String application = (action.equalsIgnoreCase('gverifyinquiry'))? 'gVerify' : 'gIdentify';

    	// Create the GIACT Inquiry response
		GiactInquiryResponse__c gLog = new GiactInquiryResponse__c ();
		gLog.Application__c = application;
		gLog.ValuePlus__c = vp.id;
        return gLog;
    }

    public static GiactInquiryResponse__c generateGiactAuditLogForBankAccount(String action, String errorMessage, String stackTraceString, Bank_Account__c ba, String applicationType) {

    	String application = (action.equalsIgnoreCase('gverifyinquiry'))? 'gVerify' : 'gIdentify';

    	// Create the GIACT Inquiry response
		GiactInquiryResponse__c gLog = new GiactInquiryResponse__c ();
		gLog.Application__c = application;
		gLog.BankAccount__c = ba.id;

        return gLog;
    }

	public static Attachment saveXMLAsPdf (String text, String fileName) {
		Blob body;
	    try {
	        body = Blob.toPdf(text);
	    } catch (Exception e) {
	        body = Blob.valueOf('Failed to prepare a pdf file.');
	    }
	    return new Attachment (body = body,
								Name = fileName,
								IsPrivate = false);
    }

	public static boolean isReadyToTransmitToGiact (ValuePlus__c vp, Integer counter) {
		Boolean isReady =false;

		if (counter == 0 && !String.isBlank(vp.GIACTBusinessValidation__c) && vp.GIACTBusinessValidation__c.equalsIgnoreCase('Ready To Transmit To GIACT')) {
			isReady = true;
		} else if (counter == 1 && !String.isBlank(vp.GIACTBusinessOwner_1_Validation__c) && vp.GIACTBusinessOwner_1_Validation__c.equalsIgnoreCase('Ready To Transmit To GIACT'))  {
			isReady = true;
		} else if (counter == 2 && !String.isBlank(vp.GIACTBusinessOwner_2_Validation__c) && vp.GIACTBusinessOwner_2_Validation__c.equalsIgnoreCase('Ready To Transmit To GIACT')) {
			isReady = true;
		}  else if (counter == 3 && !String.isBlank(vp.GIACTBusinessOwner_3_Validation__c) && vp.GIACTBusinessOwner_3_Validation__c.equalsIgnoreCase('Ready To Transmit To GIACT')) {
			isReady = true;
		} else if (counter == 4 && !String.isBlank(vp.GIACTBusinessOwner_4_Validation__c) && vp.GIACTBusinessOwner_4_Validation__c.equalsIgnoreCase('Ready To Transmit To GIACT')) {
			isReady = true;
		}
		return isReady;
	}
}