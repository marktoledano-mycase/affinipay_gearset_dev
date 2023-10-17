/******************************************************************************************************
* copyright © 2015
*
* File		: PS_BatchFieldUpdates.cls
*
* Purpose	: This is a batch class for other(any) Update. Thi class identified the records for other update 
*				and instanciates the service class to send the request to profitstars
*
* Referred from 	: PS_BatchFieldUpdateScheduler.cls
*
* Test class : PS_BatchFieldUpdatesTest
*-----------------------------------------------------------------------------
*
*Release Date		Request 	Updated By			Description
*----------------------------------------------------------------------------------------------------------------------
*					Nill							Initial Creation
*
*07/21/2015			R151866		Venkat Araveeti		MyCase Integration
*09/29/2015			R152543		Venkat Araveeti		Updated other call type to send dynamic subject, description
*08/12/2016			R165394 	Rohit Kumar Malik	Repeat Sending to ProfitStart queue
*07/18/2019			R1916930	Vijay Reddy			Refractored the logic, added ownership updates
*******************************************************************************************************/
public class PS_BatchFieldUpdates implements Database.Batchable<sObject>, Database.AllowsCallouts {

	public class PS_BatchFieldUpdatesException extends Exception{}
	private @testVisible String errorMessage;

	String query;

	public PS_BatchFieldUpdates(){
		//request #R151866 updated to identify the reocrd type
		// Request #R165394 Repeat sending to Profit Starsq
		// Summary of the fix (Now this process only the Value+ Records which are of Stage != Lost)
		Boolean useSFLogic = false;
		// useSFLogic = [Select Use_SF_Logic__c from ProfitStarsIntegration__c where Name = 'APM Payments' limit 1].Use_SF_Logic__c;

		// if(useSFLogic || Test.isRunningTest()){
		// 	this.query = 'SELECT Id, account__c, recordType.Name, Account__r.Name, Account__r.ProfitStars_Update_Field__c FROM ValuePlus__c WHERE recordType.Name like \'%Payments%\' and Stage__c!=\'Lost\' and Account__c in (SELECT id FROM account WHERE ps_UpdateRequired__c = True)';
		// } else {
			this.query = 'SELECT Id, account__c, recordType.Name, Account__r.Name, Account__r.ProfitStars_Update_Field__c FROM ValuePlus__c WHERE recordType.Name like \'%Payments%\' and Stage__c!=\'Lost\' and Account__c in (SELECT id FROM account WHERE ps_UpdateRequired__c = True and recordType.Name = \'MyCase Account\')';
		// }
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
					fup = new ps_FieldUpdateReq('ownership update', s.Id, null);
				} else{
					fup = new ps_FieldUpdateReq('field update', s.Id, null);
				}
				
				if(fup.response != null){
					if(fup.response.success != null && fup.response.success.toLowerCase() == 'true'){
						logs.add(ProfitStarsUtils.generateAuditLogForAccount('Field Update', 'Success', JSON.serializePretty(fup.response), s.account__c, fieldUpdate, s.recordType.Name));		//request #R151866 updated to capture application type
						accountIdsToUpdate.add(s.Account__c);
					} else if(fup.response.errorMessage != null){
						logs.add(ProfitStarsUtils.generateAuditLogForAccount('Field Update', 'Failure', JSON.serializePretty(fup.response), s.account__c, fieldUpdate, s.recordType.Name));		//request #R151866 updated to capture application type
						failedToUpdate.add(s.Account__c);
					}
				} 
			} catch(ProfitStarsRequestValidation.ProfitStarsValidationException e){
				failedToUpdate.add(s.Account__c);
				logs.add(ProfitStarsUtils.generateAuditLogForAccount('Pre-call Validation', e.getMessage(), e.getStackTraceString(), s.account__c, fieldUpdate, s.recordType.Name));		//request #R151866 updated to capture application type
				ProfitStarsUtils.sendErrorEmail(s, 'Other Update', e.getMessage(), e.getStackTraceString(), null); //request #R151866 Added to send email with failure message
			} catch(Exception e){
				failedToUpdate.add(s.Account__c);
				logs.add(ProfitStarsUtils.generateAuditLogForAccount('Field Update', e.getMessage(), e.getStackTraceString(), s.account__c, fieldUpdate, s.recordType.Name));		//request #R151866 updated to capture application type
				ProfitStarsUtils.sendErrorEmail(s, 'Other Update', e.getMessage(), e.getStackTraceString(), null); //request #R151866 Added to send email with failure message
				SystemExceptionLogger.fireSystemExceptionLogEvent(e,'PS_BatchFieldUpdates','execute', SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, e.getMessage(), 'PS_BatchFieldUpdates: Field Update', null, false);
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

	        accstoUpdate = [SELECT Id, ps_UpdateRequired__c, ProfitStars_Push_Status__c FROM Account WHERE Id in :accountsToUpdate OR Id in :failedUpdates];
			for(Account a : accstoUpdate){
				a.ps_UpdateRequired__c = false;

				if(failedUpdates.contains(a.Id)){
					a.ProfitStars_Push_Status__c = 'failure';
				} else{
					a.ProfitStars_Push_Status__c = 'success';
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
                throw new PS_BatchFieldUpdatesException(errorMessage);
            }
    	} catch(Exception e){
			SystemExceptionLogger.fireSystemExceptionLogEvent(e,'PS_BatchFieldUpdates','Finalize', SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, e.getMessage(), 'PS_BatchFieldUpdates: finalize', null, false);	
		}
    }

	public void finish(Database.BatchableContext BC){}
}