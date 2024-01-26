({
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
})