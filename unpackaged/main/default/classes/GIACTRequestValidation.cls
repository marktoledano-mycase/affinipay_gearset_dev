/**********************************************************************************************************************
* copyright © 2017
* File      : GIACTRequestValidation.cls
* Purpose   :  This class validates a set of custom Setting records. Based on the custom setting records this class
* determines, if the all the required fields are available on the SObject record. For eg. if The custom setting is
* gVerify and The SObject is Bank Account. Then it validates if all the Required fields on the Custom Setting is 
* avaialble in the BankAccount Record. 
* 
*
* @author Rohit Kumar Malik
* @version 1.0
* @since 2017-10-20
**********************************************************************************************************************/

public with sharing class GIACTRequestValidation {
	
	Public class GIACTValidationException extends Exception {
	}

	Private sObject record;
	Private Map<String, sObject> requiredFields;
	Private String action;
	Public Boolean hasError = false;

	/**
	* This is the constructor of the class which initializes all the necessary variables before Validating the record.
	* 
	* @param record Bank Account Record which is being validated. 
	* @param This is the map of all the fields which needs to be part of the Request payload. 	
	* @return 
	* @exception GIACTValidationException return the exception if call don't have capabilty to valiadate a specific
	*action For eg. gverifyinquiry.
	* @see GIACTValidationException
	*/
	Public GIACTRequestValidation(Bank_Account__c record, Map<String, sObject> reqFields, String action) {
		this.record = record;
		this.requiredFields = reqFields;
		this.action = action;

		//constructor acts as Facade to branch out to particular calls based on Action
		if (action.toLowerCase() == 'gverifyinquiry') {
			validateRequiredFields();
		} else {
			throw new GIACTValidationException('Failed to find a matching fieldset to work with. Input was: ' + action);
		}
	}

	Public GIACTRequestValidation(ValuePlus__c record, Map<String, sObject> reqFields, String action) {
		this.record = record;
		this.requiredFields = reqFields;
		this.action = action;

		//constructor acts as Facade to branch out to particular calls based on Action
		if (action.toLowerCase() == 'gIdentifyInquiry') {
			validateRequiredFields ();
		}else {
			throw new GIACTValidationException('Failed to find a matching fieldset to work with. Input was: ' + action);
		}
	}

	/**
	* The Actual validation happens in this method based ont he production. If the particalura Custom setting record is having a hardcoded field then it will pick that else it will pull the data from the record.
	*  
	* @param product this specifies if current processing is for MyCase/APM
	* @return 
	* @exception GIACTValidationException return the exception if call don't have capabilty to valiadate a specific action For eg. gverifyinquiry.
	* @see GIACTValidationException
	*/
	private Void validateRequiredFields() {

		System.debug('FileName-GIACTRequestValidation:');
		for (String fsm : this.requiredFields.keyset()) {
			Boolean skipped = false;
			sObject x = this.requiredFields.get(fsm);
			Boolean requiredCondition = false;
			System.debug('Key which you can check - ' + fsm + ' Value - ' + x);


			if ((Boolean) x.get('Required__c') || requiredCondition) {
				String fp = (String) x.get('Field_Path__c');
				String ce = (String) x.get('CustomErrorMsg__c');
				String value;
			 	//if (x.get('HardcodedValue__c') != null ) {
				if (!String.isEmpty((String)x.get('HardcodedValue__c'))) {			 		
					value = (String) x.get('HardcodedValue__c');
				} else {
					value = GIACTUtils.extractRelatedField(fp, this.record);
				}
				
				System.debug(' Value - ' + value);

				if (skipped == false && (value == null || String.isBlank(value))) {
					this.hasError = true;
					throw new GIACTValidationException('Failed to find a value for ' + fp + ' but that field is Required.');
				}
			}
		}
	}

	/**
	* This is the entry method for the class. 
	*  
	* @param record Value+ Record which is being validated. 
	* @param reqFields This is the map of all the fields which needs to be part of the Request payload.
	* @param action Action specifies if this is a gVerify / gIdentify inquiry.
	* @param product this specifies if current processing is for MyCase/APM
	* @return 
	* @exception GIACTValidationException return the exception if call don't have capabilty to valiadate a specific action For eg. gverifyinquiry.
	* @see GIACTValidationException
	*/
	Public Static Boolean validate(ValuePlus__c record, Map<String, sObject> reqFields) {
		System.debug('FileName-GIACTRequestValidation:');
		GIACTRequestValidation validation = new GIACTRequestValidation(record, reqFields, 'gIdentifyInquiry');
		return !validation.hasError;
	}

	/**
	* This is the entry method for the class. 
	*  
	* @param record Bank Account Record which is being validated. 
	* @param reqFields This is the map of all the fields which needs to be part of the Request payload.
	* @param action Action specifies if this is a gVerify / gIdentify inquiry.
	* @param product this specifies if current processing is for MyCase/APM
	* @return 
	* @exception GIACTValidationException return the exception if call don't have capabilty to valiadate a specific action For eg. gverifyinquiry.
	* @see GIACTValidationException
	*/
	Public Static Boolean validate(Bank_Account__c record, Map<String, sObject> reqFields) {
		System.debug('FileName-GIACTRequestValidation:');
		GIACTRequestValidation validation = new GIACTRequestValidation(record, reqFields, 'gverifyinquiry');
		return !validation.hasError;
	}
}