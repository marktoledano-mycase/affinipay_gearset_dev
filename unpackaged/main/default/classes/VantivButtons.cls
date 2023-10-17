global class VantivButtons 
{
    global class VantivButtonResult
    {
        public String result{get; set;}
        public Boolean didPass{get; set;}
    }
    
    webservice static String callLegalEntity(Id id)
    {
        VantivButtons.VantivButtonResult result = new VantivButtons.VantivButtonResult();
        VantivLegalEntityReq req;
        Vantiv_Audit_Logs__c log = new Vantiv_Audit_Logs__c();
        ValuePlus__c vp = new ValuePlus__c(Id=id); 
        try
        {
            req = new VantivLegalEntityReq(id);
            if(req.response.isSuccess)
            {
                result.didPass = true;
                vp.Vantiv_Legal_Entity_Id__c = req.response.legalEntityId;
                vp.Vantiv_Onboarding_Status__c = req.response.responseDescription;
                vp.Vantiv_Enrolled_Date__c = System.Now();
                if(req.response.isDuplicate)
                {
                    result.result ='Merchat was already enrolled with vantiv. Existing legal entity id '+ req.response.legalEntityId;
                }
                else
                {
                    result.result = 'Request submitted successfully. Onboarding Status: '+req.response.responseDescription;
                }
            }
            else
            {
                result.didPass = false;
                result.result = 'Create legal entity request failed with following errors ';
                for(String error : req.response.errors)
                {
                    result.result = result.result+'\n'+error;
                }
            }
            log=VantivUtils.createAuditLog(id,req.response.responseDescription, result.result, req.response.toString(), 'Create Legal Entity', getVPRecordTypeName(id), true);
            
        }
        catch(Exception e)
        {
            vp.Vantiv_Onboarding_Status__c = 'Failed';
            result.didPass = false;
            result.result = e.getMessage();
            log=VantivUtils.createAuditLog(id,'Failed', result.result, '', 'Create Legal Entity', getVPRecordTypeName(id), true);
        }
        update vp;
        insert log;
        
        return JSON.serialize(result);
    } 
    
    webservice static String callSubMerchantCreateReq(Id id)
    {
        VantivButtons.VantivButtonResult result = new VantivButtons.VantivButtonResult();
        VantivSubMerchantCreateReq req;
        Vantiv_Audit_Logs__c log = new Vantiv_Audit_Logs__c();
        Bank_Account__c ba = new Bank_Account__c(Id=id); 
        try
        {
            req = new VantivSubMerchantCreateReq(id);
            if(req.response.isSuccess)
            {
                result.didPass = true;
                /*vp.Vantiv_Legal_Entity_Id__c = req.response.legalEntityId;
                vp.Vantiv_Onboarding_Status__c = req.response.responseDescription;
                vp.Vantiv_Enrolled_Date__c = System.Now();*/
                ba.Vantiv_Sub_Merchant_Id__c = req.response.subMerchantId;
                ba.Vantiv_Merchant_Ident_String__c = req.response.merchantIdentString;
                ba.Vantiv_PayPage_Id__c = req.response.payPageId;
                if(req.response.isDuplicate)
                {
                    result.result ='Sub-Merchat was already enrolled with vantiv. Existing Sub-Merchant id '+ req.response.subMerchantId;
                    ba.Vantiv_Bank_Account_Onboarding_Status__c = 'Duplicate';
                }
                else
                {
                    result.result = 'Sub-Merchant successfully onboarded. Sub-Merchant Id '+req.response.subMerchantId;
                    ba.Vantiv_Bank_Account_Onboarding_Status__c = 'Approved';
                }
            }
            else
            {
                result.didPass = false;
                result.result = 'Create Sub-Merchant request failed with following errors ';
                ba.Vantiv_Bank_Account_Onboarding_Status__c = 'Failed';
                for(String error : req.response.errors)
                {
                    result.result = result.result+'\n'+error;
                }
            }
            log=VantivUtils.createAuditLog(id,ba.Vantiv_Bank_Account_Onboarding_Status__c, result.result, req.response.toString(), 'Create Sub-Merchant', getVPRecordTypebyBankAccount(id), false);
            
        }
        catch(Exception e)
        {
            //vp.Vantiv_Onboarding_Status__c = 'Failed';
            ba.Vantiv_Bank_Account_Onboarding_Status__c = 'Failed';
            result.didPass = false;
            result.result = e.getMessage();
            log=VantivUtils.createAuditLog(id,'Failed', result.result+e.getStackTraceString(), '', 'Create Sub-Merchant', getVPRecordTypebyBankAccount(id), false);
        }
        update ba;
        insert log;
        
        return JSON.serialize(result);
    } 
    
    webservice static String callLegalEntityUpdateReq(Id id)
    {
        VantivButtons.VantivButtonResult result = new VantivButtons.VantivButtonResult();
        VantivLegalEntityUpdateReq req;
        Vantiv_Audit_Logs__c log = new Vantiv_Audit_Logs__c();
        ValuePlus__c vp = new ValuePlus__c(Id=id); 
        try
        {
            req = new VantivLegalEntityUpdateReq(id);
            if(req.response.isSuccess)
            {
                result.didPass = true;
                vp.Vantiv_Legal_Entity_Update_Status__c = req.response.responseDescription;
                if(req.response.responseDescription != null)
                {
                    result.result = 'Merchant successfully updated. Legal entity Id '+req.response.legalEntityId;
                }
                else
                {
                    vp.Vantiv_Legal_Entity_Update_Status__c = 'Change Unknown';
                    result.result = 'No update was identified. Transaction Id '+req.response.transactionId;
                }
                
            }
            else
            {
                result.didPass = false;
                vp.Vantiv_Legal_Entity_Update_Status__c = 'Failed';
                result.result = 'Update legal entity request failed with following errors ';
                for(String error : req.response.errors)
                {
                    result.result = result.result+'\n'+error;
                }
            }
            log=VantivUtils.createAuditLog(id,vp.Vantiv_Legal_Entity_Update_Status__c, result.result, req.response.toString(), 'Update Legal Entity', getVPRecordTypeName(id), true);
            
        }
        catch(Exception e)
        {
            vp.Vantiv_Legal_Entity_Update_Status__c = 'Failed';
            result.didPass = false;
            result.result = e.getMessage();
            log=VantivUtils.createAuditLog(id,'Failed', result.result, '', 'Update Legal Entity', getVPRecordTypeName(id), true);
        }
        update vp;
        insert log;
        
        return JSON.serialize(result);
    } 
    
    webservice static String callSubMerchantUpdateReq(Id id)
    {
        VantivButtons.VantivButtonResult result = new VantivButtons.VantivButtonResult();
        VantivSubMerchantUpdateReq req;
        Vantiv_Audit_Logs__c log = new Vantiv_Audit_Logs__c();
        Bank_Account__c ba = new Bank_Account__c(Id=id); 
        try
        {
            req = new VantivSubMerchantUpdateReq(id);
            if(req.response.isSuccess)
            {
                result.didPass = true;
                ba.Vantiv_Bank_Account_Update_Status__c = 'Approved';
                result.result = 'Sub-Merchant successfully Updated. Transaction Id '+req.response.transactionId;
            }
            else
            {
                result.didPass = false;
                result.result = 'Update Sub-Merchant request failed with following errors ';
                ba.Vantiv_Bank_Account_Update_Status__c = 'Failed';
                for(String error : req.response.errors)
                {
                    result.result = result.result+'\n'+error;
                }
            }
            log=VantivUtils.createAuditLog(id,ba.Vantiv_Bank_Account_Update_Status__c, result.result, req.response.toString(), 'Update Sub-Merchant', getVPRecordTypebyBankAccount(id), false);
            
        }
        catch(Exception e)
        {
            //vp.Vantiv_Onboarding_Status__c = 'Failed';
            ba.Vantiv_Bank_Account_Update_Status__c = 'Failed';
            result.didPass = false;
            result.result = e.getMessage();
            log=VantivUtils.createAuditLog(id,'Failed', result.result+e.getStackTraceString(), '', 'Update Sub-Merchant', getVPRecordTypebyBankAccount(id), false);
        }
        update ba;
        insert log;
        
        return JSON.serialize(result);
    } 
    
    private static String getVPRecordTypeName(Id id)
    {
        ValuePlus__c vp = new ValuePlus__c();
        if(id != null)
        {
            vp = [select Id, recordType.Id, recordType.Name from ValuePlus__c where Id =: id];
            return vp.recordType.Name;
        }
        return null;
    }
    
    private static String getVPRecordTypebyBankAccount(Id id)
    {
        Bank_Account__c ba = new Bank_Account__c();
        if(id != null)
        {
            ba = [select Id, ValuePlus__r.recordTypeId, ValuePlus__r.recordType.Name from Bank_Account__c where Id =: id];
            return ba.ValuePlus__r.recordType.Name;
        }
        return null;
    }
}