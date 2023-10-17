global class PS_BatchOutboundBankAddOnBatchSubmit implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {

	String query = '';
	public PS_BatchOutboundBankAddOnBatchSubmit(id batchaddonid) {
		query = 'SELECT Id, Name, LID__c, Ready_for_push_to_ProfitStars__c, Bank_Account_Add_On_Batch__r.Name from Bank_Account__c where Bank_Account_Add_On_Batch__r.id = \'' + batchaddonid +'\'' +  'and Status__c = \'Active\'';
		System.debug(query);
	}

	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

	global void execute(Database.BatchableContext BC, List<Bank_Account__c> scope) {

		for (Bank_Account__c bankAccount : scope) {
			String res = ps_eCheckButtonMethods.callLocation(bankAccount.id);
		}
	}

	global void finish(Database.BatchableContext BC) {

	}
}