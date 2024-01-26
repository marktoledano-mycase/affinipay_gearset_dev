({
    doInit : function(component, event, helper) {

        helper.getCurrentContact(component);
        // helper.search_IntercomContacts(component);

    },
    toggleDiv : function(component, event, helper) {
        // Get the current visibility state
        var isDivVisible = component.get("v.isDivVisible");
        
        // Toggle the visibility
        component.set("v.isDivVisible", !isDivVisible);
    },


})