public with sharing class GiactResponseParser {


		/*********************Parsing Advanced Principal Response and Preparing the HTML file String******************/

		public String prepareAdvancedHTMLResponsePrincipal (GIACTIntegrationService.PersonSearchResultRecords principalAdvanceResponse) {

		String body = '<center><br><h1 style="color:green;">Person search result records</h1><<br><br>';

		Integer counter = 1;

		for (GIACTIntegrationService.PersonSearchResultRecord person : principalAdvanceResponse.listOfLienAndBankruptcies) {

			body += '<br><br><h3 style="color:blue;"><i>Result '+ counter +'</i></h3><br>';

			body += '<table border ="1">';
			body += '<tr><th>' + 'Number Of Liens' + '</th><th>' + 'Number Of BankRuptcies' + '</th><th>' + 'Number Of Judgements'  + '</th></tr>';
			body += '<tr><td>' + person.numberOfLiens + '</td><td>' + person.numberOfBankRuptcies + '</td><td>' + person.numberOfJudgements + '</td></tr>';

			body += '</table>';

			body += '<table border ="1">';
				body += '<tr><th>' + 'First Name ' + '</th><th>' + 'Middle Name ' + '</th><th>' + 'Last Name'  + '</th></tr>';
			for (GIACTIntegrationService.CustomerName name : person.names) {
				body += '<tr><td>' + name.fName + '</td><td>' + name.mName + '</td><td>' + name.lName + '</td></tr>';
			}
			body += '</table>'; 

			counter++;
		} 
		body+='</center>';

		System.debug ('Html String - ' + body);

		return body;
	}


		/*********************Parsing Advanced Business Response and Preparing the HTML file String******************/

	public String prepareAdvancedHTMLResponseBusiness (GIACTIntegrationService.BusinessSearchResultRecords businessAdvanceResponse) {

		String body = '<br><h1 style="color:green;">Business search result records</h1><<br><br>';

		Integer counter = 1;

		for (GIACTIntegrationService.BusinessSearchResultRecord bRes : businessAdvanceResponse.listOfLienAndBankruptcies) {
			body += '<br><br><h3 style="color:blue;"><i>Result '+ counter +'</i></h3><br>';
			body += '<table border ="1">';
			body += '<tr><th>' + 'LienDebitors' + '</th><th>' + 'LienHolders' + '</th><th>' + 'BankRuptcyCreditors' + '</th><th>' + 'BankRuptcySubjects'  + '</th><th>' + 'JudgementCreditors' + '</th><th>' + 'JudgementDebtors'  + '</th></tr>';
			body += '<tr><td>' + bRes.numberOfLienDebtorCount + '</td><td>' + bRes.numberOfLienHolderCount + '</td><td>' + bRes.numberOfBankruptcyCreditorCount + '</td><td>' + bRes.numberOfBankruptcySubjectCount + '</td><td>' + bRes.numberOfJudgementCreditorCount + '</td><td>' + bRes.numberOfJudgementDebtorCount + '</td></tr>';
			body += '</table><br><br>';

			body += '<table border ="1">';
			body += '<tr><th>' + 'Business Name' + '</th></tr>';
			for (GIACTIntegrationService.BusinessName name : bRes.names) {
				body += '<tr><td>' + name.name + '</td></tr>';
			}
			body += '</table>';
		}
		return body;
	}

		/******************************************************************************************************************/

		/************************Parsing Basic Principal Response and Preparing the HTML file String**********************/

	public String prepareBasicResponseHTMLPrincipal (String jsonBody) {
		String matchedData;
		String ofactList;
		String matchedDataHTML;
		Map<String, Object> cObjMap = (Map<String, Object>) JSON.deserializeUntyped(jsonBody);

		if (cObjMap== null) return '';

		String body = '<br><center><h1 style="color:green;">Principal Identify Basic Search Results</h1></center><br><br><table border ="1"><center><tr><th>' + 'Property Name' + '</th><th>' + 'Property Value' + '</th></tr></center>';

		for (String key : cObjMap.keySet()) {
			if (key=='MatchedPersonData') {
				matchedData = (String)JSON.serialize(cObjMap.get('MatchedPersonData'));
				matchedDataHTML = parseBasicMatchedPersonData (matchedData);
				continue;
			}

			if (key=='OfacListPotentialMatches') {
				continue;
			}
			String value = (cObjMap.containsKey(key)==true && cObjMap.get(key)!=null)? (String)JSON.serialize(cObjMap.get(key)) : '';
			body += '<tr><td>' + key + '</td><td>' + value + '</td></tr>';
		}

		body += '</table>';


		if (!String.isEmpty(matchedDataHTML)) {
			body+= matchedDataHTML;
		}

		System.debug('Complete Body HTML - ' + body);
		return body;
	}

	private String parseBasicMatchedPersonData (String matchedPersonData) {

		String matchedPersonDatahtml = '<br><center><h1 style="color:green;">Matched Person Data</h1></center><br><br>';
		List<Object> matchDataList = (List<Object>)JSON.deserializeUntyped(matchedPersonData);
		if (matchDataList== null) return '';
		
		Integer counter = 1;

		for (Object obj : matchDataList) {

			matchedPersonDatahtml += '<br><br><h3 style="color:blue;"><i>Matched data for person - '+ counter +'</i></h3><br>';
			matchedPersonDatahtml += '<table border ="1">';
			matchedPersonDatahtml += '<center><tr><th>' + 'Property Name' + '</th><th>' + 'Property Value' + '</th></tr></center>';

			String matchDataItr = (String)JSON.serialize(obj);
			Map<String, Object> cObjMatchData = (Map<String, Object>) JSON.deserializeUntyped(matchDataItr);
			String nameRecordTable;
			String addressRecordTable;
			String phoneNumbersTable;
			String businessContactsTable;

			// This is not an efficient way. We are iterating once, althouth we can handle without iteration.
			for (String key : cObjMatchData.keySet()) {
				

				if (key=='NameRecords') {
					nameRecordTable = getNameRecordsTable ((String)JSON.serialize(cObjMatchData.get(key)));
				} else if (key=='AddressRecords') {
					addressRecordTable = getAddressRecordsTable ((String)JSON.serialize(cObjMatchData.get(key)));
				} else if (key=='PhoneNumbers') {
					phoneNumbersTable = getPhoneNumbersTable ((String)JSON.serialize(cObjMatchData.get(key)));
				} else if (key=='BusinessContacts') {
					businessContactsTable = getBusinessContactsTable ((String)JSON.serialize(cObjMatchData.get(key)));
				} else {
					String value = (cObjMatchData.containsKey(key)==true && cObjMatchData.get(key)!=null)? (String)JSON.serialize(cObjMatchData.get(key)) : '';
					matchedPersonDatahtml += '<tr><td>' + key + '</td><td>' + value + '</td></tr>';
				}

			}
			matchedPersonDatahtml += '</table>';

			if (!String.isEmpty(nameRecordTable)) matchedPersonDatahtml+= nameRecordTable;
			if (!String.isEmpty(addressRecordTable)) matchedPersonDatahtml+= addressRecordTable;
			if (!String.isEmpty(phoneNumbersTable)) matchedPersonDatahtml+= phoneNumbersTable;
			if (!String.isEmpty(businessContactsTable)) matchedPersonDatahtml+= businessContactsTable;

			counter++;
		}
		return matchedPersonDatahtml;
	}

	private string getNameRecordsTable (String jsonBody)  {
		List<Object> matchDataList = (List<Object>)JSON.deserializeUntyped(jsonBody);
		if (matchDataList== null) return '';

		List<String> keys = new List<String> {'BusinessName', 'BusinessType'};
		System.debug('****Prepring the Name Record Table***');
		String body = '<br><br><h3 style="color:blue;"><i>Name on the File</i></h3><br>';
		String tableString = '<center><tr><th>' + 'BusinessName' + '</th><th>' + 'BusinessType' + '</th></tr></center>';

		for (Object obj : matchDataList) {
			String jsonString = (String)JSON.serialize(obj);
			String rowString='';

			Map<String, Object> cObjMap = (Map<String, Object>) JSON.deserializeUntyped(jsonString);

			String value1  = (cObjMap.containsKey(keys[0]) && cObjMap.get(keys[0])!=null)? (String)JSON.serialize(cObjMap.get(keys[0])) : '';
			rowString += wrapStringInTD(value1.replaceAll('"', ''));

			String value2 = (cObjMap.containsKey(keys[1]) && cObjMap.get(keys[1])!=null)? (String)JSON.serialize(cObjMap.get(keys[1])) : '';
			rowString += wrapStringInTD(value2.replaceAll('"', ''));

			tableString+= wraptStringInTR(rowString);
			
			System.debug('Current Row String -' + rowString);
		}

		body += wrapStringInTable(tableString);
		System.debug('****Namre Record Table****' + body);

		return body;	
	}


	private string getAddressRecordsTable (String jsonBody)  {

		List<Object> matchDataList = (List<Object>)JSON.deserializeUntyped(jsonBody);
		if (matchDataList== null) return '';

		List<String> keys = new List<String> {'AddressLine1', 'AddressLine2', 'City', 'State',  'ZipCode'};
		String body = '<br><br><h3 style="color:blue;"><i>Addresses on the File</i></h3><br>';
		//body += '<table border ="1">';

		String tableString = '<center><tr><th>' + 'AddressLine1' + '</th><th>' + 'AddressLine2' + '</th><th>' + 'City' + '</th><th>' + 'State' + '</th><th>' + 'ZipCode' + '</th></tr></center>';

		System.debug('Total number or records in the list - ' + matchDataList.size());
		for (Object obj : matchDataList) {
			
			String rowString='';

			String jsonString = (String)JSON.serialize(obj);
			Map<String, Object> cObjMap = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
			
			String value1  = (cObjMap.containsKey(keys[0]) && cObjMap.get(keys[0])!=null)? (String)JSON.serialize(cObjMap.get(keys[0])) : '';
			rowString += wrapStringInTD(value1.replaceAll('"', ''));

			
			String value2 = (cObjMap.containsKey(keys[1]) && cObjMap.get(keys[1])!=null)? (String)JSON.serialize(cObjMap.get(keys[1])) : '';
			rowString += wrapStringInTD(value2.replaceAll('"', ''));

			String value3  = (cObjMap.containsKey(keys[2 ]) && cObjMap.get(keys[2])!=null)? (String)JSON.serialize(cObjMap.get(keys[2])) : '';
			rowString += wrapStringInTD(value3.replaceAll('"', ''));

			String value4  = (cObjMap.containsKey(keys[3]) && cObjMap.get(keys[3])!=null)? (String)JSON.serialize(cObjMap.get(keys[3])) : '';
			rowString += wrapStringInTD(value4.replaceAll('"', ''));

			String value5  = (cObjMap.containsKey(keys[4]) && cObjMap.get(keys[4])!=null)? (String)JSON.serialize(cObjMap.get(keys[4])) : '';
			rowString += wrapStringInTD(value5.replaceAll('"', ''));

			tableString+= wraptStringInTR(rowString);

		}

		body += wrapStringInTable(tableString);
		return body;	
	}
	private string getPhoneNumbersTable (String jsonBody)  {
		List<Object> matchDataList = (List<Object>)JSON.deserializeUntyped(jsonBody);
		if (matchDataList== null) return '';

		List<String> keys = new List<String> {'Classification', 'NumberType', 'AreaCode', 'Exchange', 'PhoneNumber'};

		String body = '<br><br><h3 style="color:blue;"><i>Phone Numbers on the File</i></h3><br>';
		
		String tableString = '<center><tr><th>' + 'Classification' + '</th><th>' + 'NumberType' + '</th><th>' + 'AreaCode' + '</th><th>' + 'Exchange' + '</th><th>' + 'PhoneNumber' + '</th></tr></center>';

		for (Object obj : matchDataList) {
			String jsonString = (String)JSON.serialize(obj);
			Map<String, Object> cObjMap = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
			String rowString='';

			String value1  = (cObjMap.containsKey(keys[0]) && cObjMap.get(keys[0])!=null)? (String)JSON.serialize(cObjMap.get(keys[0])) : '';
			rowString += wrapStringInTD(value1.replaceAll('"', ''));

			
			String value2 = (cObjMap.containsKey(keys[1]) && cObjMap.get(keys[1])!=null)? (String)JSON.serialize(cObjMap.get(keys[1])) : '';
			rowString += wrapStringInTD(value2.replaceAll('"', ''));

			String value3  = (cObjMap.containsKey(keys[2 ]) && cObjMap.get(keys[2])!=null)? (String)JSON.serialize(cObjMap.get(keys[2])) : '';
			rowString += wrapStringInTD(value3.replaceAll('"', ''));

			String value4  = (cObjMap.containsKey(keys[3]) && cObjMap.get(keys[3])!=null)? (String)JSON.serialize(cObjMap.get(keys[3])) : '';
			rowString += wrapStringInTD(value4.replaceAll('"', ''));

			String value5  = (cObjMap.containsKey(keys[4]) && cObjMap.get(keys[4])!=null)? (String)JSON.serialize(cObjMap.get(keys[4])) : '';
			rowString += wrapStringInTD(value5.replaceAll('"', ''));
			
			tableString+= wraptStringInTR(rowString);
		}

		body += wrapStringInTable(tableString);

		return body;
	}
	
	private string getBusinessContactsTable (String jsonBody)  {

		List<Object> matchDataList = (List<Object>)JSON.deserializeUntyped(jsonBody);
		if (matchDataList== null) return '';

		List<String> keys = new List<String> {'FirstName', 'MiddleName', 'LastName', 'Title'};
		String body = '<br><br><h3 style="color:blue;"><i>Business Contact on the File</i></h3><br>';
		String tableString = '<center><tr><th>' + 'FirstName' + '</th><th>' + 'MiddleName' + '</th><th>' + 'LastName' + '</th><th>' + 'Title' + '</th></tr></center>';

		for (Object obj : matchDataList) {
			String namejson = (String)JSON.serialize(obj);
			Map<String, Object> cObjMap = (Map<String, Object>)(JSON.deserializeUntyped(nameJson));
			String rowString='';

			String value1  = (cObjMap.containsKey(keys[0]) && cObjMap.get(keys[0])!=null)? (String)JSON.serialize(cObjMap.get(keys[0])) : '';
			rowString += wrapStringInTD(value1.replaceAll('"', ''));

			
			String value2 = (cObjMap.containsKey(keys[1]) && cObjMap.get(keys[1])!=null)? (String)JSON.serialize(cObjMap.get(keys[1])) : '';
			rowString += wrapStringInTD(value2.replaceAll('"', ''));

			String value3  = (cObjMap.containsKey(keys[2 ]) && cObjMap.get(keys[2])!=null)? (String)JSON.serialize(cObjMap.get(keys[2])) : '';
			rowString += wrapStringInTD(value3.replaceAll('"', ''));

			String value4  = (cObjMap.containsKey(keys[3]) && cObjMap.get(keys[3])!=null)? (String)JSON.serialize(cObjMap.get(keys[3])) : '';
			rowString += wrapStringInTD(value4.replaceAll('"', ''));

			tableString+= wraptStringInTR(rowString);
		}

		body += wrapStringInTable(tableString);

		return body;
	}


		/******************************************************************************************************************/
		/************************Parsing Basic Business Response and Preparing the HTML file String**********************/


	public String prepareBasicResponseHTMLBusiness (String jsonBody, GIdentifyEntity dataHolder) {
		String matchedData;
		String ofactList;
		String matchedDataHTML;
		Map<String, Object> cObjMap = (Map<String, Object>) JSON.deserializeUntyped(jsonBody);
		if (cObjMap== null) return '';

		String body = '<br><center><h1 style="color:green;">Business Identify Basic Search Results</h1></center><br><br><table border ="1"><center><tr><th>' + 'Property Name' + '</th><th>' + 'Property Value' + '</th></tr></center>';
		
		for (String key : cObjMap.keySet()) {
			if (key=='MatchedBusinessData') {
				matchedData = (String)JSON.serialize(cObjMap.get('MatchedBusinessData'));
				matchedDataHTML = parseBasicMatchedBusinessData (matchedData, dataHolder);
				continue;
			}

			if (key=='OfacListPotentialMatches') {
				continue;
			}
			String value = (cObjMap.containsKey(key)==true && cObjMap.get(key)!=null)? (String)JSON.serialize(cObjMap.get(key)) : '';
			body += '<tr><td>' + key + '</td><td>' + value + '</td></tr>';
		}


		body += '</table>';


		if (!String.isEmpty(matchedDataHTML)) {
			body+= matchedDataHTML;
		}

		System.debug('Complete Body HTML - ' + body);
		return body;
	}


	private String parseBasicMatchedBusinessData (String matchedPersonData, GIdentifyEntity dataHolder) {

		String matchedPersonDatahtml = '<br><center><h1 style="color:green;">Matched Business Data</h1></center><br><br>';
		List<Object> matchDataList = (List<Object>)JSON.deserializeUntyped(matchedPersonData);
		if (matchDataList== null) return '';
		
		
		Integer counter = 1;

		for (Object obj : matchDataList) {

			matchedPersonDatahtml += '<br><br><h3 style="color:blue;"><i>Matched data for Business - '+ counter +'</i></h3><br>';
			matchedPersonDatahtml += '<table border ="1">';
			matchedPersonDatahtml += '<center><tr><th>' + 'Property Name' + '</th><th>' + 'Property Value' + '</th></tr></center>';

			String matchDataItr = (String)JSON.serialize(obj);
			Map<String, Object> cObjMatchData = (Map<String, Object>) JSON.deserializeUntyped(matchDataItr);
			String nameRecordTable;
			String addressRecordTable;
			String phoneNumbersTable;
			String businessContactsTable;

			System.debug('Total Business Object - ' + cObjMatchData);
			// This is not an efficient way. We are iterating once, althouth we can handle without iteration.
			for (String key : cObjMatchData.keySet()) {
				

				if (key=='NameRecords') {
					nameRecordTable = getNameRecordsTable ((String)JSON.serialize(cObjMatchData.get(key)));
				} else if (key=='AddressRecords') {
					addressRecordTable = getAddressRecordsTable ((String)JSON.serialize(cObjMatchData.get(key)));
				} else if (key=='PhoneNumbers') {
					phoneNumbersTable = getPhoneNumbersTable ((String)JSON.serialize(cObjMatchData.get(key)));
				} else if (key=='BusinessContacts') {
					businessContactsTable = getBusinessContactsTable ((String)JSON.serialize(cObjMatchData.get(key)));
				} else if (key=='RegistrationType') {
					String val = (String)JSON.serialize(cObjMatchData.get(key));
					System.debug('RegistrationType Value Retrieved - ' + val);
					if (!String.isEmpty(val) && val!='null') {
						dataHolder.registrationType = (String.isEmpty(dataHolder.registrationType)?
							val : dataHolder.registrationType+', ' + val) ;
					}
				} else {
					String value = (cObjMatchData.containsKey(key)==true && cObjMatchData.get(key)!=null)? (String)JSON.serialize(cObjMatchData.get(key)) : '';
					matchedPersonDatahtml += '<tr><td>' + key + '</td><td>' + value + '</td></tr>';
				}

			}
			matchedPersonDatahtml += '</table>';

			if (!String.isEmpty(nameRecordTable)) matchedPersonDatahtml+= nameRecordTable;
			if (!String.isEmpty(addressRecordTable)) matchedPersonDatahtml+= addressRecordTable;
			if (!String.isEmpty(phoneNumbersTable)) matchedPersonDatahtml+= phoneNumbersTable;
			if (!String.isEmpty(businessContactsTable)) matchedPersonDatahtml+= businessContactsTable;

			counter++;
		}
		return matchedPersonDatahtml;
	}

	private String wrapStringInTD (String value) {
		return '<td>' + clean (value) + '</td>';
	}

	private String wraptStringInTR (String value) {
		return '<tr>' + clean(value) + '</tr>';
	}
	private String wrapStringInI (String value) {
		return '<i>' + clean (value) + '</i>';
	}
	private String clean  (String value) {
		return (String.isEmpty(value)? '' : value);
	}

	private String wrapStringInTable (String value) {
		return '<table border ="1">'+ clean (value) + '</table>';

	}
}