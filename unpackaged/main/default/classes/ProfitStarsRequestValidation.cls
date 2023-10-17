/*
* Test class: ProfitStarsRequestValidationTest
*/
public with sharing class ProfitStarsRequestValidation {
	public class ProfitStarsValidationException extends Exception {
		public ProfitStarsValidationException(String action, Id valuePlus, String response, String faultCode) {
			ProfitStarsUtils.createAuditLogInRealtime(action, valuePlus, response, faultCode, ''); //request #R151866 updated to capture application type
		}
	}

	private sObject record;
	private Map<String, sObject> requiredFields;
	private String action;
	public Boolean hasError = false;
	public List<String> errors = new List<String>();

	//Standard constructor for all but enrollment calls
	public ProfitStarsRequestValidation(ValuePlus__c record, Map<String, sObject> reqFields, String action, String product) {
		this.record = record;
		this.requiredFields = reqFields;
		this.action = action;

		System.debug('!!!!!! ' + reqFields);
		//constructor acts as Facade to branch out to particular calls based on Action
		if (action.toLowerCase() == 'velocity') {
			canMakeVelocityRequest(product);
		} else if (action.toLowerCase() == 'field update' || action.toLowerCase() == 'ownership update') {
			canMakeFieldUpdate(product);
		} else if (action.toLowerCase() == 'bank account') {
			canMakeBankAccountUpdate(product);
		} else if (action.toLowerCase() == 'location') {
			canMakeLocationUpdate(product);
		} else if (action.toLowerCase() == 'enrollment') {
			canMakeEnrollmentCall(product);
		} else {
			throw new ProfitStarsValidationException('Failed to find a matching fieldset to work with. Input was: ' + action);
		}
	}

	private Void validateRequiredFields(String product) {
		ValuePlus__c checkVp = (ValuePlus__c) this.record;
		Boolean isIMRecord = false;

		// if(checkVp != null && checkVp.RecordTypeId == InformationStrings.vPlusIMPaymentsId){
		// 	isIMRecord = true;
		// }
		for (String fsm : this.requiredFields.keyset()) {
			Boolean skipped = false;
			sObject x = this.requiredFields.get(fsm);

			Boolean requiredCondition = false;
			String field = (String)x.get('Required_If__c');

			System.debug('Rohit your key is : ' + fsm + ' Field : ' + field);

			if(field != null && !String.isEmpty(field) && (action.toLowerCase() == 'enrollment' || action.toLowerCase() == 'ownership update')){
				System.debug('Rohit you got the value here : ' + field + ' ' + requiredCondition);
				if(field.toLowerCase() == 'true'){
					requiredCondition = true;
				} else{
					requiredCondition = (Boolean)this.record.get(field);
				}
			}

			if ((Boolean) x.get('Required__c') || requiredCondition) {
				String fp;

				if(isIMRecord){
					fp = (String) x.get('Field_Path_IM__c');
				} else{
					fp = (String) x.get('Field_Path__c');
				}

				String ce = (String) x.get('Custom_Error_Msg__c');
				Boolean sub = (Boolean) x.get('Part_of_a_Subquery__c');
				String value;
				if (sub != null && sub) {
					List<Bank_Account__c> subQueryResults = (List<Bank_Account__c>) this.record.getSObjects('Bank_Accounts__r');

					if (subQueryResults == null) {
						throw new ProfitStarsValidationException('Failed to find a valid Bank Account Record associated / linked to this Value Plus Record.');
					}

					for (Bank_Account__c b : subQueryResults) {
						if ((b.ps_BankAccountUpdateRequired__c == false && b.ps_LocationUpdateRequired__c == false) || b.Ready_for_push_to_ProfitStars__c == false) {
							//Records meeting this criteria will be rejected from the request builder so lets not validate them.
							skipped = true;
							continue;
						}

						if(action == 'bank account' && product != 'echeck' && (b.LID__c == null || b.Ready_for_push_to_ProfitStars__c == false)){
			                skipped = true;
			                continue;
			            }

			            if(action == 'bank account' && product == 'echeck' && b.Outbound_Location_Update_Status__c != 'Ready To Update'){
			                skipped = true;
			                continue;
			            }

			            if(action == 'location' && b.LID__c != null){
			                skipped = true;
			                continue;
			            }

						System.debug('SubQueryResults  = ' + subQueryResults);
						String[] parts = fp.split('\\.', 2);
						value = (string) b.get(parts[1]);
					}
				} else if (x.get('Hardcoded_Value__c') != null ) {
					value = (String) x.get('Hardcoded_Value__c');
				} else {
					value = ProfitStarsUtils.extractRelatedField(fp, this.record, product);
				}
				if (skipped == false && (value == null || String.isBlank(value))) {
					this.hasError = true;
					if (PSBatchSchedulable_Omnibus.useFieldPath || isIMRecord) {
						throw new ProfitStarsValidationException('Failed to find a value for ' + fp + ' but that field is Required.');
					} else {
						throw new ProfitStarsValidationException('Failed to find a value for ' + ce + ' but that field is Required.');
					}
				}
			}
		}
	}

	/**
	 * While these currently only call one validation method, this is architected such that
	 * future validation methods may be dropped in to these facade methods as needed.
	 */
	
	public Boolean canMakeVelocityRequest(String product) {
		validateRequiredFields(product);
		return this.hasError;
	}

	public Boolean canMakeFieldUpdate(String product) {
		validateRequiredFields(product);
		return this.hasError;
	}

	public Boolean canMakeBankAccountUpdate(String product) {
		validateRequiredFields(product);
		return this.hasError;
	}

	public Boolean canMakeLocationUpdate(String product) {
		validateRequiredFields(product);
		return this.hasError;
	}

	public Boolean canMakeEnrollmentCall(String product) {
		validateRequiredFields(product);
		//validateConditionalRequiredFields(product);
		return this.hasError;
	}

	public Static Boolean validate(ValuePlus__c record, Map<String, sObject> reqFields, String action, String product) {
		ProfitStarsRequestValidation validation = new ProfitStarsRequestValidation(record, reqFields, action, product);
		// Friendly reminder: This method returns the inverse of hasError, because the nomeoclature
		// of hasError is inverse to the point of the method -- to determine if the record is valid.
		return !validation.hasError;
	}
}