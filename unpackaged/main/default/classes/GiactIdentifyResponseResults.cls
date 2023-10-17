/*
* Test Class: GiactVerifyServiceTest
*/
public without sharing class GiactIdentifyResponseResults {
	public static Map <String, Object> parse(String json) {
		json = GIACTUtils.sanitizeJson(json);
		Map <String, Object>  gResponse;
		System.debug('FileName-GiactResponseResults: Sanitized Json Response - '+json);
		gResponse =  (Map <String, Object>) System.JSON.deserializeUntyped(json);
		return gResponse;
	}

	public class NameValuePair {
		public NameValuePair (String name, String value) {
			this.Name = name; 
			this.Value = value;
		}
		String Name {get;set;}
		String Value {get; set;}
	}

	private static Map <Integer, NameValuePair> customerResponseCodes= new Map <Integer, NameValuePair> {
		0 => new NameValuePair('Null','There is no CustomerResponseCode value for this result.'),
		1 => new NameValuePair('CA01','Information submitted failed gAuthenticate.'),
		2 => new NameValuePair('CA11','Customer authentication passed gAuthenticate.'),
		3 => new NameValuePair('CA21','The customer or business name data did not match gAuthenticate data.'),
		4 => new NameValuePair('CA22','he customers TaxId (SSN/ITIN) data did not match gAuthenticate data.'),
		5 => new NameValuePair('CA23','The customers address data did not match gAuthenticate data.'),
		6 => new NameValuePair('CA24','The customers phone data did not match gAuthenticate data.'),
		7 => new NameValuePair('CA25','The customers date of birth or ID data did not match gAuthenticate data.'),
		8 => new NameValuePair('CA30','Multiple secondary data points did not match gAuthenticate data.'),
		/*9 => new NameValuePair('CI01','Information submitted failed gIdentify/CustomerID.'),*/
		9 => new NameValuePair('CI01','Multiple primary data did not match  with GIACT Identify data.'),
		10 => new NameValuePair('CI02','N/A'),
		/*11 => new NameValuePair('CI11','Customer identification passed gIdentify/CustomerID.'),*/
		11 => new NameValuePair('CI11','Customer is successfully identified.'),
		/*12 => new NameValuePair('CI21','The customer or business name data did not match gIdentify/CustomerID data.'),*/
		12 => new NameValuePair('CI21','Customer or business name did not match with GIACT Identify data.'),
		/*13 => new NameValuePair('CI22','The customer\'s TaxId (SSN/ITIN) data did not match gIdentify/CustomerID data.'),*/
		//13 => new NameValuePair('CI22','Customers TaxId (SSN/ITIN) data match with GIACT Identify data'),
		13 => new NameValuePair('CI22','The customers TaxId (SSN/ITIN) data entered did not match identification data.'),		
		14 => new NameValuePair('CI23','The customers address data did not match gIdentify/CustomerID data.'),
		15 => new NameValuePair('CI24','The customers phone data did not match gIdentify/CustomerID data.'),
		16 => new NameValuePair('CI25','The customers date of birth or ID data did not match gIdentify/CustomerID data.'),
		17 => new NameValuePair('CI30','Multiple secondary data points did not match gIdentify/CustomerID data.'),
		18 => new NameValuePair('ND02','No data was found matching the customer information provided.')
	};

	public static void parseLevel0 (String target, String jsonText, GIdentifyEntity dataHolder, String entityType) {

		// We should not process further if we don't have any information regarging the json text
		if (String.isEmpty(jsonText)) return;

	 	Map<String, Object> cObjMap = (Map<String, Object>) JSON.deserializeUntyped(jsonText);
		if (target.equalsIgnoreCase ('CustomerResponseCode') && cObjMap!=null && cObjMap.containsKey(target)) {
			String value = (String)JSON.serialize(cObjMap.get(target));
			Integer indx = Integer.valueOf(value);
			if (customerResponseCodes.containsKey (indx)) {
				NameValuePair nvp = customerResponseCodes.get (indx);
				String responseCode = dataHolder.responseReasonCode = nvp.Name;
				dataHolder.responseReason = nvp.Value;

				dataHolder.nameValidationStatus = 'Success';
				dataHolder.dobValidationStatus = 'Success';
				dataHolder.addressValidationStatus = 'Success';
				dataHolder.taxIdValidationStatus = 'Success';

				if (responseCode.equalsIgnoreCase('CI01') || responseCode.equalsIgnoreCase('CI02') || responseCode.equalsIgnoreCase('ND02')) {
					dataHolder.nameValidationStatus = 'Failed';
					dataHolder.dobValidationStatus = 'Failed';
					dataHolder.addressValidationStatus = 'Failed';
					dataHolder.taxIdValidationStatus = 'Failed';
				} else if (responseCode.equalsIgnoreCase('CI21')) {
					dataHolder.nameValidationStatus = 'Failed';
	 			} else if (responseCode.equalsIgnoreCase('CI22')) {
	 				dataHolder.taxIdValidationStatus = 'Failed';
 				} else if (responseCode.equalsIgnoreCase('CI23')) {
 					dataHolder.addressValidationStatus = 'Failed';
 				}else if (responseCode.equalsIgnoreCase('CI25') && entityType.equalsIgnoreCase('Individual')) {
 					dataHolder.dobValidationStatus = 'Failed';
 				}
			}
		} else {

			// Think how can you handle this scenario here. Perhaps I can update the information on any of the
			// text string

		}
	}

	public static void parseBusinessData (String target, String jsonText, GIdentifyEntity dataHolder) {
		
		Map<String, Object> cObjMap = (Map<String, Object>) JSON.deserializeUntyped(jsonText);
	 	String matchedData = (String)JSON.serialize(cObjMap.get('MatchedBusinessData'));

		String OfACList = (String)JSON.serialize(cObjMap.get('OfacListPotentialMatches'));
		List<Object> OfACListData = (List<Object>)JSON.deserializeUntyped(OfACList);

		if (OfACListData!= null && !OfACListData.isEmpty()) {
			dataHolder.ofacInformation = 'Potential Match ALERT';			
		} else {
			dataHolder.ofacInformation = 'No OFAC match found';
		}
	}

	public static void parsePersonData (String target, String jsonText, GIdentifyEntity dataHolder) {

		Map<String, Object> cObjMap = (Map<String, Object>) JSON.deserializeUntyped(jsonText);
	 	String matchedData = (String)JSON.serialize(cObjMap.get('MatchedPersonData'));

		String OfACList = (String)JSON.serialize(cObjMap.get('OfacListPotentialMatches'));
		List<Object> OfACListData = (List<Object>)JSON.deserializeUntyped(OfACList);

		if (OfACListData!= null && !OfACListData.isEmpty()) {
			dataHolder.ofacInformation = 'Potential Match ALERT';			
		} else {
			dataHolder.ofacInformation = 'No OFAC match found';
		}
	}
}