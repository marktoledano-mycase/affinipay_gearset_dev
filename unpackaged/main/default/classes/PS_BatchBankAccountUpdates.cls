/******************************************************************************************************
* copyright © 2015
*
* File		: PS_BatchBankAccountUpdates.cls
*
* Purpose	: This is a batch class for Bank Account Update. Thi class identified the records for bank account update 
*				and instanciates the service class to send the request to profitstars
*
* Referred from 	: PS_BatchBankAccountScheduler.cls
*
* Test class : PS_BatchBankAccountUpdatesTest
*-----------------------------------------------------------------------------
*
*Release Date		Request 	Updated By			Description
*----------------------------------------------------------------------------------------------------------------------
*					Nill							Initial Creation
*
*07/21/2015			R151866		Venkat Araveeti		MyCase Integration
*08/28/2015			R152441		Venkat Araveeti	 	Update flag value to stop auto retry
*01/05/2016			R153369		Venkat Araveeti		Updated the SOQL to retrieve the required bank accounts only
*10/18/2019			R1918048	Ryan Kleinberg		Now sends an email to payment.support@mycase.com when a myCase bank Account fails
														to be pushed to profit stars
*******************************************************************************************************/
public class PS_BatchBankAccountUpdates implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
    
    public class PS_BatchBankAccountUpdatesException extends Exception{}
    private @testVisible String errorMessage;
    
    String query;
    
    public PS_BatchBankAccountUpdates() {
        Boolean useSFLogic = false;
		// useSFLogic = [Select Use_SF_Logic__c from ProfitStarsIntegration__c where Name = 'APM Payments' limit 1].Use_SF_Logic__c;

        if(useSFLogic || Test.isRunningTest()){
            this.query = 'Select ID, ps_LocationUpdateRequired__c, ps_UpdateRequired__c, recordType.Name, Account__r.Name, ' +  //request #R151866 updated to identify the record type
                '		(SELECT id, Account_Label__c, ps_BankAccountUpdateRequired__c, ps_LocationUpdateRequired__c, LID__c, Ready_for_push_to_ProfitStars__c FROM Bank_Accounts__r where Ready_for_push_to_ProfitStars__c = true and ps_BankAccountUpdateRequired__c = true) ' +
                '		FROM ValuePlus__c ' +
                '		WHERE Id IN (' +
                '			SELECT ValuePlus__c ' +
                '			FROM Bank_Account__c WHERE Status__c = \'Active\' ' +
                '			AND LID__c != null' +
                '			AND Ready_for_push_to_ProfitStars__c = true' +
                '			AND ps_BankAccountUpdateRequired__c = true' +
                '		) ' +
                '		AND Successfully_Enrolled_in_Profit_Stars_at__c != null';
        } else{
            this.query = 'Select ID, ps_LocationUpdateRequired__c, ps_UpdateRequired__c, recordType.Name, Account__r.Name, ' +  //request #R151866 updated to identify the record type
            '		(SELECT id, Account_Label__c, ps_BankAccountUpdateRequired__c, ps_LocationUpdateRequired__c, LID__c, Ready_for_push_to_ProfitStars__c FROM Bank_Accounts__r where Ready_for_push_to_ProfitStars__c = true and ps_BankAccountUpdateRequired__c = true) ' +
            '		FROM ValuePlus__c ' +
            '		WHERE Id IN (' +
            '			SELECT ValuePlus__c ' +
            '			FROM Bank_Account__c WHERE Status__c = \'Active\' ' +
            '			AND LID__c != null' +
            '			AND Ready_for_push_to_ProfitStars__c = true' +
            '			AND ps_BankAccountUpdateRequired__c = true' +
            '		) ' +
            '		AND Successfully_Enrolled_in_Profit_Stars_at__c != null AND recordType.Name = \'MyCase Payments\'';
        }
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }
    
    // Because this call can execute against N number of bank account call outs, and because of the limit of 100 callouts
    // This execution method must be called with scope size 1.
    public void execute(Database.BatchableContext BC, List<ValuePlus__c> scope) {
        
        Set<PS_Audit_Log__c> logs = new Set<PS_Audit_Log__c>();
        List<Bank_Account__c> bankAccountsToUpdate = new List<Bank_Account__c>();
        List<Bank_Account__c> failedUpdates = new List<Bank_Account__c>();
        String action;
        
        Bank_Account__c[] bankAccounts;
        for (ValuePlus__c s : scope) {
            bankAccounts = s.getSObjects('Bank_Accounts__r');
            log.log('Iterating with Object id: ', s.id, 'Bank Accounts = ' + bankAccounts);
            Boolean allPassed = true;
            String failedBankLabels;
            try {
                action = 'Bank Account Update';
                ps_BankAccountReq bankResp = new ps_BankAccountReq(s.id, null);
                
                if(bankResp.response != null && bankResp.response.results != null && !bankResp.response.results.isEmpty()){
                    for(Bank_Account__c ba : bankAccounts){
                        if(bankResp.response.results.keySet().contains(ba.Id)){
                            ps_MaintRequestResults resp = bankResp.response.results.get(ba.Id);
                            
                            if(resp != null){
                                if(resp.success != null && resp.success.toLowerCase() == 'true'){
                                    logs.add(ProfitStarsUtils.generateAuditLogForBankAccount(action, 'Success', JSON.serializePretty(resp), ba.Id, s.recordType.Name));		//request #R151866 updated to capture application type
                                    bankAccountsToUpdate.add(ba);
                                }else if(resp.errorMessage != null){
                                    allPassed = false;
                                    failedBankLabels = failedBankLabels == null ? ba.Account_Label__c : failedBankLabels + ', ' + ba.Account_Label__c;
                                    logs.add(ProfitStarsUtils.generateAuditLogForBankAccount(action, 'Failure', JSON.serializePretty(resp), ba.Id, s.recordType.Name));		//request #R151866 updated to capture application type
                                    failedUpdates.add(ba);
                                    
                                }
                            }
                        }
                    }
                    
                    if(!allPassed){
                        String errorDetails = 'The following bank account records are not successfully updated in ProfitStars: ' + failedBankLabels;
                        errorDetails += '\nPlease refer to the audit log(s) on the individual bank accounts for specific error details.';
                        logs.add(ProfitStarsUtils.generateAuditLogForValuePlus(action, 'Failure', errorDetails, s.id, s.recordType.Name));
                    }else{
                        logs.add(ProfitStarsUtils.generateAuditLogForValuePlus(action, 'Success', JSON.serializePretty(bankResp.response), s.id, s.recordType.Name));
                    }
                }
            } catch (ProfitStarsRequestValidation.ProfitStarsValidationException e) {
                failedUpdates.addAll(bankAccounts);
                logs.add(ProfitStarsUtils.generateAuditLogForValuePlus('Pre-call Validation', e.getMessage(), e.getStackTraceString(), s.id, s.recordType.Name));		//request #R151866 updated to capture application type
                ProfitStarsUtils.sendErrorEmail(s, 'Bank Account Update', e.getMessage(), e.getStackTraceString(), null); //request #R151866 Added to send email with failure message
            } catch (Exception e) {
                failedUpdates.addAll(bankAccounts);
                logs.add(ProfitStarsUtils.generateAuditLogForValuePlus(action, e.getMessage(), e.getStackTraceString(), s.id, s.recordType.Name));		//request #R151866 updated to capture application type
                ProfitStarsUtils.sendErrorEmail(s, 'Bank Account Update', e.getMessage(), e.getStackTraceString(), null); //request #R151866 Added to send email with failure message
                
                SystemExceptionLogger.fireSystemExceptionLogEvent(e,'PS_BatchBankAccountUpdates','execute', SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, e.getMessage(), 'PS_BatchBankAccountUpdates: Bank Account Update', null, false);
            }
        }
        
        if(!bankAccountsToUpdate.isEmpty() || !failedUpdates.isEmpty() || !logs.isEmpty()){
            finalize(bankAccountsToUpdate, failedUpdates, logs);
        }
    }
    
    @testVisible
    private void finalize(List<Bank_Account__c> bankAccountsToUpdate, List<Bank_Account__c> failedUpdates, Set<PS_Audit_Log__c> logs){
        
        Map<Id, Bank_Account__c> updatedBankAccounts = new Map<Id, Bank_Account__c>();
        List<ps_audit_log__c> deduped = new List<PS_Audit_Log__c>();
        
        try{
            for(Bank_Account__c ba : bankAccountsToUpdate){
                ba.ps_BankAccountUpdateRequired__c = false;
                ba.ready_for_push_to_ProfitStars__c = false;
                ba.ProfitStars_Push_Status__c = 'success';
                updatedBankAccounts.put(ba.Id, ba);
            }
            for(Bank_Account__c b : failedUpdates){
                b.ProfitStars_Push_Status__c = 'failed';
                b.ready_for_push_to_ProfitStars__c = false;	
                updatedBankAccounts.put(b.Id, b);				//request #R152441 - Updated flag to cyclic requests on failure
            }
            
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
            
            if(!updatedBankAccounts.isEmpty()){
                Database.SaveResult[] resultList = Database.UPDATE(updatedBankAccounts.values(), false);
                
                for(Database.SaveResult res : resultList){
                    if(!res.isSuccess()){
                        for(Database.Error error : res.getErrors()){
                            errorMessage += error.getStatusCode() + ': ' + error.getMessage() + ', ';
                        }
                    }
                }
            }
            
            List<Messaging.Email> emails = new List<Messaging.Email>();
            Map<Id, PS_Audit_Log__c> insertedAudit = new Map<id, PS_Audit_Log__c>([SELECT Id, DateTimeStamp__c, BankAccount__r.ValuePlus__r.RecordTypeId, Error_Message__c, BankAccount__r.Account_Label__c
                                                                                   FROM PS_Audit_Log__c 
                                                                                   WHERE Id in:deduped ]);
            for(PS_Audit_Log__c l : insertedAudit.values()){
                Bank_Account__c failedBank = updatedBankAccounts.get(l.BankAccount__c);
                if(failedBank != null && l.Error_Message__c.toLowerCase()!='success'){
                    Id vp = failedBank.ValuePlus__c;
                    //If bank account is MyCase, Send email 
                    if(l.BankAccount__r.ValuePlus__r.RecordTypeId == InformationStrings.vPlusMycasePaymentsId){
                        String subject = 'ProfitStars Bank Account Update Failure for: ' + l.BankAccount__r.Account_Label__c;
                        String body = 'ProfitStars Bank Account Update has failed for the following account. ' + '\n' +
                            'Bank Account: ' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + l.BankAccount__c +' ' + '\n' +
                            'Time: ' + l.DateTimeStamp__c + ' ' +  '\n' +
                            'Error Message: ' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + l.Id + ' ' +  '\n' +
                            'ValuePlus: ' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + vp;
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.toaddresses = new List<String>{System.Label.MyCaseSupportEmail};                    
                            mail.setSubject(subject);                    
                        mail.setPlainTextBody(body);  
                        mail.setSaveAsActivity(false);                                      
                        emails.add(mail);                    
                    }
                }
                
            }
            if(!emails.isEmpty() && !test.isRunningTest()){
                Messaging.sendEmail(emails);
            }
            
            if(!String.isEmpty(errorMessage)){
                throw new PS_BatchBankAccountUpdatesException(errorMessage);
            }
            
        } catch(Exception e){            
            SystemExceptionLogger.fireSystemExceptionLogEvent(e,'PS_BatchBankAccountUpdates','Finalize', SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, e.getMessage(), 'PS_BatchBankAccountUpdates: finalize', null, false);	
        }
    }
    
    public void finish(Database.BatchableContext BC){}
}