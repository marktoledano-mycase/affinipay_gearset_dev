/*
* Test Class: GiactVerifyServiceTest
*/
public with sharing class GIACT_GIdentifyRequest {
	
    public String firstName {get; set;}
    public String lastName {get; set;}

    public String businessName {get; set;}

    public String taxId {get; set;}
    public String dateOfBirth {get; set;} // YYYY-MM-DD formate

    public String addressLine1 {get; set;}
    public String city {get; set;}
    public String state {get; set;}
    public String zipCode {get; set;} 
    public string country {get; set;}   


	public GIACT_GIdentifyRequest(GIACTRestRequestBuilder.GIACTRequestAPMIdentify bodyObj) {
	
		System.debug(LoggingLevel.INFO, '*** Initializing Giact Inquiry Request Object.');
		initialize (bodyObj);

	}

	private void initialize (GIACTRestRequestBuilder.GIACTRequestAPMIdentify bodyObj) {
		
		Map <String, String> input = bodyObj.Customer;

		if (input.containsKey ('FirstName')) {
			firstName=input.get ('FirstName');
			firstName = cleanupReservedEntities(firstName);
		} 

		if (input.containsKey ('LastName')) {
			lastName=input.get ('LastName');
			lastName = cleanupReservedEntities(lastName);
		} 

		if (input.containsKey ('BusinessName')) {
			businessName=input.get ('BusinessName');
			businessName = cleanupReservedEntities(businessName);			
		} 

		if (input.containsKey ('TaxId')) {
			taxId=input.get ('TaxId');
			taxId = cleanupReservedEntities(taxId);			
		} 

		if (input.containsKey ('AddressLine1')) {
			addressLine1=input.get ('AddressLine1');
			addressLine1 = cleanupReservedEntities(addressLine1);			
		} 

		if (input.containsKey ('City')) {
			city=input.get ('City');
			city = cleanupReservedEntities(city);			
		} 

		if (input.containsKey ('State')) {
			state=input.get ('State');
			state = cleanupReservedEntities(state);
		} 

		if (input.containsKey ('ZipCode')) {
			zipCode=input.get ('ZipCode');
			zipCode = cleanupReservedEntities(zipCode);
		} 

		if (input.containsKey ('Country')) {
			country=input.get ('Country');
			country = cleanupReservedEntities(country);
		} 
	}

	private String cleanupReservedEntities (String value) {

		if (value.contains('<')) {
			value=value.replaceAll('[<]', '&lt;');
		}

		if (value.contains('>')) {
			value=value.replaceAll('[>]', '&gt;');
		}

		if (value.contains('&')) {
			value=value.replaceAll('[&]', '&amp;');
		}

		if (value.contains('\'')) {
			value=value.replaceAll('[\']', '&apos;');
		}

		if (value.contains('\"')) {
			value=value.replaceAll('[\"]', '&quot;');
		}

		return value;



	}

	public String getBusinessRequestXMLBody() {
		
		// We need avoid the 5 predefined entities reserved for salesforce. 
		String value;

		String xml =
        '<?xml version="1.0" encoding="utf-8"?>' + 
		'<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">'+
		  '<soap:Header>' +
			'<AuthenticationHeader xmlns="http://www.giact.com/api/identificationservices/v1.0">' +
		      '<ApiUsername>JIK7-KNTS-AZWC-7R7TBD</ApiUsername>' +
		      '<ApiPassword>QP-_SYigAtnE6</ApiPassword>' +
		    '</AuthenticationHeader>' +
		  '</soap:Header>' +
		  '<soap:Body>' + 
			//'<BusinessComboSearch xmlns="http://www.giact.com/api/identificationservices/v1.0">' + 
			'<BusinessSearch xmlns="http://www.giact.com/api/identificationservices/v1.0">' +
		      '<Inquiry>';
		      	if (!String.isEmpty(businessName))
		        xml+= '<BusinessName>'+businessName+'</BusinessName>';
		        xml+= '<Address>';
		        	//if (!String.isEmpty(addressLine1))
			        //xml+= '<Line1>'+addressLine1+'</Line1>';
					//xml+= '<AddressLine1>'+addressLine1+'</AddressLine1>';
			        if (!String.isEmpty(city))
			        xml+= '<City>'+city+'</City>';
			        if (!String.isEmpty(state))
			        xml+= '<State>'+state+'</State>'; 
			        if (!String.isEmpty(zipCode))
			        xml+= '<ZipCode>'+zipCode+'</ZipCode>';
			        xml+= '<Country>US</Country>';
		       	xml+= '</Address>';
        		//if (!String.isEmpty(taxId))
	        		//xml+= '<FEINumber>'+taxId+'</FEINumber>';
					//xml+= '<TaxId>'+taxId+'</TaxId>';
		      xml+= '</Inquiry>' + 
		    //'</BusinessComboSearch>' + 
			'</BusinessSearch>' + 
		  '</soap:Body>' + 
		'</soap:Envelope>';
        return xml;
    }

	public String getPrincipalRequestXMLBody() {
        String xml =
        '<?xml version="1.0" encoding="utf-8"?>' + 
		'<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">'+
		  '<soap:Header>' +
		    '<AuthenticationHeader xmlns="http://www.giact.com/api/identificationservices/v1.0">' +
		      '<ApiUsername>JIK7-KNTS-AZWC-7R7TBD</ApiUsername>' +
		      '<ApiPassword>QP-_SYigAtnE6</ApiPassword>' +
		    '</AuthenticationHeader>' +
		  '</soap:Header>' +
		  '<soap:Body>' + 
		    '<PersonSearch xmlns="http://www.giact.com/api/identificationservices/v1.0">' + 
		      '<Inquiry>' + 
		        '<Name>';

	        	if (!String.isEmpty(firstName))
		          	xml+= '<FirstName>'+firstName+'</FirstName>';
	          	if (!String.isEmpty(lastName))
		          xml+= '<LastName>'+lastName+'</LastName>'; 
		        xml+= '</Name>' + 
		        '<Address>';
	        	if (!String.isEmpty(addressLine1))
		          xml+= '<Line1>'+addressLine1+'</Line1>';
	          	if (!String.isEmpty(city))
		          xml+= '<City>'+city+'</City>';
	          	if (!String.isEmpty(state))
		          xml+= '<State>'+state+'</State>'; 
	          	if (!String.isEmpty(zipCode))
		          xml+= '<ZipCode>'+zipCode+'</ZipCode>';
		          xml+= '<Country>US</Country>' + 
		        '</Address>';
	        	if (!String.isEmpty(taxId))
	        	xml+= '<SSN>'+taxId+'</SSN>';
		     /*   '<DateOfBirth></DateOfBirth>' + */
		      xml+= '</Inquiry>' + 
		    '</PersonSearch>' + 
		  '</soap:Body>' + 
		'</soap:Envelope>';
        
        return xml;
    }



	private String clean (String value) {
		if (value == null) {
			return '';
		}
		return value;
	}
}