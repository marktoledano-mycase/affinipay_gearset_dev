/******************************************************************************************************
* copyright © 2016
*
* File		: PS_BatchGetMidLid.cls
*
* Purpose	: This is a batch class for other(any) Update. Thi class identified the records for other update 
*				and instanciates the service class to send the request to profitstars
*
* Referred from 	: PS_BatchFieldUpdateScheduler.cls
*
* Test class: PS_BatchGetMidLidTest
*-----------------------------------------------------------------------------
*
*Release Date		Request 	Updated By			Description
*----------------------------------------------------------------------------------------------------------------------
*					Nill							Initial Creation
*
*08/15/2016			R151866		Rohit Kumar Malik	Create a batch to update MID and LIDs (GET Request) from ProfitStars
*08/15/2016			R152543		Rohit Kumar Malik	Updated other call type to send dynamic subject, description 

** Latest Changes 08/16/2016

To Do: 
Test on Min 100 Records as there can be as Heap Error 
Test Class
Schedular 
Salesforce To Salesforce Setting 

*******************************************************************************************************/
public class PS_BatchGetMidLid implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {

	String query;

	public PS_BatchGetMidLid() {
		Boolean useSFLogic = true;

		// if(!Test.isRunningTest()){
		// 	useSFLogic = [Select Use_SF_Logic__c from ProfitStarsIntegration__c where Name = 'APM Payments' limit 1].Use_SF_Logic__c;
		// }
		
		// if(useSFLogic){
		// 	// This query is to retrieve all the records for ProfitStarsIntegration custom setting, currently there are 3 records inbound pm, outbound pm, inbound mycase
		// 	this.query = 'Select Id, Name from ProfitStarsIntegration__c';
		// } else{
			this.query = 'Select Id, Name from ProfitStarsIntegration__c where Name = \'MyCase Payments\'';
		// }
	}

	public Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

	public void execute(Database.BatchableContext BC, List<ProfitStarsIntegration__c> scope) {

		List<PS_Audit_Log__c> logs = new List <PS_Audit_Log__c>();
		List<ValuePlus__c> valuePlusUpdateList = new List<ValuePlus__c>();	
		List<Bank_Account__c> bankAccountUpdateList = new List<Bank_Account__c>();
		Map <Id, Id> bankAcIdToVPlusId = new Map<Id, Id>();
        boolean isInbound = true;
		String vplogType = '';
		String banklogType = '';
		//String recordTypeName = 'APM Payments';
	
		// ps_GetAllMerchantRespProcessor is responsible for parsing the xml response from callout
		ps_GetAllMerchantRespProcessor psRespProcessor = new ps_GetAllMerchantRespProcessor();
		Map<Id, ps_GuidResp.WSMerchant> vIdToMerchantMap = new Map<Id, ps_GuidResp.WSMerchant>();
		Map<Id, Map<String, ps_GuidResp.WSMerchantLocation>> bankLabelToLocation = new Map<Id, Map<String, ps_GuidResp.WSMerchantLocation>>();
		Set<Id> valuePlusIdSet = new Set<Id>();
		Map<Id, String> vIdToRTNameMap = new Map<Id, String>();
		Set<Id> outboundVIds = new Set<Id>();
		Set<Id> inboundVIds = new Set<Id>();

		try{
			
			for(ProfitStarsIntegration__c s : scope){

				System.debug('Custom Setting Name - ' + s.Name);
				// Product is passed only in case of outbound payment
				String product = (s.Name =='APM Payments Echeck')? 'echeck' : null;

				ps_GetMidLid fup = new ps_GetMidLid(s.Id, product);
				System.debug('fup.response: ' + fup.response);
				System.debug('fup.response.getAllMerchants: ' + fup.response.getAllMerchants);

				if(fup.response != null && fup.response.getAllMerchants != null && fup.response.getAllMerchants.getAllMerchantsResult != null 
					&& fup.response.getAllMerchants.getAllMerchantsResult.wsMerchant != null){

					for(ps_GuidResp.WSMerchant merchantResult : fup.response.getAllMerchants.getAllMerchantsResult.wsMerchant){
						if(merchantResult.merchantName != null){
							
                            String token = merchantResult.boardingRefID;
							System.debug('Token - ' + token);

							Id vPlusid;

							if (token !=  null && token != 'san_true' && token != 'true') {
								String vid = String.escapeSingleQuotes(token);
							   
								if((vid.length() == 15 || vid.length() == 18) && Pattern.matches('^[a-zA-Z0-9]*$', vid)) {
									vPlusid = Id.valueOf(vid);
								} else {
									continue;
								}
							} 

							if(vPlusid != null){
								vIdToMerchantMap.put(vPlusid, merchantResult);

								if(merchantResult.locations != null && !merchantResult.locations.wsMerchantLocation.isEmpty()){
									for(ps_GuidResp.WSMerchantLocation loc : merchantResult.locations.wsMerchantLocation){
										Map<String, ps_GuidResp.WSMerchantLocation> tempMap;
										if(bankLabelToLocation.containsKey(vPlusid)){
											tempMap = bankLabelToLocation.get(vPlusid);
										} else{
											tempMap = new Map<String, ps_GuidResp.WSMerchantLocation>();
										}
										tempMap.put(loc.locationName, loc);
										bankLabelToLocation.put(vPlusid, tempMap);
									}
								}
							}
						}
					}
					System.debug('vIdToMerchantMap: ' + vIdToMerchantMap);
					System.debug('bankLabelToLocation: ' + bankLabelToLocation);

					if(!vIdToMerchantMap.isEmpty()){
						valuePlusIdSet = vIdToMerchantMap.keySet();

						for(Id vId : valuePlusIdSet){
							if(s.name == 'MyCase Payments'){
								//recordTypeName = 'MyCase Payments';
								vIdToRTNameMap.put(vId, 'MyCase Payments');
							} else{
								vIdToRTNameMap.put(vId, 'APM Payments');
							}

							if(s.name == 'APM Payments Echeck'){
								//isInbound = false;
								outboundVIds.add(vId);
							} else{
								inboundVIds.add(vId);
							}
						}
					}
				}
			}

			List<ValuePlus__c> valuePlusList = new List<ValuePlus__c>();

			//Logic for Inbound records
			List<ValuePlus__c> valuePlusInboundList = new List<ValuePlus__c>();
            system.debug('Estos son los Ids: ' + inboundVIds);
			valuePlusInboundList = [SELECT Id, Name, Account__r.Account_DBA_Name__c, ProfitStars_Merchant_ID__c, OnBoardingStatus__c, Outbound_MID__c, Outbound_On_Boarding_Status__c,
					(Select Id, Name, Account_Label__c, LID__c, Location_Add_Status__c, Outbound_LID__c, Outbound_Location_Add_Status__c from Bank_Accounts__r WHERE LID__c = null) 
					FROM ValuePlus__c 
					WHERE ProfitStars_Merchant_ID__c = null AND Id in :inboundVIds and (PMT_ProfitStars_On_Boarding_Status__c = 'Transmitted' or OnBoardingStatus__c = 'Transmitted')];

			if(!valuePlusInboundList.isEmpty()){
				valuePlusList.addAll(valuePlusInboundList);
			}

			//Logic for Outbound records
			List<ValuePlus__c> valuePlusOutboundList = new List<ValuePlus__c>();
			valuePlusOutboundList = [SELECT Id, Name, Account__r.Account_DBA_Name__c, ProfitStars_Merchant_ID__c, OnBoardingStatus__c, Outbound_MID__c, Outbound_On_Boarding_Status__c,
					(Select Id, Name, Account_Label__c, LID__c, Location_Add_Status__c, Outbound_LID__c, Outbound_Location_Add_Status__c from Bank_Accounts__r WHERE Outbound_LID__c = null) 
					FROM ValuePlus__c 
					WHERE Outbound_MID__c = null AND Id in :outboundVIds and Outbound_On_Boarding_Status__c = 'Transmitted'];

			if(!valuePlusOutboundList.isEmpty()){
				valuePlusList.addAll(valuePlusOutboundList);
			}

			for(ValuePlus__c vp : valuePlusList){

				Boolean isUpdated = false;

				if(!vIdToMerchantMap.containsKey(vp.Id)){
					continue;
				}

				if(inboundVIds.contains(vp.Id)){
					vp.ProfitStars_Merchant_ID__c = vIdToMerchantMap.get(vp.id).entityId;

					if(vIdToRTNameMap.containsKey(vp.Id) && vIdToRTNameMap.get(vp.Id) == 'MyCase Payments') {
						vp.PMT_ProfitStars_On_Boarding_Status__c = 'Approved';
					} else{
						vp.OnBoardingStatus__c = 'Approved';
					}
					isUpdated = true;
				} else{
					vp.Outbound_MID__c = vIdToMerchantMap.get(vp.id).entityId;
					vp.Outbound_On_Boarding_Status__c = 'Approved';
					isUpdated = true;
				}

				if(isUpdated){
					valuePlusUpdateList.add(vp);
					System.debug('BizSys_RK Updated ValuePlus Record ' + vp.Name + ' for merchant ' + vp.Account__r.Account_DBA_Name__c);
					isUpdated = false;
				}

				for(Bank_Account__c ba : vp.Bank_Accounts__r) {

					System.debug('BizSys_RK Bank Account Label : ' + ba.Account_Label__c);

					if(bankLabelToLocation.containsKey(vp.Id) && bankLabelToLocation.get(vp.Id).containsKey(ba.Account_Label__c)){	

						// Fields to update in this request on Bank Account Object							
						if(inboundVIds.contains(vp.Id)){
							ba.LID__c = bankLabelToLocation.get(vp.Id).get(ba.Account_Label__c).locationId;
							ba.Location_Add_Status__c = 'Approved';
						} else{
							ba.Outbound_LID__c = bankLabelToLocation.get(vp.Id).get(ba.Account_Label__c).locationId;
							ba.Outbound_Location_Add_Status__c = 'Approved';
						}

						bankAcIdToVPlusId.put(ba.id, vp.id);
						bankAccountUpdateList.add(ba);
						System.debug('BizSys_RK Updated Bank Account ' + ba.Account_Label__c + ' for merchant ' + vp.Account__r.Account_DBA_Name__c);
					}
				}
			}

			// Logging is created once the records are updated correctly, The success record is created 
			// if update is failed, failure log is created. 
			if(!bankAccountUpdateList.isEmpty()){
				ClsStaticVariable.isBankAccountTrigger = false; //this flag is not used anymore, have to test it to verify 

				Database.SaveResult[] srList = Database.update(bankAccountUpdateList, false);
				// Iterate through each returned result
				for (Database.SaveResult sr : srList) {
					Id vPlusId = bankAcIdToVPlusId.get(sr.getId());
					banklogType = (inboundVIds.contains(vPlusId)) ? 'GetAllMerchant Inbound LID' : 'GetAllMerchant Outbound LID';

				    if(sr.isSuccess()){
				        // Operation was successful, so get the ID of the record that was processed
				        logs.add(ProfitStarsUtils.generateAuditLogForValuePlus(banklogType, 'Success', '' , vPlusId, vIdToRTNameMap.get(vPlusId)));
				        System.debug('BizSys_RK Successfully updated the bank account. BankAccount Id: ' + sr.getId());
				    }
				    else{
				    	String errors = '';
				        // Operation failed, so get all errors                
				        for(Database.Error err : sr.getErrors()){
				        	errors = errors + ' Error Status Code ' + err.getStatusCode() + ' : Error Message : ' + err.getMessage() + ' : Bank Account Fields that affected this error : ' + err.getFields();
				        }
				        logs.add(ProfitStarsUtils.generateAuditLogForValuePlus(banklogType, 'Failure', '' , vPlusId, vIdToRTNameMap.get(vPlusId)));

				    }
				}
				//update bankAccountUpdateList;
				// Can create Pick the reason from Database.SaveResultMethod
			}

			// Logging is created once the records are updated correctly, The success record is created 
			// if update is failed, failure log is created. 
			if(!valuePlusUpdateList.isEmpty()){
				ClsStaticVariable.isValuePlusTrigger = false; //this flag is not used anymore, have to test it to verify

				Database.SaveResult[] srList = Database.update(valuePlusUpdateList, false);
				for(Database.SaveResult sr : srList){
					Id vPlusId = sr.getId();
					vplogType = (inboundVIds.contains(vPlusId)) ? 'GetAllMerchant Inbound MID' : 'GetAllMerchant Outbound MID';

				    if(sr.isSuccess()){
				        // Operation was successful, so get the ID of the record that was processed
				        logs.add(ProfitStarsUtils.generateAuditLogForValuePlus(vplogType, 'Success', '' , vPlusId, vIdToRTNameMap.get(vPlusId)));
				        System.debug('BizSys_RK Successfully updated the VPlus. VPlus Id: ' + vPlusId);
				    }
				    else{
				    	String errors = '';
				        for(Database.Error err : sr.getErrors()){
				        	errors = errors + ' Error Status Code ' + err.getStatusCode() + ' : Error Message : ' + err.getMessage() + ' : Bank Account Fields that affected this error : ' + err.getFields();
				        }
	    				logs.add(ProfitStarsUtils.generateAuditLogForValuePlus(vplogType, 'Failure', errors , vPlusId, vIdToRTNameMap.get(vPlusId)));
				    }
				}
			}

			if(!logs.isEmpty()){
				insert logs;
			}
		}catch(Exception e){
			System.debug('BizSys_RK Error Message ' + e.getMessage() + e.getLineNumber());
			SystemExceptionLogger.fireSystemExceptionLogEvent(e,'PS_BatchGetMidLid','execute', SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, e.getMessage(), 'PS_BatchGetMidLid', null, false);
		}
	}

	public void finish(Database.BatchableContext BC) {}
}