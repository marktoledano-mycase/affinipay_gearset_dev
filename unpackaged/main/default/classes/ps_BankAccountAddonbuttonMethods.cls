global class ps_BankAccountAddonbuttonMethods {
	global class buttonException extends Exception {}

	global class ButtonResult {
		Public String result {get; set;}
		Public Boolean didPass {get; set;}
	}

	Public String result;

	webService static String CallBankAddonBatch(Id id) {
		ButtonResult outputResult = new ButtonResult ();
		PS_BatchBankAddOnBatchSubmit bat = new PS_BatchBankAddOnBatchSubmit (Id);

		Database.executeBatch(bat,1);

		outputResult.didPass = true;
		outputResult.result = 'Inbound BankAccount batch is processed, Please review Bank Account Audit Logs.';
		return JSON.serialize(outputResult);
	}

	webService static String CallBankAddonBatchOutbound(Id id) {

		ButtonResult outputResult = new ButtonResult ();
		PS_BatchOutboundBankAddOnBatchSubmit bat = new PS_BatchOutboundBankAddOnBatchSubmit (Id);
		Database.executeBatch(bat,1);
		outputResult.didPass = true;
		outputResult.result = 'Outbound BankAccount batch is processed, Please review Bank Account Audit Logs.';
		return JSON.serialize(outputResult);
	}

	// webService static String CallCyberSourceSubscriptionBatch (Id id) {
	// 	System.debug(LoggingLevel.DEBUG, '***RK-Making a call to CyberSourceSubscription Batch.');
	// 	ButtonResult outputResult = new ButtonResult ();
	// 	CyberSourceBankAccountBatchService bat = new CyberSourceBankAccountBatchService (id);
	// 	Database.executeBatch (bat,1);
	// 	outputResult.didPass = true;
	// 	outputResult.result = 'Outbound BankAccount batch is processed, Please review Bank Account Audit Logs.';
	// 	return JSON.serialize(outputResult);
	// }
}