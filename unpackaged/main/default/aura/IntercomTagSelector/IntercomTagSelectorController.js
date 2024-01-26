({
    doInit : function(component, event, helper) {
        // Load add tags to the TagDataAll list
        helper.getAllTags(component);
    },
    updateSearch : function(component, event, helper) {
        // On input search TagDataAll list and return to TagDataSearch list
        var searchInput = component.get("v.searchTerm").toLowerCase();
        var originalList = component.get("v.TagDataAll");
        console.log('Tag Search: ' + searchInput);
        
        // Filter the list based on the search input
        var filteredList = originalList.filter(function(data) {
            // console.log('Tag SearchResults: ' + data.name.toLowerCase().includes(searchInput));
            return data.name.toLowerCase().includes(searchInput);
        });

        // Update the filtered list attribute
        component.set("v.TagDataSearch", filteredList);    
    },
    create_tag : function(component, event, helper) {
        var new_tag_name = component.get("v.new_tag_name");
        var action = component.get("c.CreateTag");
        action.setParams({
            "tag_name": new_tag_name
        });

        action.setCallback(this, function(response){
    
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse  = response.getReturnValue();
                // component.set("v.new_tag_name", storeResponse);
                component.set("v.new_tag_status", "Tag created successfully");
                component.set("v.new_tag_id", storeResponse);
                component.set("v.selected_tag_id", storeResponse);
                $A.enqueueAction(component.get('c.attach_tag'));

            }
        });
        $A.enqueueAction(action);
        
    },
    attach_tag : function(component, event, helper) {
        var contact_id = component.get("v.contact_id");
        var tag_id = component.get("v.selected_tag_id");
        var action = component.get("c.addContactTag");
        action.setParams({
            "contact_id": contact_id,
            "tag_id": tag_id
        });

        action.setCallback(this, function(response){
    
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse  = response.getReturnValue();
                component.set("v.CurrentContactData", storeResponse);
                component.set("v.attach_status", "Tag attached successfully");
                var refreshEvent = $A.get("e.c:IntercomAddTagRefresh");
                refreshEvent.fire();            
            }
        });
        $A.enqueueAction(action);
    },
})