({
    sendTo : function(component, event) {
        var sendToId = component.get("v.recordId");
        var routingQueue = component.get("v.routingQueue");
        var toastEvent = $A.get("e.force:showToast");
        var action = component.get("c.routeCase");
        
        action.setParams({ "recordId" : sendToId, "caseQueue" : routingQueue});
        action.setCallback(this, function(response) {
            var state = response.getState();
            var returnValue = response.getReturnValue();
            if(component.isValid() && state === "SUCCESS"){
                var successValue =  response.getReturnValue();
                if (successValue){
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Hang Tight! We're updating the case.",
                        "type":"success"
                    });
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                } else {
                    toastEvent.setParams({
                        "title": "Failure!",
                        "message": "Something went wrong. Please notify your friendly neighborhood Salesforce Team.",
                        "type" : "error"
                    });
                    toastEvent.fire();
                }
            } else {
            	var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert(errors[0].message);
                    }
                }
            }
        });
        $A.enqueueAction(action);
    }
})