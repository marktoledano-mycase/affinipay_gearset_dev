({
    init: function (cmp, event, helper){
        cmp.set('v.casecolumns', [
            { label: 'Case Number', fieldName: 'recordLink', type: 'url', 
                typeAttributes: {label: { fieldName: 'CaseNumber' }}, cellAttributes: { alignment: 'left' }},
            { label: '# Total Users', fieldName: 'Total_Users__c', type: 'number', cellAttributes: { alignment: 'left' }},
            { label: 'Contact Name', fieldName: 'ContactName', type: 'text', cellAttributes: { alignment: 'left' }},
            { label: 'Subject', fieldName: 'Subject', type: 'text', wrapText: true, cellAttributes: { alignment: 'left' }},
            { label: 'Status', fieldName: 'Status', type: 'text', cellAttributes: { alignment: 'left' }},
            { label: 'Priority', fieldName: 'Priority', type: 'text', cellAttributes: { alignment: 'left' }},
            { label: 'Date/Time Opened', fieldName: 'CreatedDate', type: 'date', typeAttributes:{
                year: "numeric", month: "numeric", day: "2-digit", hour: "2-digit", minute: "2-digit"}, cellAttributes: { alignment: 'left' }}
        ]);
        helper.getData(cmp);
    },

    assignNextCase: function(cmp, event, helper){
        helper.assignNext(cmp);
    },

    refresh: function(cmp, event, helper){
        $A.get('e.force:refreshView').fire();
    }
})