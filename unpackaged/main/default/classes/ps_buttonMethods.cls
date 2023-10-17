/******************************************************************************************************
* copyright © 2015
*
* File		: ps_buttonMethods.cls
*
* Purpose	: This is a global class created to process request to profit stars by user action. The scripts are  
*				available on ValuePlus__c object.
*
* Referred from 	: Javascript('Enroll in ProfitStars', 'Push Velocity Update')
*
* Test class: ps_buttonMethodsTest
*-----------------------------------------------------------------------------
*
*Release Date		Request 	Updated By			Description
*----------------------------------------------------------------------------------------------------------------------
*					Nill							Initial Creation
*
*07/22/2015			R151866		Venkat Araveeti		MyCase Integration
*08/28/2015			R152441		Venkat Araveeti		Create new webservice for location calls
*******************************************************************************************************/
global class ps_buttonMethods{
	global class buttonException extends Exception {}

	global class ButtonResult{
		Public String result {get; set;}
		Public Boolean didPass {get; set;}
	}

	public String result;

	webService static String callEnrollment(Id id){
		ps_buttonMethods.buttonResult res = new ps_buttonMethods.buttonResult();
		ps_EnrollmentReq enrollmentReq;
		String recordTypeName;
		try{
			enrollmentReq = new ps_EnrollmentReq(id, null);
			System.debug('enrollmentReq '+enrollmentReq);
			recordTypeName = getVPRecordTypeName(id);
			ValuePlus__c vp = new ValuePlus__c(Id = id);
			
			if(enrollmentReq.resp != null && enrollmentReq.resp.message != null && (enrollmentReq.resp.message.toLowerCase() == 'success' || enrollmentReq.resp.message.toLowerCase() == 'account already exists')){
				res.didPass = true;
				res.result = JSON.serialize(enrollmentReq.resp);

				if(recordTypeName == 'MyCase Payments'){
					vp.PMT_ProfitStars_On_Boarding_Status__c = 'Transmitted';
				} else{
					vp.PMT_ProfitStars_On_Boarding_Status__c = 'Transmitted';
				}
				
				vp.Successfully_Enrolled_in_Profit_Stars_at__c = DateTime.now();
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
				Call_Type__c = 'Enroll',
				Error_Message__c = e.getMessage(),
				Raw_Json__c = e.getStackTraceString(), 
				Application_Type__c = recordTypeName		//request #R151866 Updated to insert application type
			);
			insert audit;
		}

		try{
			PS_Audit_Log__c audit;
			if(res.didPass){
				audit = new PS_Audit_Log__c(
					Value_plus__c = id,
					Call_Type__c = 'Enroll',
					Error_Message__c = 'Success',
					Raw_Json__c = (enrollmentReq != null && enrollmentReq.resp != null)? JSON.serialize(enrollmentReq.resp) : '',
					Application_Type__c = recordTypeName		//request #R151866 Updated to insert application type
				);	
			} else if(enrollmentReq != null && enrollmentReq.resp != null && enrollmentReq.resp.message != null){
				audit = new PS_Audit_Log__c(
					Value_plus__c = id,
					Call_Type__c = 'Enroll',
					Error_Message__c = 'Failure',
					Raw_Json__c = JSON.serialize(enrollmentReq.resp),
					Application_Type__c = recordTypeName
				);
			}

			if(audit != null){
				System.debug(audit);
				insert audit;
			}
		} catch(Exception e){
			System.debug(e);
			System.debug(e.getStackTraceString());
			System.debug(e.getMessage());
			SystemExceptionLogger.insertSystemExceptionLogEntry(e, 'ps_buttonMethods', 'callEnrollment', SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, e.getMessage(), false);
		}

		return JSON.serialize(res);
	}

	webService static String callVelocity(Id id){
		ps_VelocityReq velocityReq;
		ps_buttonMethods.buttonResult res = new ps_buttonMethods.buttonResult();
		try{
			velocityReq = new ps_VelocityReq(id, null);
			
			if(velocityReq.response != null && velocityReq.response.success != null && velocityReq.response.success.toLowerCase() == 'true'){
				system.debug('Velocity ' + velocityReq.response);
				res.didPass = true;
				res.result = JSON.serialize(velocityReq.response);
			} else {
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
				Call_Type__c = 'Batch Velocity Update',
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
					Call_Type__c = 'Batch Velocity Update',
					Error_Message__c = 'Success',
					Raw_Json__c = (velocityReq != null && velocityReq.response != null)? JSON.serialize(velocityReq.response) : '', 
					Application_Type__c = getVPRecordTypeName(id)		//request #R151866 Updated to insert application type
				);
			}else if(velocityReq != null && velocityReq.response != null && velocityReq.response.errorMessage != null){
				audit = new PS_Audit_Log__c(
					Value_plus__c = id,
					Call_Type__c = 'Batch Velocity Update',
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
			SystemExceptionLogger.insertSystemExceptionLogEntry(e, 'ps_buttonMethods', 'callVelocity', SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, e.getMessage(), false);
		}
		return JSON.serialize(res);
	}
	
	/*
	*	Request #R152441 - Created this method for users to be able to 
	*				submit new bank accounts to profitstars on button click
	*/
	webService static String callLocation(Id id){
		ProfitStarsIntegrationService psIs = new ProfitStarsIntegrationService();
		ps_addOnBatchReq locationReq;
		String locResp;
		Bank_Account__c ba = [select Id, ValuePlus__c, Account_Label__c, ValuePlus__r.ProfitStars_Merchant_ID__c, ValuePlus__r.recordType.Name from Bank_Account__c where Id = : id LIMIT 1];
		
		ps_buttonMethods.buttonResult res = new ps_buttonMethods.buttonResult();
		try{
			locationReq = new ps_addOnBatchReq(ba.ValuePlus__c, id, null);
			
			if(locationReq.response != null && locationReq.response.success != null && locationReq.response.success.toLowerCase() == 'true'){
				system.debug('locationReq ' + locationReq.response);
				System.debug('locationReq.response.success: ' + locationReq.response.success);
				res.didPass = true;
				res.result = JSON.serialize(locationReq.response);
				locResp = psIs.makeGetLocationByLocationNameRequest(ba.ValuePlus__r.ProfitStars_Merchant_ID__c, ba.ValuePlus__r.recordType.Name, ba.Account_Label__c, null);
				ProfitStarsUtils.fetchBankAccountToUpdate(ba, locResp);
			} else{
				res.didPass = false;
				if(locationReq.response != null && locationReq.response.errorMessage != null){
					res.result = locationReq.response.errorMessage;
				}else{
					res.result = 'Did not get a valid response back!';
				}
			}
		} catch(ProfitStarsIntegrationService.PSISException ps){
			ba.Location_Add_Status__c = 'Failed';
			ba.Ready_for_push_to_ProfitStars__c = false;
			
			res.didPass = false;
			res.result = ps.getMessage();
			PS_Audit_Log__c audit = new PS_Audit_Log__c(
				BankAccount__c = id,
				Call_Type__c = 'Batch Location Update',
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
				Call_Type__c = 'Batch Location Update',
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
					Call_Type__c = 'Batch Location Update',
					Error_Message__c = 'Success',
					Raw_Json__c = (locationReq != null && locationReq.response != null)? JSON.serializePretty(locationReq.response) : '', 
					Application_Type__c = ba.ValuePlus__r.recordType.Name		
				);
			}else if(locationReq != null && locationReq.response != null && locationReq.response.errorMessage != null){
				audit = new PS_Audit_Log__c(
					BankAccount__c = id,
					Call_Type__c = 'Batch Location Update',
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
			SystemExceptionLogger.insertSystemExceptionLogEntry(e, 'ps_buttonMethods', 'callLocation', SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, e.getMessage(), false);
		}
		System.debug('ps_buttonMethods.callLocation Bank Account is '+ba);
		update ba;
		return JSON.serialize(res);
	}

	//Adds a 'Return-Only' Bank Account to ProfitStars
	webService static String callAddReturnAccount(Id id){
		ps_FieldUpdateReq addReturnAccReq;
		ps_buttonMethods.buttonResult res = new ps_buttonMethods.buttonResult();

		Bank_Account__c ba = [select Id, Return_Account_Add_Status__c, ValuePlus__r.recordType.Name from Bank_Account__c where Id = :id LIMIT 1];

		try{
			addReturnAccReq = new ps_FieldUpdateReq('return only account', id, null);
			
			if(addReturnAccReq.response != null && addReturnAccReq.response.success != null && addReturnAccReq.response.success.toLowerCase() == 'true') {
				system.debug('AddReturnAccount Response: ' + addReturnAccReq.response);
				res.didPass = true;
				res.result = JSON.serialize(addReturnAccReq.response);
				ba.Return_Account_Add_Status__c = 'Submitted';
			} else{
				res.didPass = false;
				if(addReturnAccReq.response != null && addReturnAccReq.response.errorMessage != null){
					res.result = addReturnAccReq.response.errorMessage;
				}else{
					res.result = 'Did not get a valid response back!';
				}
				ba.Return_Account_Add_Status__c = 'Failed';
			}
		} catch(Exception e) {
			res.didPass = false;
			res.result = e.getMessage();
			ba.Return_Account_Add_Status__c = 'Failed';

			PS_Audit_Log__c audit = new PS_Audit_Log__c(
				BankAccount__c = id,
				Call_Type__c = 'Add Return-Only Account',
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
					Call_Type__c = 'Add Return-Only Account',
					Error_Message__c = 'Success',
					Raw_Json__c = (addReturnAccReq != null && addReturnAccReq.response != null)? JSON.serialize(addReturnAccReq.response) : '', 
					Application_Type__c = ba.ValuePlus__r.recordType.Name
				);
			}else if(addReturnAccReq != null && addReturnAccReq.response != null && addReturnAccReq.response.errorMessage != null){
				audit = new PS_Audit_Log__c(
					BankAccount__c = id,
					Call_Type__c = 'Add Return-Only Account',
					Error_Message__c = 'Failure',
					Raw_Json__c = JSON.serialize(addReturnAccReq.response),
					Application_Type__c = ba.ValuePlus__r.recordType.Name
				);
			}

			if(audit != null){
				System.debug(audit);
				insert audit;
			}
		} catch(Exception e) {
			System.debug(e.getMessage());
			SystemExceptionLogger.insertSystemExceptionLogEntry(e, 'ps_buttonMethods', 'callAddReturnAccount', SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, e.getMessage(), false);
		}
		update ba;
		return JSON.serialize(res);
	}
	
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