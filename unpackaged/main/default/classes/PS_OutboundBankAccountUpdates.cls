/*
* Test class: PS_OutboundBankAccountUpdatesTest
*/
public class PS_OutboundBankAccountUpdates implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts{
	
	Set<PS_Audit_Log__c> logs = new Set<PS_Audit_Log__c>();
	String query;
	List<Bank_Account__c> bankAccountsToUpdate = new List<Bank_Account__c>();
	List<Bank_Account__c> failedUpdates = new List<Bank_Account__c>();
	Map<Id, Bank_Account__c> updatedBankAccounts = new Map<Id, Bank_Account__c>();
	
	public Database.QueryLocator start(Database.BatchableContext bc){
		return Database.getQueryLocator([Select ID, ps_LocationUpdateRequired__c, ps_UpdateRequired__c, recordType.Name, Account__r.Name, 
											(SELECT id, Account_Label__c, ps_BankAccountUpdateRequired__c, ps_LocationUpdateRequired__c, LID__c, Ready_for_push_to_ProfitStars__c 
												FROM Bank_Accounts__r where Outbound_Location_Update_Status__c='Ready To Update' and Outbound_LID__c != null) 
											FROM ValuePlus__c WHERE Id IN 
												(SELECT ValuePlus__c FROM Bank_Account__c 
													WHERE Status__c = 'Active' AND Outbound_Location_Update_Status__c='Ready To Update' and Outbound_LID__c != null) 
											AND Successfully_Enrolled_Outbound_at__c != null and Outbound_MID__c != null]);
	}
	
	public void execute(Database.BatchableContext bc, List<ValuePlus__c> scope){
		String action;
		//Savepoint sp = Database.setSavePoint();
		Bank_Account__c[] bankAccounts;
		for (ValuePlus__c s : scope) {
			bankAccounts = s.getSObjects('Bank_Accounts__r');
			log.log('Iterating with Object id: ', s.id, 'Bank Accounts = ' + bankAccounts);
			Boolean allPassed = true;
			String failedBankLabels;
			try {
				action = 'Bank Account Update for Outbound';
				ps_BankAccountReq bankResp = new ps_BankAccountReq(s.id, 'echeck');
				//this.logs.add(ProfitStarsUtils.generateAuditLogForValuePlus('Bank Account Update for Outbound', 'Success', JSON.serializePretty(bank.response) , s.id, s.recordType.Name));		
				//bankAccountsToUpdate.addAll(bankAccounts);
				if(bankResp.response != null && bankResp.response.results != null && !bankResp.response.results.isEmpty()){
					for(Bank_Account__c ba : bankAccounts){
						if(bankResp.response.results.keySet().contains(ba.Id)){
							ps_MaintRequestResults resp = bankResp.response.results.get(ba.Id);

							if(resp != null){
								if(resp.success != null && resp.success.toLowerCase() == 'true'){
									this.logs.add(ProfitStarsUtils.generateAuditLogForBankAccount(action, 'Success', JSON.serializePretty(resp), ba.Id, s.recordType.Name));		//request #R151866 updated to capture application type
									bankAccountsToUpdate.add(ba);
								}else if(resp.errorMessage != null){
									allPassed = false;
									failedBankLabels = failedBankLabels == null ? ba.Account_Label__c : failedBankLabels + ', ' + ba.Account_Label__c;
									this.logs.add(ProfitStarsUtils.generateAuditLogForBankAccount(action, 'Failure', JSON.serializePretty(resp), ba.Id, s.recordType.Name));		//request #R151866 updated to capture application type
									failedUpdates.add(ba);
								}
							}
						}
					}

					if(!allPassed){
						String errorDetails = 'The following bank account records are not successfully updated in ProfitStars: ' + failedBankLabels;
						errorDetails += '\nPlease refer to the audit log(s) on the individual bank accounts for specific error details.';
						this.logs.add(ProfitStarsUtils.generateAuditLogForValuePlus(action, 'Failure', errorDetails, s.id, s.recordType.Name));
					}else{
						this.logs.add(ProfitStarsUtils.generateAuditLogForValuePlus(action, 'Success', JSON.serializePretty(bankResp.response), s.id, s.recordType.Name));
					}
				}
			} catch (ProfitStarsRequestValidation.ProfitStarsValidationException e) {
				failedUpdates.addAll(bankAccounts);
				this.logs.add(ProfitStarsUtils.generateAuditLogForValuePlus('Pre-call Validation', e.getMessage(), e.getStackTraceString(), s.id, s.recordType.Name));		
				ProfitStarsUtils.sendErrorEmail(s, 'Bank Account Update for Outbound', e.getMessage(), e.getStackTraceString(), 'echeck'); 
			} catch (Exception e) {
				failedUpdates.addAll(bankAccounts);
				this.logs.add(ProfitStarsUtils.generateAuditLogForValuePlus(action, e.getMessage(), e.getStackTraceString(), s.id, s.recordType.Name));		
				ProfitStarsUtils.sendErrorEmail(s, 'Bank Account Update for Outbound', e.getMessage(), e.getStackTraceString(), 'echeck');
				SystemExceptionLogger.fireSystemExceptionLogEvent(e,'PS_OutboundBankAccountUpdates','execute', SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, e.getMessage(), 'PS_OutboundBankAccountUpdates: Bank Account Update for Outbound', null, false); 
			}
		}

		try{
			update scope;
		}catch (Exception e) {
			SystemExceptionLogger.fireSystemExceptionLogEvent(e,'PS_OutboundBankAccountUpdates','execute', SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, e.getMessage(), 'PS_OutboundBankAccountUpdates: V+ Updates', null, false); 
		}
	}
	
	public void finish(Database.BatchableContext bc){
		
		try {
			for (Bank_Account__c ba : bankAccountsToUpdate) {
				ba.Outbound_Location_Update_Status__c = 'Approved';
				updatedBankAccounts.put(ba.Id, ba);
			}
			for (Bank_Account__c b : failedUpdates) {
				b.Outbound_Location_Update_Status__c = 'Failed';
				updatedBankAccounts.put(b.Id, b);			
			}
			List<ps_audit_log__c> deduped = new List<PS_Audit_Log__c>();
			deduped.addAll(logs);
			log.error('logs to be written', deduped, 'End logs to be written ' + logs);
			insert deduped;
			//update bankAccountsToUpdate;
			//update failedUpdates;
			update updatedBankAccounts.values();
		} catch (DmlException e) {
			System.debug(e.getMessage());
			SystemExceptionLogger.fireSystemExceptionLogEvent(e,'PS_OutboundBankAccountUpdates','finish', SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, e.getMessage(), 'PS_OutboundBankAccountUpdates: Bank Updates', null, false); 
		}
	}
}