/******************************************************************************************************
* copyright © 2015
*
* File		: ps_BatchVelocityUpdate.cls
*
* Purpose	: This is a batch class for Velocity Update. Thi class identified the records for velocity update 
*				and instanciates the service class to send the request to profitstars
*
* Referred from 	: PS_BatchVelocityScheduler.cls
*-----------------------------------------------------------------------------
*
*Release Date		Request 	Updated By			Description
*----------------------------------------------------------------------------------------------------------------------
*					Nill							Initial Creation
*
*7/21/2015			R151866		Venkat Araveeti		MyCase Integration
*******************************************************************************************************/
global class ps_BatchVelocityUpdate implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {

	Set<PS_Audit_Log__c> logs = new Set<PS_Audit_Log__c>();
	String query;
	String product;

	global ps_BatchVelocityUpdate(String productString) {
		product = productString;
		//request #R151866 updated to identify the reocrd type
		this.query = 'SELECT id, ps_VelocityUpdateRequired__c, ps_UpdateRequired__c, recordType.Name, Account__r.Name FROM ValuePlus__c WHERE ps_VelocityUpdateRequired__c = True AND Successfully_Enrolled_in_Profit_Stars_at__c != null';
	}

	global ps_BatchVelocityUpdate() {
		//request #R151866 updated to identify the reocrd type
		this.query = 'SELECT id, ps_VelocityUpdateRequired__c, ps_UpdateRequired__c, recordType.Name, Account__r.Name FROM ValuePlus__c WHERE ps_VelocityUpdateRequired__c = True AND Successfully_Enrolled_in_Profit_Stars_at__c != null';
	}

	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

	global void execute(Database.BatchableContext BC, List<ValuePlus__c> scope) {
		for (ValuePlus__c s : scope) {
			try {
				ps_velocityReq velocity = new ps_velocityReq(s.ID, product);
				s.ps_VelocityUpdateRequired__c = false;
				s.ProfitStars_Push_Status__c = 'Success';
				logs.add(ProfitStarsUtils.generateAuditLogForValuePlus('Batch Velocity Update', 'Success', JSON.serializePretty(velocity.response) , s.id, s.recordType.Name));		//request #R151866 updated to capture application type
			} catch (Exception e) {
				s.ProfitStars_Push_Status__c = 'Failure';
				s.ps_VelocityUpdateRequired__c = false;
				logs.add(ProfitStarsUtils.generateAuditLogForValuePlus('Batch Velocity Update', e.getMessage(), e.getStackTraceString() , s.id, s.recordType.Name));		//request #R151866 updated to capture application type
				ProfitStarsUtils.sendErrorEmail(s, 'Velocity Update', e.getMessage(), e.getStackTraceString(), null); //request #R151866 Added to send email with failure message
			}
		}
		update scope;
	}

	global void finish(Database.BatchableContext BC) {
		try {
			List<ps_audit_log__c> deduped = new List<PS_Audit_Log__c>();
			deduped.addAll(logs);
			insert deduped;
		} catch (DmlException e) {
			System.debug(e.getMessage());
		}
	}

}