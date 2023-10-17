({
    ownThisCase : function(component, event, helper){
        component.set("v.routingQueue", "ownThisCase");
        helper.sendTo(component, event, helper);
    },
    closeAsSpam : function(component, event, helper){
        component.set("v.routingQueue", "closeAsSpam");
        helper.sendTo(component, event, helper);
    },
    escalate : function(component, event, helper){
        component.set("v.routingQueue", "escalate");
        helper.sendTo(component, event, helper);
    },
    ownEscalation : function(component, event, helper){
        component.set("v.routingQueue", "ownEscalation");
        helper.sendTo(component, event, helper);
    },
    sendToCS : function(component, event, helper){
        component.set("v.routingQueue", "sendToCS");
        helper.sendTo(component, event, helper);
    },
    sendToWebsites : function(component, event, helper){
        component.set("v.routingQueue", "sendToWebsites");
        helper.sendTo(component, event, helper);
    },
    sendToSalesMycase : function(component, event, helper){
        component.set("v.routingQueue", "sendToSalesMycase");
        helper.sendTo(component, event, helper);
    },
    sendToPayments : function(component, event, helper){
        component.set("v.routingQueue", "sendToPayments");
        helper.sendTo(component, event, helper);
    },
    sendToMyCaseAccounting : function(component, event, helper){
        component.set("v.routingQueue", "sendToAccounting");
        helper.sendTo(component, event, helper);
    },
    sendToBilling : function(component, event, helper){
        component.set("v.routingQueue", "sendToBilling");
        helper.sendTo(component, event, helper);
    },
    billingCase : function(component, event, helper){
        component.set("v.routingQueue", "billingCase");
        helper.sendTo(component, event, helper);
    },
    adminDupe : function(component, event, helper){
        component.set("v.routingQueue", "adminDupe");
        helper.sendTo(component, event, helper);
    }

})