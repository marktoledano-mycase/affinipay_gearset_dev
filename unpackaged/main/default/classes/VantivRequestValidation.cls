public with sharing class VantivRequestValidation {
	
	public class VantivRequestValidationException extends Exception{}
	
	Public Boolean hasError = false;
	Private sObject record;
	Private Map<String, sObject> requiredFields;
	Private String action;
	
	public VantivRequestValidation(sObject record, Map<String, sObject> reqFields, String action)
	{
		this.record = record;
		this.requiredFields = reqFields;
		this.action = action;
		
		if('LegalEntityCreateRequest'.equalsIgnoreCase(action) 
			|| 'LegalEntityUpdateRequest'.equalsIgnoreCase(action) 
			|| 'LegalEntityPrincipalCreateRequest'.equalsIgnoreCase (action) 
			|| 'LegalEntityPrincipal3Create'.equalsIgnoreCase (action)
			|| 'LegalEntityPrincipal4Create'.equalsIgnoreCase (action)) 
		{
			canMakeLegalEntityCall();
		}
		else if('SubMerchantCreateRequest'.equalsIgnoreCase(action) || 'SubMerchantUpdateRequest'.equalsIgnoreCase(action))
		{
			canMakeSubMerchantCall();
		}
		else
		{
			throw new VantivRequestValidationException('Unable to validate request for action '+action);
		}
	}
	
	private void canMakeLegalEntityCall()
	{
		validateRequiredFields();
		if(('Approved'.equalsIgnoreCase((String)record.get('Vantiv_Onboarding_Status__c')) && (String) record.get('Vantiv_Legal_Entity_Id__c') == null))
		{
			throw new VantivRequestValidationException('Legal entity id unavailable.');
		}
	}
	
	private void canMakeSubMerchantCall()
	{
		validateRequiredFields();
		if(VantivUtils.extractRelatedField('ValuePlus__r.Vantiv_Legal_Entity_Id__c', record) == null ||
				('Approved'.equalsIgnoreCase((String)record.get('Vantiv_Bank_Account_Onboarding_Status__c')) && (String)record.get('Vantiv_Sub_Merchant_Id__c') == null))
				{
					throw new VantivRequestValidationException('Legal Entity id and/or SubMerchant id is unavailable.');
				}
	}
	
	private void validateRequiredFields()
	{
		
		for (String fsm : this.requiredFields.keyset()) {
			Boolean skipped = false;
			sObject x = this.requiredFields.get(fsm);
			if ((Boolean) x.get('Is_Required__c')) {
				String fp = (String) x.get('Field_Path__c');
				String ce = (String) x.get('Error_Message__c');
				Boolean sub = (Boolean) x.get('Part_of_a_Subquery__c');
				String value;
				if (sub != null && sub) {
					List<Bank_Account__c> subQueryResults = (List<Bank_Account__c>) this.record.getSObjects('Bank_Accounts__r');
					for (Bank_Account__c b : subQueryResults) {
						if (subQueryResults == null) {
							throw new VantivRequestValidationException('Failed to find a valid Bank Account Record associated / linked to this Value Plus Record.');
						}
						String[] parts = fp.split('\\.', 2);
						System.debug('SubQueryResults  = ' + subQueryResults);
						value = (string) subQueryResults[0].get(parts[1]);
					}
				} else if (x.get('Hardcoded_Value__c') != null ) {
					value = (String) x.get('Hardcoded_Value__c');
				} else {
					value = VantivUtils.extractRelatedField(fp, this.record);
				}
				if (skipped == false && (value == null || String.isBlank(value))) {
					this.hasError = true;
				    throw new VantivRequestValidationException('Failed to find a value for ' + ce + ' but that field is Required. Field: '+fp);
				}
			}
		}
	
	}
	
	public static void validate(sObject record, Map<String, sObject> reqFields, String action)
	{
		VantivRequestValidation validator = new VantivRequestValidation(record, reqFields, action);
	}

}