({
    doInit : function(component, event, helper) {

           // Create a new Date object with the provided epoch time
           var date = new Date(component.get("v.datetimevalue") * 1000);

           // Define month names
           var monthNames = [
            'January', 'February', 'March', 'April', 'May', 'June',
            'July', 'August', 'September', 'October', 'November', 'December'
        ];

        // Get the individual components of the date
        var month = monthNames[date.getMonth()];
        var day = ('0' + date.getDate()).slice(-2);
        var year = date.getFullYear();
        var hours = ('0' + date.getHours()).slice(-2);
        var minutes = ('0' + date.getMinutes()).slice(-2);

        // Format the datetime as desired, e.g., 'MMMM DD, YYYY hh:mm'
        var formattedDateTime = month + ' ' + day + ', ' + year + ' ' + hours + ':' + minutes;

        component.set("v.converteddatetime", formattedDateTime);
           
    },
})