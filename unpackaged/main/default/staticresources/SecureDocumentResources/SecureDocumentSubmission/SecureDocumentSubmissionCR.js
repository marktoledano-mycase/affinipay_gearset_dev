   j$ = jQuery.noConflict();
        
j$(document).ready(function() {

    var consumerRules = {
        inquiryType: {
            required:true,
            messages: {
                required: "Inquiry Type is required"
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
        mobilePhone: {
            required: true,
            messages: {
                required: "Phone Number is required"
            }
        },
        Phone: {
            required: true,
            messages: {
                required: "Phone Number is required"
            }
        },
        email: {
            required: false,
            email: true,
            regex: "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}",
            messages: {
                required: "Email is required",
                regex: "Please enter a valid email"
            }
        },
        mailingAddress1: {
            required: true,
            messages: {
                required: "Mailing Address is required"
            }
        },
        consumerAddressCity: {
            required: true,
            messages: {
                required: "Mailing Street is required"
            }
        },
        consumerAddressState: {
            required: true,
            messages: {
                required: "Mailing State is required"
            }
        },
        consumerAddressZip: {
            required: true,
            messages: {
                required: "Mailing Zipcode is required"
            }
        },
        consumerAddressCountry: {
            required: true,
            messages: {
                required: "Mailing Country is required"
            }
        },
        socialSecurityNumber: {
            required: true,
            messages: {
                required: "Social Security Number is required"
            }
        },
        propertyManagementCo: {
            required: false,
            messages: {
                required: "Property Management Company is required"
            }
        },
        description: {
            required: true,
            messages: {
                required: "Description is required"
            }   
        }
    };
    
    var requiredFiles = {
        driversLicense: true,
        socialSecurityCard: false,
        proofDocuments: true
    }
    
    var consumerRequiredFiles = {
        CopyofReport: {
            driversLicense: true,
            socialSecurityCard: false,
            proofDocuments: true
        },
        CreditDispute: {
            driversLicense: true,
            socialSecurityCard: false,
            proofDocuments: true
        },
        CreditInquiry: {
            driversLicense: true,
            socialSecurityCard: false,
            proofDocuments: true
        },
        CriminalDispute: {
            driversLicense: true,
            socialSecurityCard: false,
            proofDocuments: true
        },
        CriminalInquiry: {
            driversLicense: true,
            socialSecurityCard: false,
            proofDocuments: true
        },
        EvictionDispute: {
            driversLicense: true,
            socialSecurityCard: false,
            proofDocuments: true
        },
        PermissiblePurpose: {
            driversLicense: false,
            socialSecurityCard: false,
            proofDocuments: false
        },
        GeneralInquiry: {
            driversLicense: false,
            socialSecurityCard: false,
            proofDocuments: false
        },
        RentBureau: {
            driversLicense: true,
            socialSecurityCard: false,
            proofDocuments: true
        }, 
    }
  
	// Add phone number masking
    j$('[id$=mobilePhone]').mask("(999) 999-9999");
	
    // Add regular expression option for jquery validate:
    j$.validator.addMethod(
        "regex",
        function(value, element, regexp) {
            var re = new RegExp(regexp);
            return this.optional(element) || re.test(value);
        },
        "Incorrect format; Please check your input."
    );
    
    j$('[id$=consumerRelationsForm]').validate({
        //by default the error elements is a <label>
        errorElement: "div",
        //place all errors in a <div id="errors"> element
        errorPlacement: function(error, element) {
            error.appendTo("div#errors");
        }
    });
	
    function updateRequiredFiles() {
        if (j$('[id$=inquiryType]').val()) {
            var inquiryType = j$('[id$=inquiryType]').val().replace(/\s+/g, '');
            
            var inquiryObject = consumerRequiredFiles[inquiryType];
            for (var item in inquiryObject) {
                if(inquiryObject[item]) {
                    j$('#' + item).text('Required');
                } else {
                    j$('#' + item).text('Optional');    
                }
            }   
        }
    }

    function addRules(rulesObj){
        for (var item in rulesObj){
            if(rulesObj[item].required) {
                j$('#' + item + 'Label .star').show();
            }
        } 
    }
    

	// Form defaults to Submitted By Consumer, so initialize required fields.
	updateRequiredFiles();
	addRules(consumerRules);
    
    j$('[id$=inquiryType]').rules("add",{
        required: true,
        messages: {
            required: "Inquiry Type is required"
        }
    });
        
    j$('[id$=inquiryTypeLabel] .star').show();
    
    j$('[id$=inquiryType]').change(function() {
        updateRequiredFiles();
    });

});