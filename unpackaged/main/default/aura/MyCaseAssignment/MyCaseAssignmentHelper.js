({
    getData : function(cmp){
        var action = cmp.get('c.getCaseData');
        action.setCallback(this, $A.getCallback(function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var rows = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                for(var i = 0; i < rows.length; i++){
                    var row = rows[i];
                    if(row.Contact){
                        row.ContactName = row.Contact.Name;
                    }
                    row.recordLink = '/'+row.Id;
                }
                cmp.set('v.casedata', rows);
                cmp.set('v.showCaseTable', true);
            } else{
                toastEvent.setParams({
                    "title": "Failure!",
                    "message": "Something went wrong, please reach out to your friendly neighborhood Salesforce team.",
                    "type": "error"
                });
            }
            toastEvent.fire();
        }));
        $A.enqueueAction(action);
    },

    assignNext : function(cmp){
        var action = cmp.get("c.assignNext");
        action.setCallback(this, function(response){
            var state = response.getState();
            var toastEvent = $A.get("e.force:showToast");
            if(state === "SUCCESS"){
                $A.get('e.force:refreshView').fire();
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "The Case has been assigned successfully.",
                    "type": "success",
                    "duration": "1000"
                });
            } else{
                toastEvent.setParams({
                    "title": "Failure!",
                    "message": "Something went wrong, please reach out to your friendly neighborhood Salesforce team.",
                    "type": "error"
                });
            }
            toastEvent.fire();
        });
        $A.enqueueAction(action);
    }
})