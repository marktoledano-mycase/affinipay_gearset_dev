({
    getContactTags : function(component) {
        var action = component.get("c.getTags");
        var contact_id = component.get("v.contact_id");
        action.setParams({
            "contact_id": contact_id
        });


        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse  = response.getReturnValue();
                console.log('Tags Response:' + storeResponse);
                component.set("v.TagData", storeResponse);
            }
        });
        $A.enqueueAction(action);
    },
    getAllTags : function(component) {
        var action = component.get("c.getAllTags");

        action.setCallback(this, function(response){
    
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse  = response.getReturnValue();
                // console.log('Tag Data Response: ' + storeResponse);
                component.set("v.TagDataAll", storeResponse);
                component.set("v.TagDataSearch", storeResponse);
            }
        });
        $A.enqueueAction(action);

    },
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
    checkTaggingPermissions : function(component){
        var action = component.get('c.doesCurrentUserHavePermission');

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var hasPermission = response.getReturnValue();
                if (hasPermission) {
                    console.log('User has the custom permission');
                    component.set("v.tagging_permissions", "true");
                } else {
                    console.log('User does not have the custom permission');
                    component.set("v.tagging_permissions", "false");
                }
            } else {
                console.error('Error calling Apex method');
            }
        });

        $A.enqueueAction(action);        
    }
})