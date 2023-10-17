/*
* Test class: GiactVerifyServiceTest, ps_buttonMethodsTest
*/
public without sharing class BankAccountTriggerHandler extends TriggerHandler {

	//public override void Context methods
	//public override void beforeInsert()
	//public override void beforeUpdate()
	//public override void beforeDelete()
	//public override void afterInsert()
	//public override void afterDelete()
	//public override void afterUndelete()

	//Class level variables
	private List<Bank_Account__c> newList;
	private Map<Id, Bank_Account__c> newBankAccountMap;
	private Map<Id, Bank_Account__c> oldBankAccountMap;
	private List<Bank_Account__c> toUpdateLocation = new List<Bank_Account__c>();
	private List<Bank_Account__c> toUpdateBank = new List<Bank_Account__c>();

	public static boolean runBeforeUpdate = true;
	public static boolean runAfterUpdate = true;

	public static boolean runBeforeInsert = true;
	public static boolean runAfterInsert = true;	

	//Constructor
	public BankAccountTriggerHandler() {
		this.newList = Trigger.new;
		this.newBankAccountMap = (Map<Id, Bank_Account__c>) Trigger.newMap;
		this.oldBankAccountMap = (Map<Id, Bank_Account__c>) Trigger.oldMap;
	}

	public static boolean runBeforeUpdateOnce () {
		if (runBeforeUpdate) {
			runBeforeUpdate=false;
			return true;
		} else {
			return runBeforeUpdate;
		}
	}

	public static boolean runAfterUpdateOnce () {
		if (runAfterUpdate) {
			runAfterUpdate=false;
			return true;
		} else {
			return runAfterUpdate;
		}
	}
	public static boolean runBeforeInsertOnce () {
		if (runBeforeInsert) {
			runBeforeInsert=false;
			return true;
		} else {
			return runBeforeInsert;
		}
	}

	public static boolean runAfterInsertOnce () {
		if (runAfterInsert) {
			runAfterInsert=false;
			return true;
		} else {
			return runAfterInsert;
		}
	}


	//This is the context method executed when the trigger fires in an AfterUpdate context.
	//it should contain nothing but calls to other methods. logicless!
	public override void afterUpdate() {
		TriggerHandler.bypass('BankAccountTriggerHandler');
		processForLocationUpdate();

		if (runAfterUpdateOnce() && !System.isBatch() && !system.isFuture()){
			gVerifygIdentify ();
		}
		TriggerHandler.clearBypass('BankAccountTriggerHandler');
	}

	public override void afterInsert() {
		TriggerHandler.bypass('BankAccountTriggerHandler');
		//processForLocationUpdate();
		if (runAfterInsertOnce () && !System.isBatch() && !system.isFuture()){			
			gVerifygIdentify ();
		}
		TriggerHandler.clearBypass('BankAccountTriggerHandler');
	}

	public override void beforeInsert() {
		// This will prevent the trigger from creating the a Bank Account if there are some Bank accounts with the same Account Labels.
		// Find a map of the value plus records which are having a bank account with Account Label as this 
		validateDuplicateBankAccountLables ();
	}

	public override void beforeUpdate() {
		validateDuplicateBankAccountLables ();
	}

	private void validateDuplicateBankAccountLables () {
		Map<Id, Set<String>> valuePlusBankAccounts = new Map<Id, Set<String>> ();
		List <Id> valuePlusIds = new List<Id> ();
		// Get the list of all the value plus records from Bank Accounts
		for (Bank_Account__c ba: (List<Bank_Account__c>)trigger.new) {
			valuePlusIds.add (ba.ValuePlus__c);
		}

		List<Bank_Account__c> bankAccounts = [Select ValuePlus__c, Account_Label__c from Bank_Account__c where ValuePlus__c in :valuePlusIds];
		for (Bank_Account__c ba: bankAccounts) {

			if (!valuePlusBankAccounts.containsKey (ba.ValuePlus__c)) {
				valuePlusBankAccounts.put (ba.ValuePlus__c, new Set<String>());
			}
			valuePlusBankAccounts.get(ba.ValuePlus__c).add(ba.Account_Label__c);

		}

		for (Bank_Account__c ba: (List<Bank_Account__c>)trigger.new) {
			if (trigger.isInsert && valuePlusBankAccounts.containsKey(ba.ValuePlus__c) && valuePlusBankAccounts.get(ba.ValuePlus__c).contains(ba.Account_Label__c)) {
				ba.addError ('There is another bank account with this name/label, please update this record with a unique bank account name/label.!!');
				continue;
			} else if (trigger.isUpdate && oldBankAccountMap.get(ba.id).Account_Label__c != ba.Account_Label__c && valuePlusBankAccounts.containsKey(ba.ValuePlus__c) 
				&& valuePlusBankAccounts.get(ba.ValuePlus__c).contains(ba.Account_Label__c)) {
				ba.addError ('There is another bank account with this name/label, please update this record with a unique bank account name/label.!!');
				continue;
			}
		}
	}

	//Helper methods
	/**
	 * Iterates over all records in the newBankAccountMap values collection and checks them for
	 * needing a location or bank account update.
	 *
	 * Records that return true for updates have their checkbox marked as true.
	 */
	private void processForLocationUpdate() {
		for (Bank_Account__c ba : newBankAccountMap.values()) {

			if (recordMeetsDataCriteriaForUpdate(ba.Id)) {
				if (ba.LID__c != null) {
					toUpdateBank.add(ba);
				} else {
					toUpdateLocation.add(ba);
				}
			}
		}

		toUpdateLocation = [SELECT ID FROM Bank_Account__c WHERE ID in: toUpdateLocation];
		for (Bank_Account__c ba : toUpdateLocation) {
			ba.ps_LocationUpdateRequired__c = true;
		}

		toUpdateBank = [SELECT ID FROM Bank_Account__c WHERE ID in: toUpdateBank];
		for (Bank_Account__c ba : toUpdateBank) {
			ba.ps_BankAccountUpdateRequired__c = true;
		}
 
		try {
			toUpdateLocation.addAll(toUpdateBank);
			update toUpdateLocation;
		} catch (DmlException e) {
			log.error('Failed to update bank account records during trigger processing', e, 'Failed to update bank account Records during trigger processing');
		}
	}

	/**
	 * didChange returns a boolean indicating of the old and
	 * new versions of a given field are different
	 * @param  String          field				Field name to retrieve from sObject record for comparison
	 * @param  Bank_Account__c old          Old version of the bank account record to be tested.
	 * @param  Bank_Account__c knew         New version of the bank account record to be tested.
	 * @return Boolean                 			true if the old version and the new version of the field are different.
	 */
	private boolean didChange(String field, Bank_Account__c old, Bank_Account__c knew) {
		return (old.get(field) != knew.get(field)) ? true : false;
	}

	/**
	 * Determines if a bank_account record requires a location or bank account update to profit stars.
	 * @param  Id key     GUID for the record to be retrieved from the trigger context variables
	 * @return Boolean    True if the account #, routing # or address has changed AND there is a valid label
	 */
	private Boolean recordMeetsDataCriteriaForUpdate(Id key) {
		Bank_Account__c old = oldBankAccountMap.get(key);
		Bank_Account__c knew = newBankAccountMap.get(key);
		Boolean accountNoChanged = didChange('AccountNo__c', old, knew);
		Boolean accountLabelChanged = didChange ('Account_Label__c', old, knew);
		Boolean accountLableValid = (knew.Account_Label__c != null) ? true : false;
		Boolean routingNoChanged = didChange('RoutingNo__c', old, knew);
		Boolean addressChanged = (didChange('Bank_Street__c', old, knew) || didChange('Bank_City__c', old, knew) || didChange('Bank_State__c', old, knew) || didChange('Bank_Zip__c', old, knew) || didChange('Bank_Name__c', old, knew));

		return ((accountNoChanged || routingNoChanged || addressChanged ||  accountLabelChanged) && accountLableValid) ? true : false;
	}

	private void gVerifygIdentify () {
		System.debug ('Calling gVerify');
		GiactVerifyService.processBankAccountRecordsForGiact (Trigger.new);
	}
}