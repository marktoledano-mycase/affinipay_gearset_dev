global class VantivLegalEntityStatusBatch  implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful{
	
	List<Vantiv_Audit_Logs__c> logs = new List<Vantiv_Audit_Logs__c>();
	List<ValuePlus__c> recordsToUpdate = new List<ValuePlus__c>();
	global Database.QueryLocator start(Database.BatchableContext bc)
	{
		return Database.getQueryLocator('Select Id, recordType.Name from ValuePlus__c where Vantiv_Onboarding_Status__c like \'%Manual Review%\' and Vantiv_Enrolled_Date__c < TODAY and Vantiv_Legal_Entity_Id__c != null');
	}
	
	global void execute(Database.BatchableContext bc, List<ValuePlus__c> scope)
	{
		for(ValuePlus__c vp : scope)
		{
			VantivLegalEntityRetrieveReq req;
			try
			{
				String result ;
				req = new VantivLegalEntityRetrieveReq(vp.Id);
				vp.Vantiv_Onboarding_Status__c = req.response.responseDescription;
				result = req.response.responseDescription;
				if(req.response.notes != null){ result = result + '. '+req.response.notes;}
				recordsToUpdate.add(vp);
				logs.add(VantivUtils.createAuditLog(vp.id,req.response.responseDescription, 'enrollment status :'+result, req.response.toString(), 'Retrieve Legal Entity', vp.recordType.Name, true));
			}
			catch(Exception e)
			{
				logs.add(VantivUtils.createAuditLog(vp.id,req.response.responseDescription, e.getMessage(), req.response.toString(), 'Retrieve Legal Entity', vp.recordType.Name, true));
			}
			
		}
		
	}
	global void finish(Database.BatchableContext bc)
	{
		update recordsToUpdate;
		insert logs;
	}

}