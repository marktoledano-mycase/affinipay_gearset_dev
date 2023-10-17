({
    //Enroll in ProfitStars Inbound
    psInbound : function(component, event, helper){
        var record = component.get("v.record");
        
        if(record.PMT_ProfitStars_On_Boarding_Status__c != 'Ready to Transmit'){
            alert("ProfitStars On-boarding Status has not been set to \"Ready to Transmit\"");
        }else if(record.Successfully_Enrolled_in_Profit_Stars_at__c != null){
            alert("This Record was already enrolled in profit stars at: " + record.Successfully_Enrolled_in_Profit_Stars_at__c + " and is not eligible for re-Enrollment.");
        }else{
            var c = confirm("Record will be enrolled in ProfitStars, continue?"); 
            if(c == true){
                component.set("v.actionName", "psInbound");
        		component.set("v.successMessage", "Sent to ProfitStars for Enrollment");
                helper.routeCategory(component, event);   
            }                        
        }
    },
    //Push Velocity Inbound
    veloInbound : function(component, event, helper){
        component.set("v.actionName", "veloInbound");
        component.set("v.successMessage", "Update Sent to ProfitStars");
        var c = confirm("Velocity will be updated in ProfitStars based on current Record, Continue?"); 
        if(c == true){ 
            helper.routeCategory(component, event);   
        }
    },
    //Enroll in Vantiv
    vantivEnroll : function(component, event, helper){
        var record = component.get("v.record");
        
        if(record.Vantiv_Enrolled_Date__c != null && record.Vantiv_Onboarding_Status__c != 'Retry'){
            alert("Vantiv Enrolled Date is not empty. Merchant was already onboarded.");
        }else if(record.Vantiv_Onboarding_Status__c != 'Ready To Transmit' && record.Vantiv_Onboarding_Status__c != 'Retry'){
            alert("Vantiv Onboarding status is not \"Ready To Transmit\". Please update the record and retry.");
        }else{
            var c = confirm("Merchant will be sent to Vantiv, continue?");
            if(c == true){
                component.set("v.actionName", "vantivEnroll");
        		component.set("v.successMessage", "Enrolled in Vantiv");
                helper.routeCategory(component, event);   
            }                        
        }
    }
})