/*
* Test class: ps_eCheckButtonMethodsTest, CyberSourceIntegrationServiceTest
*/ 
global class ps_eCheckButtonMethods{
	
	global class OutboundOutboundButtonException extends Exception {}

	global class ButtonResult{
		Public String result {get; set;}
		Public Boolean didPass {get; set;}
	}

	Public String result;

	webService static String callEnrollment(Id id){
		ValuePlus__c vp = [SELECT Id,RecordTypeId FROM ValuePlus__c WHERE Id =: id];
		ps_eCheckButtonMethods.buttonResult res = new ps_eCheckButtonMethods.buttonResult();
		ps_EnrollmentReq enrollmentReq;
		try{
			enrollmentReq = new ps_EnrollmentReq(id, 'echeck');
			
			if(enrollmentReq.resp != null && enrollmentReq.resp.message != null && (enrollmentReq.resp.message.toLowerCase() == 'success' || enrollmentReq.resp.message.toLowerCase() == 'account already exists')){
				res.didPass = true;
				res.result = JSON.serialize(enrollmentReq.resp);
				vp.Outbound_On_Boarding_Status__c = 'Transmitted';
				vp.Successfully_Enrolled_Outbound_at__c= DateTime.now();
				update vp;
			} else{
				res.didPass = false;
				if(enrollmentReq.resp != null && enrollmentReq.resp.message != null){
					res.result = enrollmentReq.resp.message;
				}else{
					res.result = 'Did not get a valid response back!';
				}
			}
		} catch(Exception e){
			res.didPass = false;
			res.result = e.getMessage();
			PS_Audit_Log__c audit = new PS_Audit_Log__c(
				Value_plus__c = id,
				Call_Type__c = 'Enroll Outbound',
				Error_Message__c = e.getMessage(),
				Raw_Json__c = e.getStackTraceString(), 
				Application_Type__c = getVPRecordTypeName(id)		//request #R151866 Updated to insert application type
			);
			insert audit;
		}

		try{
			PS_Audit_Log__c audit;
			if(res.didPass){
				audit = new PS_Audit_Log__c(
					Value_plus__c = id,
					Call_Type__c = 'Enroll Outbound',
					Error_Message__c = 'Success',
					Raw_Json__c = (enrollmentReq != null && enrollmentReq.resp != null)? JSON.serialize(enrollmentReq.resp) : '', 
					Application_Type__c = getVPRecordTypeName(id)		//request #R151866 Updated to insert application type
				);
			}else if(enrollmentReq != null && enrollmentReq.resp != null && enrollmentReq.resp.message != null){
				audit = new PS_Audit_Log__c(
					Value_plus__c = id,
					Call_Type__c = 'Enroll Outbound',
					Error_Message__c = 'Failure',
					Raw_Json__c = JSON.serialize(enrollmentReq.resp),
					Application_Type__c = getVPRecordTypeName(id)
				);
			}

			if(audit != null){
				System.debug(audit);
				insert audit;
			}
		} catch(Exception e){
			System.debug(e.getMessage());
			SystemExceptionLogger.insertSystemExceptionLogEntry(e, 'ps_eCheckButtonMethods', 'callEnrollment', SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, e.getMessage(), false);
		}
		return JSON.serialize(res);
	}

	webService static String callVelocity(Id id){
		ps_VelocityReq velocityReq;
		ps_eCheckButtonMethods.buttonResult res = new ps_eCheckButtonMethods.buttonResult();
		try{
			velocityReq = new ps_VelocityReq(id, 'echeck');
			
			if(velocityReq.response != null && velocityReq.response.success != null && velocityReq.response.success.toLowerCase() == 'true'){
				system.debug('Velocity ' + velocityReq.response);
				res.didPass = true;
				res.result = JSON.serialize(velocityReq.response);
			} else{
				res.didPass = false;
				
				if(velocityReq.response != null && velocityReq.response.errorMessage != null){
					res.result = velocityReq.response.errorMessage;
				}else{
					res.result = 'Did not get a valid response back!';
				}
			}
		} catch(Exception e){
			res.didPass = false;
			res.result = e.getMessage();
			PS_Audit_Log__c audit = new PS_Audit_Log__c(
				Value_plus__c = id,
				Call_Type__c = 'Velocity Update Outbound',
				Error_Message__c = e.getMessage(),
				Raw_Json__c = e.getStackTraceString(),
				Application_Type__c = getVPRecordTypeName(id)		//request #R151866 Updated to insert application type
			);
			insert audit;
		}
		try{
			PS_Audit_Log__c audit;

			if(res.didPass){
				audit = new PS_Audit_Log__c(
					Value_plus__c = id,
					Call_Type__c = 'Velocity Update Outbound',
					Error_Message__c = 'Success',
					Raw_Json__c = (velocityReq != null && velocityReq.response != null)? JSON.serialize(velocityReq.response) : '', 
					Application_Type__c = getVPRecordTypeName(id)		//request #R151866 Updated to insert application type
				);
			}else if(velocityReq != null && velocityReq.response != null && velocityReq.response.errorMessage != null){
				audit = new PS_Audit_Log__c(
					Value_plus__c = id,
					Call_Type__c = 'Velocity Update Outbound',
					Error_Message__c = 'Failure',
					Raw_Json__c = JSON.serialize(velocityReq.response),
					Application_Type__c = getVPRecordTypeName(id)
				);
			}

			if(audit != null){
				System.debug(audit);
				insert audit;
			}
		} catch(Exception e){
			System.debug(e.getMessage());
			SystemExceptionLogger.insertSystemExceptionLogEntry(e, 'ps_eCheckButtonMethods', 'callVelocity', SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, e.getMessage(), false);
		}
		return JSON.serialize(res);
	}
	
	/*
	*	Request #R152441 - Created this method for users to be able to 
	*				submit new bank accounts to profitstars on button click
	*/
	webService static String callLocation(Id id){
		ProfitStarsIntegrationService psIs = new ProfitStarsIntegrationService();
		String locResp;
		ps_addOnBatchReq locationReq;
		
		Bank_Account__c ba = [select Id, ValuePlus__c, Account_Label__c, ValuePlus__r.Outbound_MID__c, ValuePlus__r.recordType.Name from Bank_Account__c where Id = : id LIMIT 1];
		ps_eCheckButtonMethods.buttonResult res = new ps_eCheckButtonMethods.buttonResult();
		try{
			
			locationReq = new ps_addOnBatchReq(ba.ValuePlus__c, id, 'echeck');
			
			if (locationReq.response != null && locationReq.response.success != null && locationReq.response.success.toLowerCase() == 'true') {
				system.debug('locationReq ' + locationReq.response);
				res.didPass = true;
				res.result = JSON.serialize(locationReq.response);
				
				locResp = psIs.makeGetLocationByLocationNameRequest(ba.ValuePlus__r.Outbound_MID__c, ba.ValuePlus__r.recordType.Name, ba.Account_Label__c, 'echeck');
				ProfitStarsUtils.fetchBankAccountToUpdateOutbound(ba, locResp);
			} else{
				res.didPass = false;
				
				if(locationReq.response != null && locationReq.response.errorMessage != null){
					res.result = locationReq.response.errorMessage;
				}else{
					res.result = 'Did not get a valid response back!';
				}
			}
		} catch(ProfitStarsIntegrationService.PSISException ps){
			ba.Outbound_Location_Add_Status__c = 'Failed';
			
			res.didPass = false;
			res.result = ps.getMessage();
			PS_Audit_Log__c audit = new PS_Audit_Log__c(
				BankAccount__c = id,
				Call_Type__c = 'Add Location to Outbound',
				Error_Message__c = ps.getMessage(),
				Raw_Json__c = ps.getStackTraceString(),
				Application_Type__c = ba.ValuePlus__r.recordType.Name		
			);
			insert audit;
		} catch(Exception e){
			
			res.didPass = false;
			res.result = e.getMessage();
			PS_Audit_Log__c audit = new PS_Audit_Log__c(
				BankAccount__c = id,
				Call_Type__c = 'Add Location to Outbound',
				Error_Message__c = e.getMessage(),
				Raw_Json__c = e.getStackTraceString(),
				Application_Type__c = ba.ValuePlus__r.recordType.Name		
			);
			insert audit;
		}

		try{
			PS_Audit_Log__c audit;

			if(res.didPass){
				audit = new PS_Audit_Log__c(
					BankAccount__c = id,
					Call_Type__c = 'Add Location to Outbound',
					Error_Message__c = 'Success',
					Raw_Json__c = (locationReq != null && locationReq.response != null)? JSON.serializePretty(locationReq.response) : '', 
					Application_Type__c = ba.ValuePlus__r.recordType.Name		
				);
			}else if(locationReq != null && locationReq.response != null && locationReq.response.errorMessage != null){
				audit = new PS_Audit_Log__c(
					BankAccount__c = id,
					Call_Type__c = 'Add Location to Outbound',
					Error_Message__c = 'Failure',
					Raw_Json__c = JSON.serialize(locationReq.response),
					Application_Type__c = ba.ValuePlus__r.recordType.Name
				);
			}

			if(audit != null){
				System.debug(audit);
				insert audit;
			}
		} catch(Exception e){
			System.debug(e.getMessage());
			SystemExceptionLogger.insertSystemExceptionLogEntry(e, 'ps_eCheckButtonMethods', 'callLocation', SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, e.getMessage(), false);
		}
		System.debug('ps_eCheckButtonMethods.callLocation Bank Account is ' + ba);
		update ba;
		return JSON.serialize(res);
	}


	
	/*
	*	Request #R152441 - Created this method for users to be able to 
	*				submit new bank accounts to profitstars on button click
	*
	* Not used anymore?
	*/
	webService static String callLocationUpdate(Id id){
		/*ps_BankAccountReq locationupdateReq;
		Bank_Account__c ba = [select Id, ValuePlus__c, ValuePlus__r.recordType.Name from Bank_Account__c where Id = : id LIMIT 1];
		ps_eCheckButtonMethods.buttonResult res = new ps_eCheckButtonMethods.buttonResult();
		try {
			locationupdateReq = new ps_BankAccountReq(ba.ValuePlus__c, 'echeck');
			
			//if (locationupdateReq.response.didPass) {
			if (locationupdateReq.response != null && locationupdateReq.response.success != null && locationupdateReq.response.success.toLowerCase() == 'true') {
				system.debug('locationupdateReq ' + locationupdateReq.response);
				res.didPass = true;
				res.result = JSON.serialize(locationupdateReq.response);
				ba.Outbound_Location_Update_Status__c = 'Success';
			} else {
				res.didPass = false;
				ba.Outbound_Location_Update_Status__c = 'Failed';
				
				if(locationupdateReq.response != null && locationupdateReq.response.errorMessage != null){
					res.result = locationupdateReq.response.errorMessage;
				}else{
					res.result = 'Did not get a valid response back!';
				}
			}
			//res.result = JSON.serialize(locationupdateReq.response.didPass);
		} 
		catch(ProfitStarsIntegrationService.PSISException ps)
		{
			ba.Outbound_Location_Update_Status__c = 'Failed';
			
			res.didPass = false;
			res.result = ps.getMessage();
			PS_Audit_Log__c audit = new PS_Audit_Log__c(
				BankAccount__c = id,
				Call_Type__c = 'Location Update Outbound',
				Error_Message__c = ps.getMessage(),
				Raw_Json__c = ps.getStackTraceString(),
				Application_Type__c = ba.ValuePlus__r.recordType.Name		
			);
			insert audit;
		
		}
		catch (Exception e) {
			ba.Outbound_Location_Update_Status__c = 'Failed';
			res.didPass = false;
			res.result = e.getMessage();
			PS_Audit_Log__c audit = new PS_Audit_Log__c(
				BankAccount__c = id,
				Call_Type__c = 'Location Update Outbound',
				Error_Message__c = e.getMessage(),
				Raw_Json__c = e.getStackTraceString(),
				Application_Type__c = ba.ValuePlus__r.recordType.Name		
			);
			insert audit;
		}
		try {
			PS_Audit_Log__c audit;

			if(res.didPass){
				audit = new PS_Audit_Log__c(
					BankAccount__c = id,
					Call_Type__c = 'Location Update Outbound',
					Error_Message__c = 'Success',
					Raw_Json__c = (locationupdateReq != null && locationupdateReq.response != null)? JSON.serializePretty(locationupdateReq.response) : '', 
					Application_Type__c = ba.ValuePlus__r.recordType.Name		
				);
			}else if(locationupdateReq != null && locationupdateReq.response != null && locationupdateReq.response.errorMessage != null){
				audit = new PS_Audit_Log__c(
					BankAccount__c = id,
					Call_Type__c = 'Location Update Outbound',
					Error_Message__c = 'Failure',
					Raw_Json__c = JSON.serialize(locationupdateReq.response),
					Application_Type__c = ba.ValuePlus__r.recordType.Name
				);
			}

			if(audit != null){
				System.debug(audit);
				insert audit;
			}
		} catch (Exception e) {
			System.debug(e.getMessage());
			SystemExceptionLogger.insertSystemExceptionLogEntry(e, 'ps_eCheckButtonMethods', 'callLocationUpdate', SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, e.getMessage(), false);
		}
		System.debug('ps_eCheckButtonMethods.callLocation Bank Account is '+ba);
		update ba;
		return JSON.serialize(res);*/
		return null;
	}

	// webService static String createCyberSourceSubcription(Id id){
		
	// 	CyberSourceIntegrationService csIntegSvc = new CyberSourceIntegrationService();

	// 	ps_eCheckButtonMethods.buttonResult res = new ps_eCheckButtonMethods.buttonResult();		
	// 	Bank_Account__c ba = [select Id, 
	// 		ValuePlus__c,
	// 		ValuePlus__r.Account__r.Account_Legal_Name__c,
	// 		ValuePlus__r.Account__r.Account_DBA_Name__c,
	// 		ValuePlus__r.Account__r.ShippingStreet,
	// 		ValuePlus__r.Account__r.ShippingCity,
	// 		ValuePlus__r.Account__r.ShippingState,
	// 		ValuePlus__r.Account__r.ShippingPostalCode,
	// 		ValuePlus__r.Account__r.ShippingCountry,
	// 		ValuePlus__r.Account__r.Zuora_Billing_Contact_Email__c,
	// 		ValuePlus__r.Account__r.Phone,
	// 		CybersourceUpdateDate__c, 
	// 		Cybersource_ID__c, 
	// 		CybersourceUpdateStatus__c,
	// 		RoutingNo__c,
	// 		AccountNo__c
	// 		from Bank_Account__c where Id = : id LIMIT 1];	


	// 	try{
	// 		System.debug(LoggingLevel.ERROR, 'calling the cybersource integration service.');
	// 		CyberSourceIntegrationService.CyberSourceResult cybRes = csIntegSvc.registerBankAccount(ba);
	// 					System.debug(LoggingLevel.ERROR, 'Rohit Result - ' + cybRes);

	// 		if(cybRes.isSuccssful==true){
	// 			System.debug(LoggingLevel.ERROR, 'Rohit Result - ' + cybRes + ' Bank account - ' + ba);

	//  			ba.CybersourceUpdateDate__c = System.today();
	//  			ba.CybersourceUpdateStatus__c = 'Transmitted';
	//  			Database.SaveResult[] srList = Database.UPDATE (new List<Bank_Account__c> {ba}, false);

    //             for (Database.SaveResult sr : srList){
    //                 if (sr.isSuccess()){
    //                     System.debug (LoggingLevel.ERROR,'*** Account is successfully updated. Account Id : ' + sr.getId());
    //                 } else{
    //                     for(Database.Error err : sr.getErrors()){
    //                        String errMsg = err.getStatusCode() + ': ' + err.getMessage() + ' Account fields that affected this error: ' + err.getFields() + '\n';
    //                        	System.debug(LoggingLevel.ERROR, 'Failed - ' + errMsg);
    //                     }
    //                 }
    //             }
	//  		}
	//  		Automation_Log__c log = new Automation_Log__c (Message__c=cybRes.message, BankAccount__c = ba.id);
	//  		insert log;
	// 	} catch(Exception e){
	// 		SystemExceptionLogger.insertSystemExceptionLogEntry(e, 'ps_eCheckButtonMethods', 'createCyberSourceSubcription', SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, e.getMessage(), false);
	// 	}
	// 	res.didPass = true;
	// 	return JSON.serialize(res);
	// }

	
	/*
		request #R151866 This method retrieves record type incase of failure.
		The recordtype is unavailable in the context during the javascript call and a SOQL is forced.
	*/
	private static String getVPRecordTypeName(Id id){
		ValuePlus__c vp = new ValuePlus__c();
		if(id != null){
			vp = [select Id, recordType.Id, recordType.Name from ValuePlus__c where Id =: id];
			return vp.recordType.Name;
		}
		return null;
	}
}