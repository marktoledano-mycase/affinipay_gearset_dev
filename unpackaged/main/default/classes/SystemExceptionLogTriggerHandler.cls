public with sharing class SystemExceptionLogTriggerHandler extends TriggerHandler {

	//Class level variables
	private Map<Id, System_Exception_Log__c> newSystemExceptionLogMap;
	private Map<Id, System_Exception_Log__c> oldSystemExceptionLogMap;
	private List<System_Exception_Log__c> toUpdateLocation = new List<System_Exception_Log__c>();
	private List<System_Exception_Log__c> toUpdateBank = new List<System_Exception_Log__c>();

	public static boolean runBeforeUpdate = true;
	public static boolean runAfterUpdate = true;

	public static boolean runBeforeInsert = true;
	public static boolean runAfterInsert = true;	

	//Constructor
	public SystemExceptionLogTriggerHandler() {
		this.newSystemExceptionLogMap = (Map<Id, System_Exception_Log__c>) Trigger.newMap;
		this.oldSystemExceptionLogMap = (Map<Id, System_Exception_Log__c>) Trigger.oldMap;
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
		TriggerHandler.bypass('SystemExceptionLogTriggerHandler');
		TriggerHandler.clearBypass('SystemExceptionLogTriggerHandler');
	}

	public override void afterInsert() {
		TriggerHandler.bypass('SystemExceptionLogTriggerHandler');
		List<AutomationErrorLog__c> sysErrors = new List<AutomationErrorLog__c>();
		for (SObject record : Trigger.new) {
			System_Exception_Log__c log = (System_Exception_Log__c) record;
			if (!String.isEmpty(log.Object_Name__c)) {
				if (log.Object_Name__c.equals ('ValuePlus')) {
					sysErrors.add(new AutomationErrorLog__c(ValuePlus__c=Id.valueOf(log.Object_Reference__c), SystemExceptionLog__c=log.Id, Source_Application__c=log.Source_Application__c));
				} else if (log.Object_Name__c.equals ('BankAccount')) {
					sysErrors.add(new AutomationErrorLog__c(Bank_Account__c=Id.valueOf(log.Object_Reference__c), SystemExceptionLog__c=log.Id, Source_Application__c=log.Source_Application__c));
				}	
			}
		}
		insert sysErrors;
		TriggerHandler.clearBypass('SystemExceptionLogTriggerHandler');
	}

	public override void beforeInsert() {
		// This will prevent the trigger from creating the a Bank Account if there are some Bank accounts with the same Account Labels.
		// Find a map of the value plus records which are having a bank account with Account Label as this 
	}

	public override void beforeUpdate() {
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


}