({
    getCurrentContact : function(component) {
        var contact_record_id = component.get("v.recordId");
        console.log('RECORD ID: '+ contact_record_id);
        var action = component.get("c.getCurrentContactInfo");
        action.setParams({
            "contact_id": contact_record_id,
        });

        action.setCallback(this, function(response){
    
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse  = response.getReturnValue();
                console.log('Current contact email: ' + storeResponse[0].Email);
                component.set("v.contact_email", storeResponse[0].Email);
                component.set("v.CurrentContactData", storeResponse);
                this.search_IntercomContacts(component);
            }
        });
        $A.enqueueAction(action);
  
    },
    search_IntercomContacts : function(component) {
        var action = component.get("c.searchIntercomContacts");
        var contact_email = component.get("v.contact_email");
        action.setParams({
            "search_type": "email",
            "search_term" : contact_email
        });


        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse  = response.getReturnValue();
                console.log('Response:' + storeResponse);
                component.set("v.IntercomContactData", storeResponse);
            }
        });
        $A.enqueueAction(action);
    },


    
    })