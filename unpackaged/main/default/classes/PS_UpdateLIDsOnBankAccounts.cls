/*
* Test class: PS_UpdateLIDsOnBankAccountsTest
*/
public class PS_UpdateLIDsOnBankAccounts implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful{
	
	private String query;

	public class PS_UpdateLIDsOnBankAccountsException extends Exception {}
	
	public PS_UpdateLIDsOnBankAccounts(){
		String inboundFilter = '(LID__c = null and Location_Add_Status__c = ' + '\'Submitted\' and ValuePlus__r.ProfitStars_Merchant_ID__c != null)';
		String outboundFilter = '(Outbound_LID__c = null and Outbound_Location_Add_Status__c = ' + '\'Submitted\' and ValuePlus__r.Outbound_MID__c != null)';
		String inboundMyCaseFilter = '(LID__c = null and Location_Add_Status__c = ' + '\'Submitted\' and ValuePlus__r.ProfitStars_Merchant_ID__c != null and ValuePlus__r.recordType.Name = \'MyCase Payments\')';
		Boolean useSFLogic = false;
		// useSFLogic = [Select Use_SF_Logic__c from ProfitStarsIntegration__c where Name = 'APM Payments' limit 1].Use_SF_Logic__c;

		if(useSFLogic || Test.isRunningTest()){
			query = 'Select Id, Account_Label__c, ValuePlus__c, LID__c, Location_Add_Status__c, Outbound_LID__c, Outbound_Location_Add_Status__c, ' + 
				'ValuePlus__r.ProfitStars_Merchant_ID__c, ValuePlus__r.Outbound_MID__c, ValuePlus__r.recordType.Name ' + 
				'from Bank_Account__c where (' +  inboundFilter + ' or ' + outboundFilter + ') and Status__c = \'Active\'';
		} else{
			query = 'Select Id, Account_Label__c, ValuePlus__c, LID__c, Location_Add_Status__c, Outbound_LID__c, Outbound_Location_Add_Status__c, ' + 
			'ValuePlus__r.ProfitStars_Merchant_ID__c, ValuePlus__r.Outbound_MID__c, ValuePlus__r.recordType.Name ' + 
			'from Bank_Account__c where (' +  inboundMyCaseFilter + ') and Status__c = \'Active\'';
		}
	}
	
	public Database.QueryLocator start(Database.BatchableContext bc){
		System.debug('Query is: ' + query);
		return Database.getQueryLocator(query);
	}

   	public void execute(Database.BatchableContext bc, List<Bank_Account__c> bankAccountList){

   		ProfitStarsIntegrationService psService = new ProfitStarsIntegrationService();
   		List<Bank_Account__c> bankAccUpdateList = new List<Bank_Account__c>();
   		List<PS_Audit_Log__c> auditLogs = new List <PS_Audit_Log__c>();
   		Map<Id, Bank_Account__c> bankAccountMap = new Map<Id, Bank_Account__c>();
   		Set<Id> inboundBankIds = new Set<Id>();
   		Set<Id> outboundBankIds = new Set<Id>();
   		String inboundlogType = 'Bank Account Inbound LID Update';
   		String outboundlogType = 'Bank Account Outbound LID Update';
   		String errorMsg = ''; 

		for(Bank_Account__c ba : bankAccountList){
			try{
				String locRespInbound;
				String locRespOutbound;
				Boolean isBankUpdated = false;

				System.debug('Bank Account Id: ' + ba.Id);
				bankAccountMap.put(ba.Id, ba);

				if(ba.LID__c == null && ba.ValuePlus__r.ProfitStars_Merchant_ID__c != null && ba.Location_Add_Status__c == 'Submitted'){
					locRespInbound = psService.makeGetLocationByLocationNameRequest(ba.ValuePlus__r.ProfitStars_Merchant_ID__c, ba.ValuePlus__r.recordType.Name, ba.Account_Label__c, null);
					inboundBankIds.add(ba.Id);
				}

				if(ba.Outbound_LID__c == null && ba.ValuePlus__r.Outbound_MID__c != null && ba.Outbound_Location_Add_Status__c == 'Submitted'){
					locRespOutbound = psService.makeGetLocationByLocationNameRequest(ba.ValuePlus__r.Outbound_MID__c, ba.ValuePlus__r.recordType.Name, ba.Account_Label__c, 'echeck');
					outboundBankIds.add(ba.Id);
				}

				if(!String.isEmpty(locRespInbound)){
					ps_GuidResp.GetLocationByLocationNameResults parseResultInbound = (ps_GuidResp.GetLocationByLocationNameResults) System.JSON.deserialize(locRespInbound, ps_GuidResp.GetLocationByLocationNameResults.class);

					if(parseResultInbound != null){
						if(!String.isEmpty(parseResultInbound.errorMessage) && !String.isEmpty(parseResultInbound.errorCode)){
							auditLogs.add(ProfitStarsUtils.generateAuditLogForBankAccount(inboundlogType, parseResultInbound.errorMessage, parseResultInbound.errorCode, ba.Id, ba.ValuePlus__r.recordType.Name));

						}else if(parseResultInbound.getLocationByLocationName != null && parseResultInbound.getLocationByLocationName.getLocationByLocationNameResult != null){
							Integer statusCode = Integer.valueOf(parseResultInbound.httpStatusCode.trim());

							if(200 == statusCode && parseResultInbound.getLocationByLocationName.getLocationByLocationNameResult.locationId != null){
								ba.Location_Add_Status__c = 'Approved';
								ba.LID__c = parseResultInbound.getLocationByLocationName.getLocationByLocationNameResult.locationId.trim();
								isBankUpdated = true;
							}
						}
					}
				}

				if(!String.isEmpty(locRespOutbound)){
					ps_GuidResp.GetLocationByLocationNameResults parseResultOutbound = (ps_GuidResp.GetLocationByLocationNameResults) System.JSON.deserialize(locRespOutbound, ps_GuidResp.GetLocationByLocationNameResults.class);

					if(parseResultOutbound != null){
						if(!String.isEmpty(parseResultOutbound.errorMessage) && !String.isEmpty(parseResultOutbound.errorCode)){
							auditLogs.add(ProfitStarsUtils.generateAuditLogForBankAccount(outboundlogType, parseResultOutbound.errorMessage, parseResultOutbound.errorCode, ba.Id, ba.ValuePlus__r.recordType.Name));

						}else if(parseResultOutbound.getLocationByLocationName != null && parseResultOutbound.getLocationByLocationName.getLocationByLocationNameResult != null){
							Integer statusCode = Integer.valueOf(parseResultOutbound.httpStatusCode.trim());

							if(200 == statusCode && parseResultOutbound.getLocationByLocationName.getLocationByLocationNameResult.locationId != null){
								ba.Outbound_Location_Add_Status__c = 'Approved';
								ba.Outbound_LID__c = parseResultOutbound.getLocationByLocationName.getLocationByLocationNameResult.locationId.trim();
								isBankUpdated = true;
							}
						}
					}
				}

				if(isBankUpdated){
					bankAccUpdateList.add(ba);
				}
			}catch(Exception ex){
				SystemExceptionLogger.fireSystemExceptionLogEvent(ex,'PS_UpdateLIDsOnBankAccounts','execute', SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, ex.getMessage(), 'PS_UpdateLIDsOnBankAccounts: Bank Account Updates', null, false); 
			}
		}

		try{

   			if(!bankAccUpdateList.isEmpty()){

   				List<Database.SaveResult> srList = Database.Update(bankAccUpdateList, false);
   				for(Database.SaveResult sr : srList){
					Id baId = sr.getId();
					String appType = bankAccountMap.get(baId).ValuePlus__r.recordType.Name;

				    if(sr.isSuccess()){
				    	if(inboundBankIds.contains(baId)){
					        auditLogs.add(ProfitStarsUtils.generateAuditLogForBankAccount(inboundlogType, 'Success', '' , baId, appType));
					    }
					    if(outboundBankIds.contains(baId)){
					        auditLogs.add(ProfitStarsUtils.generateAuditLogForBankAccount(outboundlogType, 'Success', '' , baId, appType));
					    }
				    } else{           
				        for(Database.Error err : sr.getErrors()){
				        	errorMsg += err.getStatusCode() + ': ' + err.getMessage() + ' Bank Account Fields that affected this error ' + err.getFields() + '\n';
				        }
				        if(inboundBankIds.contains(baId)){
					        auditLogs.add(ProfitStarsUtils.generateAuditLogForBankAccount(inboundlogType, 'Failure', '' , baId, appType));
					    }
					    if(outboundBankIds.contains(baId)){
					        auditLogs.add(ProfitStarsUtils.generateAuditLogForBankAccount(outboundlogType, 'Failure', '' , baId, appType));
					    }
				    }
				}
   			}

   			if(!auditLogs.isEmpty()){
   				insert auditLogs;
   			}

   			if(!String.isEmpty(errorMsg)){
				throw new PS_UpdateLIDsOnBankAccountsException(errorMsg);
			}

   		} catch(Exception ex){
			SystemExceptionLogger.fireSystemExceptionLogEvent(ex,'PS_UpdateLIDsOnBankAccounts','execute', SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, ex.getMessage(), 'PS_UpdateLIDsOnBankAccounts: LID Updates on Bank Account', null, false); 
		}
	}
	
	public void finish(Database.BatchableContext bc){}
}