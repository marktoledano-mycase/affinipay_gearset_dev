/******************************************************************************************************
* copyright © 2015
*
* File		: PS_BatchLocationUpdates.cls
*
* Purpose	: This is a batch class for Location Update. Thi class identified the records for location update 
*				and instanciates the service class to send the request to profitstars
*
* Referred from 	: PS_BatchLocationScheduler.cls
*-----------------------------------------------------------------------------
*
*Release Date		Request 	Updated By			Description
*----------------------------------------------------------------------------------------------------------------------
*					Nill							Initial Creation
*
*7/21/2015			R151866		Venkat Araveeti		MyCase Integration
*******************************************************************************************************/
global class PS_BatchLocationUpdates implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful  {

	Set<PS_Audit_Log__c> logs = new Set<PS_Audit_Log__c>();
	String query;

	global PS_BatchLocationUpdates() {
		//request #R151866 updated to identify the reocrd type
		this.query = 'SELECT Id, recordType.Name, Account__r.Name FROM ValuePlus__c WHERE ps_LocationUpdateRequired__c = True AND Successfully_Enrolled_in_Profit_Stars_at__c != null';
	System.debug(query);
	}

	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

	global void execute(Database.BatchableContext BC, List<ValuePlus__c> scope) {
		for (ValuePlus__c s : scope) {
			try {
				ps_locationReq v = new ps_locationReq(s.ID, null);
				s.ps_LocationUpdateRequired__c	 = false;
				s.ProfitStars_Push_Status__c = 'Success';
				logs.add(ProfitStarsUtils.generateAuditLogForValuePlus('Batch Location update', 'Success', JSON.serializePretty(v.response), s.id, s.recordType.Name));		//request #R151866 updated to capture application type
			} catch (Exception e) {
				//System.debug(e);
				s.ProfitStars_Push_Status__c = 'Failure';
				s.ps_LocationUpdateRequired__c	 = false;
				PS_Audit_Log__c l = new PS_Audit_Log__c();
				l.Call_type__c = 'Batch Location update';
				l.Error_Message__c = e.getMessage();
				l.Raw_Json__c = e.getStackTraceString();
				l.Value_Plus__c = s.id;
				l.Application_Type__c = s.recordType.Name;		//request #R151866 updated to capture application type
				logs.add(l);
				//Fail after first error:
				//System.debug('venkat logs are '+logs);
				//Throw new ProfitStarsIntegrationService.PSISException('Failing after first error in batch to prevent further callouts'+e.getStackTraceString());
				//ProfitStarsUtils.createAuditLogInRealtime('bank account', s.ValuePlus__c, e.getStackTraceString(), e.getMessage());
				ProfitStarsUtils.sendErrorEmail(s, 'Location Update', e.getMessage(), e.getStackTraceString(), null); //request #R151866 Added to send email with failure message
			}

		}
		list<Bank_Account__c> bankAccountsList = [select Id from Bank_Account__c where ValuePlus__c =: scope];
		for(Bank_Account__c bankAccount :bankAccountsList)
		{
			bankAccount.ps_LocationUpdateRequired__c=false;
			bankAccount.ready_for_push_to_ProfitStars__c = false;
		}
		update bankAccountsList;
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