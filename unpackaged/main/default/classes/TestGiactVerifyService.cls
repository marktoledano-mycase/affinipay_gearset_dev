@isTest
public with sharing class TestGiactVerifyService {

	private static Id myCaseRecTypeId = InformationStrings.vPlusMycasePaymentsId;
	// private static Id apmRecTypeId = InformationStrings.vPlusAPMPaymentsId;
	private static string tincheckResponse = '{"ValidateTinNameAddressListMatchResult_type_info":["ValidateTinNameAddressListMatchResult","http://www.TinCheck.com/WebServices/PVSService/",null,"0","1","false"],"ValidateTinNameAddressListMatchResult":{"TINNAME_RESULT_type_info":["TINNAME_RESULT","http://www.TinCheck.com/WebServices/PVSService/",null,"0","1","false"],"TINNAME_RESULT":{"TINNAME_DETAILS_type_info":["TINNAME_DETAILS","http://www.TinCheck.com/WebServices/PVSService/",null,"0","1","false"],"TINNAME_DETAILS":"IRS Match found. TIN and Name combination matches IRS EIN records","TINNAME_CODE_type_info":["TINNAME_CODE","http://www.TinCheck.com/WebServices/PVSService/",null,"1","1","false"],"TINNAME_CODE":"7","STATUS_type_info":["STATUS","http://www.TinCheck.com/WebServices/PVSService/",null,"0","1","false"],"STATUS":null,"GIIN_DETAILS_type_info":["GIIN_DETAILS","http://www.TinCheck.com/WebServices/PVSService/",null,"0","1","false"],"GIIN_DETAILS":"GIIN/FATCA not processed due to company settings","GIIN_DATA_type_info":["GIIN_DATA","http://www.TinCheck.com/WebServices/PVSService/",null,"0","1","false"],"GIIN_DATA":"","GIIN_CODE_type_info":["GIIN_CODE","http://www.TinCheck.com/WebServices/PVSService/",null,"1","1","false"],"GIIN_CODE":"12","field_order_type_info":["TINNAME_CODE","TINNAME_DETAILS","DMF_CODE","DMF_DETAILS","DMF_DATA","EIN_CODE","EIN_DETAILS","EIN_DATA","GIIN_CODE","GIIN_DETAILS","GIIN_DATA","STATUS"],"EIN_DETAILS_type_info":["EIN_DETAILS","http://www.TinCheck.com/WebServices/PVSService/",null,"0","1","false"],"EIN_DETAILS":"EIN Possible Match found.","EIN_DATA_type_info":["EIN_DATA","http://www.TinCheck.com/WebServices/PVSService/",null,"0","1","false"],"EIN_DATA":"KINGDOM LITIGATORS INC","EIN_CODE_type_info":["EIN_CODE","http://www.TinCheck.com/WebServices/PVSService/",null,"1","1","false"],"EIN_CODE":"1","DMF_DETAILS_type_info":["DMF_DETAILS","http://www.TinCheck.com/WebServices/PVSService/",null,"0","1","false"],"DMF_DETAILS":"No Death Master File Match Found.","DMF_DATA_type_info":["DMF_DATA","http://www.TinCheck.com/WebServices/PVSService/",null,"0","1","false"],"DMF_DATA":"\n ","DMF_CODE_type_info":["DMF_CODE","http://www.TinCheck.com/WebServices/PVSService/",null,"1","1","false"],"DMF_CODE":"0","apex_schema_type_info":["http://www.TinCheck.com/WebServices/PVSService/","true","false"]},"STATUS_type_info":["STATUS","http://www.TinCheck.com/WebServices/PVSService/",null,"0","1","false"],"STATUS":{"Status_type_info":["Status","http://www.TinCheck.com/WebServices/PVSService/",null,"1","1","false"],"Status":"OK","field_order_type_info":["Status","CallsRemaining"],"CallsRemaining_type_info":["CallsRemaining","http://www.TinCheck.com/WebServices/PVSService/",null,"0","1","false"],"CallsRemaining":"No Limit","apex_schema_type_info":["http://www.TinCheck.com/WebServices/PVSService/","true","false"]},"REQUESTID_type_info":["REQUESTID","http://www.TinCheck.com/WebServices/PVSService/",null,"1","1","false"],"REQUESTID":40134933,"REQUEST_STATUS_type_info":["REQUEST_STATUS","http://www.TinCheck.com/WebServices/PVSService/",null,"1","1","false"],"REQUEST_STATUS":"1","REQUEST_DETAILS_type_info":["REQUEST_DETAILS","http://www.TinCheck.com/WebServices/PVSService/",null,"0","1","false"],"REQUEST_DETAILS":"Request Completed","LISTMATCH_RESULT_type_info":["LISTMATCH_RESULT","http://www.TinCheck.com/WebServices/PVSService/",null,"0","1","false"],"LISTMATCH_RESULT":{"STATUS_type_info":["STATUS","http://www.TinCheck.com/WebServices/PVSService/",null,"0","1","false"],"STATUS":null,"Results_type_info":["Results","http://www.TinCheck.com/WebServices/PVSService/",null,"0","1","false"],"Results":{"Result_type_info":["Result","http://www.TinCheck.com/WebServices/PVSService/",null,"0","-1","true"],"Result":[{"Type_x_type_info":["Type","http://www.TinCheck.com/WebServices/PVSService/",null,"0","1","false"],"Type_x":"OFAC","field_order_type_info":["Type_x","Code","Details","Count","Data"],"Details_type_info":["Details","http://www.TinCheck.com/WebServices/PVSService/",null,"0","1","false"],"Details":"OFAC/SDN List: No Match Found","Data_type_info":["Data","http://www.TinCheck.com/WebServices/PVSService/",null,"0","1","false"],"Data":"\n ","Count_type_info":["Count","http://www.TinCheck.com/WebServices/PVSService/",null,"1","1","false"],"Count":0,"Code_type_info":["Code","http://www.TinCheck.com/WebServices/PVSService/",null,"1","1","false"],"Code":"0","apex_schema_type_info":["http://www.TinCheck.com/WebServices/PVSService/","true","false"]},{"Type_x_type_info":["Type","http://www.TinCheck.com/WebServices/PVSService/",null,"0","1","false"],"Type_x":"FBIMWT","field_order_type_info":["Type_x","Code","Details","Count","Data"],"Details_type_info":["Details","http://www.TinCheck.com/WebServices/PVSService/",null,"0","1","false"],"Details":"FBI: Most Wanted Terrorists: No Match Found","Data_type_info":["Data","http://www.TinCheck.com/WebServices/PVSService/",null,"0","1","false"],"Data":"\n ","Count_type_info":["Count","http://www.TinCheck.com/WebServices/PVSService/",null,"1","1","false"],"Count":0,"Code_type_info":["Code","http://www.TinCheck.com/WebServices/PVSService/",null,"1","1","false"],"Code":"0","apex_schema_type_info":["http://www.TinCheck.com/WebServices/PVSService/","true","false"]},{"Type_x_type_info":["Type","http://www.TinCheck.com/WebServices/PVSService/",null,"0","1","false"],"Type_x":"FBIWCC","field_order_type_info":["Type_x","Code","Details","Count","Data"],"Details_type_info":["Details","http://www.TinCheck.com/WebServices/PVSService/",null,"0","1","false"],"Details":"FBI: White Collar Crime: No Match Found","Data_type_info":["Data","http://www.TinCheck.com/WebServices/PVSService/",null,"0","1","false"],"Data":"\n ","Count_type_info":["Count","http://www.TinCheck.com/WebServices/PVSService/",null,"1","1","false"],"Count":0,"Code_type_info":["Code","http://www.TinCheck.com/WebServices/PVSService/",null,"1","1","false"],"Code":"0","apex_schema_type_info":["http://www.TinCheck.com/WebServices/PVSService/","true","false"]},{"Type_x_type_info":["Type","http://www.TinCheck.com/WebServices/PVSService/",null,"0","1","false"],"Type_x":"FBICC","field_order_type_info":["Type_x","Code","Details","Count","Data"],"Details_type_info":["Details","http://www.TinCheck.com/WebServices/PVSService/",null,"0","1","false"],"Details":"FBI: Cyber Crimes: No Match Found","Data_type_info":["Data","http://www.TinCheck.com/WebServices/PVSService/",null,"0","1","false"],"Data":"\n ","Count_type_info":["Count","http://www.TinCheck.com/WebServices/PVSService/",null,"1","1","false"],"Count":0,"Code_type_info":["Code","http://www.TinCheck.com/WebServices/PVSService/",null,"1","1","false"],"Code":"0","apex_schema_type_info":["http://www.TinCheck.com/WebServices/PVSService/","true","false"]}],"field_order_type_info":["Result"],"apex_schema_type_info":["http://www.TinCheck.com/WebServices/PVSService/","true","false"]},"PEP_Result_type_info":["PEP_Result","http://www.TinCheck.com/WebServices/PVSService/",null,"0","1","false"],"PEP_Result":null,"OFAC_RESULT_type_info":["OFAC_RESULT","http://www.TinCheck.com/WebServices/PVSService/",null,"0","1","false"],"OFAC_RESULT":{"OFAC_DETAILS_type_info":["OFAC_DETAILS","http://www.TinCheck.com/WebServices/PVSService/",null,"0","1","false"],"OFAC_DETAILS":"OFAC/SDN List: No Match Found","OFAC_DATA_type_info":["OFAC_DATA","http://www.TinCheck.com/WebServices/PVSService/",null,"0","1","false"],"OFAC_DATA":"\n ","OFAC_COUNT_type_info":["OFAC_COUNT","http://www.TinCheck.com/WebServices/PVSService/",null,"1","1","false"],"OFAC_COUNT":0,"OFAC_CODE_type_info":["OFAC_CODE","http://www.TinCheck.com/WebServices/PVSService/",null,"1","1","false"],"OFAC_CODE":"0","field_order_type_info":["OFAC_CODE","OFAC_DETAILS","OFAC_COUNT","OFAC_DATA"],"apex_schema_type_info":["http://www.TinCheck.com/WebServices/PVSService/","true","false"]},"NV_RESULT_type_info":["NV_RESULT","http://www.TinCheck.com/WebServices/PVSService/",null,"0","1","false"],"NV_RESULT":null,"NJ_RESULT_type_info":["NJ_RESULT","http://www.TinCheck.com/WebServices/PVSService/",null,"0","1","false"],"NJ_RESULT":null,"MS_RESULT_type_info":["MS_RESULT","http://www.TinCheck.com/WebServices/PVSService/",null,"0","1","false"],"MS_RESULT":null,"MO_RESULT_type_info":["MO_RESULT","http://www.TinCheck.com/WebServices/PVSService/",null,"0","1","false"],"MO_RESULT":null,"LISTSMATCH_DETAILS_type_info":["LISTSMATCH_DETAILS","http://www.TinCheck.com/WebServices/PVSService/",null,"0","1","false"],"LISTSMATCH_DETAILS":"No Lists Matches Found","LISTSMATCH_CODE_type_info":["LISTSMATCH_CODE","http://www.TinCheck.com/WebServices/PVSService/",null,"1","1","false"],"LISTSMATCH_CODE":"0","IL_RESULT_type_info":["IL_RESULT","http://www.TinCheck.com/WebServices/PVSService/",null,"0","1","false"],"IL_RESULT":null,"HHS_RESULT_type_info":["HHS_RESULT","http://www.TinCheck.com/WebServices/PVSService/",null,"0","1","false"],"HHS_RESULT":null,"field_order_type_info":["LISTSMATCH_CODE","LISTSMATCH_DETAILS","OFAC_RESULT","NV_RESULT","MS_RESULT","IL_RESULT","MO_RESULT","NJ_RESULT","EPLS_RESULT","DPL_Result","PEP_Result","HHS_RESULT","STATUS","Results"],"EPLS_RESULT_type_info":["EPLS_RESULT","http://www.TinCheck.com/WebServices/PVSService/",null,"0","1","false"],"EPLS_RESULT":null,"DPL_Result_type_info":["DPL_Result","http://www.TinCheck.com/WebServices/PVSService/",null,"0","1","false"],"DPL_Result":null,"apex_schema_type_info":["http://www.TinCheck.com/WebServices/PVSService/","true","false"]},"field_order_type_info":["REQUESTID","REQUEST_STATUS","REQUEST_DETAILS","TINNAME_RESULT","LISTMATCH_RESULT","ADDRESS_RESULT","STATUS"],"apex_schema_type_info":["http://www.TinCheck.com/WebServices/PVSService/","true","false"],"ADDRESS_RESULT_type_info":["ADDRESS_RESULT","http://www.TinCheck.com/WebServices/PVSService/",null,"0","1","false"],"ADDRESS_RESULT":{"field_order_type_info":["ADDRESS_CODE","ADDRESS_DETAILS"],"apex_schema_type_info":["http://www.TinCheck.com/WebServices/PVSService/","true","false"],"ADDRESS_DETAILS_type_info":["ADDRESS_DETAILS","http://www.TinCheck.com/WebServices/PVSService/",null,"0","1","false"],"ADDRESS_DETAILS":"No USPS Match found.","ADDRESS_CODE_type_info":["ADDRESS_CODE","http://www.TinCheck.com/WebServices/PVSService/",null,"1","1","false"],"ADDRESS_CODE":"0"}},"field_order_type_info":["ValidateTinNameAddressListMatchResult"],"apex_schema_type_info":["http://www.TinCheck.com/WebServices/PVSService/","true","false"]}';
	private static string bizResponse = '{"ItemReferenceId":10061329370,"CreatedDate":"2018-04-02T12:57:18.3596197-05:00","ErrorMessage":null,"VerificationResponse":6,"AccountResponseCode":null,"BankName":null,"AccountAddedDate":null,"AccountLastUpdatedDate":null,"AccountClosedDate":null,"BankAccountType":null,"VoidedCheckImage":null,"FundsConfirmationResult":null,"CustomerResponseCode":11,"MatchedPersonData":null,"ConsumerAlertMessages":null,"MatchedBusinessData":[{"NameRecords":[{"BusinessName":"TM PROPERTY SOLUTIONS LLC","BusinessType":"PRIMARY"}],"MatchingBusinessContactFound":null,"FEIN":null,"DunsNumber":"070691668","CorporationType":"CORPORATION","RegistrationType":"LIMITED LIABILITY COMPANY","IncorporationState":"CO","IncorporationDate":"2015-11-13T00:00:00","FilingNumber":"20151730577","Industries":[],"Domains":[],"AddressRecords":[{"AddressLine1":"2695 PATTERSON RD STE 2-292","AddressLine2":null,"City":"GRAND JUNCTION","State":"CO","ZipCode":"81506","ParsedAddressLine1":{"StreetNumber":"2695","PreDirectional":null,"StreetName":"PATTERSON","StreetSuffix":"RD","PostDirectional":null,"UnitType":"STE","UnitIdentifier":"2-292"}}],"PhoneNumbers":[],"BusinessContacts":[{"FirstName":"TONYA","MiddleName":"M","LastName":"MCFARLAND","Title":"REGISTERED AGENT"}],"BankruptcySubjectRecordCount":0,"BankruptcyCreditorRecordCount":0,"MiscellaneousDetails":null,"BusinessReportKey":"bM1AGB4UdGTec1hxi8QsFVkT7Cmbp/WGr/m/kuh4/t1g="}],"OfacListPotentialMatches":[],"GIdentifyKbaResult":null,"EmailAddressInformationResult":null,"IpAddressInformationResult":null,"DomainRegistry":null,"MobileVerifyResult":null,"MobileIdentifyResult":null,"MobileLocationResult":null,"PhoneIntelligenceResult":null}';
	private static String bizAdvResponse = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><BusinessSearchResponse xmlns="http://www.giact.com/api/identificationservices/v1.0"><BusinessSearchResult><SearchModified>false</SearchModified><NumberOfRecordsFound>1</NumberOfRecordsFound><NumberOfRecordsFoundWithModifiedSearch>0</NumberOfRecordsFoundWithModifiedSearch><AbbreviatedResult>false</AbbreviatedResult><SearchResultRecords><IDAdvancedBusinessSearchResultRecord><BusinessReportKey>bhHNTL2Ejcv936LNOyAqF4WEOwSkVJLCJ2rBGiwR8bm8=</BusinessReportKey><FEINumber /><BusinessNames><IDAdvancedBusinessName><Name>TM PROPERTY SOLUTIONS  LLC</Name><Type>Primary</Type></IDAdvancedBusinessName><IDAdvancedBusinessName><Name>TM PROPERTY SOLUTIONS, LLC</Name><Type>Primary</Type></IDAdvancedBusinessName></BusinessNames><DomesticWorldFlag>D</DomesticWorldFlag><ParentBusinessReportKey /><ParentDomesticWorldFlag /><GlobalBusinessReportKey /><GlobalDomesticWorldFlag /><HQBusinessReportKey /><HQBusinessDomesticWorldFlag /><Industry>Nonresidential Building Operators</Industry><Industries><string>Nonresidential Building Operators</string></Industries><Addresses><IDAdvancedAddressRecord><ConfirmedAddress>false</ConfirmedAddress><Address><Line1>602 RICO WAY</Line1><City>GRAND JUNCTION</City><State>CO</State><ZipCode>81506</ZipCode><Zip4>8221</Zip4></Address><DateFirstSeen><Day>18</Day><Month>11</Month><Year>2015</Year></DateFirstSeen><DateLastSeen><Day>25</Day><Month>10</Month><Year>2017</Year></DateLastSeen><PhoneListings><IDAdvancedPhoneListing><Phone>9702347163</Phone><PhoneType>Unknown</PhoneType><ListingType>Unknown</ListingType><Carrier>T-MOBILE USA INC</Carrier><CarrierType>WIRELESS</CarrierType><City>GRAND JUNCTION</City><State>CO</State><County>MESA</County><TimeZone>MT</TimeZone></IDAdvancedPhoneListing></PhoneListings></IDAdvancedAddressRecord></Addresses><PrincipalContacts><IDAdvancedBusinessContact><PersonReportKey>G5R9-W737</PersonReportKey><Name><FirstName>TONYA</FirstName><MiddleName /><LastName>MCFARLAND</LastName><NameSuffix /></Name><Title>PRIN; PRINCIPAL; REGISTERED AGENT</Title><ContactType>Principal</ContactType><Address><Line1>602 RICO WAY</Line1><City>GRAND JUNCTION</City><State>CO</State><ZipCode>81506</ZipCode><Zip4>8221</Zip4></Address></IDAdvancedBusinessContact></PrincipalContacts><OtherContacts /><DeedCount>0</DeedCount><ForeclosureCount>0</ForeclosureCount><VehicleCount>0</VehicleCount><AircraftCount>0</AircraftCount><JudgementDebtorCount>0</JudgementDebtorCount><JudgementCreditorCount>0</JudgementCreditorCount><LienHolderCount>0</LienHolderCount><LienDebtorCount>0</LienDebtorCount><BankruptcySubjectCount>0</BankruptcySubjectCount><BankruptcyCreditorCount>0</BankruptcyCreditorCount><PossibleEmployeeCount>0</PossibleEmployeeCount></IDAdvancedBusinessSearchResultRecord></SearchResultRecords></BusinessSearchResult></BusinessSearchResponse></soap:Body></soap:Envelope>';
	private static String personBasicResponse = '{"ItemReferenceId":10061088347,"CreatedDate":"2018-03-30T12:02:29.5781762-05:00","ErrorMessage":null,"VerificationResponse":6,"AccountResponseCode":null,"BankName":null,"AccountAddedDate":null,"AccountLastUpdatedDate":null,"AccountClosedDate":null,"BankAccountType":null,"VoidedCheckImage":null,"FundsConfirmationResult":null,"CustomerResponseCode":11,"MatchedPersonData":[{"FirstName":"TONYA","MiddleName":null,"LastName":"MCFARLAND","DateOfBirth":"1971-09-09T00:00:00","IdNumber":null,"SsnIssueState":"CO","SsnIssueStartYear":"1973","SsnIssueEndYear":"1974","SsnStatus":"clear","AddressRecords":[{"AddressLine1":"602 RICO","AddressLine2":null,"City":"GRAND JUNCTION","State":"CO","ZipCode":"81506","Status":0,"DateReported":"2013-07-13T00:00:00","ParsedAddressLine1":{"StreetNumber":"602","PreDirectional":null,"StreetName":"RICO","StreetSuffix":null,"PostDirectional":null,"UnitType":null,"UnitIdentifier":null}},{"AddressLine1":"264 PINON","AddressLine2":null,"City":"GRAND JUNCTION","State":"CO","ZipCode":"81503","Status":1,"DateReported":"2009-09-21T00:00:00","ParsedAddressLine1":{"StreetNumber":"264","PreDirectional":null,"StreetName":"PINON","StreetSuffix":null,"PostDirectional":null,"UnitType":null,"UnitIdentifier":null}},{"AddressLine1":"296 W PARKVIEW","AddressLine2":null,"City":"GRAND JUNCTION","State":"CO","ZipCode":"81503","Status":2,"DateReported":null,"ParsedAddressLine1":{"StreetNumber":"296","PreDirectional":"W","StreetName":"PARKVIEW","StreetSuffix":null,"PostDirectional":null,"UnitType":null,"UnitIdentifier":null}}],"PhoneNumbers":[{"Classification":0,"NumberType":1,"AreaCode":"970","Exchange":"234","Suffix":"7163","PhoneNumber":"9702347163"}]},{"FirstName":"TONYA","MiddleName":"M","LastName":"MOORE","DateOfBirth":"1971-09-09T00:00:00","IdNumber":null,"SsnIssueState":null,"SsnIssueStartYear":null,"SsnIssueEndYear":null,"SsnStatus":null,"AddressRecords":[{"AddressLine1":"264 PINON","AddressLine2":null,"City":"GRAND JUNCTION","State":"CO","ZipCode":"81503","Status":0,"DateReported":"2013-07-01T00:00:00","ParsedAddressLine1":{"StreetNumber":"264","PreDirectional":null,"StreetName":"PINON","StreetSuffix":null,"PostDirectional":null,"UnitType":null,"UnitIdentifier":null}},{"AddressLine1":"602 RICO","AddressLine2":null,"City":"GRAND JUNCTION","State":"CO","ZipCode":"81506","Status":1,"DateReported":"2013-07-01T00:00:00","ParsedAddressLine1":{"StreetNumber":"602","PreDirectional":null,"StreetName":"RICO","StreetSuffix":null,"PostDirectional":null,"UnitType":null,"UnitIdentifier":null}},{"AddressLine1":"1800 MAIN","AddressLine2":null,"City":"GRAND JUNCTION","State":"CO","ZipCode":"81501","Status":2,"DateReported":"2009-10-01T00:00:00","ParsedAddressLine1":{"StreetNumber":"1800","PreDirectional":null,"StreetName":"MAIN","StreetSuffix":null,"PostDirectional":null,"UnitType":null,"UnitIdentifier":null}}],"PhoneNumbers":[{"Classification":0,"NumberType":2,"AreaCode":"970","Exchange":"241","Suffix":"1799","PhoneNumber":"9702411799"}]}],"ConsumerAlertMessages":[],"MatchedBusinessData":null,"OfacListPotentialMatches":[],"GIdentifyKbaResult":null,"EmailAddressInformationResult":null,"IpAddressInformationResult":null,"DomainRegistry":null,"MobileVerifyResult":null,"MobileIdentifyResult":null,"MobileLocationResult":null,"PhoneIntelligenceResult":null}';
	private static String personAdvancedResponse = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><PersonSearchResponse xmlns="http://www.giact.com/api/identificationservices/v1.0"><PersonSearchResult><SearchModified>false</SearchModified><NumberOfRecordsFound>1</NumberOfRecordsFound><NumberOfRecordsFoundWithModifiedSearch>0</NumberOfRecordsFoundWithModifiedSearch><AbbreviatedResult>false</AbbreviatedResult><SearchResultRecords><IDAdvancedPersonSearchResultRecord><PersonReportKey>G5R9-W737</PersonReportKey><DateFirstSeen>0001-01-01T00:00:00</DateFirstSeen><DateLastSeen>2018-03-30T00:00:00</DateLastSeen><Names><IDAdvancedBasicName><FirstName>TONYA</FirstName><MiddleName>MARIANA</MiddleName><LastName>MCFARLAND</LastName><NameSuffix /><DateFirstSeen><Day>01</Day><Month>08</Month><Year>2013</Year></DateFirstSeen><DateLastSeen><Day>04</Day><Month>01</Month><Year>2018</Year></DateLastSeen></IDAdvancedBasicName><IDAdvancedBasicName><FirstName>TONYA</FirstName><MiddleName>MARIANA</MiddleName><LastName>HICKS</LastName><NameSuffix /><DateFirstSeen><Day>16</Day><Month>09</Month><Year>1997</Year></DateFirstSeen><DateLastSeen><Day>01</Day><Month>12</Month><Year>2017</Year></DateLastSeen></IDAdvancedBasicName><IDAdvancedBasicName><FirstName>TONYA</FirstName><MiddleName>MARIANA</MiddleName><LastName>FLEMING</LastName><NameSuffix /><DateFirstSeen><Day>01</Day><Month>06</Month><Year>1990</Year></DateFirstSeen><DateLastSeen><Day>01</Day><Month>07</Month><Year>2013</Year></DateLastSeen></IDAdvancedBasicName><IDAdvancedBasicName><FirstName>TONYA</FirstName><MiddleName>MARIANA</MiddleName><LastName>MOORE</LastName><NameSuffix /><DateFirstSeen><Day>01</Day><Month>06</Month><Year>1988</Year></DateFirstSeen><DateLastSeen><Day>01</Day><Month>07</Month><Year>2013</Year></DateLastSeen></IDAdvancedBasicName></Names><DateOfBirthRecords><IDAdvancedDateOfBirthRecord><DateOfBirth><Day>09</Day><Month>09</Month><Year>1971</Year></DateOfBirth><CurrentAge>46</CurrentAge></IDAdvancedDateOfBirthRecord></DateOfBirthRecords><SSNRecords><IDAdvancedSSNRecord><SSNReportKey>aESIGtzU6FEmtTLVA0z86Eg==</SSNReportKey><SSN>523027188</SSN><SSNPlaceOfIssue>COLORADO</SSNPlaceOfIssue><SSNIssueYears>1973-1974</SSNIssueYears></IDAdvancedSSNRecord><IDAdvancedSSNRecord><SSNReportKey>aQxmTPDZXAGcg6yJOhJ5yMA==</SSNReportKey><SSN>46347XXXX</SSN><SSNPlaceOfIssue>TEXAS</SSNPlaceOfIssue><SSNIssueYears>1979-1980</SSNIssueYears></IDAdvancedSSNRecord></SSNRecords><DriversLicenses /><ProfessionalLicenses /><Addresses /><PhoneListings><IDAdvancedPhoneListing><Phone>9702411799</Phone><PhoneType>LandLine</PhoneType><ListingType>Unknown</ListingType><Carrier>QWEST CORPORATION (CENTURYLINK)</Carrier><CarrierType>LANDLINE</CarrierType><City>GRAND JUNCTION</City><State>CO</State><County>MESA</County><TimeZone>MT</TimeZone><Score>88</Score></IDAdvancedPhoneListing><IDAdvancedPhoneListing><Phone>9702347163</Phone><PhoneType>Mobile</PhoneType><ListingType>Unknown</ListingType><Carrier>T-MOBILE USA INC</Carrier><CarrierType>WIRELESS</CarrierType><City>GRAND JUNCTION</City><State>CO</State><County>MESA</County><TimeZone>MT</TimeZone><Score>86</Score></IDAdvancedPhoneListing><IDAdvancedPhoneListing><Phone>8019444772</Phone><PhoneType>Unknown</PhoneType><ListingType>Unknown</ListingType><Carrier>QWEST CORPORATION (CENTURYLINK)</Carrier><CarrierType>LANDLINE</CarrierType><City>MIDVALE</City><State>UT</State><County>SALT LAKE</County><TimeZone>MT</TimeZone><Score>66</Score></IDAdvancedPhoneListing><IDAdvancedPhoneListing><Phone>9702632135</Phone><PhoneType>Unknown</PhoneType><ListingType>Unknown</ListingType><Carrier>QWEST CORPORATION (CENTURYLINK)</Carrier><CarrierType>LANDLINE</CarrierType><City>GRAND JUNCTION</City><State>CO</State><County>MESA</County><TimeZone>MT</TimeZone><Score>66</Score></IDAdvancedPhoneListing><IDAdvancedPhoneListing><Phone>9702618273</Phone><PhoneType>Mobile</PhoneType><ListingType>Unknown</ListingType><Carrier>NEW CINGULAR WIRELESS PCS LLC (AT&amp;T MOBILITY)</Carrier><CarrierType>WIRELESS</CarrierType><City>GRAND JUNCTION</City><State>CO</State><County>MESA</County><TimeZone>MT</TimeZone><Score>26</Score></IDAdvancedPhoneListing><IDAdvancedPhoneListing><Phone>9702432720</Phone><PhoneType>Unknown</PhoneType><ListingType>Unknown</ListingType><Carrier>QWEST CORPORATION (CENTURYLINK)</Carrier><CarrierType>LANDLINE</CarrierType><City>GRAND JUNCTION</City><State>CO</State><County>MESA</County><TimeZone>MT</TimeZone><Score>3</Score></IDAdvancedPhoneListing><IDAdvancedPhoneListing><Phone>9702700816</Phone><PhoneType>Mobile</PhoneType><ListingType>Unknown</ListingType><Carrier>NEW CINGULAR WIRELESS PCS LLC (AT&amp;T MOBILITY)</Carrier><CarrierType>WIRELESS</CarrierType><City>GRAND JUNCTION</City><State>CO</State><County>MESA</County><TimeZone>MT</TimeZone><Score>3</Score></IDAdvancedPhoneListing></PhoneListings><EmailAddresses><string>tana_35@msn.com</string></EmailAddresses><NumberOfBankruptcies>2</NumberOfBankruptcies><MostRecentBankruptcyDate><Day>23</Day><Month>10</Month><Year>1996</Year></MostRecentBankruptcyDate><NumberOfBankruptcyRecords>2</NumberOfBankruptcyRecords><MostRecentBankruptcyRecordDate><Day>23</Day><Month>10</Month><Year>1996</Year></MostRecentBankruptcyRecordDate><NumberOfLiens>0</NumberOfLiens><NumberOfJudgements>0</NumberOfJudgements><NumberOfUtilityRecordsAvailable>0</NumberOfUtilityRecordsAvailable><Relatives><IDAdvancedPersonRelative><PersonReportKey>77R3-4275</PersonReportKey><Name><FirstName>PATRICIA</FirstName><MiddleName /><LastName>BEMIS</LastName><NameSuffix>V</NameSuffix></Name><DateOfBirth><DateOfBirth><Month>08</Month><Year>1954</Year></DateOfBirth><CurrentAge>63</CurrentAge></DateOfBirth></IDAdvancedPersonRelative><IDAdvancedPersonRelative><PersonReportKey>56VN-T93V</PersonReportKey><Name><FirstName>PATRICIA</FirstName><MiddleName /><LastName>BEMIS</LastName><NameSuffix>V</NameSuffix></Name><DateOfBirth><DateOfBirth><Month>08</Month><Year>1958</Year></DateOfBirth><CurrentAge>59</CurrentAge></DateOfBirth></IDAdvancedPersonRelative><IDAdvancedPersonRelative><PersonReportKey>K989-P74T</PersonReportKey><Name><FirstName>HARPER</FirstName><MiddleName>JADE</MiddleName><LastName>FLEMING</LastName><NameSuffix /></Name><DateOfBirth><DateOfBirth><Month>09</Month><Year>1991</Year></DateOfBirth><CurrentAge>26</CurrentAge></DateOfBirth></IDAdvancedPersonRelative><IDAdvancedPersonRelative><PersonReportKey>D4DF-YG9J</PersonReportKey><Name><FirstName>KATHERINE</FirstName><MiddleName>A</MiddleName><LastName>FLEMING</LastName><NameSuffix /></Name><DateOfBirth><DateOfBirth><Month>07</Month><Year>1996</Year></DateOfBirth><CurrentAge>21</CurrentAge></DateOfBirth></IDAdvancedPersonRelative><IDAdvancedPersonRelative><PersonReportKey>N3DY-BH45</PersonReportKey><Name><FirstName>LARRY</FirstName><MiddleName>JOE</MiddleName><LastName>FLEMING</LastName><NameSuffix /></Name><DateOfBirth><DateOfBirth><Month>06</Month><Year>1966</Year></DateOfBirth><CurrentAge>51</CurrentAge></DateOfBirth></IDAdvancedPersonRelative><IDAdvancedPersonRelative><PersonReportKey>GY7M-G23W</PersonReportKey><Name><FirstName>TIMOTHY</FirstName><MiddleName>H</MiddleName><LastName>FLEMING</LastName><NameSuffix /></Name><DateOfBirth><DateOfBirth><Month>10</Month><Year>1966</Year></DateOfBirth><CurrentAge>51</CurrentAge></DateOfBirth></IDAdvancedPersonRelative><IDAdvancedPersonRelative><PersonReportKey>QHXG-PY4X</PersonReportKey><Name><FirstName>TYLER</FirstName><MiddleName>SHANE</MiddleName><LastName>FLEMING</LastName><NameSuffix /></Name><DateOfBirth><DateOfBirth><Month>11</Month><Year>1992</Year></DateOfBirth><CurrentAge>25</CurrentAge></DateOfBirth></IDAdvancedPersonRelative><IDAdvancedPersonRelative><PersonReportKey>T6H3-XY3C</PersonReportKey><Name><FirstName>RORY</FirstName><MiddleName>B</MiddleName><LastName>HICKS</LastName><NameSuffix /></Name><DateOfBirth><DateOfBirth><Month>11</Month><Year>1987</Year></DateOfBirth><CurrentAge>30</CurrentAge></DateOfBirth></IDAdvancedPersonRelative><IDAdvancedPersonRelative><PersonReportKey>2GFR-PK3V</PersonReportKey><Name><FirstName>TOMMY</FirstName><MiddleName>L</MiddleName><LastName>HICKS</LastName><NameSuffix /></Name><DateOfBirth><DateOfBirth><Month>01</Month><Year>1948</Year></DateOfBirth><CurrentAge>70</CurrentAge></DateOfBirth></IDAdvancedPersonRelative><IDAdvancedPersonRelative><PersonReportKey>TH5K-783L</PersonReportKey><Name><FirstName>WILLIAM</FirstName><MiddleName>BENNETT</MiddleName><LastName>HICKS</LastName><NameSuffix /></Name><DateOfBirth><DateOfBirth><Month>08</Month><Year>1968</Year></DateOfBirth><CurrentAge>49</CurrentAge></DateOfBirth></IDAdvancedPersonRelative><IDAdvancedPersonRelative><PersonReportKey>L55L-3Y3R</PersonReportKey><Name><FirstName>MISTY</FirstName><MiddleName>LYNN</MiddleName><LastName>JONES</LastName><NameSuffix /></Name><DateOfBirth><DateOfBirth><Month>04</Month><Year>1974</Year></DateOfBirth><CurrentAge>43</CurrentAge></DateOfBirth></IDAdvancedPersonRelative><IDAdvancedPersonRelative><PersonReportKey>XL8T-Y94Y</PersonReportKey><Name><FirstName>MAX</FirstName><MiddleName>LEE</MiddleName><LastName>MCFARLAND</LastName><NameSuffix /></Name><DateOfBirth><DateOfBirth><Month>11</Month><Year>1967</Year></DateOfBirth><CurrentAge>50</CurrentAge></DateOfBirth></IDAdvancedPersonRelative><IDAdvancedPersonRelative><PersonReportKey>56RW-CD4M</PersonReportKey><Name><FirstName>PAULA</FirstName><MiddleName>RAE</MiddleName><LastName>MCFARLAND</LastName><NameSuffix /></Name><DateOfBirth><DateOfBirth><Month>11</Month><Year>1970</Year></DateOfBirth><CurrentAge>47</CurrentAge></DateOfBirth></IDAdvancedPersonRelative><IDAdvancedPersonRelative><PersonReportKey>2KQD-8J44</PersonReportKey><Name><FirstName>SHALONA</FirstName><MiddleName>JOLENE</MiddleName><LastName>MCFARLAND</LastName><NameSuffix /></Name><DateOfBirth><DateOfBirth><Month>02</Month><Year>1971</Year></DateOfBirth><CurrentAge>47</CurrentAge></DateOfBirth></IDAdvancedPersonRelative><IDAdvancedPersonRelative><PersonReportKey>VCJM-263H</PersonReportKey><Name><FirstName>STANLEY</FirstName><MiddleName>L</MiddleName><LastName>MCFARLAND</LastName><NameSuffix /></Name><DateOfBirth><DateOfBirth><Month>09</Month><Year>1932</Year></DateOfBirth><CurrentAge>85</CurrentAge></DateOfBirth><DateOfDeath><Name><FirstName>STANLEY</FirstName><MiddleName>LAYTHE</MiddleName><LastName>MCFARLAND</LastName><NameSuffix /><ProfessionalSuffix /></Name><SSNRecord /><DateOfBirth><Day>08</Day><Month>09</Month><Year>1932</Year></DateOfBirth><DateOfDeath><Day>08</Day><Month>03</Month><Year>2016</Year></DateOfDeath><AgeAtDeath>83</AgeAtDeath><DateOfBirthRecord><DateOfBirth><Day>08</Day><Month>09</Month><Year>1932</Year></DateOfBirth><CurrentAge>85</CurrentAge></DateOfBirthRecord><Address><Line1 /><City>GRAND JUNCTION</City><State>CO</State><ZipCode>81501</ZipCode><County>MESA</County><Zip4 /></Address><VerifyProof /><DeathRecordDoesNotBelongToSubject>false</DeathRecordDoesNotBelongToSubject></DateOfDeath></IDAdvancedPersonRelative><IDAdvancedPersonRelative><PersonReportKey>856X-553W</PersonReportKey><Name><FirstName>AMY</FirstName><MiddleName>ANNMARIE</MiddleName><LastName>MOORE</LastName><NameSuffix /></Name><DateOfBirth><DateOfBirth><Month>06</Month><Year>1975</Year></DateOfBirth><CurrentAge>42</CurrentAge></DateOfBirth></IDAdvancedPersonRelative><IDAdvancedPersonRelative><PersonReportKey>HBFD-VL3G</PersonReportKey><Name><FirstName>JERRY</FirstName><MiddleName>LAVERNE</MiddleName><LastName>MOORE</LastName><NameSuffix /></Name><DateOfBirth><DateOfBirth><Month>11</Month><Year>1928</Year></DateOfBirth><CurrentAge>89</CurrentAge></DateOfBirth><DateOfDeath><Name><FirstName>JERRY</FirstName><MiddleName>LAVERN</MiddleName><LastName>MOORE</LastName><NameSuffix /><ProfessionalSuffix /></Name><SSNRecord /><DateOfBirth><Day>18</Day><Month>11</Month><Year>1928</Year></DateOfBirth><DateOfDeath><Day>13</Day><Month>03</Month><Year>2017</Year></DateOfDeath><AgeAtDeath>88</AgeAtDeath><DateOfBirthRecord><DateOfBirth><Day>18</Day><Month>11</Month><Year>1928</Year></DateOfBirth><CurrentAge>89</CurrentAge></DateOfBirthRecord><Address><Line1 /><City>GRAND JUNCTION</City><State>CO</State><ZipCode>81501</ZipCode><County>MESA</County><Zip4 /></Address><VerifyProof /><DeathRecordDoesNotBelongToSubject>false</DeathRecordDoesNotBelongToSubject></DateOfDeath></IDAdvancedPersonRelative><IDAdvancedPersonRelative><PersonReportKey>837W-5V3R</PersonReportKey><Name><FirstName>RAY</FirstName><MiddleName>EUGENE</MiddleName><LastName>MOORE</LastName><NameSuffix /></Name><DateOfBirth><DateOfBirth><Month>11</Month><Year>1972</Year></DateOfBirth><CurrentAge>45</CurrentAge></DateOfBirth></IDAdvancedPersonRelative><IDAdvancedPersonRelative><PersonReportKey>JLBH-9L3M</PersonReportKey><Name><FirstName>ROY</FirstName><MiddleName>EMERSON</MiddleName><LastName>MOORE</LastName><NameSuffix /></Name><DateOfBirth><DateOfBirth><Month>12</Month><Year>1953</Year></DateOfBirth><CurrentAge>64</CurrentAge></DateOfBirth></IDAdvancedPersonRelative><IDAdvancedPersonRelative><PersonReportKey>NKPB-6D44</PersonReportKey><Name><FirstName>STELLA</FirstName><MiddleName>PEARL</MiddleName><LastName>MOORE</LastName><NameSuffix /></Name><DateOfBirth><DateOfBirth><Month>08</Month><Year>1929</Year></DateOfBirth><CurrentAge>88</CurrentAge></DateOfBirth><DateOfDeath><Name><FirstName>STELLA</FirstName><MiddleName>PEARL</MiddleName><LastName>MOORE</LastName><NameSuffix /><ProfessionalSuffix /></Name><SSNRecord><SSNReportKey>alVEHD911OWgG+tJvhyjTwQ==</SSNReportKey><SSN>440285133</SSN><SSNPlaceOfIssue>OKLAHOMA</SSNPlaceOfIssue><SSNIssueYears>1934-1951</SSNIssueYears></SSNRecord><DateOfBirth><Day>22</Day><Month>08</Month><Year>1929</Year></DateOfBirth><DateOfDeath><Day>16</Day><Month>08</Month><Year>2011</Year></DateOfDeath><AgeAtDeath>81</AgeAtDeath><DateOfBirthRecord><DateOfBirth><Day>22</Day><Month>08</Month><Year>1929</Year></DateOfBirth><CurrentAge>88</CurrentAge></DateOfBirthRecord><Address><Line1 /><City>OVERTON</City><State>NV</State><ZipCode>89040</ZipCode><County>CLARK</County><Zip4 /></Address><VerifyProof>P</VerifyProof><DeathRecordDoesNotBelongToSubject>false</DeathRecordDoesNotBelongToSubject></DateOfDeath></IDAdvancedPersonRelative><IDAdvancedPersonRelative><PersonReportKey>N7C1-4G3X</PersonReportKey><Name><FirstName>SUSAN</FirstName><MiddleName>A</MiddleName><LastName>MOORE</LastName><NameSuffix /></Name><DateOfBirth><DateOfBirth><Month>09</Month><Year>1956</Year></DateOfBirth><CurrentAge>61</CurrentAge></DateOfBirth></IDAdvancedPersonRelative></Relatives></IDAdvancedPersonSearchResultRecord></SearchResultRecords></PersonSearchResult></PersonSearchResponse></soap:Body></soap:Envelope>';
	private static String personBasicResponseError = '{"ItemReferenceId":10061088347,"CreatedDate":"2018-03-30T12:02:29.5781762-05:00","ErrorMessage":null,"VerificationResponse":6,"AccountResponseCode":null,"BankName":null,"AccountAddedDate":null,"AccountLastUpdatedDate":null,"AccountClosedDate":null,"BankAccountType":null,"VoidedCheckImage":null,"FundsConfirmationResult":null,"CustomerResponseCode":09,"MatchedPersonData":[{"FirstName":"TONYA","MiddleName":null,"LastName":"MCFARLAND","DateOfBirth":"1971-09-09T00:00:00","IdNumber":null,"SsnIssueState":"CO","SsnIssueStartYear":"1973","SsnIssueEndYear":"1974","SsnStatus":"clear","AddressRecords":[{"AddressLine1":"602 RICO","AddressLine2":null,"City":"GRAND JUNCTION","State":"CO","ZipCode":"81506","Status":0,"DateReported":"2013-07-13T00:00:00","ParsedAddressLine1":{"StreetNumber":"602","PreDirectional":null,"StreetName":"RICO","StreetSuffix":null,"PostDirectional":null,"UnitType":null,"UnitIdentifier":null}},{"AddressLine1":"264 PINON","AddressLine2":null,"City":"GRAND JUNCTION","State":"CO","ZipCode":"81503","Status":1,"DateReported":"2009-09-21T00:00:00","ParsedAddressLine1":{"StreetNumber":"264","PreDirectional":null,"StreetName":"PINON","StreetSuffix":null,"PostDirectional":null,"UnitType":null,"UnitIdentifier":null}},{"AddressLine1":"296 W PARKVIEW","AddressLine2":null,"City":"GRAND JUNCTION","State":"CO","ZipCode":"81503","Status":2,"DateReported":null,"ParsedAddressLine1":{"StreetNumber":"296","PreDirectional":"W","StreetName":"PARKVIEW","StreetSuffix":null,"PostDirectional":null,"UnitType":null,"UnitIdentifier":null}}],"PhoneNumbers":[{"Classification":0,"NumberType":1,"AreaCode":"970","Exchange":"234","Suffix":"7163","PhoneNumber":"9702347163"}]},{"FirstName":"TONYA","MiddleName":"M","LastName":"MOORE","DateOfBirth":"1971-09-09T00:00:00","IdNumber":null,"SsnIssueState":null,"SsnIssueStartYear":null,"SsnIssueEndYear":null,"SsnStatus":null,"AddressRecords":[{"AddressLine1":"264 PINON","AddressLine2":null,"City":"GRAND JUNCTION","State":"CO","ZipCode":"81503","Status":0,"DateReported":"2013-07-01T00:00:00","ParsedAddressLine1":{"StreetNumber":"264","PreDirectional":null,"StreetName":"PINON","StreetSuffix":null,"PostDirectional":null,"UnitType":null,"UnitIdentifier":null}},{"AddressLine1":"602 RICO","AddressLine2":null,"City":"GRAND JUNCTION","State":"CO","ZipCode":"81506","Status":1,"DateReported":"2013-07-01T00:00:00","ParsedAddressLine1":{"StreetNumber":"602","PreDirectional":null,"StreetName":"RICO","StreetSuffix":null,"PostDirectional":null,"UnitType":null,"UnitIdentifier":null}},{"AddressLine1":"1800 MAIN","AddressLine2":null,"City":"GRAND JUNCTION","State":"CO","ZipCode":"81501","Status":2,"DateReported":"2009-10-01T00:00:00","ParsedAddressLine1":{"StreetNumber":"1800","PreDirectional":null,"StreetName":"MAIN","StreetSuffix":null,"PostDirectional":null,"UnitType":null,"UnitIdentifier":null}}],"PhoneNumbers":[{"Classification":0,"NumberType":2,"AreaCode":"970","Exchange":"241","Suffix":"1799","PhoneNumber":"9702411799"}]}],"ConsumerAlertMessages":[],"MatchedBusinessData":null,"OfacListPotentialMatches":[],"GIdentifyKbaResult":null,"EmailAddressInformationResult":null,"IpAddressInformationResult":null,"DomainRegistry":null,"MobileVerifyResult":null,"MobileIdentifyResult":null,"MobileLocationResult":null,"PhoneIntelligenceResult":null}';
	//private static String bizAdvResponse = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><BusinessComboSearchResponse xmlns="http://www.giact.com/api/identificationservices/v1.0"><BusinessComboSearchResult><SearchModified>false</SearchModified><NumberOfRecordsFound>4</NumberOfRecordsFound><NumberOfRecordsFoundWithModifiedSearch>0</NumberOfRecordsFoundWithModifiedSearch><AbbreviatedResult>false</AbbreviatedResult><SearchResultRecords><IDAdvancedBusinessComboSearchResultRecord><FullBusinessSearchResultRecord><BusinessReportKey>B-8V6N-XXXX</BusinessReportKey><FEINumber>760671234</FEINumber><BusinessNames><IDAdvancedBusinessName><Name>TEST LOGIC INC</Name><Type>Primary</Type></IDAdvancedBusinessName><IDAdvancedBusinessName><Name>TEST LOGIC SYSTEMS, INC</Name><Type>Primary</Type></IDAdvancedBusinessName><IDAdvancedBusinessName><Name>TEST LOGIC, INC</Name><Type>Primary</Type></IDAdvancedBusinessName><IDAdvancedBusinessName><Name>TEST LOGIC, INC.</Name><Type>Primary</Type></IDAdvancedBusinessName></BusinessNames><DomesticWorldFlag>D</DomesticWorldFlag><ParentBusinessReportKey /><ParentDomesticWorldFlag /><GlobalBusinessReportKey /><GlobalDomesticWorldFlag /><HQBusinessReportKey /><HQBusinessDomesticWorldFlag /><Industry>Computer Software Systems Analysis And Design, Custom</Industry><Industries><string>Computer Software Systems Analysis And Design, Custom</string></Industries><Domains><string>TEST-LOGIC.COM</string></Domains><Addresses><IDAdvancedAddressRecord><ConfirmedAddress>false</ConfirmedAddress><Address><Line1>7457 TEST DR STE 208</Line1><City>HOUSTON</City><State>TX</State><ZipCode>77036</ZipCode><Zip4>2021</Zip4></Address><DateFirstSeen><Year>2000</Year></DateFirstSeen><DateLastSeen><Day>04</Day><Month>07</Month><Year>2018</Year></DateLastSeen><PhoneListings><IDAdvancedPhoneListing><Phone>8324891851</Phone><PhoneType>Unknown</PhoneType><ListingType>Unknown</ListingType><Carrier>SPRINT SPECTRUM LP</Carrier><CarrierType>WIRELESS</CarrierType><City>HOUSTON</City><State>TX</State><County>HARRIS</County><TimeZone>CT</TimeZone></IDAdvancedPhoneListing></PhoneListings></IDAdvancedAddressRecord><IDAdvancedAddressRecord><ConfirmedAddress>false</ConfirmedAddress><Address><Line1>7457 TEST DR STE 298</Line1><City>HOUSTON</City><State>TX</State><ZipCode>77036</ZipCode><Zip4>2037</Zip4></Address><DateFirstSeen><Year>2000</Year></DateFirstSeen><DateLastSeen><Day>04</Day><Month>07</Month><Year>2018</Year></DateLastSeen><PhoneListings><IDAdvancedPhoneListing><Phone>8324891851</Phone><PhoneType>Unknown</PhoneType><ListingType>Unknown</ListingType><Carrier>SPRINT SPECTRUM LP</Carrier><CarrierType>WIRELESS</CarrierType><City>HOUSTON</City><State>TX</State><County>HARRIS</County><TimeZone>CT</TimeZone></IDAdvancedPhoneListing></PhoneListings></IDAdvancedAddressRecord></Addresses><PrincipalContacts><IDAdvancedBusinessContact><PersonReportKey /><Name><FirstName>John</FirstName><MiddleName /><LastName>THOMAS</LastName><NameSuffix /></Name><Title>DIRECTOR; PRESIDENT</Title><ContactType>Principal</ContactType><Address><Line1 /><City /><State /><ZipCode /><Zip4 /></Address></IDAdvancedBusinessContact><IDAdvancedBusinessContact><PersonReportKey>399C-L741</PersonReportKey><Name><FirstName>JOHN</FirstName><MiddleName /><LastName>THOMAS</LastName><NameSuffix /></Name><Title>PRESIDENT; REGISTERED AGENT</Title><ContactType>Principal</ContactType><Address><Line1>7457 TEST DR STE 208</Line1><City>HOUSTON</City><State>TX</State><ZipCode>77036</ZipCode><Zip4>2021</Zip4></Address></IDAdvancedBusinessContact><IDAdvancedBusinessContact><PersonReportKey>YBPG-3J46</PersonReportKey><Name><FirstName>JOHN</FirstName><MiddleName /><LastName>THOMAS</LastName><NameSuffix /></Name><Title>PRESIDENT; REGISTERED AGENT</Title><ContactType>Principal</ContactType><Address><Line1>7457 TEST DR STE 208</Line1><City>HOUSTON</City><State>TX</State><ZipCode>77036</ZipCode><Zip4>2021</Zip4></Address></IDAdvancedBusinessContact></PrincipalContacts><OtherContacts><IDAdvancedBusinessContact><PersonReportKey /><Name><FirstName>Abraham</FirstName><MiddleName /><LastName>KAMATH</LastName><NameSuffix /></Name><Title>REGISTERED AGENT</Title><ContactType>Registered Agent</ContactType><Address><Line1>18537 E TEST HWY</Line1><City>COVINA</City><State>CA</State><ZipCode>91722</ZipCode><Zip4>1866</Zip4></Address></IDAdvancedBusinessContact><IDAdvancedBusinessContact><PersonReportKey>YD6X-T74J</PersonReportKey><Name><FirstName>STEVEN</FirstName><MiddleName /><LastName>SMITH</LastName><NameSuffix /></Name><Title>INFORMATION TECHNOLOGY RECRUITER</Title><ContactType>Other</ContactType><Address><Line1>7457 TEST DR STE 208</Line1><City>HOUSTON</City><State>TX</State><ZipCode>77036</ZipCode><Zip4>2021</Zip4></Address></IDAdvancedBusinessContact></OtherContacts><DeedCount>0</DeedCount><ForeclosureCount>0</ForeclosureCount><VehicleCount>0</VehicleCount><AircraftCount>0</AircraftCount><JudgementDebtorCount>2</JudgementDebtorCount><JudgementCreditorCount>0</JudgementCreditorCount><LienHolderCount>0</LienHolderCount><LienDebtorCount>10</LienDebtorCount><BankruptcySubjectCount>0</BankruptcySubjectCount><BankruptcyCreditorCount>0</BankruptcyCreditorCount><PossibleEmployeeCount>9</PossibleEmployeeCount></FullBusinessSearchResultRecord></IDAdvancedBusinessComboSearchResultRecord><IDAdvancedBusinessComboSearchResultRecord><CorporateFiling><BusinessReportKey>B-8V6N-T93M</BusinessReportKey><BusinessName>TEST LOGIC INC</BusinessName><BusinessNameType>Primary</BusinessNameType><SecStatus>Forfeited</SecStatus><State>TX</State><DateFirstSeen><Day>11</Day><Month>03</Month><Year>2017</Year></DateFirstSeen><DateLastSeen><Day>05</Day><Month>07</Month><Year>2019</Year></DateLastSeen><BusinessNames><IDAdvancedBusinessName><Name>TEST LOGIC INC</Name><Type>Primary</Type></IDAdvancedBusinessName></BusinessNames><FilingNumber>C3991234</FilingNumber><BusinessDunsNumber>099971234</BusinessDunsNumber><SIC>00000000</SIC><FranchiseTaxBoardStatus>Good Standing</FranchiseTaxBoardStatus><FranchiseTaxBoardStatusDate /><FranchiseTaxPaidDate /><FilingOfficeName>BUSINESS PROGRAMS DIVISION</FilingOfficeName><FilingOfficeBusinessReportKey>B-1V29-1234</FilingOfficeBusinessReportKey><FilingOfficeDunsNumber>361531234</FilingOfficeDunsNumber><FilingOfficeAddress><Line1>1500 TEST 11TH ST FL 3</Line1><City>SACRAMENTO</City><State>CA</State><ZipCode>95814</ZipCode><County>SACRAMENTO</County><Zip4>5701</Zip4></FilingOfficeAddress><FileDate><Day>06</Day><Month>07</Month><Year>2019</Year></FileDate><CorporationType>Profit</CorporationType><RegistrationType>Corporation</RegistrationType><ReceivedDate><Day>01</Day><Month>07</Month><Year>2019</Year></ReceivedDate><FilingDate><Day>14</Day><Month>02</Month><Year>2017</Year></FilingDate><VerificationDate><Day>29</Day><Month>06</Month><Year>2019</Year></VerificationDate><ExpirationDate /><PaidInCapitalDate /><IncorporationDate /><RAAppointDate /><FiscalYearEndDate /><IncorporationState>TX</IncorporationState><SecStateStatus>Undefined</SecStateStatus><SecStateStatusDate /><SecStateReportFileDate /><SecStateAnnualReportDueDate /><SecStateAnnualReportMailDate /><SecStateAnnualReportDelinqDate /><SecStateLastAnnualReportDate /><Address><Line1>7457 TEST DR STE 208</Line1><City>HOUSTON</City><State>TX</State><ZipCode>77036</ZipCode><County>HARRIS</County><Zip4>2021</Zip4></Address><AddressType>Mailing</AddressType><Amendments><IDAdvancedCorporateAmendment><FilingDate><Day>25</Day><Month>06</Month><Year>2019</Year></FilingDate><Reason>Forfeiture Of Incorporation</Reason><AmendmentDescription>FORFEITED BY THE SECRETARY OF STATE</AmendmentDescription></IDAdvancedCorporateAmendment></Amendments><CorporateStockIssues /><BusinessContacts><IDAdvancedBusinessContact><PersonReportKey /><Name><FirstName>JOHN</FirstName><MiddleName /><LastName>KAMATH</LastName><NameSuffix /><ProfessionalSuffix /></Name><Title>Registered Agent</Title><Address><Line1>18537 E TEST HWY</Line1><City>COVINA</City><State>CA</State><ZipCode>91722</ZipCode><County>LOS ANGELES</County><Zip4>1866</Zip4></Address></IDAdvancedBusinessContact></BusinessContacts></CorporateFiling></IDAdvancedBusinessComboSearchResultRecord><IDAdvancedBusinessComboSearchResultRecord><CorporateFiling><BusinessReportKey>B-8V6N-1234</BusinessReportKey><BusinessName>TEST LOGIC, INC.</BusinessName><BusinessNameType>Primary</BusinessNameType><SecStatus>New Corporation</SecStatus><State>TX</State><DateFirstSeen><Day>20</Day><Month>03</Month><Year>2013</Year></DateFirstSeen><DateLastSeen><Day>04</Day><Month>07</Month><Year>2018</Year></DateLastSeen><BusinessNames><IDAdvancedBusinessName><Name>TEST LOGIC, INC.</Name><Type>Primary</Type></IDAdvancedBusinessName></BusinessNames><FilingNumber>4697123</FilingNumber><BusinessDunsNumber>099971234</BusinessDunsNumber><SIC>00000000</SIC><FranchiseTaxBoardStatus>0</FranchiseTaxBoardStatus><FranchiseTaxBoardStatusDate /><FranchiseTaxPaidDate /><FilingOfficeName>NEW MEXICO PUBLIC REGULATION COMMISSION</FilingOfficeName><FilingOfficeBusinessReportKey>B-C67Q-1234</FilingOfficeBusinessReportKey><FilingOfficeDunsNumber>361859123</FilingOfficeDunsNumber><FilingOfficeAddress><Line1>311 STATE CAPITOL # 1</Line1><City>SANTA FE</City><State>NM</State><ZipCode>87501</ZipCode><County>SANTA FE</County><Zip4>2749</Zip4></FilingOfficeAddress><FileDate><Day>05</Day><Month>07</Month><Year>2018</Year></FileDate><CorporationType>Profit</CorporationType><RegistrationType>Foreign Corporation</RegistrationType><ReceivedDate><Day>13</Day><Month>06</Month><Year>2018</Year></ReceivedDate><FilingDate><Day>25</Day><Month>01</Month><Year>2013</Year></FilingDate><VerificationDate><Day>01</Day><Month>06</Month><Year>2018</Year></VerificationDate><ExpirationDate /><PaidInCapitalDate /><IncorporationDate><Day>25</Day><Month>01</Month><Year>2013</Year></IncorporationDate><RAAppointDate /><FiscalYearEndDate><Day>31</Day><Month>12</Month><Year>2013</Year></FiscalYearEndDate><IncorporationState>TX</IncorporationState><SecStateStatus>Undefined</SecStateStatus><SecStateStatusDate /><SecStateReportFileDate /><SecStateAnnualReportDueDate><Day>28</Day><Month>02</Month><Year>2013</Year></SecStateAnnualReportDueDate><SecStateAnnualReportMailDate /><SecStateAnnualReportDelinqDate /><SecStateLastAnnualReportDate /><Address><Line1>7457 HARWIN DR STE 208</Line1><City>HOUSTON</City><State>TX</State><ZipCode>77036</ZipCode><County>HARRIS</County><Zip4>2021</Zip4></Address><AddressType>Business</AddressType><Amendments><IDAdvancedCorporateAmendment><FilingDate><Day>25</Day><Month>01</Month><Year>2013</Year></FilingDate><Reason>Miscellaneous</Reason><AmendmentDescription>CERTIFICATE OF AUTHORITY;TEST LOGIC, INC.. PROSPECTING NEW BUSINESS</AmendmentDescription></IDAdvancedCorporateAmendment></Amendments><CorporateStockIssues /><BusinessContacts><IDAdvancedBusinessContact><PersonReportKey /><Title>Registered Agent</Title><BusinessName>CORPORATION SERVICE COMPANY</BusinessName><Address><Line1>125 LINCOLN AVE STE 223</Line1><City>SANTA FE</City><State>NM</State><ZipCode>87501</ZipCode><County>SANTA FE</County><Zip4>2053</Zip4></Address></IDAdvancedBusinessContact><IDAdvancedBusinessContact><PersonReportKey /><Name><FirstName>JOHN</FirstName><MiddleName /><LastName>THOMAS</LastName><NameSuffix /><ProfessionalSuffix /></Name><Title>Director</Title></IDAdvancedBusinessContact><IDAdvancedBusinessContact><PersonReportKey /><Name><FirstName>JOHN</FirstName><MiddleName /><LastName>THOMAS</LastName><NameSuffix /><ProfessionalSuffix /></Name><Title>President</Title></IDAdvancedBusinessContact></BusinessContacts><PerpetualIndicator>Y</PerpetualIndicator><MiscDetails>BUSINESS PURPOSE: PROSPECTING NEW BUSINESS</MiscDetails></CorporateFiling></IDAdvancedBusinessComboSearchResultRecord><IDAdvancedBusinessComboSearchResultRecord><CorporateFiling><BusinessReportKey>B-8V6N-T93M</BusinessReportKey><BusinessName>TEST LOGIC SYSTEMS, INC</BusinessName><BusinessNameType>Former</BusinessNameType><SecStatus>In Existence</SecStatus><State>TX</State><DateFirstSeen><Day>19</Day><Month>12</Month><Year>2000</Year></DateFirstSeen><DateLastSeen><Day>19</Day><Month>12</Month><Year>2017</Year></DateLastSeen><BusinessNames><IDAdvancedBusinessName><Name>TEST LOGIC, INC</Name><Type>Primary</Type></IDAdvancedBusinessName><IDAdvancedBusinessName><Name>TEST LOGIC SYSTEMS, INC</Name><Type>Former</Type></IDAdvancedBusinessName><IDAdvancedBusinessName><Name>TEST LOGIC, INC.</Name><Type>Trade Style</Type></IDAdvancedBusinessName></BusinessNames><FilingNumber>0160850100</FilingNumber><BusinessDunsNumber>099971652</BusinessDunsNumber><SIC>00000000</SIC><FranchiseTaxBoardStatus>0</FranchiseTaxBoardStatus><FranchiseTaxBoardStatusDate /><FranchiseTaxPaidDate /><FilingOfficeName>SECRETARY OF STATE</FilingOfficeName><FilingOfficeBusinessReportKey>B-YGMV-3R3K</FilingOfficeBusinessReportKey><FilingOfficeDunsNumber>361958267</FilingOfficeDunsNumber><FilingOfficeAddress><Line1>1019 BRAZOS ST</Line1><City>AUSTIN</City><State>TX</State><ZipCode>78701</ZipCode><County>TRAVIS</County><Zip4>2413</Zip4></FilingOfficeAddress><FileDate><Day>20</Day><Month>12</Month><Year>2017</Year></FileDate><CorporationType>Profit</CorporationType><RegistrationType>Domestic Corporation</RegistrationType><ReceivedDate><Day>19</Day><Month>12</Month><Year>2017</Year></ReceivedDate><FilingDate><Day>14</Day><Month>12</Month><Year>2000</Year></FilingDate><VerificationDate><Day>18</Day><Month>12</Month><Year>2017</Year></VerificationDate><ExpirationDate /><PaidInCapitalDate /><IncorporationDate><Day>14</Day><Month>12</Month><Year>2000</Year></IncorporationDate><RAAppointDate /><FiscalYearEndDate /><IncorporationState>TX</IncorporationState><SecStateStatus>Undefined</SecStateStatus><SecStateStatusDate /><SecStateReportFileDate /><SecStateAnnualReportDueDate /><SecStateAnnualReportMailDate /><SecStateAnnualReportDelinqDate /><SecStateLastAnnualReportDate /><Address><Line1>7457 HARWIN DR STE 208</Line1><City>HOUSTON</City><State>TX</State><ZipCode>77036</ZipCode><County>HARRIS</County><Zip4>2021</Zip4></Address><AddressType>Mailing</AddressType><Amendments><IDAdvancedCorporateAmendment><FilingDate><Day>17</Day><Month>12</Month><Year>2017</Year></FilingDate><Reason>Miscellaneous</Reason><AmendmentDescription>PUBLIC INFORMATION REPORT (PIR)</AmendmentDescription></IDAdvancedCorporateAmendment><IDAdvancedCorporateAmendment><FilingDate><Day>03</Day><Month>04</Month><Year>2017</Year></FilingDate><Reason>Miscellaneous</Reason><AmendmentDescription>PUBLIC INFORMATION REPORT (PIR)</AmendmentDescription></IDAdvancedCorporateAmendment><IDAdvancedCorporateAmendment><FilingDate><Day>05</Day><Month>01</Month><Year>2016</Year></FilingDate><Reason>Miscellaneous</Reason><AmendmentDescription>PUBLIC INFORMATION REPORT (PIR)</AmendmentDescription></IDAdvancedCorporateAmendment><IDAdvancedCorporateAmendment><FilingDate><Day>19</Day><Month>11</Month><Year>2014</Year></FilingDate><Reason>Miscellaneous</Reason><AmendmentDescription>PUBLIC INFORMATION REPORT (PIR)</AmendmentDescription></IDAdvancedCorporateAmendment><IDAdvancedCorporateAmendment><FilingDate><Day>05</Day><Month>09</Month><Year>2013</Year></FilingDate><Reason>Miscellaneous</Reason><AmendmentDescription>PRIOR LEGAL NAME: TEST LOGIC SYSTEMS, INC</AmendmentDescription></IDAdvancedCorporateAmendment><IDAdvancedCorporateAmendment><FilingDate><Day>14</Day><Month>07</Month><Year>2012</Year></FilingDate><Reason>Miscellaneous</Reason><AmendmentDescription>PUBLIC INFORMATION REPORT (PIR)</AmendmentDescription></IDAdvancedCorporateAmendment><IDAdvancedCorporateAmendment><FilingDate><Day>24</Day><Month>11</Month><Year>2010</Year></FilingDate><Reason>Miscellaneous</Reason><AmendmentDescription>PUBLIC INFORMATION REPORT (PIR)</AmendmentDescription></IDAdvancedCorporateAmendment><IDAdvancedCorporateAmendment><FilingDate><Day>26</Day><Month>07</Month><Year>2010</Year></FilingDate><Reason>Miscellaneous</Reason><AmendmentDescription>PUBLIC INFORMATION REPORT (PIR)</AmendmentDescription></IDAdvancedCorporateAmendment><IDAdvancedCorporateAmendment><FilingDate><Day>16</Day><Month>11</Month><Year>2009</Year></FilingDate><Reason>Miscellaneous</Reason><AmendmentDescription>ACTIVE ASSUMED NAME: TEST LOGIC, INC.</AmendmentDescription></IDAdvancedCorporateAmendment><IDAdvancedCorporateAmendment><FilingDate><Day>18</Day><Month>09</Month><Year>2009</Year></FilingDate><Reason>Miscellaneous</Reason><AmendmentDescription>PUBLIC INFORMATION REPORT (PIR)</AmendmentDescription></IDAdvancedCorporateAmendment><IDAdvancedCorporateAmendment><FilingDate><Day>28</Day><Month>08</Month><Year>2009</Year></FilingDate><Reason>Miscellaneous</Reason><AmendmentDescription>REINSTATEMENT</AmendmentDescription></IDAdvancedCorporateAmendment><IDAdvancedCorporateAmendment><FilingDate><Day>10</Day><Month>02</Month><Year>2006</Year></FilingDate><Reason>Miscellaneous</Reason><AmendmentDescription>TAX FORFEITURE</AmendmentDescription></IDAdvancedCorporateAmendment><IDAdvancedCorporateAmendment><FilingDate><Day>28</Day><Month>12</Month><Year>2004</Year></FilingDate><Reason>Miscellaneous</Reason><AmendmentDescription>PUBLIC INFORMATION REPORT (PIR)</AmendmentDescription></IDAdvancedCorporateAmendment><IDAdvancedCorporateAmendment><FilingDate><Day>28</Day><Month>04</Month><Year>2004</Year></FilingDate><Reason>Miscellaneous</Reason><AmendmentDescription>PUBLIC INFORMATION REPORT (PIR)</AmendmentDescription></IDAdvancedCorporateAmendment><IDAdvancedCorporateAmendment><FilingDate><Day>14</Day><Month>12</Month><Year>2000</Year></FilingDate><Reason>Miscellaneous</Reason><AmendmentDescription>ARTICLES OF INCORPORATION</AmendmentDescription></IDAdvancedCorporateAmendment></Amendments><CorporateStockIssues /><BusinessContacts><IDAdvancedBusinessContact><PersonReportKey>YBPG-3J46</PersonReportKey><Name><FirstName>JOHN</FirstName><MiddleName>G</MiddleName><LastName>THOMAS</LastName><NameSuffix /><ProfessionalSuffix /></Name><Title>Registered Agent</Title><Address><Line1>7457 HARWIN DR STE 208</Line1><City>HOUSTON</City><State>TX</State><ZipCode>77036</ZipCode><County>HARRIS</County><Zip4>2021</Zip4></Address></IDAdvancedBusinessContact></BusinessContacts><PerpetualIndicator>Y</PerpetualIndicator><MiscDetails>STATE TAXPAYER IDENTIFICATION NUMBER:  17606740888</MiscDetails></CorporateFiling></IDAdvancedBusinessComboSearchResultRecord></SearchResultRecords></BusinessComboSearchResult></BusinessComboSearchResponse></soap:Body></soap:Envelope>';
	private static String bizAdvResponseError = '<?xml version="1.0" encoding="utf-8"?><soap:Errors xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><Error><Source>Test Source</Source><ReasonCode>500</ReasonCode><Description>Test Description</Description><Recoverable>True</Recoverable></Error></soap:Errors>';

	@testSetup
    public static void setup() {
        TestDataFactory.createCustomSettings();
    }
	
	Static void createIntegSvcCustSetting () {
		Giact_Integration__c giactInteg = new Giact_Integration__c (Name='gVerifyInquiry', Active__c=true, giact_password__c='tesmppassword', giact_username__c='DL7H-B3AZ-23CU5J-F8WEasdfasdf', giact_url_domain__c='https://api.giact.com/verificationservices/web_api/inquiries_v5_8');
		Giact_Integration__c tinCheckInteg = new Giact_Integration__c (Name='Tin Check', Active__c=true, giact_password__c='tesmppassword', giact_username__c='DL7H-B3AZ-23CU5J-F8WEasdfasdf', giact_url_domain__c='https://api.giact.com/verificationservices/web_api/inquiries_v5_8');
		insert tinCheckInteg;
		insert giactinteg;
	}

// 	Static void createGIDAPMCustomSetting () {
// 		List<GID_APM_Business__c> gid_apm_biz = new List<GID_APM_Business__c> ();
// 		gid_apm_biz.add(new GID_APM_Business__c(Name = 'AddressLine1-Business',GIACTName__c = 'AddressLine1',Disabled__c=false,Field_Path__c='Account__r.ShippingStreet', HardcodedValue__c=null, Required__c=true));
// 		gid_apm_biz.add(new GID_APM_Business__c(Name = 'BusinessName-APM',GIACTName__c = 'BusinessName',Disabled__c=false,Field_Path__c='Account__r.Account_Legal_Name__c', HardcodedValue__c=null, Required__c=true));
// 		gid_apm_biz.add(new GID_APM_Business__c(Name = 'City-Business',GIACTName__c = 'City',Disabled__c=false,Field_Path__c='Account__r.ShippingCity', HardcodedValue__c=null, Required__c=true));
// 		gid_apm_biz.add(new GID_APM_Business__c(Name = 'Country',GIACTName__c = 'Country',Disabled__c=false,Field_Path__c='Account__r.ShippingCountry', HardcodedValue__c='US', Required__c=true));
// 		gid_apm_biz.add(new GID_APM_Business__c(Name = 'State-Business',GIACTName__c = 'State',Disabled__c=false,Field_Path__c='Account__r.ShippingState', HardcodedValue__c=null, Required__c=true));
// 		gid_apm_biz.add(new GID_APM_Business__c(Name = 'TaxId-Business',GIACTName__c = 'TaxId',Disabled__c=false,Field_Path__c='Account__r.Tax_ID__c', HardcodedValue__c=null, Required__c=true));
// 		gid_apm_biz.add(new GID_APM_Business__c(Name = 'ZipCode-Business',GIACTName__c = 'ZipCode',Disabled__c=false,Field_Path__c='Account__r.ShippingPostalCode', HardcodedValue__c=null, Required__c=true));
// 		insert gid_apm_biz;

// 		List<GID_APM_Principal_1__c> gid_apm_prin1 = new List<GID_APM_Principal_1__c> ();
// 		gid_apm_prin1.add(new GID_APM_Principal_1__c(Name = 'AddressLine1-1',GIACTName__c = 'AddressLine1',Disabled__c=false,Field_Path__c='Account__r.Principal_1_Street__c', HardcodedValue__c=null, Required__c=true));
// 		gid_apm_prin1.add(new GID_APM_Principal_1__c(Name = 'FirstName-1',GIACTName__c = 'FirstName',Disabled__c=false,Field_Path__c='Account__r.Principal_1_First_Name__c', HardcodedValue__c=null, Required__c=true));
// 		gid_apm_prin1.add(new GID_APM_Principal_1__c(Name = 'LastName-1',GIACTName__c = 'LastName',Disabled__c=false,Field_Path__c='Account__r.Principal_1_Last_Name__c', HardcodedValue__c=null, Required__c=true));
// 		gid_apm_prin1.add(new GID_APM_Principal_1__c(Name = 'City-1',GIACTName__c = 'City',Disabled__c=false,Field_Path__c='Account__r.Principal_1_City__c', HardcodedValue__c=null, Required__c=true));
// 		gid_apm_prin1.add(new GID_APM_Principal_1__c(Name = 'Country',GIACTName__c = 'Country',Disabled__c=false,Field_Path__c='Account__r.ShippingCountry', HardcodedValue__c='US', Required__c=true));
// 		gid_apm_prin1.add(new GID_APM_Principal_1__c(Name = 'DateOfBirth',GIACTName__c = 'DateOfBirth',Disabled__c=false,Field_Path__c='Account__r.Principal_1_DOB__c', HardcodedValue__c='US', Required__c=true));		
// 		gid_apm_prin1.add(new GID_APM_Principal_1__c(Name = 'State-1',GIACTName__c = 'State',Disabled__c=false,Field_Path__c='Account__r.Principal_1_State__c', HardcodedValue__c=null, Required__c=true));
// 		gid_apm_prin1.add(new GID_APM_Principal_1__c(Name = 'TaxId-1',GIACTName__c = 'TaxId',Disabled__c=false,Field_Path__c='Account__r.Principal_1_SSN__c', HardcodedValue__c=null, Required__c=true));
// 		gid_apm_prin1.add(new GID_APM_Principal_1__c(Name = 'ZipCode-1',GIACTName__c = 'ZipCode',Disabled__c=false,Field_Path__c='Account__r.Principal_1_Zip__c', HardcodedValue__c=null, Required__c=true));
// 		insert gid_apm_prin1;

// 		List<GID_APM_Principal_2__c> gid_apm_prin2 = new List<GID_APM_Principal_2__c> ();
// 		gid_apm_prin2.add(new GID_APM_Principal_2__c(Name = 'AddressLine1-2',GIACTName__c = 'AddressLine1',Disabled__c=false,Field_Path__c='Account__r.Principal_2_Street__c', HardcodedValue__c=null, Required__c=true));
// 		gid_apm_prin2.add(new GID_APM_Principal_2__c(Name = 'FirstName-2',GIACTName__c = 'FirstName',Disabled__c=false,Field_Path__c='Account__r.Principal_2_First_Name__c', HardcodedValue__c=null, Required__c=true));
// 		gid_apm_prin2.add(new GID_APM_Principal_2__c(Name = 'LastName-2',GIACTName__c = 'LastName',Disabled__c=false,Field_Path__c='Account__r.Principal_2_Last_Name__c', HardcodedValue__c=null, Required__c=true));
// 		gid_apm_prin2.add(new GID_APM_Principal_2__c(Name = 'City-2',GIACTName__c = 'City',Disabled__c=false,Field_Path__c='Account__r.Principal_2_City__c', HardcodedValue__c=null, Required__c=true));
// 		gid_apm_prin2.add(new GID_APM_Principal_2__c(Name = 'Country',GIACTName__c = 'Country',Disabled__c=false,Field_Path__c='Account__r.ShippingCountry', HardcodedValue__c='US', Required__c=true));
// 		gid_apm_prin2.add(new GID_APM_Principal_2__c(Name = 'DateOfBirth',GIACTName__c = 'DateOfBirth',Disabled__c=false,Field_Path__c='Account__r.Principal_2_DOB__c', HardcodedValue__c='US', Required__c=true));		
// 		gid_apm_prin2.add(new GID_APM_Principal_2__c(Name = 'State-2',GIACTName__c = 'State',Disabled__c=false,Field_Path__c='Account__r.Principal_2_State__c', HardcodedValue__c=null, Required__c=true));
// 		gid_apm_prin2.add(new GID_APM_Principal_2__c(Name = 'TaxId-2',GIACTName__c = 'TaxId',Disabled__c=false,Field_Path__c='Account__r.Principal_2_SSN__c', HardcodedValue__c=null, Required__c=true));
// 		gid_apm_prin2.add(new GID_APM_Principal_2__c(Name = 'ZipCode-2',GIACTName__c = 'ZipCode',Disabled__c=false,Field_Path__c='Account__r.Principal_2_Zip__c', HardcodedValue__c=null, Required__c=true));
// 		insert gid_apm_prin2;

// 		List<GID_APM_Principal_3__c> gid_apm_prin3 = new List<GID_APM_Principal_3__c> ();
// 		gid_apm_prin3.add(new GID_APM_Principal_3__c(Name = 'AddressLine1-3',GIACTName__c = 'AddressLine1',Disabled__c=false,Field_Path__c='Account__r.Principal_3_Street__c', HardcodedValue__c=null, Required__c=true));
// 		gid_apm_prin3.add(new GID_APM_Principal_3__c(Name = 'FirstName-3',GIACTName__c = 'FirstName',Disabled__c=false,Field_Path__c='Account__r.Principal_3_First_Name__c', HardcodedValue__c=null, Required__c=true));
// 		gid_apm_prin3.add(new GID_APM_Principal_3__c(Name = 'LastName-3',GIACTName__c = 'LastName',Disabled__c=false,Field_Path__c='Account__r.Principal_3_Last_Name__c', HardcodedValue__c=null, Required__c=true));
// 		gid_apm_prin3.add(new GID_APM_Principal_3__c(Name = 'City-3',GIACTName__c = 'City',Disabled__c=false,Field_Path__c='Account__r.Principal_3_City__c', HardcodedValue__c=null, Required__c=true));
// 		gid_apm_prin3.add(new GID_APM_Principal_3__c(Name = 'Country',GIACTName__c = 'Country',Disabled__c=false,Field_Path__c='Account__r.ShippingCountry', HardcodedValue__c='US', Required__c=true));
// 		gid_apm_prin3.add(new GID_APM_Principal_3__c(Name = 'DateOfBirth',GIACTName__c = 'DateOfBirth',Disabled__c=false,Field_Path__c='Account__r.Principal_3_DOB__c', HardcodedValue__c='US', Required__c=true));		
// 		gid_apm_prin3.add(new GID_APM_Principal_3__c(Name = 'State-3',GIACTName__c = 'State',Disabled__c=false,Field_Path__c='Account__r.Principal_3_State__c', HardcodedValue__c=null, Required__c=true));
// 		gid_apm_prin3.add(new GID_APM_Principal_3__c(Name = 'TaxId-3',GIACTName__c = 'TaxId',Disabled__c=false,Field_Path__c='Account__r.Principal_3_SSN__c', HardcodedValue__c=null, Required__c=true));
// 		gid_apm_prin3.add(new GID_APM_Principal_3__c(Name = 'ZipCode-3',GIACTName__c = 'ZipCode',Disabled__c=false,Field_Path__c='Account__r.Principal_3_Zip__c', HardcodedValue__c=null, Required__c=true));
// 		insert gid_apm_prin3;

// 		List<GID_APM_Principal_4__c> gid_apm_prin4 = new List<GID_APM_Principal_4__c> ();
// 		gid_apm_prin4.add(new GID_APM_Principal_4__c(Name = 'AddressLine1-4',GIACTName__c = 'AddressLine1',Disabled__c=false,Field_Path__c='Account__r.Principal_4_Street__c', HardcodedValue__c=null, Required__c=true));
// 		gid_apm_prin4.add(new GID_APM_Principal_4__c(Name = 'FirstName-4',GIACTName__c = 'FirstName',Disabled__c=false,Field_Path__c='Account__r.Principal_4_First_Name__c', HardcodedValue__c=null, Required__c=true));
// 		gid_apm_prin4.add(new GID_APM_Principal_4__c(Name = 'LastName-4',GIACTName__c = 'LastName',Disabled__c=false,Field_Path__c='Account__r.Principal_4_Last_Name__c', HardcodedValue__c=null, Required__c=true));
// 		gid_apm_prin4.add(new GID_APM_Principal_4__c(Name = 'City-4',GIACTName__c = 'City',Disabled__c=false,Field_Path__c='Account__r.Principal_4_City__c', HardcodedValue__c=null, Required__c=true));
// 		gid_apm_prin4.add(new GID_APM_Principal_4__c(Name = 'Country',GIACTName__c = 'Country',Disabled__c=false,Field_Path__c='Account__r.ShippingCountry', HardcodedValue__c='US', Required__c=true));
// 		gid_apm_prin4.add(new GID_APM_Principal_4__c(Name = 'DateOfBirth',GIACTName__c = 'DateOfBirth',Disabled__c=false,Field_Path__c='Account__r.Principal_4_DOB__c', HardcodedValue__c='US', Required__c=true));		
// 		gid_apm_prin4.add(new GID_APM_Principal_4__c(Name = 'State-4',GIACTName__c = 'State',Disabled__c=false,Field_Path__c='Account__r.Principal_4_State__c', HardcodedValue__c=null, Required__c=true));
// 		gid_apm_prin4.add(new GID_APM_Principal_4__c(Name = 'TaxId-4',GIACTName__c = 'TaxId',Disabled__c=false,Field_Path__c='Account__r.Principal_4_SSN__c', HardcodedValue__c=null, Required__c=true));
// 		gid_apm_prin4.add(new GID_APM_Principal_4__c(Name = 'ZipCode-4',GIACTName__c = 'ZipCode',Disabled__c=false,Field_Path__c='Account__r.Principal_4_Zip__c', HardcodedValue__c=null, Required__c=true));
// 		insert gid_apm_prin4;
// 	}

// Static void createGVFAPMCustomSetting () {

// 		List<GVF_APM_Business__c> GVF_APM_biz = new List<GVF_APM_Business__c> ();
// 		GVF_APM_biz.add(new GVF_APM_Business__c(Name = 'BankName',GIACTName__c = 'BankName',Disabled__c=false,Field_Path__c='Account_Label__c', HardcodedValue__c=null, Required__c=false, LevelName__c=null));
// 		GVF_APM_biz.add(new GVF_APM_Business__c(Name = 'AccountNumber',GIACTName__c = 'AccountNumber',Disabled__c=false,Field_Path__c='AccountNo__c', HardcodedValue__c=null, Required__c=true, LevelName__c='check'));
// 		GVF_APM_biz.add(new GVF_APM_Business__c(Name = 'AccountType',GIACTName__c = 'AccountType',Disabled__c=false,Field_Path__c='Account_Type__c', HardcodedValue__c=null, Required__c=false, LevelName__c='check'));
// 		GVF_APM_biz.add(new GVF_APM_Business__c(Name = 'RoutingNumber',GIACTName__c = 'AccountNumber',Disabled__c=false,Field_Path__c='RoutingNo__c', HardcodedValue__c=null, Required__c=true, LevelName__c='check'));

// 		GVF_APM_biz.add(new GVF_APM_Business__c(Name = 'AddressLine1-Business',GIACTName__c = 'AddressLine1',Disabled__c=false,Field_Path__c='ValuePlus__r.Account__r.ShippingStreet', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
// 		GVF_APM_biz.add(new GVF_APM_Business__c(Name = 'BusinessName-APM',GIACTName__c = 'BusinessName',Disabled__c=false,Field_Path__c='ValuePlus__r.Account__r.Full_Company_Name_Legal__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
// 		GVF_APM_biz.add(new GVF_APM_Business__c(Name = 'City-Business',GIACTName__c = 'City',Disabled__c=false,Field_Path__c='ValuePlus__r.Account__r.ShippingCity', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
// 		GVF_APM_biz.add(new GVF_APM_Business__c(Name = 'Country',GIACTName__c = 'Country',Disabled__c=false,Field_Path__c='ValuePlus__r.Account__r.BillingCountry', HardcodedValue__c='US', Required__c=false, LevelName__c='customer'));
// 		GVF_APM_biz.add(new GVF_APM_Business__c(Name = 'State-Business',GIACTName__c = 'State',Disabled__c=false,Field_Path__c='ValuePlus__r.Account__r.ShippingState', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
// 		GVF_APM_biz.add(new GVF_APM_Business__c(Name = 'TaxId-Business',GIACTName__c = 'TaxId',Disabled__c=false,Field_Path__c='ValuePlus__r.Account__r.Tax_ID__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
// 		GVF_APM_biz.add(new GVF_APM_Business__c(Name = 'ZipCode-Business',GIACTName__c = 'ZipCode',Disabled__c=false,Field_Path__c='ValuePlus__r.Account__r.ShippingPostalCode', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
// 		insert GVF_APM_biz;

// 		List<GVF_APM_Principal_1__c> GVF_APM_prin1 = new List<GVF_APM_Principal_1__c> ();
// 		GVF_APM_prin1.add(new GVF_APM_Principal_1__c(Name = 'BankName',GIACTName__c = 'BankName',Disabled__c=false,Field_Path__c='Account_Label__c', HardcodedValue__c=null, Required__c=false, LevelName__c=null));
// 		GVF_APM_prin1.add(new GVF_APM_Principal_1__c(Name = 'AccountNumber',GIACTName__c = 'AccountNumber',Disabled__c=false,Field_Path__c='AccountNo__c', HardcodedValue__c=null, Required__c=true, LevelName__c='check'));
// 		GVF_APM_prin1.add(new GVF_APM_Principal_1__c(Name = 'AccountType',GIACTName__c = 'AccountType',Disabled__c=false,Field_Path__c='Account_Type__c', HardcodedValue__c=null, Required__c=false, LevelName__c='check'));
// 		GVF_APM_prin1.add(new GVF_APM_Principal_1__c(Name = 'RoutingNumber',GIACTName__c = 'AccountNumber',Disabled__c=false,Field_Path__c='RoutingNo__c', HardcodedValue__c=null, Required__c=true, LevelName__c='check'));

// 		GVF_APM_prin1.add(new GVF_APM_Principal_1__c(Name = 'AddressLine1-1',GIACTName__c = 'AddressLine1',Disabled__c=false,Field_Path__c='ValuePlus__r.Account__r.Principal_1_Street__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
// 		GVF_APM_prin1.add(new GVF_APM_Principal_1__c(Name = 'FirstName-1',GIACTName__c = 'FirstName',Disabled__c=false,Field_Path__c='ValuePlus__r.Account__r.Principal_1_First_Name__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
// 		GVF_APM_prin1.add(new GVF_APM_Principal_1__c(Name = 'LastName-1',GIACTName__c = 'LastName',Disabled__c=false,Field_Path__c='ValuePlus__r.Account__r.Principal_1_Last_Name__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
// 		GVF_APM_prin1.add(new GVF_APM_Principal_1__c(Name = 'City-1',GIACTName__c = 'City',Disabled__c=false,Field_Path__c='ValuePlus__r.MC_Principal_1_City__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
// 		GVF_APM_prin1.add(new GVF_APM_Principal_1__c(Name = 'Country',GIACTName__c = 'Country',Disabled__c=false,Field_Path__c='ValuePlus__r.Account__r.BillingCountry', HardcodedValue__c='US', Required__c=true, LevelName__c='customer'));
// 		GVF_APM_prin1.add(new GVF_APM_Principal_1__c(Name = 'DateOfBirth',GIACTName__c = 'DateOfBirth',Disabled__c=false,Field_Path__c='ValuePlus__r.MC_Principal_1_DOB__c', HardcodedValue__c=null, Required__c=false, LevelName__c='customer'));		
// 		GVF_APM_prin1.add(new GVF_APM_Principal_1__c(Name = 'State-1',GIACTName__c = 'State',Disabled__c=false,Field_Path__c='ValuePlus__r.Account__r.Principal_1_State__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
// 		GVF_APM_prin1.add(new GVF_APM_Principal_1__c(Name = 'TaxId-1',GIACTName__c = 'TaxId',Disabled__c=false,Field_Path__c='ValuePlus__r.Account__r.Principal_1_SSN__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
// 		GVF_APM_prin1.add(new GVF_APM_Principal_1__c(Name = 'ZipCode-1',GIACTName__c = 'ZipCode',Disabled__c=false,Field_Path__c='ValuePlus__r.Account__r.Principal_1_Zip__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
// 		insert GVF_APM_prin1;

// 		List<GVF_APM_Principal_2__c> GVF_APM_prin2 = new List<GVF_APM_Principal_2__c> ();
// 		GVF_APM_prin2.add(new GVF_APM_Principal_2__c(Name = 'BankName',GIACTName__c = 'BankName',Disabled__c=false,Field_Path__c='Account_Label__c', HardcodedValue__c=null, Required__c=false, LevelName__c=null));
// 		GVF_APM_prin2.add(new GVF_APM_Principal_2__c(Name = 'AccountNumber',GIACTName__c = 'AccountNumber',Disabled__c=false,Field_Path__c='AccountNo__c', HardcodedValue__c=null, Required__c=true, LevelName__c='check'));
// 		GVF_APM_prin2.add(new GVF_APM_Principal_2__c(Name = 'AccountType',GIACTName__c = 'AccountType',Disabled__c=false,Field_Path__c='Account_Type__c', HardcodedValue__c=null, Required__c=false, LevelName__c='check'));
// 		GVF_APM_prin2.add(new GVF_APM_Principal_2__c(Name = 'RoutingNumber',GIACTName__c = 'AccountNumber',Disabled__c=false,Field_Path__c='RoutingNo__c', HardcodedValue__c=null, Required__c=true, LevelName__c='check'));

// 		GVF_APM_prin2.add(new GVF_APM_Principal_2__c(Name = 'AddressLine1-2',GIACTName__c = 'AddressLine1',Disabled__c=false,Field_Path__c='ValuePlus__r.Account__r.Principal_2_Street__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
// 		GVF_APM_prin2.add(new GVF_APM_Principal_2__c(Name = 'FirstName-2',GIACTName__c = 'FirstName',Disabled__c=false,Field_Path__c='ValuePlus__r.Account__r.Principal_2_First_Name__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
// 		GVF_APM_prin2.add(new GVF_APM_Principal_2__c(Name = 'LastName-2',GIACTName__c = 'LastName',Disabled__c=false,Field_Path__c='ValuePlus__r.Account__r.Principal_2_Last_Name__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
// 		GVF_APM_prin2.add(new GVF_APM_Principal_2__c(Name = 'City-2',GIACTName__c = 'City',Disabled__c=false,Field_Path__c='ValuePlus__r.Account__r.Principal_2_City__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
// 		GVF_APM_prin2.add(new GVF_APM_Principal_2__c(Name = 'Country',GIACTName__c = 'Country',Disabled__c=false,Field_Path__c='ValuePlus__r.Account__r.BillingCountry', HardcodedValue__c='US', Required__c=true, LevelName__c='customer'));
// 		//GVF_APM_prin2.add(new GVF_APM_Principal_2__c(Name = 'DateOfBirth',GIACTName__c = 'DateOfBirth',Disabled__c=false,Field_Path__c='ValuePlus__r.MC_Principal_2_DOB__c', HardcodedValue__c=null, Required__c=false, LevelName__c='customer'));		
// 		GVF_APM_prin2.add(new GVF_APM_Principal_2__c(Name = 'State-2',GIACTName__c = 'State',Disabled__c=false,Field_Path__c='ValuePlus__r.Account__r.Principal_2_State__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
// 		GVF_APM_prin2.add(new GVF_APM_Principal_2__c(Name = 'TaxId-2',GIACTName__c = 'TaxId',Disabled__c=false,Field_Path__c='ValuePlus__r.Account__r.Principal_2_SSN__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
// 		GVF_APM_prin2.add(new GVF_APM_Principal_2__c(Name = 'ZipCode-2',GIACTName__c = 'ZipCode',Disabled__c=false,Field_Path__c='ValuePlus__r.Account__r.Principal_2_Zip__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
// 		insert GVF_APM_prin2;

// 		List<GVF_APM_Principal_3__c> GVF_APM_prin3 = new List<GVF_APM_Principal_3__c> ();
// 		GVF_APM_prin3.add(new GVF_APM_Principal_3__c(Name = 'BankName',GIACTName__c = 'BankName',Disabled__c=false,Field_Path__c='Account_Label__c', HardcodedValue__c=null, Required__c=false, LevelName__c=null));
// 		GVF_APM_prin3.add(new GVF_APM_Principal_3__c(Name = 'AccountNumber',GIACTName__c = 'AccountNumber',Disabled__c=false,Field_Path__c='AccountNo__c', HardcodedValue__c=null, Required__c=true, LevelName__c='check'));
// 		GVF_APM_prin3.add(new GVF_APM_Principal_3__c(Name = 'AccountType',GIACTName__c = 'AccountType',Disabled__c=false,Field_Path__c='Account_Type__c', HardcodedValue__c=null, Required__c=false, LevelName__c='check'));
// 		GVF_APM_prin3.add(new GVF_APM_Principal_3__c(Name = 'RoutingNumber',GIACTName__c = 'AccountNumber',Disabled__c=false,Field_Path__c='RoutingNo__c', HardcodedValue__c=null, Required__c=true, LevelName__c='check'));

// 		GVF_APM_prin3.add(new GVF_APM_Principal_3__c(Name = 'AddressLine1-3',GIACTName__c = 'AddressLine1',Disabled__c=false,Field_Path__c='ValuePlus__r.Account__r.Principal_3_Street__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
// 		GVF_APM_prin3.add(new GVF_APM_Principal_3__c(Name = 'FirstName-3',GIACTName__c = 'FirstName',Disabled__c=false,Field_Path__c='ValuePlus__r.Account__r.Principal_3_First_Name__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
// 		GVF_APM_prin3.add(new GVF_APM_Principal_3__c(Name = 'LastName-3',GIACTName__c = 'LastName',Disabled__c=false,Field_Path__c='ValuePlus__r.Account__r.Principal_3_Last_Name__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
// 		GVF_APM_prin3.add(new GVF_APM_Principal_3__c(Name = 'City-3',GIACTName__c = 'City',Disabled__c=false,Field_Path__c='ValuePlus__r.Account__r.Principal_3_City__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
// 		GVF_APM_prin3.add(new GVF_APM_Principal_3__c(Name = 'Country',GIACTName__c = 'Country',Disabled__c=false,Field_Path__c='ValuePlus__r.Account__r.ShippingCountry', HardcodedValue__c='US', Required__c=true, LevelName__c='customer'));
// 		//GVF_APM_prin3.add(new GVF_APM_Principal_3__c(Name = 'DateOfBirth',GIACTName__c = 'DateOfBirth',Disabled__c=false,Field_Path__c='ValuePlus__r.MC_Principal_3_DOB__c', HardcodedValue__c='US', Required__c=false, LevelName__c='customer'));		
// 		GVF_APM_prin3.add(new GVF_APM_Principal_3__c(Name = 'State-3',GIACTName__c = 'State',Disabled__c=false,Field_Path__c='ValuePlus__r.Account__r.Principal_3_State__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
// 		GVF_APM_prin3.add(new GVF_APM_Principal_3__c(Name = 'TaxId-3',GIACTName__c = 'TaxId',Disabled__c=false,Field_Path__c='ValuePlus__r.Account__r.Principal_3_SSN__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
// 		GVF_APM_prin3.add(new GVF_APM_Principal_3__c(Name = 'ZipCode-3',GIACTName__c = 'ZipCode',Disabled__c=false,Field_Path__c='ValuePlus__r.Account__r.Principal_3_Zip__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
// 		insert GVF_APM_prin3;

// 		List<GVF_APM_Principal_4__c> GVF_APM_prin4 = new List<GVF_APM_Principal_4__c> ();
// 		GVF_APM_prin4.add(new GVF_APM_Principal_4__c(Name = 'BankName',GIACTName__c = 'BankName',Disabled__c=false,Field_Path__c='Account_Label__c', HardcodedValue__c=null, Required__c=false, LevelName__c=null));
// 		GVF_APM_prin4.add(new GVF_APM_Principal_4__c(Name = 'AccountNumber',GIACTName__c = 'AccountNumber',Disabled__c=false,Field_Path__c='AccountNo__c', HardcodedValue__c=null, Required__c=true, LevelName__c='check'));
// 		GVF_APM_prin4.add(new GVF_APM_Principal_4__c(Name = 'AccountType',GIACTName__c = 'AccountType',Disabled__c=false,Field_Path__c='Account_Type__c', HardcodedValue__c=null, Required__c=false, LevelName__c='check'));
// 		GVF_APM_prin4.add(new GVF_APM_Principal_4__c(Name = 'RoutingNumber',GIACTName__c = 'AccountNumber',Disabled__c=false,Field_Path__c='RoutingNo__c', HardcodedValue__c=null, Required__c=true, LevelName__c='check'));

// 		GVF_APM_prin4.add(new GVF_APM_Principal_4__c(Name = 'AddressLine1-4',GIACTName__c = 'AddressLine1',Disabled__c=false,Field_Path__c='ValuePlus__r.Account__r.Principal_4_Street__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
// 		GVF_APM_prin4.add(new GVF_APM_Principal_4__c(Name = 'FirstName-4',GIACTName__c = 'FirstName',Disabled__c=false,Field_Path__c='ValuePlus__r.Account__r.Principal_4_First_Name__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
// 		GVF_APM_prin4.add(new GVF_APM_Principal_4__c(Name = 'LastName-4',GIACTName__c = 'LastName',Disabled__c=false,Field_Path__c='ValuePlus__r.Account__r.Principal_4_Last_Name__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
// 		GVF_APM_prin4.add(new GVF_APM_Principal_4__c(Name = 'City-4',GIACTName__c = 'City',Disabled__c=false,Field_Path__c='ValuePlus__r.Account__r.Principal_4_City__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
// 		GVF_APM_prin4.add(new GVF_APM_Principal_4__c(Name = 'Country',GIACTName__c = 'Country',Disabled__c=false,Field_Path__c='ValuePlus__r.Account__r.BillingCountry', HardcodedValue__c='US', Required__c=true, LevelName__c='customer'));
// 		GVF_APM_prin4.add(new GVF_APM_Principal_4__c(Name = 'DateOfBirth',GIACTName__c = 'DateOfBirth',Disabled__c=false,Field_Path__c='ValuePlus__r.MC_Principal_4_DOB__c', HardcodedValue__c='US', Required__c=false, LevelName__c='customer'));		
// 		GVF_APM_prin4.add(new GVF_APM_Principal_4__c(Name = 'State-4',GIACTName__c = 'State',Disabled__c=false,Field_Path__c='VValuePlus__r.Account__r.Principal_4_State__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
// 		GVF_APM_prin4.add(new GVF_APM_Principal_4__c(Name = 'TaxId-4',GIACTName__c = 'TaxId',Disabled__c=false,Field_Path__c='ValuePlus__r.Account__r.Principal_4_SSN__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
// 		GVF_APM_prin4.add(new GVF_APM_Principal_4__c(Name = 'ZipCode-4',GIACTName__c = 'ZipCode',Disabled__c=false,Field_Path__c='ValuePlus__r.Account__r.Principal_4_Zip__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
// 		insert GVF_APM_prin4;
// 	}

	Static void createGIDMyCaseCustomSetting () {
		List<GID_MyCase_Business__c> gid_MyCase_biz = new List<GID_MyCase_Business__c> ();
		gid_MyCase_biz.add(new GID_MyCase_Business__c(Name = 'AddressLine1-Business',GIACTName__c = 'AddressLine1',Disabled__c=false,Field_Path__c='Account__r.ShippingStreet', HardcodedValue__c=null, Required__c=true));
		gid_MyCase_biz.add(new GID_MyCase_Business__c(Name = 'BusinessName-MyCase',GIACTName__c = 'BusinessName',Disabled__c=false,Field_Path__c='Account__r.Account_Legal_Name__c', HardcodedValue__c=null, Required__c=true));
		gid_MyCase_biz.add(new GID_MyCase_Business__c(Name = 'City-Business',GIACTName__c = 'City',Disabled__c=false,Field_Path__c='Account__r.ShippingCity', HardcodedValue__c=null, Required__c=true));
		gid_MyCase_biz.add(new GID_MyCase_Business__c(Name = 'Country',GIACTName__c = 'Country',Disabled__c=false,Field_Path__c='Account__r.ShippingCountry', HardcodedValue__c='US', Required__c=true));
		gid_MyCase_biz.add(new GID_MyCase_Business__c(Name = 'State-Business',GIACTName__c = 'State',Disabled__c=false,Field_Path__c='Account__r.ShippingState', HardcodedValue__c=null, Required__c=true));
		gid_MyCase_biz.add(new GID_MyCase_Business__c(Name = 'TaxId-Business',GIACTName__c = 'TaxId',Disabled__c=false,Field_Path__c='Account__r.Tax_ID__c', HardcodedValue__c=null, Required__c=true));
		gid_MyCase_biz.add(new GID_MyCase_Business__c(Name = 'ZipCode-Business',GIACTName__c = 'ZipCode',Disabled__c=false,Field_Path__c='Account__r.ShippingPostalCode', HardcodedValue__c=null, Required__c=true));
		insert gid_MyCase_biz;

		List<GID_MyCase_Principal_1__c> gid_MyCase_prin1 = new List<GID_MyCase_Principal_1__c> ();
		gid_MyCase_prin1.add(new GID_MyCase_Principal_1__c(Name = 'AddressLine1-1',GIACTName__c = 'AddressLine1',Disabled__c=false,Field_Path__c='MC_Principal_1_Street__c', HardcodedValue__c=null, Required__c=true));
		gid_MyCase_prin1.add(new GID_MyCase_Principal_1__c(Name = 'FirstName-1',GIACTName__c = 'FirstName',Disabled__c=false,Field_Path__c='MC_Principal_1_First_Name__c', HardcodedValue__c=null, Required__c=true));
		gid_MyCase_prin1.add(new GID_MyCase_Principal_1__c(Name = 'LastName-1',GIACTName__c = 'LastName',Disabled__c=false,Field_Path__c='MC_Principal_1_Last_Name__c', HardcodedValue__c=null, Required__c=true));
		gid_MyCase_prin1.add(new GID_MyCase_Principal_1__c(Name = 'City-1',GIACTName__c = 'City',Disabled__c=false,Field_Path__c='MC_Principal_1_City__c', HardcodedValue__c=null, Required__c=true));
		gid_MyCase_prin1.add(new GID_MyCase_Principal_1__c(Name = 'Country',GIACTName__c = 'Country',Disabled__c=false,Field_Path__c='Account__r.ShippingCountry', HardcodedValue__c='US', Required__c=true));
		gid_MyCase_prin1.add(new GID_MyCase_Principal_1__c(Name = 'DateOfBirth',GIACTName__c = 'DateOfBirth',Disabled__c=false,Field_Path__c='MC_Principal_1_DOB__c', HardcodedValue__c='US', Required__c=true));		
		gid_MyCase_prin1.add(new GID_MyCase_Principal_1__c(Name = 'State-1',GIACTName__c = 'State',Disabled__c=false,Field_Path__c='MC_Principal_1_State__c', HardcodedValue__c=null, Required__c=true));
		gid_MyCase_prin1.add(new GID_MyCase_Principal_1__c(Name = 'TaxId-1',GIACTName__c = 'TaxId',Disabled__c=false,Field_Path__c='MC_Principal_1_SSN__c', HardcodedValue__c=null, Required__c=true));
		gid_MyCase_prin1.add(new GID_MyCase_Principal_1__c(Name = 'ZipCode-1',GIACTName__c = 'ZipCode',Disabled__c=false,Field_Path__c='MC_Principal_1_Zip__c', HardcodedValue__c=null, Required__c=true));
		insert gid_MyCase_prin1;

		List<GID_MyCase_Principal_2__c> gid_MyCase_prin2 = new List<GID_MyCase_Principal_2__c> ();
		gid_MyCase_prin2.add(new GID_MyCase_Principal_2__c(Name = 'AddressLine1-2',GIACTName__c = 'AddressLine1',Disabled__c=false,Field_Path__c='MC_Principal_2_Street__c', HardcodedValue__c=null, Required__c=true));
		gid_MyCase_prin2.add(new GID_MyCase_Principal_2__c(Name = 'FirstName-2',GIACTName__c = 'FirstName',Disabled__c=false,Field_Path__c='MC_Principal_2_First_Name__c', HardcodedValue__c=null, Required__c=true));
		gid_MyCase_prin2.add(new GID_MyCase_Principal_2__c(Name = 'LastName-2',GIACTName__c = 'LastName',Disabled__c=false,Field_Path__c='MC_Principal_2_Last_Name__c', HardcodedValue__c=null, Required__c=true));
		gid_MyCase_prin2.add(new GID_MyCase_Principal_2__c(Name = 'City-2',GIACTName__c = 'City',Disabled__c=false,Field_Path__c='MC_Principal_2_City__c', HardcodedValue__c=null, Required__c=true));
		gid_MyCase_prin2.add(new GID_MyCase_Principal_2__c(Name = 'Country',GIACTName__c = 'Country',Disabled__c=false,Field_Path__c='Account__r.ShippingCountry', HardcodedValue__c='US', Required__c=true));
		gid_MyCase_prin2.add(new GID_MyCase_Principal_2__c(Name = 'DateOfBirth',GIACTName__c = 'DateOfBirth',Disabled__c=false,Field_Path__c='MC_Principal_2_DOB__c', HardcodedValue__c='US', Required__c=true));		
		gid_MyCase_prin2.add(new GID_MyCase_Principal_2__c(Name = 'State-2',GIACTName__c = 'State',Disabled__c=false,Field_Path__c='MC_Principal_2_State__c', HardcodedValue__c=null, Required__c=true));
		gid_MyCase_prin2.add(new GID_MyCase_Principal_2__c(Name = 'TaxId-2',GIACTName__c = 'TaxId',Disabled__c=false,Field_Path__c='MC_Principal_2_SSN__c', HardcodedValue__c=null, Required__c=true));
		gid_MyCase_prin2.add(new GID_MyCase_Principal_2__c(Name = 'ZipCode-2',GIACTName__c = 'ZipCode',Disabled__c=false,Field_Path__c='MC_Principal_2_Zip__c', HardcodedValue__c=null, Required__c=true));
		insert gid_MyCase_prin2;

		List<GID_MyCase_Principal_3__c> gid_MyCase_prin3 = new List<GID_MyCase_Principal_3__c> ();
		gid_MyCase_prin3.add(new GID_MyCase_Principal_3__c(Name = 'AddressLine1-3',GIACTName__c = 'AddressLine1',Disabled__c=false,Field_Path__c='MC_Principal_3_Street__c', HardcodedValue__c=null, Required__c=true));
		gid_MyCase_prin3.add(new GID_MyCase_Principal_3__c(Name = 'FirstName-3',GIACTName__c = 'FirstName',Disabled__c=false,Field_Path__c='MC_Principal_3_First_Name__c', HardcodedValue__c=null, Required__c=true));
		gid_MyCase_prin3.add(new GID_MyCase_Principal_3__c(Name = 'LastName-3',GIACTName__c = 'LastName',Disabled__c=false,Field_Path__c='MC_Principal_3_Last_Name__c', HardcodedValue__c=null, Required__c=true));
		gid_MyCase_prin3.add(new GID_MyCase_Principal_3__c(Name = 'City-3',GIACTName__c = 'City',Disabled__c=false,Field_Path__c='MC_Principal_3_City__c', HardcodedValue__c=null, Required__c=true));
		gid_MyCase_prin3.add(new GID_MyCase_Principal_3__c(Name = 'Country',GIACTName__c = 'Country',Disabled__c=false,Field_Path__c='Account__r.ShippingCountry', HardcodedValue__c='US', Required__c=true));
		gid_MyCase_prin3.add(new GID_MyCase_Principal_3__c(Name = 'DateOfBirth',GIACTName__c = 'DateOfBirth',Disabled__c=false,Field_Path__c='MC_Principal_3_DOB__c', HardcodedValue__c='US', Required__c=true));		
		gid_MyCase_prin3.add(new GID_MyCase_Principal_3__c(Name = 'State-3',GIACTName__c = 'State',Disabled__c=false,Field_Path__c='MC_Principal_3_State__c', HardcodedValue__c=null, Required__c=true));
		gid_MyCase_prin3.add(new GID_MyCase_Principal_3__c(Name = 'TaxId-3',GIACTName__c = 'TaxId',Disabled__c=false,Field_Path__c='MC_Principal_3_SSN__c', HardcodedValue__c=null, Required__c=true));
		gid_MyCase_prin3.add(new GID_MyCase_Principal_3__c(Name = 'ZipCode-3',GIACTName__c = 'ZipCode',Disabled__c=false,Field_Path__c='MC_Principal_3_Zip__c', HardcodedValue__c=null, Required__c=true));
		insert gid_MyCase_prin3;

		List<GID_MyCase_Principal_4__c> gid_MyCase_prin4 = new List<GID_MyCase_Principal_4__c> ();
		gid_MyCase_prin4.add(new GID_MyCase_Principal_4__c(Name = 'AddressLine1-4',GIACTName__c = 'AddressLine1',Disabled__c=false,Field_Path__c='Principal_4_Street__c', HardcodedValue__c=null, Required__c=true));
		gid_MyCase_prin4.add(new GID_MyCase_Principal_4__c(Name = 'FirstName-4',GIACTName__c = 'FirstName',Disabled__c=false,Field_Path__c='MC_Principal_4_First_Name__c', HardcodedValue__c=null, Required__c=true));
		gid_MyCase_prin4.add(new GID_MyCase_Principal_4__c(Name = 'LastName-4',GIACTName__c = 'LastName',Disabled__c=false,Field_Path__c='MC_Principal_4_Last_Name__c', HardcodedValue__c=null, Required__c=true));
		gid_MyCase_prin4.add(new GID_MyCase_Principal_4__c(Name = 'City-4',GIACTName__c = 'City',Disabled__c=false,Field_Path__c='MC_Principal_4_City__c', HardcodedValue__c=null, Required__c=true));
		gid_MyCase_prin4.add(new GID_MyCase_Principal_4__c(Name = 'Country',GIACTName__c = 'Country',Disabled__c=false,Field_Path__c='Account__r.ShippingCountry', HardcodedValue__c='US', Required__c=true));
		gid_MyCase_prin4.add(new GID_MyCase_Principal_4__c(Name = 'DateOfBirth',GIACTName__c = 'DateOfBirth',Disabled__c=false,Field_Path__c='MC_Principal_4_DOB__c', HardcodedValue__c='US', Required__c=true));		
		gid_MyCase_prin4.add(new GID_MyCase_Principal_4__c(Name = 'State-4',GIACTName__c = 'State',Disabled__c=false,Field_Path__c='MC_Principal_4_State__c', HardcodedValue__c=null, Required__c=true));
		gid_MyCase_prin4.add(new GID_MyCase_Principal_4__c(Name = 'TaxId-4',GIACTName__c = 'TaxId',Disabled__c=false,Field_Path__c='Principal_4_SSN__c', HardcodedValue__c=null, Required__c=true));
		gid_MyCase_prin4.add(new GID_MyCase_Principal_4__c(Name = 'ZipCode-4',GIACTName__c = 'ZipCode',Disabled__c=false,Field_Path__c='MC_Principal_4_Zip__c', HardcodedValue__c=null, Required__c=true));
		insert gid_MyCase_prin4;
	}

Static void createGVFMyCaseCustomSetting () {

		List<GVF_MyCase_Business__c> GVF_MyCase_biz = new List<GVF_MyCase_Business__c> ();
		GVF_MyCase_biz.add(new GVF_MyCase_Business__c(Name = 'BankName',GIACTName__c = 'BankName',Disabled__c=false,Field_Path__c='Account_Label__c', HardcodedValue__c=null, Required__c=false, LevelName__c=null));
		GVF_MyCase_biz.add(new GVF_MyCase_Business__c(Name = 'AccountNumber',GIACTName__c = 'AccountNumber',Disabled__c=false,Field_Path__c='AccountNo__c', HardcodedValue__c=null, Required__c=true, LevelName__c='check'));
		GVF_MyCase_biz.add(new GVF_MyCase_Business__c(Name = 'AccountType',GIACTName__c = 'AccountType',Disabled__c=false,Field_Path__c='Account_Type__c', HardcodedValue__c=null, Required__c=false, LevelName__c='check'));
		GVF_MyCase_biz.add(new GVF_MyCase_Business__c(Name = 'RoutingNumber',GIACTName__c = 'AccountNumber',Disabled__c=false,Field_Path__c='RoutingNo__c', HardcodedValue__c=null, Required__c=true, LevelName__c='check'));

		GVF_MyCase_biz.add(new GVF_MyCase_Business__c(Name = 'AddressLine1-Business',GIACTName__c = 'AddressLine1',Disabled__c=false,Field_Path__c='ValuePlus__r.Account__r.ShippingStreet', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
		GVF_MyCase_biz.add(new GVF_MyCase_Business__c(Name = 'BusinessName-MyCase',GIACTName__c = 'BusinessName',Disabled__c=false,Field_Path__c='ValuePlus__r.Account__r.Full_Company_Name_Legal__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
		GVF_MyCase_biz.add(new GVF_MyCase_Business__c(Name = 'City-Business',GIACTName__c = 'City',Disabled__c=false,Field_Path__c='ValuePlus__r.Account__r.ShippingCity', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
		GVF_MyCase_biz.add(new GVF_MyCase_Business__c(Name = 'Country',GIACTName__c = 'Country',Disabled__c=false,Field_Path__c='ValuePlus__r.Account__r.BillingCountry', HardcodedValue__c='US', Required__c=false, LevelName__c='customer'));
		GVF_MyCase_biz.add(new GVF_MyCase_Business__c(Name = 'State-Business',GIACTName__c = 'State',Disabled__c=false,Field_Path__c='ValuePlus__r.Account__r.ShippingState', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
		GVF_MyCase_biz.add(new GVF_MyCase_Business__c(Name = 'TaxId-Business',GIACTName__c = 'TaxId',Disabled__c=false,Field_Path__c='ValuePlus__r.Account__r.Tax_ID__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
		GVF_MyCase_biz.add(new GVF_MyCase_Business__c(Name = 'ZipCode-Business',GIACTName__c = 'ZipCode',Disabled__c=false,Field_Path__c='ValuePlus__r.Account__r.ShippingPostalCode', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
		insert GVF_MyCase_biz;

		List<GVF_MyCase_Principal_1__c> GVF_MyCase_prin1 = new List<GVF_MyCase_Principal_1__c> ();
		GVF_MyCase_prin1.add(new GVF_MyCase_Principal_1__c(Name = 'BankName',GIACTName__c = 'BankName',Disabled__c=false,Field_Path__c='Account_Label__c', HardcodedValue__c=null, Required__c=false, LevelName__c=null));
		GVF_MyCase_prin1.add(new GVF_MyCase_Principal_1__c(Name = 'AccountNumber',GIACTName__c = 'AccountNumber',Disabled__c=false,Field_Path__c='AccountNo__c', HardcodedValue__c=null, Required__c=true, LevelName__c='check'));
		GVF_MyCase_prin1.add(new GVF_MyCase_Principal_1__c(Name = 'AccountType',GIACTName__c = 'AccountType',Disabled__c=false,Field_Path__c='Account_Type__c', HardcodedValue__c=null, Required__c=false, LevelName__c='check'));
		GVF_MyCase_prin1.add(new GVF_MyCase_Principal_1__c(Name = 'RoutingNumber',GIACTName__c = 'AccountNumber',Disabled__c=false,Field_Path__c='RoutingNo__c', HardcodedValue__c=null, Required__c=true, LevelName__c='check'));

		GVF_MyCase_prin1.add(new GVF_MyCase_Principal_1__c(Name = 'AddressLine1-1',GIACTName__c = 'AddressLine1',Disabled__c=false,Field_Path__c='ValuePlus__r.MC_Principal_1_Street__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
		GVF_MyCase_prin1.add(new GVF_MyCase_Principal_1__c(Name = 'FirstName-1',GIACTName__c = 'FirstName',Disabled__c=false,Field_Path__c='ValuePlus__r.MC_Principal_1_First_Name__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
		GVF_MyCase_prin1.add(new GVF_MyCase_Principal_1__c(Name = 'LastName-1',GIACTName__c = 'LastName',Disabled__c=false,Field_Path__c='ValuePlus__r.MC_Principal_1_Last_Name__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
		GVF_MyCase_prin1.add(new GVF_MyCase_Principal_1__c(Name = 'City-1',GIACTName__c = 'City',Disabled__c=false,Field_Path__c='ValuePlus__r.MC_Principal_1_City__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
		GVF_MyCase_prin1.add(new GVF_MyCase_Principal_1__c(Name = 'Country',GIACTName__c = 'Country',Disabled__c=false,Field_Path__c='ValuePlus__r.Account__r.ShippingCountry', HardcodedValue__c='US', Required__c=true, LevelName__c='customer'));
		GVF_MyCase_prin1.add(new GVF_MyCase_Principal_1__c(Name = 'DateOfBirth',GIACTName__c = 'DateOfBirth',Disabled__c=false,Field_Path__c='ValuePlus__r.MC_Principal_1_DOB__c', HardcodedValue__c=null, Required__c=false, LevelName__c='customer'));		
		GVF_MyCase_prin1.add(new GVF_MyCase_Principal_1__c(Name = 'State-1',GIACTName__c = 'State',Disabled__c=false,Field_Path__c='ValuePlus__r.MC_Principal_1_State__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
		GVF_MyCase_prin1.add(new GVF_MyCase_Principal_1__c(Name = 'TaxId-1',GIACTName__c = 'TaxId',Disabled__c=false,Field_Path__c='ValuePlus__r.MC_Principal_1_SSN__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
		GVF_MyCase_prin1.add(new GVF_MyCase_Principal_1__c(Name = 'ZipCode-1',GIACTName__c = 'ZipCode',Disabled__c=false,Field_Path__c='ValuePlus__r.MC_Principal_1_Zip__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
		insert GVF_MyCase_prin1;

		List<GVF_MyCase_Principal_2__c> GVF_MyCase_prin2 = new List<GVF_MyCase_Principal_2__c> ();
		GVF_MyCase_prin2.add(new GVF_MyCase_Principal_2__c(Name = 'BankName',GIACTName__c = 'BankName',Disabled__c=false,Field_Path__c='Account_Label__c', HardcodedValue__c=null, Required__c=false, LevelName__c=null));
		GVF_MyCase_prin2.add(new GVF_MyCase_Principal_2__c(Name = 'AccountNumber',GIACTName__c = 'AccountNumber',Disabled__c=false,Field_Path__c='AccountNo__c', HardcodedValue__c=null, Required__c=true, LevelName__c='check'));
		GVF_MyCase_prin2.add(new GVF_MyCase_Principal_2__c(Name = 'AccountType',GIACTName__c = 'AccountType',Disabled__c=false,Field_Path__c='Account_Type__c', HardcodedValue__c=null, Required__c=false, LevelName__c='check'));
		GVF_MyCase_prin2.add(new GVF_MyCase_Principal_2__c(Name = 'RoutingNumber',GIACTName__c = 'AccountNumber',Disabled__c=false,Field_Path__c='RoutingNo__c', HardcodedValue__c=null, Required__c=true, LevelName__c='check'));

		GVF_MyCase_prin2.add(new GVF_MyCase_Principal_2__c(Name = 'AddressLine1-2',GIACTName__c = 'AddressLine1',Disabled__c=false,Field_Path__c='ValuePlus__r.MC_Principal_2_Street__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
		GVF_MyCase_prin2.add(new GVF_MyCase_Principal_2__c(Name = 'FirstName-2',GIACTName__c = 'FirstName',Disabled__c=false,Field_Path__c='ValuePlus__r.MC_Principal_2_First_Name__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
		GVF_MyCase_prin2.add(new GVF_MyCase_Principal_2__c(Name = 'LastName-2',GIACTName__c = 'LastName',Disabled__c=false,Field_Path__c='ValuePlus__r.MC_Principal_2_Last_Name__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
		GVF_MyCase_prin2.add(new GVF_MyCase_Principal_2__c(Name = 'City-2',GIACTName__c = 'City',Disabled__c=false,Field_Path__c='ValuePlus__r.MC_Principal_2_City__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
		GVF_MyCase_prin2.add(new GVF_MyCase_Principal_2__c(Name = 'Country',GIACTName__c = 'Country',Disabled__c=false,Field_Path__c='ValuePlus__r.Account__r.ShippingCountry', HardcodedValue__c='US', Required__c=true, LevelName__c='customer'));
		GVF_MyCase_prin2.add(new GVF_MyCase_Principal_2__c(Name = 'DateOfBirth',GIACTName__c = 'DateOfBirth',Disabled__c=false,Field_Path__c='ValuePlus__r.MC_Principal_2_DOB__c', HardcodedValue__c=null, Required__c=false, LevelName__c='customer'));		
		GVF_MyCase_prin2.add(new GVF_MyCase_Principal_2__c(Name = 'State-2',GIACTName__c = 'State',Disabled__c=false,Field_Path__c='ValuePlus__r.MC_Principal_2_State__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
		GVF_MyCase_prin2.add(new GVF_MyCase_Principal_2__c(Name = 'TaxId-2',GIACTName__c = 'TaxId',Disabled__c=false,Field_Path__c='ValuePlus__r.MC_Principal_2_SSN__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
		GVF_MyCase_prin2.add(new GVF_MyCase_Principal_2__c(Name = 'ZipCode-2',GIACTName__c = 'ZipCode',Disabled__c=false,Field_Path__c='ValuePlus__r.MC_Principal_2_Zip__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
		insert GVF_MyCase_prin2;

		List<GVF_MyCase_Principal_3__c> GVF_MyCase_prin3 = new List<GVF_MyCase_Principal_3__c> ();
		GVF_MyCase_prin3.add(new GVF_MyCase_Principal_3__c(Name = 'BankName',GIACTName__c = 'BankName',Disabled__c=false,Field_Path__c='Account_Label__c', HardcodedValue__c=null, Required__c=false, LevelName__c=null));
		GVF_MyCase_prin3.add(new GVF_MyCase_Principal_3__c(Name = 'AccountNumber',GIACTName__c = 'AccountNumber',Disabled__c=false,Field_Path__c='AccountNo__c', HardcodedValue__c=null, Required__c=true, LevelName__c='check'));
		GVF_MyCase_prin3.add(new GVF_MyCase_Principal_3__c(Name = 'AccountType',GIACTName__c = 'AccountType',Disabled__c=false,Field_Path__c='Account_Type__c', HardcodedValue__c=null, Required__c=false, LevelName__c='check'));
		GVF_MyCase_prin3.add(new GVF_MyCase_Principal_3__c(Name = 'RoutingNumber',GIACTName__c = 'AccountNumber',Disabled__c=false,Field_Path__c='RoutingNo__c', HardcodedValue__c=null, Required__c=true, LevelName__c='check'));

		GVF_MyCase_prin3.add(new GVF_MyCase_Principal_3__c(Name = 'AddressLine1-3',GIACTName__c = 'AddressLine1',Disabled__c=false,Field_Path__c='ValuePlus__r.MC_Principal_3_Street__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
		GVF_MyCase_prin3.add(new GVF_MyCase_Principal_3__c(Name = 'FirstName-3',GIACTName__c = 'FirstName',Disabled__c=false,Field_Path__c='ValuePlus__r.MC_Principal_3_First_Name__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
		GVF_MyCase_prin3.add(new GVF_MyCase_Principal_3__c(Name = 'LastName-3',GIACTName__c = 'LastName',Disabled__c=false,Field_Path__c='ValuePlus__r.MC_Principal_3_Last_Name__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
		GVF_MyCase_prin3.add(new GVF_MyCase_Principal_3__c(Name = 'City-3',GIACTName__c = 'City',Disabled__c=false,Field_Path__c='ValuePlus__r.MC_Principal_3_City__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
		GVF_MyCase_prin3.add(new GVF_MyCase_Principal_3__c(Name = 'Country',GIACTName__c = 'Country',Disabled__c=false,Field_Path__c='ValuePlus__r.Account__r.ShippingCountry', HardcodedValue__c='US', Required__c=true, LevelName__c='customer'));
		GVF_MyCase_prin3.add(new GVF_MyCase_Principal_3__c(Name = 'DateOfBirth',GIACTName__c = 'DateOfBirth',Disabled__c=false,Field_Path__c='ValuePlus__r.MC_Principal_3_DOB__c', HardcodedValue__c=null, Required__c=false, LevelName__c='customer'));		
		GVF_MyCase_prin3.add(new GVF_MyCase_Principal_3__c(Name = 'State-3',GIACTName__c = 'State',Disabled__c=false,Field_Path__c='ValuePlus__r.MC_Principal_3_State__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
		GVF_MyCase_prin3.add(new GVF_MyCase_Principal_3__c(Name = 'TaxId-3',GIACTName__c = 'TaxId',Disabled__c=false,Field_Path__c='ValuePlus__r.MC_Principal_3_SSN__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
		GVF_MyCase_prin3.add(new GVF_MyCase_Principal_3__c(Name = 'ZipCode-3',GIACTName__c = 'ZipCode',Disabled__c=false,Field_Path__c='ValuePlus__r.MC_Principal_3_Zip__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
		insert GVF_MyCase_prin3;

		List<GVF_MyCase_Principal_4__c> GVF_MyCase_prin4 = new List<GVF_MyCase_Principal_4__c> ();
		GVF_MyCase_prin4.add(new GVF_MyCase_Principal_4__c(Name = 'BankName',GIACTName__c = 'BankName',Disabled__c=false,Field_Path__c='Account_Label__c', HardcodedValue__c=null, Required__c=false, LevelName__c=null));
		GVF_MyCase_prin4.add(new GVF_MyCase_Principal_4__c(Name = 'AccountNumber',GIACTName__c = 'AccountNumber',Disabled__c=false,Field_Path__c='AccountNo__c', HardcodedValue__c=null, Required__c=true, LevelName__c='check'));
		GVF_MyCase_prin4.add(new GVF_MyCase_Principal_4__c(Name = 'AccountType',GIACTName__c = 'AccountType',Disabled__c=false,Field_Path__c='Account_Type__c', HardcodedValue__c=null, Required__c=false, LevelName__c='check'));
		GVF_MyCase_prin4.add(new GVF_MyCase_Principal_4__c(Name = 'RoutingNumber',GIACTName__c = 'AccountNumber',Disabled__c=false,Field_Path__c='RoutingNo__c', HardcodedValue__c=null, Required__c=true, LevelName__c='check'));

		GVF_MyCase_prin4.add(new GVF_MyCase_Principal_4__c(Name = 'AddressLine1-4',GIACTName__c = 'AddressLine1',Disabled__c=false,Field_Path__c='ValuePlus__r.Principal_4_Street__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
		GVF_MyCase_prin4.add(new GVF_MyCase_Principal_4__c(Name = 'FirstName-4',GIACTName__c = 'FirstName',Disabled__c=false,Field_Path__c='ValuePlus__r.MC_Principal_4_First_Name__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
		GVF_MyCase_prin4.add(new GVF_MyCase_Principal_4__c(Name = 'LastName-4',GIACTName__c = 'LastName',Disabled__c=false,Field_Path__c='ValuePlus__r.MC_Principal_4_Last_Name__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
		GVF_MyCase_prin4.add(new GVF_MyCase_Principal_4__c(Name = 'City-4',GIACTName__c = 'City',Disabled__c=false,Field_Path__c='ValuePlus__r.MC_Principal_4_City__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
		GVF_MyCase_prin4.add(new GVF_MyCase_Principal_4__c(Name = 'Country',GIACTName__c = 'Country',Disabled__c=false,Field_Path__c='ValuePlus__r.Account__r.ShippingCountry', HardcodedValue__c='US', Required__c=true, LevelName__c='customer'));
		GVF_MyCase_prin4.add(new GVF_MyCase_Principal_4__c(Name = 'DateOfBirth',GIACTName__c = 'DateOfBirth',Disabled__c=false,Field_Path__c='ValuePlus__r.MC_Principal_4_DOB__c', HardcodedValue__c=null, Required__c=false, LevelName__c='customer'));		
		GVF_MyCase_prin4.add(new GVF_MyCase_Principal_4__c(Name = 'State-4',GIACTName__c = 'State',Disabled__c=false,Field_Path__c='ValuePlus__r.MC_Principal_4_State__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
		GVF_MyCase_prin4.add(new GVF_MyCase_Principal_4__c(Name = 'TaxId-4',GIACTName__c = 'TaxId',Disabled__c=false,Field_Path__c='ValuePlus__r.Principal_4_SSN__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
		GVF_MyCase_prin4.add(new GVF_MyCase_Principal_4__c(Name = 'ZipCode-4',GIACTName__c = 'ZipCode',Disabled__c=false,Field_Path__c='ValuePlus__r.MC_Principal_4_Zip__c', HardcodedValue__c=null, Required__c=true, LevelName__c='customer'));
		insert GVF_MyCase_prin4;
	}	


   static Bank_Account__c testDateGVerify1 (String acntRecordTypeName, String vPlusRecordTypeName, String OwnershipType, Decimal reqVersion) {

		createIntegSvcCustSetting ();

		Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(acntRecordTypeName).getRecordTypeId();
		if (vPlusRecordTypeName=='APM Payments') {
			System.debug('Inserting custom setting ');
    		// createGVFAPMCustomSetting ();
		} else {
    		createGVFMyCaseCustomSetting ();
		}

    	// Create an Account
		Account account = TestDataFactory.createAccountList(1, false)[0];
		account.Name = 'GiactVerify Test Account';
		account.RecordTypeId = recTypeId;
		account.Tax_ID__c = '857694857';
		account.Ownership_Type__c = OwnershipType;
		account.ShippingStreet = '50 Castilian Drive';
		account.ShippingCity = 'Goleta';
		account.ShippingState = 'CA';
		account.ShippingPostalCode = '93117';
		account.BillingStreet = '50 Castilian Drive';
		account.BillingCity = 'Goleta';
		account.BillingCountry = 'US';
		account.BillingPostalCode = '93117';

		account.Principal_1_First_Name__c = 'Rohit1';
		account.Principal_1_Last_Name__c = 'Malik1';
		account.Principal_1_SSN__c = '576857461';

		account.Principal_2_First_Name__c = 'Rohit2';
		account.Principal_2_Last_Name__c = 'Malik2';
		account.Principal_2_SSN__c = '576857462';

		account.Principal_3_First_Name__c = 'Rohit3';
		account.Principal_3_Last_Name__c = 'Malik3';
		account.Principal_3_SSN__c = '576857463';

		account.Principal_4_First_Name__c = 'Rohit4';
		account.Principal_4_Last_Name__c = 'Malik4';
		account.Principal_4_SSN__c = '576857464';


		account.Full_Company_Name_Legal__c = 'GiactVerify Test Account';
		insert account;

		String email = 'test.one@appfolio.com';
		Contact contact = TestDataFactory.createContactList(1, account.Id, false)[0];
		contact.FirstName = 'Giact FirstName';
		contact.LastName = 'Giact LastName';
		contact.Email = email;
		insert contact;


	 	Id vPlusRecTypeId = ValuePlus__c.sObjectType.getDescribe().getRecordTypeInfosByName().get(vPlusRecordTypeName).getRecordTypeId();
		ValuePlus__c vp = TestDataFactory.createValuePlusList(1, account.id, false)[0];
		vp.RecordTypeid = vPlusRecTypeId;
		vp.Stage__c = 'Live';
        insert vp;

		Bank_Account__c ba = TestDataFactory.createBankAccountList(1, vp.Id, false)[0];
		ba.RoutingNo__c = '264171209';
		ba.AccountNo__c = '2306145';
		ba.Account_Label__c = 'Tenant Deposit Account';
		ba.GiactStatus__c = 'Ready to Transmit to GIACT';
		ba.GiactRequestVersion__c = reqVersion;
        ba.MyCase_Account_Type__c = 'Operating';
        insert ba; 

        return ba;
	}


	static ValuePlus__c testDateGIdentify1 (String acntRecordTypeName, String vPlusRecordTypeName, String OwnershipType, Decimal reqVersion) {

		createIntegSvcCustSetting ();

		// Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(acntRecordTypeName).getRecordTypeId();
		if (vPlusRecordTypeName=='APM Payments') {
			System.debug('Inserting custom setting ');
    		// createGIDAPMCustomSetting ();
		} else {
    		createGIDMyCaseCustomSetting ();
		}

    	// Create an Account
		Account account = TestDataFactory.createAccountList(1, false)[0];
		account.Name = 'GiactVerify Test Account';
		// account.RecordTypeId = recTypeId;
		account.Tax_ID__c = '857694857';
		account.Ownership_Type__c = OwnershipType;
		account.ShippingStreet = '50 Castilian Drive';
		account.ShippingCity = 'Goleta';
		account.ShippingState = 'CA';
		account.ShippingPostalCode = '93117';
		account.BillingStreet = '50 Castilian Drive';
		account.BillingCity = 'Goleta';
		account.BillingCountry = 'US';
		account.BillingPostalCode = '93117';
		account.Tax_Id__C = '908987658';

		account.Principal_1_First_Name__c = 'Rohit1';
		account.Principal_1_Last_Name__c = 'Malik1';
		account.Principal_1_SSN__c = '576857461';
		account.Principal_1_Street__c = '50 Castilian Drive';
		account.Principal_1_City__c = 'Goleta';
		account.ShippingCountry = 'US';
		account.Principal_1_DOB__c = date.newInstance(1971, 09, 09);
		account.Principal_1_State__c = 'CA';
		account.Principal_1_Zip__c = '93117';

		account.Principal_2_First_Name__c = 'Rohit2';
		account.Principal_2_Last_Name__c = 'Malik2';
		account.Principal_2_SSN__c = '576857462';
		account.Principal_2_Street__c = '50 Castilian Drive';
		account.Principal_2_City__c = 'Goleta';
		account.ShippingCountry = 'US';
		account.Principal_2_DOB__c = date.newInstance(1971, 09, 09);
		account.Principal_2_State__c = 'CA';
		account.Principal_2_Zip__c = '93117';

		account.Principal_3_First_Name__c = 'Rohit3';
		account.Principal_3_Last_Name__c = 'Malik3';
		account.Principal_3_SSN__c = '576857463';
		account.Principal_3_Street__c = '50 Castilian Drive';
		account.Principal_3_City__c = 'Goleta';
		account.ShippingCountry = 'US';
		account.Principal_3_DOB__c = date.newInstance(1971, 09, 09);
		account.Principal_3_State__c = 'CA';
		account.Principal_3_Zip__c = '93117';		

		account.Principal_4_First_Name__c='Rohit4';
		account.Principal_4_Last_Name__c='Malik4';
		account.Principal_4_SSN__c = '576857464';
		account.Principal_4_Street__c = '50 Castilian Drive';
		account.Principal_4_City__c = 'Goleta';
		account.ShippingCountry = 'US';
		account.Principal_4_DOB__c = date.newInstance(1971, 09, 09);
		account.Principal_4_State__c = 'CA';
		account.Principal_4_Zip__c = '93117';				

		account.Full_Company_Name_Legal__c = 'GiactVerify Test Account';
		insert account;

		String email = 'test.one@appfolio.com';
		Contact contact = TestDataFactory.createContactList(1, account.Id, false)[0];
		contact.FirstName = 'Giact FirstName';
		contact.LastName = 'Giact LastName';
		contact.LeadSource = 'Add On';
		contact.Lead_Channel__c = 'Add On';
		contact.Email = email;
		insert contact;


	 	Id vPlusRecTypeId = ValuePlus__c.sObjectType.getDescribe().getRecordTypeInfosByName().get(vPlusRecordTypeName).getRecordTypeId();
		ValuePlus__c vp = TestDataFactory.createValuePlusList(1, account.id, false)[0];
		vp.RecordTypeid = vPlusRecTypeId;
		vp.Stage__c = 'Sold/Not Started';
	 	return vp;
	}

	static ValuePlus__c testData_MyCase (String acntRecordTypeName, String vPlusRecordTypeName, String OwnershipType, Decimal reqVersion) {

		createIntegSvcCustSetting ();

		// Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(acntRecordTypeName).getRecordTypeId();
	 	Id vPlusRecTypeId = ValuePlus__c.sObjectType.getDescribe().getRecordTypeInfosByName().get(vPlusRecordTypeName).getRecordTypeId();

		if (vPlusRecordTypeName=='APM Payments') {
			System.debug('Inserting custom setting ');
    		// createGIDAPMCustomSetting ();
		} else {
    		createGIDMyCaseCustomSetting ();
		}

    	// Create an Account
		Account account = TestDataFactory.createAccountList(1, false)[0];
		account.Name = 'GiactVerify Test Account';
		// account.RecordTypeId = recTypeId;
		account.Tax_ID__c = '857694857';
		account.Ownership_Type__c = OwnershipType;
		account.ShippingStreet = '50 Castilian Drive';
		account.ShippingCity = 'Goleta';
		account.ShippingState = 'CA';
		account.ShippingPostalCode = '93117';
		account.BillingStreet = '50 Castilian Drive';
		account.BillingCity = 'Goleta';
		account.BillingCountry = 'US';
		account.BillingPostalCode = '93117';
		account.Tax_Id__C = '908987658';
		insert account;

		String email = 'test.one@appfolio.com';
		Contact contact = TestDataFactory.createContactList(1, account.Id, false)[0];
		contact.FirstName = 'Giact FirstName';
		contact.LastName = 'Giact LastName';
		contact.Email = email;
		contact.LeadSource = 'Add On';
		contact.Lead_Channel__c = 'Add On';
		insert contact;

		ValuePlus__c vp = TestDataFactory.createValuePlusList(1, account.id, false)[0];
		vp.RecordTypeid = vPlusRecTypeId;
		vp.Stage__c = 'Sold/Not Started';
        vp.Tax_Id__C = '989765432';
		vp.MC_Principal_1_First_Name__c = 'Rohit1';
		vp.MC_Principal_1_Last_Name__c = 'Malik1';
		vp.MC_Principal_1_SSN__c = '576857461';
		vp.MC_Principal_1_Street__c = '50 Castilian Drive';
		vp.MC_Principal_1_City__c = 'Goleta';		
		vp.MC_Principal_1_DOB__c = date.newInstance(1971, 09, 09);
		vp.MC_Principal_1_State__c = 'CA';
		vp.MC_Principal_1_Zip__c = '93117';


		vp.MC_Principal_2_First_Name__c = 'Rohit1';
		vp.MC_Principal_2_Last_Name__c = 'Malik1';
		vp.MC_Principal_2_SSN__c = '576857461';
		vp.MC_Principal_2_Street__c = '50 Castilian Drive';
		vp.MC_Principal_2_City__c = 'Goleta';
		vp.MC_Principal_2_DOB__c = date.newInstance(1971, 09, 09);
		vp.MC_Principal_2_State__c = 'CA';
		vp.MC_Principal_2_Zip__c = '93117';


		vp.MC_Principal_3_First_Name__c = 'Rohit1';
		vp.MC_Principal_3_Last_Name__c = 'Malik1';
		vp.MC_Principal_3_SSN__c = '576857461';
		vp.MC_Principal_3_Street__c = '50 Castilian Drive';
		vp.MC_Principal_3_City__c = 'Goleta';
		vp.MC_Principal_3_DOB__c = date.newInstance(1971, 09, 09);
		vp.MC_Principal_3_State__c = 'CA';
		vp.MC_Principal_3_Zip__c = '93117';


		vp.MC_Principal_4_First_Name__c = 'Rohit1';
		vp.MC_Principal_4_Last_Name__c = 'Malik1';
		vp.Principal_4_SSN__c = '576857461';
		vp.Principal_4_Street__c = '50 Castilian Drive';
		vp.MC_Principal_4_City__c = 'Goleta';
		vp.MC_Principal_4_DOB__c = date.newInstance(1971, 09, 09);
		vp.MC_Principal_4_State__c = 'CA';
		vp.MC_Principal_4_Zip__c = '93117';

		return vp;
	}

	static Map<String, String> responseHeaders = new Map<String, String> {
        'Content-Type' => 'application/json'};
    // static testMethod void testGiactVerifySoleProprieterBusiness () {

       	 
	// 	List<String> l_resp_body = new List<String> {bizResponse};

	// 	Test.setMock(HttpCalloutMock.class, new HttpMockTestTemplate(new List<Integer>{200}, 'OK', l_resp_body, 
    //                                                                                    responseHeaders));

    //     Test.startTest();	
	// 	Bank_Account__c ba = testDateGVerify1 ('Property Management', 'APM Payments', 'Sole Proprietor', null);
    //     ba.GiactStatus__c = 'Ready to Transmit to GIACT';
    //     update ba;
	// 	Test.stopTest();
	// }

	// static testMethod void testGiactIdentifyAPMBusiness () {
	// 	List<String> l_resp_body = new List<String> {bizResponse, bizAdvResponse};
	// 	Test.setMock(HttpCalloutMock.class, new HttpMockTestTemplate(new List<Integer>{200, 200}, 'OK', l_resp_body, 
    //                                                                                    responseHeaders));

    //     Test.startTest();	
	// 	ValuePlus__c vp = testDateGIdentify1 ('Property Management', 'APM Payments', 'Sole Proprietor', null);
    // 	vp.GIACTBusinessValidation__c = 'Ready To Transmit To GIACT';
    // 	vp.Stage__c='Sold/Not Started';
    //     vp.GIACTBusinessOwner_1_Validation__c = null;
    //     vp.GIACTBusinessOwner_2_Validation__c = null;
    //     vp.GIACTBusinessOwner_3_Validation__c = null;        
    //     vp.GIACTBusinessOwner_4_Validation__c = null;
    //     vp.TIN_Match__c = null;   

    //     System.debug('Updating the record.');    
    // 	insert vp;

	// 	Test.stopTest();
	// 	List<GIACTIdentifyResponses__c> responses = [Select id from GIACTIdentifyResponses__c where ValuePlus__c = :vp.Id];
	// 	System.assertNotEquals(null, responses.size());
	// }

	// static testMethod void testGiactIdentifyAPMBusinessError () {
	// 	List<String> l_resp_body = new List<String> {bizResponse, bizAdvResponseError};
	// 	Test.setMock(HttpCalloutMock.class, new HttpMockTestTemplate(new List<Integer>{200, 200}, 'OK', l_resp_body, 
    //                                                                                    responseHeaders));

    //     Test.startTest();	
	// 	ValuePlus__c vp = testDateGIdentify1 ('Property Management', 'APM Payments', 'Sole Proprietor', null);
    // 	vp.GIACTBusinessValidation__c = 'Ready To Transmit To GIACT';
    // 	vp.Stage__c='Sold/Not Started';
    //     vp.GIACTBusinessOwner_1_Validation__c = null;
    //     vp.GIACTBusinessOwner_2_Validation__c = null;
    //     vp.GIACTBusinessOwner_3_Validation__c = null;        
    //     vp.GIACTBusinessOwner_4_Validation__c = null;
    //     vp.TIN_Match__c = null;   

    //     System.debug('Updating the record.');    
    // 	insert vp;

	// 	Test.stopTest();
	// 	List<GIACTIdentifyResponses__c> responses = [Select id from GIACTIdentifyResponses__c where ValuePlus__c = :vp.Id];
	// 	System.assertNotEquals(null, responses.size());
	// }

	// static testMethod void testGID_APM_Principal1 () {
	// 	List<String> l_resp_body = new List<String> {personBasicResponse, personAdvancedResponse};

	// 	Test.setMock(HttpCalloutMock.class, new HttpMockTestTemplate(new List<Integer>{200, 200}, 'OK', l_resp_body, 
    //                                                                                    responseHeaders));

    //     Test.startTest();	
	// 	ValuePlus__c vp = testDateGIdentify1 ('Property Management', 'APM Payments', 'Sole Proprietor', null);
    // 	vp.GIACTBusinessValidation__c = null;
    //     vp.GIACTBusinessOwner_1_Validation__c = 'Ready To Transmit To GIACT';
    //     vp.GIACTBusinessOwner_2_Validation__c = null;
    //     vp.GIACTBusinessOwner_3_Validation__c = null;        
    //     vp.GIACTBusinessOwner_4_Validation__c = null;
    //     vp.TIN_Match__c = null;       
    // 	insert vp;

	// 	Test.stopTest();
	// }

	// static testMethod void testGID_APM_Principal1SoleProp () {
	// 	List<String> l_resp_body = new List<String> {personBasicResponse, personAdvancedResponse};

	// 	Test.setMock(HttpCalloutMock.class, new HttpMockTestTemplate(new List<Integer>{200, 200}, 'OK', l_resp_body, 
    //                                                                                    responseHeaders));

    //     Test.startTest();	
	// 	ValuePlus__c vp = testDateGIdentify1 ('Property Management', 'APM Payments', 'Sole Proprietor', null);
    // 	vp.GIACTBusinessValidation__c = null;
    //     vp.GIACTBusinessOwner_1_Validation__c = 'Ready To Transmit To GIACT';
    //     vp.GIACTBusinessOwner_2_Validation__c = null;
    //     vp.GIACTBusinessOwner_3_Validation__c = null;        
    //     vp.GIACTBusinessOwner_4_Validation__c = null;
    //     vp.TIN_Match__c = null;       
    // 	insert vp;

	// 	Test.stopTest();
	// }

	// static testMethod void testGID_APM_Principal2 () {
	// 	List<String> l_resp_body = new List<String> {personBasicResponse, personAdvancedResponse};

	// 	Test.setMock(HttpCalloutMock.class, new HttpMockTestTemplate(new List<Integer>{200}, 'OK', l_resp_body, 
    //                                                                                    responseHeaders));

    //     Test.startTest();	
	// 	ValuePlus__c vp = testDateGIdentify1 ('Property Management', 'APM Payments', 'Sole Proprietor', null);
    //     vp.GIACTBusinessValidation__c = null;
    //     vp.GIACTBusinessOwner_1_Validation__c = null;
    //     vp.GIACTBusinessOwner_2_Validation__c = 'Ready To Transmit To GIACT';
    //     vp.GIACTBusinessOwner_3_Validation__c = null;        
    //     vp.GIACTBusinessOwner_4_Validation__c = null;
    //     vp.TIN_Match__c = null;       
    // 	insert vp;

	// 	Test.stopTest();
	// }

	// static testMethod void testGID_APM_Principal3 () {
	// 	List<String> l_resp_body = new List<String> {personBasicResponse, personAdvancedResponse};

	// 	Test.setMock(HttpCalloutMock.class, new HttpMockTestTemplate(new List<Integer>{200}, 'OK', l_resp_body, 
    //                                                                                    responseHeaders));

    //     Test.startTest();	
	// 	ValuePlus__c vp = testDateGIdentify1 ('Property Management', 'APM Payments', 'Sole Proprietor', null);
    //     vp.GIACTBusinessValidation__c = null;
    //     vp.GIACTBusinessOwner_1_Validation__c = null;
    //     vp.GIACTBusinessOwner_2_Validation__c = null;
    //     vp.GIACTBusinessOwner_3_Validation__c = 'Ready To Transmit To GIACT';        
    //     vp.GIACTBusinessOwner_4_Validation__c = null;
    //     vp.TIN_Match__c = null;       
    // 	insert vp;
	// 	Test.stopTest();
	// }

	// static testMethod void testGID_APM_Principal4 () {
	// 	List<String> l_resp_body = new List<String> {personBasicResponseError, personAdvancedResponse};

	// 	Test.setMock(HttpCalloutMock.class, new HttpMockTestTemplate(new List<Integer>{200}, 'OK', l_resp_body, 
    //                                                                                    responseHeaders));

    //     Test.startTest();	
	// 	ValuePlus__c vp = testDateGIdentify1 ('Property Management', 'APM Payments', 'Sole Proprietor', null);
	// 	vp.GIACTBusinessValidation__c = null;
    //     vp.GIACTBusinessOwner_1_Validation__c = null;
    //     vp.GIACTBusinessOwner_2_Validation__c = null;
    //     vp.GIACTBusinessOwner_3_Validation__c = null;
    //     vp.GIACTBusinessOwner_4_Validation__c = 'Ready To Transmit To GIACT'; 
    //     vp.TIN_Match__c = null;
    // 	insert vp;        
	// 	Test.stopTest();
	// }
static testMethod void testGiactIdentifyMyCaseBusiness () {
		List<String> l_resp_body = new List<String> {bizResponse, bizAdvResponse};
		Test.setMock(HttpCalloutMock.class, new HttpMockTestTemplate(new List<Integer>{200, 200}, 'OK', l_resp_body, 
                                                                                       responseHeaders));

        Test.startTest();	
		ValuePlus__c vp = testData_MyCase ('', 'MyCase Payments', 'LLC', null);
    	vp.GIACTBusinessValidation__c = 'Ready To Transmit To GIACT';
        vp.GIACTBusinessOwner_1_Validation__c = null;
        vp.GIACTBusinessOwner_2_Validation__c = null;
        vp.GIACTBusinessOwner_3_Validation__c = null;        
        vp.GIACTBusinessOwner_4_Validation__c = null;
        vp.TIN_Match__c = null;       
    	insert vp;

		Test.stopTest();
	}

	static testMethod void testGID_MyCase_Principal1 () {
		List<String> l_resp_body = new List<String> {personBasicResponse, personAdvancedResponse};

		Test.setMock(HttpCalloutMock.class, new HttpMockTestTemplate(new List<Integer>{200, 200}, 'OK', l_resp_body, 
                                                                                       responseHeaders));

        Test.startTest();	
		ValuePlus__c vp = testData_MyCase ('Property Management', 'MyCase Payments', 'LLC', null);
    	vp.GIACTBusinessValidation__c = null;
        vp.GIACTBusinessOwner_1_Validation__c = 'Ready To Transmit To GIACT';
        vp.GIACTBusinessOwner_2_Validation__c = null;
        vp.GIACTBusinessOwner_3_Validation__c = null;        
        vp.GIACTBusinessOwner_4_Validation__c = null;
        vp.TIN_Match__c = null;       
    	insert vp;

		Test.stopTest();
	}

	static testMethod void testGID_MyCase_Principal2 () {
		List<String> l_resp_body = new List<String> {personBasicResponse, personAdvancedResponse};

		Test.setMock(HttpCalloutMock.class, new HttpMockTestTemplate(new List<Integer>{200}, 'OK', l_resp_body, 
                                                                                       responseHeaders));

        Test.startTest();	
		ValuePlus__c vp = testData_MyCase ('Property Management', 'MyCase Payments', 'LLC', null);
        vp.GIACTBusinessValidation__c = null;
        vp.GIACTBusinessOwner_1_Validation__c = null;
        vp.GIACTBusinessOwner_2_Validation__c = 'Ready To Transmit To GIACT';
        vp.GIACTBusinessOwner_3_Validation__c = null;        
        vp.GIACTBusinessOwner_4_Validation__c = null;
        vp.TIN_Match__c = null;       
    	insert vp;

		Test.stopTest();
	}

	static testMethod void testGID_MyCase_Principal3 () {
		List<String> l_resp_body = new List<String> {personBasicResponse, personAdvancedResponse};

		Test.setMock(HttpCalloutMock.class, new HttpMockTestTemplate(new List<Integer>{200}, 'OK', l_resp_body, 
                                                                                       responseHeaders));

        Test.startTest();	
		ValuePlus__c vp = testData_MyCase ('Property Management', 'MyCase Payments', 'LLC', null);
        vp.GIACTBusinessValidation__c = null;
        vp.GIACTBusinessOwner_1_Validation__c = null;
        vp.GIACTBusinessOwner_2_Validation__c = null;
        vp.GIACTBusinessOwner_3_Validation__c = 'Ready To Transmit To GIACT';        
        vp.GIACTBusinessOwner_4_Validation__c = null;
        vp.TIN_Match__c = null;       
    	insert vp;        
		Test.stopTest();
	}

	static testMethod void testGID_MyCase_Principal4 () {
		List<String> l_resp_body = new List<String> {personBasicResponseError, personAdvancedResponse};

		Test.setMock(HttpCalloutMock.class, new HttpMockTestTemplate(new List<Integer>{200}, 'OK', l_resp_body, 
                                                                                       responseHeaders));

        Test.startTest();	
		ValuePlus__c vp = testData_MyCase ('Property Management', 'MyCase Payments', 'LLC', null);
		vp.GIACTBusinessValidation__c = null;
        vp.GIACTBusinessOwner_1_Validation__c = null;
        vp.GIACTBusinessOwner_2_Validation__c = null;
        vp.GIACTBusinessOwner_3_Validation__c = null;
        vp.GIACTBusinessOwner_4_Validation__c = 'Ready To Transmit To GIACT'; 
        vp.TIN_Match__c = null;
    	insert vp;
		Test.stopTest();
	}

	// static testMethod void testGiactVerifyForAuthErr () {
    //    	TestGiactHttpMock mockResp = new TestGiactHttpMock('ACK_GOOD_AUTHERROR_RESPONSE_JSON');
    //     Test.setMock(HttpCalloutMock.class, mockResp);
    //     Test.startTest();	
	// 	Bank_Account__c ba = testDateGVerify1 ('Property Management', 'APM Payments', 'Partnership', 1.1);
    //     ba.GiactStatus__c = 'Ready to Transmit to GIACT';
    //     update ba;
	// 	//Id batchInstanceId = Database.executeBatch(new GiactVerifyService(), 1); 
	// 	Test.stopTest();
	// }

	// static testMethod void testGiactVerifyPartnserShipBusiness () {

    //    	String resp = '{"errors":[{"status":"400","title":"Invalid Inquiry","detail":"UniqueId cannot be longer than 50 characters."}]}';
    //    	TestGiactHttpMock mockResp = new TestGiactHttpMock(400, 'Failure', '400', resp);
    //     Test.setMock(HttpCalloutMock.class, mockResp);	
    //     Test.startTest();	
	// 	Bank_Account__c ba = testDateGVerify1 ('Property Management', 'APM Payments', 'Partnership', 0.0);
	// 	ba.GiactStatus__c = 'Ready to Transmit to GIACT';
	// 	GiactResponseResults.Errors errs =  GiactResponseResults.parseErrors(resp);
	// 	for (GiactResponseResults.error er : errs.errors) {
	// 		System.assertEquals(er.detail, 'UniqueId cannot be longer than 50 characters.');
	// 		System.assertEquals(er.title, 'Invalid Inquiry');
	// 		System.assertEquals(er.status, '400');
	// 	}

	// 	update ba;
	// 	//Id batchInstanceId = Database.executeBatch(new GiactVerifyService(), 1); 
	// 	Test.stopTest();
	// }

	// static testMethod void testGiactVerifyForGiactError () {
    //    	TestGiactHttpMock mockResp = new TestGiactHttpMock('ACK_ERR_400_RESPONSE_JSON');
    //     Test.setMock(HttpCalloutMock.class, mockResp);
    //     Test.startTest();	
	// 	Bank_Account__c ba = testDateGVerify1 ('Property Management', 'APM Payments', 'Partnership', 0.0);
    //     ba.GiactStatus__c = 'Ready to Transmit to GIACT';
    //     update ba;
	// 	//Id batchInstanceId = Database.executeBatch(new GiactVerifyService(), 1); 
	// 	Test.stopTest();
	// }


	// static testMethod void testFullSuccess () {

	// 	String resp = '{"ItemReferenceId":10043241053, "CreatedDate":"2017-10-11T19:51:05.4744298-05:00", "ErrorMessage":null, "VerificationResponse":6, "AccountResponseCode":12, "BankName":"BANK OF AMERICA N.A.", "AccountAddedDate":"2005-06-07T00:00:00", "AccountLastUpdatedDate":"2017-05-18T00:00:00", "AccountClosedDate":null, "BankAccountType":null, "VoidedCheckImage":null, "FundsConfirmationResult":null, "CustomerResponseCode":2, "MatchedPersonData":null, "ConsumerAlertMessages":null, "MatchedBusinessData":null, "OfacListPotentialMatches":null, "GIdentifyKbaResult":null, "EmailAddressInformationResult":null, "IpAddressInformationResult":null, "DomainRegistry":null, "MobileVerifyResult":null, "MobileIdentifyResult":null, "MobileLocationResult":null, "PhoneIntelligenceResult":null}';
		
	// 	TestGiactHttpMock mockResp = new TestGiactHttpMock(200, 'Success', '200', resp);
    //     Test.setMock(HttpCalloutMock.class, mockResp);	
    //     Test.startTest();
	// 	Bank_Account__c ba = testDateGVerify1 ('Property Management', 'APM Payments', 'Partnership', 0.0);
	// 	ba.GiactStatus__c = 'Ready to Transmit to GIACT';
	// 	GiactResponseResults.Errors errs =  GiactResponseResults.parseErrors(resp);
	// 	update ba;
	// 	//Id batchInstanceId = Database.executeBatch(new GiactVerifyService(), 1); 
	// 	Test.stopTest();		
	// }

	// static testMethod void testGIACTUtils () {
	// 	test.startTest ();
	// 	Bank_Account__c ba = testDateGVerify1 ('Property Management', 'APM Payments', 'Partnership', 1.1);
	// 	try {
	// 		GIACTUtils.extractRelatedField('randompath', ba);
	// 	} catch (Exception e) {
	// 		Boolean result = e instanceof SObjectException;
	// 		System.assertEquals(result, true);
	// 	}
	// 	test.stopTest();
	// }

	static testMethod void testSystemExceptionLogTriggerHandler () {
		SystemExceptionLogTriggerHandler.runBeforeUpdateOnce();
		SystemExceptionLogTriggerHandler.runAfterUpdateOnce();
		SystemExceptionLogTriggerHandler.runBeforeInsertOnce();
		SystemExceptionLogTriggerHandler.runAfterInsertOnce();

		BankAccountTriggerHandler.runBeforeUpdateOnce ();
		BankAccountTriggerHandler.runBeforeUpdateOnce ();
		BankAccountTriggerHandler.runBeforeInsertOnce ();
		BankAccountTriggerHandler.runBeforeInsertOnce ();
		BankAccountTriggerHandler.runAfterInsertOnce ();
		BankAccountTriggerHandler.runAfterInsertOnce ();		

		GiactShouldRun.stopTrigger ();
		GiactShouldRun.canIRun ();
		GIACTUtils.getRequiredFieldsForAPMIdentifyCall('GID APM Business', 'MyCase');
		GIACTUtils.getRequiredFieldsForAPMIdentifyCall('GID APM Principal 1', 'MyCase');
		GIACTUtils.getRequiredFieldsForAPMIdentifyCall('GID APM Principal 2', 'MyCase');
		GIACTUtils.getRequiredFieldsForAPMIdentifyCall('GID APM Principal 3', 'MyCase');
		GIACTUtils.getRequiredFieldsForAPMIdentifyCall('GID APM Principal 4', 'MyCase');
		GIACTUtils.getRequiredFieldsForAPMIdentifyCall('GID MyCase Business', 'MyCase');
		GIACTUtils.getRequiredFieldsForAPMIdentifyCall('GID MyCase Principal 1', 'MyCase');
		GIACTUtils.getRequiredFieldsForAPMIdentifyCall('GID MyCase Principal 2', 'MyCase');
		GIACTUtils.getRequiredFieldsForAPMIdentifyCall('GID MyCase Principal 3', 'MyCase');
		GIACTUtils.getRequiredFieldsForAPMIdentifyCall('GID MyCase Principal 4', 'MyCase');
		GIACTUtils.getRequiredFieldsForAPMIdentifyCall('GVF APM Business', 'MyCase');
		GIACTUtils.getRequiredFieldsForAPMIdentifyCall('GVF APM Principal 1', 'MyCase');
		GIACTUtils.getRequiredFieldsForAPMIdentifyCall('GVF APM Principal 2', 'MyCase');
		GIACTUtils.getRequiredFieldsForAPMIdentifyCall('GVF APM Principal 3', 'MyCase');
		GIACTUtils.getRequiredFieldsForAPMIdentifyCall('GVF APM Principal 4', 'MyCase');
		GIACTUtils.getRequiredFieldsForAPMIdentifyCall('GVF MyCase Business', 'MyCase');
		GIACTUtils.getRequiredFieldsForAPMIdentifyCall('GVF MyCase Principal 1', 'MyCase');
		GIACTUtils.getRequiredFieldsForAPMIdentifyCall('GVF MyCase Principal 2', 'MyCase');
		GIACTUtils.getRequiredFieldsForAPMIdentifyCall('GVF MyCase Principal 3', 'MyCase');
		GIACTUtils.getRequiredFieldsForAPMIdentifyCall('GVF MyCase Principal 4', 'MyCase');
		try {
			GIACTUtils.getRequiredFieldsForAPMIdentifyCall('GVF MyCase fasdfasdf 4', 'MyCase');
		} catch (Exception e) {

		}
		ValuePlus__c vp = testDateGIdentify1 ('', 'MyCase Payments', 'Sole Proprietor', null);
		vp.GIACTBusinessValidation__c = 'Ready To Transmit To GIACT';
        vp.GIACTBusinessOwner_1_Validation__c = 'Ready To Transmit To GIACT';
        vp.GIACTBusinessOwner_2_Validation__c = 'Ready To Transmit To GIACT';
        vp.GIACTBusinessOwner_3_Validation__c = 'Ready To Transmit To GIACT';
        vp.GIACTBusinessOwner_4_Validation__c = 'Ready To Transmit To GIACT';
        vp.TIN_Match__c ='Ready to Transmit';
		GIACTUtils.isReadyToTransmitToGiact (vp, 0);
		GIACTUtils.isReadyToTransmitToGiact (vp, 1);
		GIACTUtils.isReadyToTransmitToGiact (vp, 2);
		GIACTUtils.isReadyToTransmitToGiact (vp, 3);
		GIACTUtils.isReadyToTransmitToGiact (vp, 4);
		GIACTUtils.saveXMLAsPdf('Text', 'Temp.pdf');

		GIdentifyEntity gidEntity = new GIdentifyEntity ();
		GIdentifyEntity gidEntity1 = new GIdentifyEntity (vp.Id, true);
		gidEntity1.insertEntity();

		
		String parseStr = '{"UniqueId": "a0Bc0000005YvKpEAK-Business-2","GVerifyEnabled": true,"GOfacScanEnabled": null,"GIdentifyEnabled": false,"GAuthenticateEnabled": true,"Customer": {"ZipCode": "11787","TaxId": "421668135","State": "NY","Country": "US","City": "Smithtown","BusinessName": "Law Office of Lisa S. Fine P.C.","AddressLine1": "732 Smithtown Bypass, Suite A53","EntityType": "0"},"Check": {"RoutingNumber": "021407912","AccountType": "0","AccountNumber": "7527235396"}}';
		GiactIdentifyResponseResults.parse (parseStr);
		GIdentifyEntity dataHolder = new GIdentifyEntity();
		//GiactIdentifyResponseResults.parseAuthenticateLevel0(personBasicResponse, )
	}
	static testMethod void testTinCheckMethods () {
		List<String> l_resp_body = new List<String> {tincheckResponse};

        Test.startTest();
		TinCheckService.ADDRESS_RESPONSE addResp = new TinCheckService.ADDRESS_RESPONSE ();
		TinCheckService.BulkTinCheckObjectResponse_element bulkTincheckObjResp = new TinCheckService.BulkTinCheckObjectResponse_element ();
		TinCheckService.VersionResponse_element versionResp = new TinCheckService.VersionResponse_element ();
		TinCheckService.ArrayOfBulkUploadStatusItem aOfBulkUploadStatusItem = new TinCheckService.ArrayOfBulkUploadStatusItem ();
		TinCheckService.ServiceStatusResponse_element ServiceStatusResponse_element = new TinCheckService.ServiceStatusResponse_element ();
		TinCheckService.TINNAME_RESPONSE TINNAME_RESPONSE = new TinCheckService.TINNAME_RESPONSE ();
		TinCheckService.ServiceStatusResponse ServiceStatusResponse = new TinCheckService.ServiceStatusResponse ();
		TinCheckService.NV_RESPONSE NV_RESPONSE = new TinCheckService.NV_RESPONSE ();
		TinCheckService.ArrayOfBulkTinCheckRequestObject ArrayOfBulkTinCheckRequestObject = new TinCheckService.ArrayOfBulkTinCheckRequestObject ();
		TinCheckService.BulkTinCheckStatusResponse_element BulkTinCheckStatusResponse_element = new TinCheckService.BulkTinCheckStatusResponse_element ();		
		TinCheckService.OFAC_RESPONSE OFAC_RESPONSE = new TinCheckService.OFAC_RESPONSE ();
		TinCheckService.ServiceStatus_element ServiceStatus_element = new TinCheckService.ServiceStatus_element ();
		TinCheckService.MO_RESPONSE MO_RESPONSE = new TinCheckService.MO_RESPONSE ();
		TinCheckService.TINNAME_ADDRESS_LISTMATCH_RESPONSE TINNAME_ADDRESS_LISTMATCH_RESPONSE = new TinCheckService.TINNAME_ADDRESS_LISTMATCH_RESPONSE ();
		TinCheckService.BulkTinCheckStatus_element BulkTinCheckStatus_element = new TinCheckService.BulkTinCheckStatus_element ();	
		TinCheckService.BulkTinCheckResultResponse_element BulkTinCheckResultResponse_element = new TinCheckService.BulkTinCheckResultResponse_element ();		
		TinCheckService.NJ_RESPONSE NJ_RESPONSE = new TinCheckService.NJ_RESPONSE ();
		TinCheckService.Result Result = new TinCheckService.Result ();
		TinCheckService.ValidateListMatch_element ValidateListMatch_element = new TinCheckService.ValidateListMatch_element ();
		TinCheckService.BulkTinCheck_element BulkTinCheck_element = new TinCheckService.BulkTinCheck_element ();
		TinCheckService.BulkTinCheckRequestObject BulkTinCheckRequestObject = new TinCheckService.BulkTinCheckRequestObject ();
		TinCheckService.DPL_RESPONSE DPL_RESPONSE = new TinCheckService.DPL_RESPONSE ();
		TinCheckService.PEP_RESPONSE PEP_RESPONSE = new TinCheckService.PEP_RESPONSE ();
		TinCheckService.BulkTinCheckResponse_element BulkTinCheckResponse_element = new TinCheckService.BulkTinCheckResponse_element ();
		TinCheckService.IL_RESPONSE IL_RESPONSE = new TinCheckService.IL_RESPONSE ();
		TinCheckService.ValidateTinNameAddressListMatchResponse_element ValidateTinNameAddressListMatchResponse_element = new TinCheckService.ValidateTinNameAddressListMatchResponse_element ();	
		TinCheckService.BulkTinCheckResult_element BulkTinCheckResult_element = new TinCheckService.BulkTinCheckResult_element ();
		TinCheckService.TinNameClass TinNameClass = new TinCheckService.TinNameClass ();
		TinCheckService.MS_RESPONSE MS_RESPONSE = new TinCheckService.MS_RESPONSE ();
		TinCheckService.ArrayOfResult ArrayOfResult = new TinCheckService.ArrayOfResult ();		
		TinCheckService.EPLS_RESPONSE EPLS_RESPONSE = new TinCheckService.EPLS_RESPONSE ();			
		TinCheckService.Version_element Version_element = new TinCheckService.Version_element ();
		TinCheckService.BulkResponse BulkResponse = new TinCheckService.BulkResponse ();			
		TinCheckService.ValidateTinNameResponse_element ValidateTinNameResponse_element = new TinCheckService.ValidateTinNameResponse_element ();				
		TinCheckService.LISTMATCH_RESPONSE LISTMATCH_RESPONSE = new TinCheckService.LISTMATCH_RESPONSE ();
		TinCheckService.BulkTinCheckFileResponse BulkTinCheckFileResponse = new TinCheckService.BulkTinCheckFileResponse ();
		TinCheckService.UserClass UserClass = new TinCheckService.UserClass ();
		TinCheckService.ValidateTinName_element ValidateTinName_element = new TinCheckService.ValidateTinName_element ();
		TinCheckService.BulkUploadStatusResponse BulkUploadStatusResponse = new TinCheckService.BulkUploadStatusResponse ();
		TinCheckService.BulkUploadStatusItem BulkUploadStatusItem = new TinCheckService.BulkUploadStatusItem ();
		TinCheckService.BulkTinCheckRequest BulkTinCheckRequest = new TinCheckService.BulkTinCheckRequest ();
		TinCheckService.HHS_RESPONSE HHS_RESPONSE = new TinCheckService.HHS_RESPONSE ();
		TinCheckService.ValidateListMatchResponse_element ValidateListMatchResponse_element = new TinCheckService.ValidateListMatchResponse_element ();		
		TinCheckService.USPSAddressClass USPSAddressClass = new TinCheckService.USPSAddressClass ();			
		TinCheckService.BulkTinCheckObject_element BulkTinCheckObject_element = new TinCheckService.BulkTinCheckObject_element ();
		TinCheckService.PVSServiceSoap PVSServiceSoap1 = new TinCheckService.PVSServiceSoap ();

		//PVSServiceSoap1.ServiceStatus(UserClass);
		Test.setMock(HttpCalloutMock.class, new HttpMockTestTemplate(new List<Integer>{200}, 'OK', l_resp_body, 
                                                                                       responseHeaders));

		PVSServiceSoap1.BulkTinCheckResult(123, UserClass);
		Test.setMock(HttpCalloutMock.class, new HttpMockTestTemplate(new List<Integer>{200}, 'OK', l_resp_body, 
                                                                                       responseHeaders));

		PVSServiceSoap1.Version ();
		Test.setMock(HttpCalloutMock.class, new HttpMockTestTemplate(new List<Integer>{200}, 'OK', l_resp_body, 
                                                                                       responseHeaders));

		PVSServiceSoap1.BulkTinCheckStatus (UserClass);
		Test.setMock(HttpCalloutMock.class, new HttpMockTestTemplate(new List<Integer>{200}, 'OK', l_resp_body, 
                                                                                       responseHeaders));

		PVSServiceSoap1.BulkTinCheckObject (ArrayOfBulkTinCheckRequestObject, UserClass);
		Test.setMock(HttpCalloutMock.class, new HttpMockTestTemplate(new List<Integer>{200}, 'OK', l_resp_body, 
                                                                                       responseHeaders));

		PVSServiceSoap1.ValidateTinName (TinNameClass, UserClass);
		Test.setMock(HttpCalloutMock.class, new HttpMockTestTemplate(new List<Integer>{200}, 'OK', l_resp_body, 
                                                                                       responseHeaders));
		PVSServiceSoap1.BulkTinCheck (BulkTinCheckRequest, UserClass);

		Test.setMock(HttpCalloutMock.class, new HttpMockTestTemplate(new List<Integer>{200}, 'OK', l_resp_body, 
                                                                                       responseHeaders));
		PVSServiceSoap1.ValidateTinNameAddressListMatch (TinNameClass, USPSAddressClass, UserClass);

		Test.setMock(HttpCalloutMock.class, new HttpMockTestTemplate(new List<Integer>{200}, 'OK', l_resp_body, 
                                                                                       responseHeaders));
		PVSServiceSoap1.ValidateListMatch (TinNameClass, UserClass);

		/*AsyncTinCheckService.ServiceStatusResponse_elementFuture ServiceStatusResponse_elementFuture = new AsyncTinCheckService.ServiceStatusResponse_elementFuture ();
		AsyncTinCheckService.BulkTinCheckResultResponse_elementFuture BulkTinCheckResultResponse_elementFuture = new AsyncTinCheckService.BulkTinCheckResultResponse_elementFuture ();		
		AsyncTinCheckService.VersionResponse_elementFuture VersionResponse_elementFuture = new AsyncTinCheckService.VersionResponse_elementFuture ();	
		AsyncTinCheckService.BulkTinCheckStatusResponse_elementFuture BulkTinCheckStatusResponse_elementFuture = new AsyncTinCheckService.BulkTinCheckStatusResponse_elementFuture ();
		AsyncTinCheckService.BulkTinCheckObjectResponse_elementFuture BulkTinCheckObjectResponse_elementFuture = new AsyncTinCheckService.BulkTinCheckObjectResponse_elementFuture ();
		AsyncTinCheckService.ValidateTinNameResponse_elementFuture ValidateTinNameResponse_elementFuture = new AsyncTinCheckService.ValidateTinNameResponse_elementFuture ();	
*/
		Test.stopTest();

		//ValidateListMatch(TinCheckService.TinNameClass TinName,TinCheckService.UserClass CurUser)

	}
/*static testMethod void testTinCheckMethods2 () {
		List<String> l_resp_body = new List<String> {tincheckResponse};

        Test.startTest();
			Test.setMock(HttpCalloutMock.class, new HttpMockTestTemplate(new List<Integer>{200}, 'OK', l_resp_body, 
                                                                                       responseHeaders));
		AsyncTinCheckService.ServiceStatusResponse_elementFuture ServiceStatusResponse_elementFuture = new AsyncTinCheckService.ServiceStatusResponse_elementFuture ();
		AsyncTinCheckService.BulkTinCheckResultResponse_elementFuture BulkTinCheckResultResponse_elementFuture = new AsyncTinCheckService.BulkTinCheckResultResponse_elementFuture ();		
		AsyncTinCheckService.VersionResponse_elementFuture VersionResponse_elementFuture = new AsyncTinCheckService.VersionResponse_elementFuture ();	
		AsyncTinCheckService.BulkTinCheckStatusResponse_elementFuture BulkTinCheckStatusResponse_elementFuture = new AsyncTinCheckService.BulkTinCheckStatusResponse_elementFuture ();
		AsyncTinCheckService.BulkTinCheckObjectResponse_elementFuture BulkTinCheckObjectResponse_elementFuture = new AsyncTinCheckService.BulkTinCheckObjectResponse_elementFuture ();
		AsyncTinCheckService.ValidateTinNameResponse_elementFuture ValidateTinNameResponse_elementFuture = new AsyncTinCheckService.ValidateTinNameResponse_elementFuture ();	

		Test.stopTest();

		//ValidateListMatch(TinCheckService.TinNameClass TinName,TinCheckService.UserClass CurUser)

	}*/

	// static testMethod void testTinCheckResponse () {

    //    	String resp = '{"errors":[{"status":"400","title":"Invalid Inquiry","detail":"UniqueId cannot be longer than 50 characters."}]}';
	// 	List<String> l_resp_body = new List<String> {tincheckResponse};

	// 	Test.setMock(HttpCalloutMock.class, new HttpMockTestTemplate(new List<Integer>{200}, 'OK', l_resp_body, 
    //                                                                                    responseHeaders));
    //     Test.startTest();	
	// 	ValuePlus__c vp = testDateGIdentify1 ('Property Management', 'APM Payments', 'Sole Proprietor', null);
	// 	vp.GIACTBusinessValidation__c = null;
    //     vp.GIACTBusinessOwner_1_Validation__c = null;
    //     vp.GIACTBusinessOwner_2_Validation__c = null;
    //     vp.GIACTBusinessOwner_3_Validation__c = null;
    //     vp.GIACTBusinessOwner_4_Validation__c = null; 
    //     vp.TIN_Match__c ='Ready to Transmit';
    // 	insert vp;
	// 	Test.stopTest();
	// }


}