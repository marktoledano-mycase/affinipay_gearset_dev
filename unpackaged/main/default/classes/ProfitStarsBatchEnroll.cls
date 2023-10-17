/******************************************************************************************************
* copyright © 2015
*
* File		: ProfitStarsBatchEnroll.cls
*
* Purpose	: This is a batch class for bulk enroll. This call identifies the eligible accounts
*				for profitstars enrollment and instanciates the service class
*
* Referred from 	: PS_BatchEnrollScheduler.cls
*
* Test class: ProfitStarsBatchEnrollTest
*-----------------------------------------------------------------------------
*
*Release Date		Request 	Updated By			Description
*----------------------------------------------------------------------------------------------------------------------
*					Nill							Initial Creation
*
*7/21/2015			R151866		Venkat Araveeti		MyCase Integration
*******************************************************************************************************/
public class ProfitStarsBatchEnroll implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful{
	Set<PS_Audit_Log__c> logs = new Set<PS_Audit_Log__c>();
	List<ValuePlus__c> failed = new List<ValuePlus__c>();

	public Database.QueryLocator start(Database.BatchableContext BC){
		return Database.getQueryLocator([SELECT Id, recordType.Name, Account__r.Name FROM ValuePlus__c WHERE
				ProfitStars_Bulk_Enroll__c = true AND PMT_ProfitStars_Migration_Status__c = 'Ready to Transmit'
				ORDER BY Id desc]);
	}


	public void execute(Database.BatchableContext BC, List<ValuePlus__c> enrollmentRecords){
		for(ValuePlus__c vp : enrollmentRecords){
			ps_EnrollmentReq req;
			// Create the enrollment request
			try{
				req = new ps_EnrollmentReq(vp.Id, null);

				if(req.resp != null && req.resp.message != null && req.resp.message.toLowerCase() == 'success'){
					vp.PMT_ProfitStars_Migration_Status__c = 'Transmitted';
					vp.ProfitStars_Bulk_Enroll__c = false;
					vp.PMT_Profit_Stars_Migration_Complete__c = Date.today();
					vp.Successfully_Enrolled_in_Profit_Stars_at__c = DateTime.now();
					logs.add(ProfitStarsUtils.generateAuditLogForValuePlus('Batch Enroll', 'Success', JSON.serializePretty(req.resp), vp.id, vp.recordType.Name));
				} else{
					String result;
					vp.PMT_ProfitStars_Migration_Status__c = 'Failed to Transmit';
					failed.add(vp);

					if(req.resp != null && req.resp.message != null){
						result = req.resp.message;
					}else{
						result = 'Did not get a valid response back!';
					}

					logs.add(ProfitStarsUtils.generateAuditLogForValuePlus('Batch Enroll', 'Failure', result, vp.id, vp.recordType.Name));
				}
			} catch(Exception e){
				System.debug(e.getMessage());
				vp.PMT_ProfitStars_Migration_Status__c = 'Failed to Transmit';
				failed.add(vp);
				logs.add(ProfitStarsUtils.generateAuditLogForValuePlus('Batch Enroll', e.getMessage(), e.getStackTraceString(), vp.id, vp.recordType.Name));		//request #R151866 updated to capture application type
				ProfitStarsUtils.sendErrorEmail(vp, 'Batch Enroll', e.getMessage(), e.getStackTraceString(), null); //request #R151866 Added to send email with failure message
				SystemExceptionLogger.fireSystemExceptionLogEvent(e,'ProfitStarsBatchEnroll','execute', SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, e.getMessage(), 'ProfitStarsBatchEnroll', null, false); 
			}
		}

		try{
			update enrollmentRecords;
		}catch(Exception e){
			SystemExceptionLogger.fireSystemExceptionLogEvent(e,'ProfitStarsBatchEnroll','execute', SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, e.getMessage(), 'ProfitStarsBatchEnroll: V+ Updates', null, false); 
		}
		
	}

	public void finish(Database.BatchableContext BC){
		try{
			List<ps_audit_log__c> deduped = new List<PS_Audit_Log__c>();
			deduped.addAll(logs);
			insert deduped;
			update failed;
		} catch(DmlException e){
			System.debug(e.getMessage());
			SystemExceptionLogger.fireSystemExceptionLogEvent(e,'ProfitStarsBatchEnroll','finish', SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, e.getMessage(), 'ProfitStarsBatchEnroll: V+ Updates', null, false); 
		}
	}
}