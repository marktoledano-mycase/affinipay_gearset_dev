j$ = jQuery.noConflict();
        
j$(document).ready(function() {
				
	var fieldRequiredRules = {
		requestType: {
			required: true,
			messages: {
				required: "Request Type is required"
			} 
		},	
		firstName: {
			required: true,
			messages: {
				required: "Consumer First Name is required"
			}
		},
		lastName: {
			required: true,
			messages: {
				required: "Consumer Last Name is required"
			}
		},
		propertyManagementCo: {
			required: true,
			messages: {
				required: "Property Management Company is required"
			}
		},
		mobilePhone: {
			required: true,
			messages: {
				required: "Phone Number is required"
			}
		}
		
	};
	
	// Add phone number masking
    j$('[id$=mobilePhone]').mask("(999) 999-9999");
	
	j$('[id$=paymentServicesForm]').validate({
		//by default the error elements is a <label>
		errorElement: "div",
		//place all errors in a <div id="errors"> element
		errorPlacement: function(error, element) {
			error.appendTo("div#errors");
		}
	});

	addRules(fieldRequiredRules);
	
	function addRules(rulesObj){
		for (var item in rulesObj){
		   j$('[id$='+item+']').rules('add',rulesObj[item]);
		   if(rulesObj[item].required) {
			   j$('[id$='+item + 'Label] .star').show();
		   }
		} 
	}
	
});