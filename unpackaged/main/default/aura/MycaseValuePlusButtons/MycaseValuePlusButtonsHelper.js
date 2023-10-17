({
    routeCategory : function(component, event){
        //call apex controller method to handle either Velocity inbound/outbound functionality 
        
        var recId = component.get("v.recordId");
        var actionName = component.get("v.actionName");
        var successMessage = component.get("v.successMessage");
        var toastEvent = $A.get("e.force:showToast");
        var action = component.get("c.processVPlusRecord");
        
        action.setParams({ "recordId" : recId, "processName" : actionName});
        action.setCallback(this, function(response) {
            var state = response.getState();
            var returnValue = response.getReturnValue();
            if(component.isValid() && state === "SUCCESS"){
                var result = response.getReturnValue();
                var parsed = JSON.parse(result); 
                if(parsed.didPass == true) { 
                    toastEvent.setParams({                        
                        "title": "Success!",
                        "message": successMessage,
                        "type":"Success"
                    });
                    toastEvent.fire();
                     
                } else { 
                    alert("Validation failed with the following error: \n\n" + parsed.result + " \n\nPlease update the Value+ record with missing information and try again"); 
                    //I'm not firing a toast here because the error message could be quite long and I want the user to have time to read it through 
                }
            } else {
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        toastEvent.setParams({
                            "title":"Failure!",
                            "message": errors[0].message
                        });
                        toastEvent.fire();
                    }
                }
            }
        });
        $A.enqueueAction(action);
        $A.get('e.force:refreshView').fire();
    },
})