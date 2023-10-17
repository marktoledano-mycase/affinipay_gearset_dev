/*
* Test class: PS_BatchFieldUpdatesForOutboundTest
*/
public class PS_BatchFieldUpdatesForOutbound implements Database.Batchable<sObject>, Database.AllowsCallouts {

	public class PS_BatchFieldUpdatesForOutboundException extends Exception{}
	private @testVisible String errorMessage;

	String query;

	public PS_BatchFieldUpdatesForOutbound(){
		//request #R151866 updated to identify the reocrd type
		// Request #R165239 ProfitStars API Call Update - Removing Calls to LOST V+ Objects
		// Summary of the fix (Now this process only the Value+ Records which are of Stage != Lost) 
		this.query = 'SELECT Id, account__c, recordType.Name, Account__r.Name, Account__r.ProfitStars_Update_Field__c FROM ValuePlus__c WHERE recordType.Name like \'%Payments%\' and Stage__c!=\'Lost\' and Account__c in (SELECT id FROM account WHERE ProfitStars_Update_Outbound__c = True and recordType.Name=\'MyCase Account\')';
	}

	public Database.QueryLocator start(Database.BatchableContext BC){
		return Database.getQueryLocator(query);
	}

	public void execute(Database.BatchableContext BC, List<ValuePlus__c> scope){

		Set<PS_Audit_Log__c> logs = new Set<PS_Audit_Log__c>();
		Set<Id> accountIdsToUpdate = new Set<Id>();
		Set<Id> failedToUpdate = new Set<Id>();
		String fieldUpdate = '';

		for(ValuePlus__c s : scope){
			try{
				ps_FieldUpdateReq fup;

				if(s.Account__r.ProfitStars_Update_Field__c != null){
					fieldUpdate = s.Account__r.ProfitStars_Update_Field__c;
				}

				if(!String.isEmpty(fieldUpdate) && fieldUpdate == 'Ownership'){
					fup = new ps_FieldUpdateReq('ownership update', s.Id, 'echeck');
				} else{
					fup = new ps_FieldUpdateReq('field update', s.Id, 'echeck');
				}

				if(fup.response != null){
					if(fup.response.success != null && fup.response.success.toLowerCase() == 'true'){
						logs.add(ProfitStarsUtils.generateAuditLogForAccount('Field Update in Outbound', 'Success', JSON.serializePretty(fup.response), s.account__c, fieldUpdate, s.recordType.Name));		//request #R151866 updated to capture application type
						accountIdsToUpdate.add(s.Account__c);
					} else if(fup.response.errorMessage != null){
						logs.add(ProfitStarsUtils.generateAuditLogForAccount('Field Update in Outbound', 'Failure', JSON.serializePretty(fup.response), s.account__c, fieldUpdate, s.recordType.Name));		//request #R151866 updated to capture application type
						failedToUpdate.add(s.Account__c);
					}
				}
			} catch(ProfitStarsRequestValidation.ProfitStarsValidationException e){
				failedToUpdate.add(s.Account__c);
				logs.add(ProfitStarsUtils.generateAuditLogForAccount('Pre-call Validation for Outbound', e.getMessage(), e.getStackTraceString(), s.account__c, fieldUpdate, s.recordType.Name));		//request #R151866 updated to capture application type
				ProfitStarsUtils.sendErrorEmail(s, 'Other Update for Outbound', e.getMessage(), e.getStackTraceString(), null); //request #R151866 Added to send email with failure message
			} catch(Exception e){
				failedToUpdate.add(s.Account__c);
				logs.add(ProfitStarsUtils.generateAuditLogForAccount('Field Update in Outbound', e.getMessage(), e.getStackTraceString(), s.account__c, fieldUpdate, s.recordType.Name));		//request #R151866 updated to capture application type
				ProfitStarsUtils.sendErrorEmail(s, 'Other Update for Outbound', e.getMessage(), e.getStackTraceString(), null); //request #R151866 Added to send email with failure message
				SystemExceptionLogger.fireSystemExceptionLogEvent(e,'PS_BatchFieldUpdatesForOutbound','execute', SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, e.getMessage(), 'PS_BatchFieldUpdatesForOutbound: Field Update for Outbound', null, false);
			}
		}

		if(!accountIdsToUpdate.isEmpty() || !failedToUpdate.isEmpty() || !logs.isEmpty()){
        	finalize(accountIdsToUpdate, failedToUpdate, logs);
        }
	}

	@testVisible
    private void finalize(Set<Id> accountsToUpdate, Set<Id> failedUpdates, Set<PS_Audit_Log__c> logs){
    	List<ps_audit_log__c> deduped = new List<PS_Audit_Log__c>();
    	List<Account> accstoUpdate = new List<Account>();

    	try{
    		deduped.addAll(logs);

    		if(!deduped.isEmpty()){
	            Database.SaveResult[] srList = Database.INSERT(deduped, false);

	            for(Database.SaveResult sr : srList){
	                if(!sr.isSuccess()){
	                    for(Database.Error err : sr.getErrors()){
	                        errorMessage += err.getStatusCode() + ': ' + err.getMessage() + ', ';
	                    }
	                }
	            }
	        }

	        accstoUpdate = [SELECT ID, ProfitStars_Update_Outbound__c, ProfitStars_Push_Status__c FROM Account WHERE Id in :accountsToUpdate OR Id in :failedUpdates];
			for(Account a : accstoUpdate){
				if(failedUpdates.contains(a.Id)){
					a.ProfitStars_Update_Outbound__c = true;
				} else{
					a.ProfitStars_Update_Outbound__c = false;
				}
			}

			if(!accstoUpdate.isEmpty()){
	            Database.SaveResult[] resultList = Database.UPDATE(accstoUpdate, false);

            	for(Database.SaveResult res : resultList){
	                if(!res.isSuccess()){
	                    for(Database.Error error : res.getErrors()){
	                        errorMessage += error.getStatusCode() + ': ' + error.getMessage() + ', ';
	                    }
	                }
	            }
	        }

	        if(!String.isEmpty(errorMessage)){
                throw new PS_BatchFieldUpdatesForOutboundException(errorMessage);
            }
    	} catch(Exception e){
			SystemExceptionLogger.fireSystemExceptionLogEvent(e,'PS_BatchFieldUpdatesForOutbound','Finalize', SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, e.getMessage(), 'PS_BatchFieldUpdatesForOutbound: finalize', null, false);	
		}
    }

	public void finish(Database.BatchableContext BC){}
}