({
    //Add new bank account to PS
    pushBankToPS : function(component, event, helper){
        var record = component.get("v.record");
        
        if(record.Ready_for_push_to_ProfitStars__c == false){
            alert("Ready for push to ProfitStars is not selected");
        }else if(record.ps_LocationUpdateRequired__c == false){
            alert("Location Update Required is not selected");
        }else if(record.LID__c != null){
            alert("Bank Account already has an LID");
        }else if(record.Location_Add_Status__c == "Submitted"){
            alert("Bank Account was already submitted to ProfitStars");
        }else{
            var c = confirm("Bank Account will be added in ProfitStars, continue?"); 
            if(c == true){
                component.set("v.actionName", "pushBankToPS");
        		component.set("v.successMessage", "Sent Bank Account to ProfitStars");
                helper.routeCategory(component, event);   
            }                        
        }
    },
    //Add new bank account to Vantiv
    addBankToVantiv : function(component, event, helper){
        var record = component.get("v.record");
        
        if(record.Vantiv_Bank_Account_Onboarding_Status__c != "Ready To Transmit"){
            alert("Vantiv Onboarding status is not \"Ready To Transmit\". Please update the record and retry.");
        }else if(record.Vantiv_Sub_Merchant_Id__c != null){
            alert("Vantiv Sub-Merchant Id is available for this bank account.");
        }else{
            var c = confirm("Bank Account will be sent to Vantiv, continue?");
            if(c == true){
                component.set("v.actionName", "addBankToVantiv");
        		component.set("v.successMessage", "Sent Bank Account to Vantiv");
                helper.routeCategory(component, event);   
            }                        
        }
    },
    //Update an existing bank account in Vantiv
    updateBankInVantiv : function(component, event, helper){
        var record = component.get("v.record");
        
        if(record.Vantiv_Sub_Merchant_Id__c == null || record.Vantiv_Sub_Merchant_Id__c == ""){
            alert("Vantiv sub-merchant Id is empty. Please add bank account to vantiv before update.");
        }else if(record.Vantiv_Bank_Account_Onboarding_Status__c != "Approved"){
            alert("Vantiv sub-merchant onboarding status is not \"Approved\". Please update the record and retry.");
        }else if(record.Vantiv_Bank_Account_Update_Status__c != "Ready To Update"){
            alert("Vantiv bank account update status is not \"Ready To Update\". Please update the status and retry.");
        }else{
            var c = confirm("Bank Account update will be sent to Vantiv, continue?");
            if(c == true){
                component.set("v.actionName", "updateBankInVantiv");
        		component.set("v.successMessage", "Updated Bank Account in Vantiv");
                helper.routeCategory(component, event);  
            }                        
        }
    }
})