({
    getContactConversationInfo : function(component) {
        var action = component.get("c.getConversations");
        var contact_id = component.get("v.contact_id");
        action.setParams({
            "contact_id": contact_id
        });


        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse  = response.getReturnValue();
                console.log('Conversation Response:' + storeResponse);
                component.set("v.ConversationData", storeResponse);
                component.set("v.conversation_count", component.get("v.ConversationData").length);
            }
        });
        $A.enqueueAction(action);
    },
})