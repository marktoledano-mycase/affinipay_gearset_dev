/**********************************************************************************************************************
* copyright © 2017
* File		: GIACTIntegrationService.cls
* Purpose	: This class validates a set of custom Setting records. Based on the custom setting records this class
* determines, if the all the required fields are available on the SObject record. For eg. if The custom setting is
* gVerify and The SObject is Bank Account. Then it validates if all the Required fields on the Custom Setting is
* avaialble in the BankAccount Record. 
* Test Class: GiactVerifyServiceTest
*
*
* @author Rohit Kumar Malik
* @version 1.0
* @since 2017-10-20
**********************************************************************************************************************/
public with sharing class GIACTIntegrationService extends RestClient {

	public class GIdentifySearchResponse {
		public List<PersonSearchResultRecords> personSearchResult = new List<PersonSearchResultRecords> ();
		public BusinessSearchResultRecords businessSearchResult  = new BusinessSearchResultRecords ();
	}

	public class PersonSearchResultRecords {
		public String xmlRequest {get; set;}
		public String xmlResponse {get; set;}
		public List <PersonSearchResultRecord> listOfLienAndBankruptcies = new List <PersonSearchResultRecord> ();
		public List<Error> errors = new List<Error>();
	}

	public Class PersonSearchResultRecord {
		public List <CustomerName> names = new List <CustomerName>();
		public List <SSNRecord> ssnRecords = new List <SSNRecord>();

		public String numberOfLiens {get; set;}
		public String numberOfBankRuptcies {get; set;}
		public String numberOfJudgements {get; set;}
	}

	public class CustomerName {
		public String fName {get; set;}
		public String mName {get; set;}
		public String lName {get; set;}
	}

	public class SSNRecord {
		public String ssn {get; set;}
		public String ssnPlaceOfIssue {get; set;}
		public String ssnIssueYears {get; set;}
	}

	public class BusinessSearchResultRecords {
		public String xmlRequest {get; set;}
		public String xmlResponse {get; set;}
		public List <BusinessSearchResultRecord> listOfLienAndBankruptcies = new List <BusinessSearchResultRecord> ();
		public List<Error> errors = new List<Error>();
	}

	public class BusinessSearchResultRecord {
		public List <BusinessName> names = new List<BusinessName> ();

		public String numberOfLienHolderCount {get; set;}
		public String numberOfLienDebtorCount {get; set;}

		public String numberOfBankruptcySubjectCount {get; set;}
		public String numberOfBankruptcyCreditorCount {get; set;}

		public String numberOfJudgementDebtorCount {get; set;}
		public String numberOfJudgementCreditorCount {get; set;}

	}

	public class BusinessName {
		public String name;
	}

    public class Error
    {
    	public String source{get; set;}
    	public String reasonCode{get; set;}
    	public String description{get; set;}
    	public String recoverable{get; set;}
    }

    public Class TinCheckResponse {
    	public GIdentifyEntityInformation__c tinCheckEntityInfo;
    	public GIACTIdentifyResponses__c tinCheckIndetifyResponse;
    	public Attachment tinCheckAttachment;
    	
    }

	@TestVisible
	private ValuePlus__c vpQueriedRecord;
	private Bank_Account__c baQueriedRecord;

	private GIACTIdentifyResponses__c curGIdentifyResponse;	
	private Set<String> curGIdnetifyResponseCodes;

	private TinCheckResponse 	curTinCheckResponse;

	public static Boolean isLegal = false;

	private Map<Integer, NameValuePair> verificationResponseCodes;
	private Map<Integer, NameValuePair> customerResponseCodes;
	private Map<Integer, NameValuePair> accountResponseCodes;

	private Map<String, String> tinNameCodesDetails;
	private Map<String, String> tinDMFCodesDetails;
	private Map<String, String> tinListMatchCodesDetails;
	private Map<String, String> tinEINCodesDetails;


	private List <NameValuePair> ownershipsAPM;
	private List <NameValuePair> ownershipsMyCase;
	private List<GIdentifyEntity> entityDataList;

	String ssnToMatchWithAdvanced;

	GIdentifySearchResponse consolidatedAdvancedResponse;

	private static Map<String, Giact_Integration__c> giactConfigMap = Giact_Integration__c.getAll();	
	private static string GIACT_CONFIG = 'gVerifyInquiry';	
	@testVisible private static string TINCHECK_CONFIG = 'Tin Check';		
	@testVisible private static String recordType; 
	private GiactInquiryResponse__c gLog;	

	public GIACTIntegrationService () {
		entityDataList = new List<GIdentifyEntity> ();
		curGIdnetifyResponseCodes = new Set<String> ();

		consolidatedAdvancedResponse = new GIdentifySearchResponse ();

		initializeOwnerships ();
		initializeVerificationResponseCodes ();
		initializeAccountResponseCodes ();
		initializeCustomerResponseCodes ();
	}

	/**
	* @brief  This map holds all the NameValuePair for all the General Verification Response Codes. 
	*/
	private void initializeVerificationResponseCodes () {
		verificationResponseCodes= new Map <Integer, NameValuePair> {
			0 => new NameValuePair ('Error', 'There was an error with the inquiry. Check the ErrorMessage property for details.'),
			1 => new NameValuePair ('PrivateBadChecksList', 'The bank account in the inquiry was found on the API user\'s private bad check list.'),
			2 => new NameValuePair ('Declined', 'The suggested action is to decline the bank account and/or customer data for this inquiry.'),
			3 => new NameValuePair ('RejectItem', 'The suggested action is to not accept an item with the check number on this inquiry.'),
			4 => new NameValuePair ('AcceptWithRisk', 'The suggested action is to further investigate or accept the bank account and/or customer data for this inquiry with known risk.'),
			5 => new NameValuePair ('RiskAlert', 'The suggested action is to further investigate the bank account and/or customer data for this inquiry due to a risk alert .'),
			6 => new NameValuePair ('Pass', 'The suggested action is to accept the bank account and/or customer data for this inquiry.'),
			7 => new NameValuePair ('PassNdd', 'The bank account in the inquiry is a Non-Demand Deposit account.'),
			8 => new NameValuePair ('NegativeData', 'There was negative data found associated with the account.'),
			9 => new NameValuePair ('NoData', 'No data was found for the bank account and/or customer data.')
		};
	}

	/**
	* @brief  This map holds all the NameValuePair for all the account validation Response Codes. 
	*/
	private void initializeAccountResponseCodes () {
		accountResponseCodes= new Map <Integer, NameValuePair> {
			0 => new NameValuePair('Null','There is no AccountResponseCode value for this result.'),
			1 => new NameValuePair('GS01','Invalid Routing Number - The routing number supplied fails the validation test.'),
			2 => new NameValuePair('GS02','Invalid Account Number - The account number supplied fails the validation test.'),
			3 => new NameValuePair('GS03','Invalid Check Number - The check number supplied fails the validation test.'),
			4 => new NameValuePair('GS04','Invalid Amount - The amount supplied fails the validation test.'),
			5 => new NameValuePair('GP01','The account was found as active in your Private Bad Checks List.'),
			6 => new NameValuePair('RT00','The routing number belongs to a reporting bank; however, no positive nor negative information has been reported on the account number.'),
			7 => new NameValuePair('RT01','This account should be declined based on the risk factor being reported.'),
			8 => new NameValuePair('RT02','This item should be rejected based on the risk factor being reported.'),
			9 => new NameValuePair('RT03','Current negative data exists on this account. Accept transaction with risk. (Example: Checking or savings accounts in NSF status, recent returns, or outstanding items)'),
			10 => new NameValuePair('RT04','Non-Demand Deposit Account (post no debits), Credit Card Check, Line of Credit, Home Equity, or a Brokerage check.'),
			11 => new NameValuePair('RT05','Recent negative data exists on the accout. Ex. No Suffecient Funds or recent returns.'),
			12 => new NameValuePair('_1111','Account Verified – The account was found to be an open and valid checking account.'),
			13 => new NameValuePair('_2222','AMEX – The account was found to be an American Express Travelers Cheque account.'),
			/**Consider this as a success as we mostly get the positive data on this. */
			14 => new NameValuePair('_3333','Non-Participant Provider – This account was reported with acceptable, positive data found in current or recent transactions.'),
			15 => new NameValuePair('_5555','Savings Account Verified – The account was found to be an open and valid savings account.'),
			/**We will never see this is for Real-time extened process*/
			16 => new NameValuePair('_7777','Checking or savings account was found to have positive historical data.'), // 
			/**We will never see this is for Real-time extened process*/
			17 => new NameValuePair('_8888','Savings account was found to have positive historical data.'),
			/**We will never see this is for Real-time extened process*/
			18 => new NameValuePair('_9999','Account reported as having positive historical data.'),
			19 => new NameValuePair('GN01','Negative information was found in this account\'s history.'),
			20 => new NameValuePair('GN05','The routing number is reported as not currently assigned to a financial institution.'),
			21 => new NameValuePair('ND00','No positive or negative information has been reported on the account.'),
			22 => new NameValuePair('ND01','This routing number can only be valid for US Government financial institutions.')
		};
	}


	/**
	* @brief  This map holds all the NameValuePair for all the customer validation Response Codes. 
	* 		9 => new NameValuePair('CI01','Information submitted failed gIdentify/CustomerID.'), What is the meaning of this. 
	* 
	*/	
	private void initializeCustomerResponseCodes () {
		customerResponseCodes= new Map <Integer, NameValuePair> {
			0 => new NameValuePair('Null','There is no CustomerResponseCode value for this result.'),
			1 => new NameValuePair('CA01','Information submitted failed gAuthenticate.'),
			2 => new NameValuePair('CA11','Customer authentication passed gAuthenticate.'),
			3 => new NameValuePair('CA21','The customer or business name data did not match gAuthenticate data.'),
			4 => new NameValuePair('CA22','The customers TaxId (SSN/ITIN) data did not match gAuthenticate data.'),
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
	}

	private void initializeTinNameCodes () {
		tinNameCodesDetails = new Map<String, String> {
			'-1'=>'Tin/Name Validation Not Processed',
			'0'=>'TIN and Name combination does not match IRS records',
			'1'=>'TIN and Name combination matches IRS records',
			'5'=>'TIN entered is not currently issued',
			'6'=>'TIN and Name combination matches IRS SSN records',
			'7'=>'TIN and Name combination matches IRS EIN records',
			'8'=>'TIN and Name combination matches IRS SSN and EIN records',
			'10'=>'Login denied: Invalid User Login and/or Password',
			'11'=>'Invalid Data',
			'12'=>'Invalid Configuration',
			'13'=>'Invalid TIN Matching request',
			'14'=>'Duplicate TIN Matching request',
			'15'=>'Connection Problem',
			'16'=>'IRS Connection Problem',
			'17'=>'IRS Tin/Name Validation temporarily unavailable',
			'18'=>'Request denied: no more checks available for this account. Please, contact TinCheck to renew your account',
			'20'=>'Processing Error',
			'21'=>'IRS Processing Error',
			'22'=>'Invalid IRS Login',
			'23'=>'Login denied: Invalid User',
			'24'=>'Login denied: Invalid Password',
			'25'=>'Login denied: This Account has been locked',
			'26'=>'Login denied: Account Locked for 24-Hours: 3 or more Login attempts',
			'27'=>'Login denied: Terms not accepted',
			'28'=>'Login denied: Account Expired'
		};
	}

	private void initializeTINDMFCodes () {
		tinDMFCodesDetails = new Map<String, String> {
			'-1' =>'Death Master File Match Not Processed',
			'0' =>'No Death Master File Match Found',
			'1' =>'Possible Death Master File Match Found'
		};
	}

	private void initializeTINListMatchCodesDetails () {
		tinListMatchCodesDetails = new Map<String, String> {
			'-1' =>'Lists Match Not Processed',
			'0' =>'No Lists Matches Found',
			'1' =>'Possible Lists Matches Found'
		};
	}

	private void initializeTINEINCodesDetails () {
		tinEINCodesDetails = new Map<String, String> {
			'1' =>'EIN Possible Match found.'
		};
	}
	
	private void initializeOwnerships () {
		ownershipsAPM=new List<NameValuePair>{
			new NameValuePair('Tax_ID__c', 'Business'),
			new NameValuePair('Principal_1_SSN__c', 'First Owner'),
			new NameValuePair('Principal_2_SSN__c', 'Second Owner'),
			new NameValuePair('Principal_3_SSN__c', 'Third Owner'),
			new NameValuePair('Principal_4_SSN__c', 'Fourth Owner')
		};
		ownershipsMyCase=new List<NameValuePair>{
			new NameValuePair('Tax_ID__c', 'Business'),
			new NameValuePair('MC_Principal_1_SSN__c', 'First Owner'),
			new NameValuePair('MC_Principal_2_SSN__c', 'Second Owner'),
			new NameValuePair('MC_Principal_3_SSN__c', 'Third Owner'),
			new NameValuePair('Principal_4_SSN__c', 'Fourth Owner')
		};
	}

	public class NameValuePair {
		public NameValuePair (String name, String value) {
			this.Name = name; 
			this.Value = value;
		}
		String Name {get;set;}
		String Value {get; set;}
	}

	Public class GIACTISException extends Exception {
		public GIACTISException(String action, Id valuePlus, String response, String faultCode) {
		}
	}

	private void queryValuePlusRecord (Id vPlusId, Boolean isForUpdate) {
		String queryStr = 'Select Id, Account__r.Ownership_Type__c, '+
				'MC_Principal_1_First_Name__c, MC_Principal_1_Last_Name__c,' +
				'MC_Principal_2_First_Name__c, MC_Principal_2_Last_Name__c, '+
				'MC_Principal_3_First_Name__c, MC_Principal_3_Last_Name__c, '+
				'MC_Principal_4_First_Name__c, MC_Principal_4_Last_Name__c, '+
				'Principal_1_First_Name__c, Principal_1_Last_Name__c,' +
				'Principal_2_First_Name__c, Principal_2_Last_Name__c, '+
				'Principal_3_First_Name__c, Principal_3_Last_Name__c, '+
				'Principal_4_First_Name__c, Principal_4_Last_Name__c, '+
				'CreatedById, Account__r.Tax_ID__c, '+
				'Account__r.Principal_1_SSN__c, '+
				'Account__r.Principal_2_SSN__c, '+
				'Account__r.Principal_3_SSN__c, '+
				'Account__r.Principal_4_SSN__c,'+
				'Tax_ID__c,'+
				'MC_Principal_1_SSN__c,'+
				'MC_Principal_2_SSN__c,'+
				'MC_Principal_3_SSN__c,'+
				'Principal_4_SSN__c,'+
				'Account__c, Account__r.Name, '+
				'Account__r.Account_Legal_Name__c, '+
				'Account__r.Full_Company_Name_Legal__c, '+
				'onboarding_specialist__c, RecordTypeId, GiactStatus__c, '+
				'GIACTBusinessValidation__c, '+
				'GIACTBusinessOwner_1_Validation__c, '+
				'GIACTBusinessOwner_2_Validation__c, '+
				'GIACTBusinessOwner_3_Validation__c, '+
				'GIACTBusinessOwner_4_Validation__c, '+
				'GIdentifyCallVersion__c, '+
				'GiactValidationFlag__c,'+
				'TIN_Match__c, '+
				'TINDateSubmitted__c from ValuePlus__c where Id=' + '\''+vPlusId+ '\'';
		if (isForUpdate) {
			queryStr += ' FOR UPDATE';
		}

		vpQueriedRecord = Database.query(queryStr);
		
		if (vpQueriedRecord==null) {
			throw new GIACTISException ('Could not query the Value plus record.');
		}
	}

	Public void pull_GiactVerifyData (String action, Id vPlusId, Id bankAccountId) {
		try {			
			queryValuePlusRecord(vPlusId, false);
			this.baQueriedRecord = [Select Id,
				CreatedById,
				ValuePlus__c,
				GiactStatus__c,
				GiactRequestVersion__c,
				Bank_Name__c,
				Bank_Account_Verification_Status__c From Bank_Account__c where Id=:bankAccountId];

			if (baQueriedRecord==null) {
				throw new GIACTISException ('Automation did not query valid Bank account. Please contact the administrator.');
			}
			if (action.toLowerCase() != 'gverifyinquiry') {
				throw new GIACTISException ('Invalid gVerify action.');
			} 
			makeGVerifyRequest (action);
		} catch (Exception ex) {
			SystemExceptionLogger.insertSystemExceptionLogEntry(ex, 
				'GIACT Verify',  
				'MakeGiactRequest', 
				SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL,
				ex.getMessage(),
				'BankAccount',
 				bankAccountId,
				false);
		}

	}

	Public void pull_GiactIdentifyData (String action, Id vPlusId) {
		try {
			queryValuePlusRecord(vPlusId, true);
			makeGiactRequest(action);
			// This is necessary to avoid the validation rules
			vpQueriedRecord.GiactValidationFlag__c=true;
			update vpQueriedRecord;
			vpQueriedRecord.GiactValidationFlag__c=false;
			update vpQueriedRecord;
		} catch (Exception ex) {
			SystemExceptionLogger.insertSystemExceptionLogEntry(ex, 
				'GIACT Identify',  
				'MakeGiactRequest', 
				SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL,
				ex.getMessage(),
				'ValuePlus',
 				vPlusId,
				false);
		}
	}

	private void makeGVerifyRequest (String action) {
		isLegal = (vpQueriedRecord.RecordTypeid == InformationStrings.vPlusMycasePaymentsId)? true : false;
		List <NameValuePair>  ownerships = (isLegal==true ? ownershipsMyCase : ownershipsAPM);
		SObject sobj = (isLegal==true ? vpQueriedRecord : vpQueriedRecord.getSObject ('Account__r'));


        if (vpQueriedRecord.Account__r.Ownership_Type__c=='Sole Proprietor') {
			System.debug('FileName-GIACTIntegrationService-' + 'Processing Bank Account without Sole Proprietor');        	
			NameValuePair nvp = ownerships[1];
			// Retrieves the Field which we need to look in the Record on value plus
			String ssnvalue = (String)sObj.get (nvp.Name);
			// Integration will be called only when SSN in updated in the Principal field of the Account, Else it will not invoke the integration.
			if (String.isEmpty(ssnvalue)) {
				throw new GIACTISException ('You are missing TaxId, which is a required field.');
			} else if (!String.isEmpty(ssnvalue) && action.equalsIgnoreCase('gverifyinquiry')) {
				// Put an Audit Log here to inform that there is no SSN, put an audit log on Bank Account
				processGVerifyRequest (2, action);
			}
    	} else {
			processGVerifyRequest (ownerships.size (), action);
    	}
		return;
	}

	private void processGVerifyRequest (Integer ownershipsSize, String action) {
		List <NameValuePair>  ownerships = (isLegal==true ? ownershipsMyCase : ownershipsAPM);
		SObject sobj = (isLegal==true ? vpQueriedRecord : vpQueriedRecord.getSObject ('Account__r'));

		Integer startIndex = 0;
		String entityType = 'Business';

		for (Integer index = startIndex; index<ownershipsSize; index++) {
			// Get the NameValuePair for this index
			NameValuePair nvp = ownerships[index];
			// Retrieves the Field which we need to look in the Record on value plus
			ssnToMatchWithAdvanced = (String)sObj.get (nvp.Name);

			//Flip the entityType if this is not the 0th Index
			if (index>0) {
				entityType = 'Individual';
			}

			if (!String.isEmpty(ssnToMatchWithAdvanced)) {

				boolean isStopProcessing =  makeGVerifyWithGAuthenticate (index, entityType, action, nvp.value);
				if (isStopProcessing==true) {
					break;
				}
			} else {
				if (index<2){
					throw new GIACTISException ('Social Security detail for ' + nvp.Name + ' is empty.');
				} else {
					break;
				}
			}

		}
		return;
	}

	private void makeGiactRequest (String action) {

		isLegal = (vpQueriedRecord.RecordTypeid == InformationStrings.vPlusMycasePaymentsId)? true : false;
		// Get the Account Object based on the Value Plus object. As we need to get information from the Account Record. 
		SObject sobj = (isLegal==true ? vpQueriedRecord : vpQueriedRecord.getSObject ('Account__r'));
		List <NameValuePair>  ownerships = (isLegal==true ? ownershipsMyCase : ownershipsAPM);

		// Check here the status of the Fields which we need to validate
		if (vpQueriedRecord.Account__r.Ownership_Type__c=='Sole Proprietor') {
		
			System.debug('***Processing GIACT request with Sole Proprietor'); 	
			
			// Retrieves the Field which we need to look in the Record on value plus
			NameValuePair nvp = ownerships[1];
			String ssnvalue = (String)sObj.get (nvp.Name);
			// If SSN is not avaialble then there is no need to proceed further.
			if (String.isEmpty(ssnvalue)) {
				throw new GIACTISException ('You are missing TaxId, which is a required field.');
			} else if (!String.isEmpty(ssnvalue) && action.equalsIgnoreCase('gidentifyinquiry')) {
				processIndividualAndBusinessIdentify (2, action);
			} else if (!String.isEmpty(ssnvalue) && action.equalsIgnoreCase('gverifyinquiry')) {
				// Put an Audit Log here to inform that there is no SSN, put an audit log on Bank Account 
			}
		} else {
			processIndividualAndBusinessIdentify (ownerships.size (), action);
		}

		// This method is updating the valueplus and GIdentify record status.
		updateValuePlusStatus ();

		// Call the TIN check also at the same point of time, as we will update the Value Plus object only once
    	ValidateTinCheck ();

    	System.debug('***Full Advanced Response*** ' + JSON.serialize(consolidatedAdvancedResponse));

    	// Perform the DML Operation here only once in the whole code. 
		if (curGIdentifyResponse!=null) {
	    	System.debug ('Inserting the Identify Response.' + curGIdentifyResponse);

	    	// Check if upsert is pass or fail
    		insert curGIdentifyResponse;

    		// This can be improved finish everything only in 2 DML Calls
    		for (GIdentifyEntity gie : entityDataList) {
    			gie.ParentId = curGIdentifyResponse.Id;
    			gie.insertEntity();
    		}
		}

		if (curTinCheckResponse!=null) {
			insert (curTinCheckResponse.tinCheckIndetifyResponse);
			curTinCheckResponse.tinCheckEntityInfo.GIACTIdentifyResponse__c = curTinCheckResponse.tinCheckIndetifyResponse.id;
			insert curTinCheckResponse.tinCheckEntityInfo;

			System.debug('Entity Info - ' + curTinCheckResponse.tinCheckEntityInfo + ' Attachment - ' + curTinCheckResponse.tinCheckAttachment);

			if (curTinCheckResponse.tinCheckEntityInfo!=null && 
				curTinCheckResponse.tinCheckEntityInfo.Id!=null && 
				curTinCheckResponse.tinCheckAttachment!=null) {
				System.debug('Entity Info - ' + curTinCheckResponse.tinCheckEntityInfo);
				curTinCheckResponse.tinCheckAttachment.ParentId = curTinCheckResponse.tinCheckEntityInfo.Id;
				insert curTinCheckResponse.tinCheckAttachment;
			}
		}
	}

	private void updateValuePlusStatus () {		
		if (curGIdentifyResponse!=null) {
			String status = '';

			if (curGIdnetifyResponseCodes.contains('Failed To Identify') || curGIdnetifyResponseCodes.contains('Needs Review')) {
				status = 'Needs Review';
			} else if (curGIdnetifyResponseCodes.contains('Automated Approval')) {
				status = 'Automated Approval';
			}
			System.debug('Setting up the status on Indentify Log  and Value Plus - ' + status);
			curGIdentifyResponse.ResponseStatus__c = status;
			vpQueriedRecord.GiactStatus__c = status;
		}		
	}

	@TestVisible 
	private void ValidateTinCheck () {
		if (vpQueriedRecord.TIN_Match__c=='Ready To Transmit')  {
			initializeTinNameCodes();
			initializeTINDMFCodes ();
			initializeTINListMatchCodesDetails ();
			initializeTINEINCodesDetails ();

			curTinCheckResponse = new TinCheckResponse ();

			GIACTIdentifyResponses__c tinCheckIndetifyResponse =  new GIACTIdentifyResponses__c (Application__c='TinCheck', ValuePlus__c=vpQueriedRecord.Id);
			curTinCheckResponse.tinCheckIndetifyResponse = tinCheckIndetifyResponse;			

			TinCheckService.PVSServiceSoap tcs = new TinCheckService.PVSServiceSoap ();
			TinCheckService.TinNameClass tnc = new TinCheckService.TinNameClass ();
			TinCheckService.UserClass uc = new TinCheckService.UserClass ();
			SObject sobj = vpQueriedRecord.getSObject ('Account__r');
			String ssn = (String)sObj.get ('Tax_ID__c');
			String businessLegalName = (String)sObj.get ('Account_Legal_Name__c');

    		vpQueriedRecord.TINDateSubmitted__c = Datetime.now();

			tnc.tin = GiactUtils.formatTaxId(ssn);
			tnc.lname = businessLegalName;

			uc.userLogin = giactConfigMap.get(TINCHECK_CONFIG).giact_username__c;
			uc.userPassword = giactConfigMap.get(TINCHECK_CONFIG).giact_password__c;

			//@VR: As per request R1812557, setting the timeout to 2 minutes to prevent the timing out issue
            tcs.timeout_x = 120000;

			System.debug('Tnc' + tnc + ' - User class - ' + uc);

			TinCheckService.TINNAME_ADDRESS_LISTMATCH_RESPONSE tinCheckResult = tcs.ValidateTinNameAddressListMatch(tnc, null, uc);
	        Long requestId = tinCheckResult.REQUESTID;
        	String request_status = tinCheckResult.REQUEST_STATUS;
        	String request_details = tinCheckResult.REQUEST_DETAILS;

        	TinCheckService.TINNAME_RESPONSE tinName_response = tinCheckResult.TINNAME_RESULT;
        	TinCheckService.LISTMATCH_RESPONSE listMatch_Result = tinCheckResult.LISTMATCH_RESULT;
        	TinCheckService.ADDRESS_RESPONSE address_Result = tinCheckResult.ADDRESS_RESULT;
        	TinCheckService.ServiceStatusResponse status = tinCheckResult.STATUS;

        	System.debug('tinName_response' + tinName_response + ' - listMatch_Result - ' + listMatch_Result);
        	System.debug('TinName Response - ' + '\n'+
        		'Tin Name DMF CODE:' + tinName_response.DMF_CODE + '\n' +
        		'TIN Name DMF Data:'+ tinName_response.DMF_DATA + '\n' + 
        		'TIN Name DMF DETAILS:' + tinName_response.DMF_DETAILS);

        	String tinNameCode = tinName_response.TINNAME_CODE;
        	String tinDMFCode = tinName_response.DMF_CODE;
        	String tinEINCode = tinName_response.EIN_CODE;
        	String tinListMatchCode = listMatch_Result.LISTSMATCH_CODE;

        	String NameDetails = tinNameCodesDetails.containsKey(tinNameCode) ? tinNameCodesDetails.get(tinNameCode) : '';
        	String DMFCodesDetails = tinDMFCodesDetails.containsKey(tinDMFCode) ? tinDMFCodesDetails.get(tinDMFCode) : '';
        	String EINdetails = tinEINCodesDetails.containsKey(tinEINCode) ? tinEINCodesDetails.get(tinEINCode): '';
        	String ListMatchDetails = tinListMatchCodesDetails.containsKey(tinListMatchCode) ? tinListMatchCodesDetails.get(tinListMatchCode) : '';

    		curTinCheckResponse.tinCheckEntityInfo = new GIdentifyEntityInformation__c (
    			Name=businessLegalName,
				recordTypeId = InformationStrings.gIdentifyTinCheckId,
				TinNameCode__c = tinNameCode,
				TinNameCodeDetails__c = NameDetails,
				DeathMasterFileCode__c=tinDMFCode,
				DeathMasterFileDetails__c=DMFCodesDetails,
				EmployerIdentificationNumberCode__c=tinEINCode,
				EmployerIdentificationNumberDetails__c = EINdetails,
				ListMatchCode__c = tinListMatchCode,
				ListMatchDetails__c = ListMatchDetails,
				TaxIDNumber__c = ssn
    		);

        	tinCheckIndetifyResponse.ResponseStatus__c = 'Needs Review';
        	Set <String> tinNameCodeSource = new Set<String>{'1', '6', '7', '8'};

        	if (!tinNameCodeSource.contains(tinName_response.TINNAME_CODE) ||
        		tinName_response.DMF_CODE!='0' ||
        		(tinName_response.EIN_CODE!='1' && tinName_response.EIN_CODE!='0') ||
        		listMatch_Result.LISTSMATCH_CODE!='0') {
        		vpQueriedRecord.TIN_Match__c = 'Needs Review';

        		System.debug('vpRecord.TIN_Match__c' + vpQueriedRecord.TIN_Match__c);
        		System.debug('tinName_response.DMF_CODE' + tinName_response.DMF_CODE);
        		System.debug('tinName_response.EIN_CODE' + tinName_response.EIN_CODE);
        		System.debug('listMatch_Result.LISTSMATCH_CODE' + listMatch_Result.LISTSMATCH_CODE);
				System.debug ('DMF Data received - ' + tinName_response.DMF_DATA);


        		String pdfData = parserTINMatchData (tinName_response.DMF_DATA, tinName_response.DMF_DETAILS, tinName_response.EIN_DATA, tinName_response.EIN_DETAILS);
        		System.debug ('TIN Match pdf Data - ' + pdfData);
        		curTinCheckResponse.tinCheckAttachment = GIACTUtils.saveXMLAsPdf(pdfData, 'TinChecMatch.pdf');

        		return;
        	}
        	vpQueriedRecord.TIN_Match__c = 'Automated Approval ';
			tinCheckIndetifyResponse.ResponseStatus__c = 'Automated Approval';

		}

	}

	public static String parserTINMatchData (String dmf_data, String dmf_details, String ein_data, String ein_details) {
		Map<String, String> dmf_data_map = new Map<String, String> ();

		String deathMateFileData = '';
		dmf_data = dmf_data.trim();

		//This block parses the DMF Data
		if (!String.isEmpty(dmf_data)) {
			//System.debug ('DMF Data received - ' + dmf_data);
			Dom.Document doc = new Dom.Document();
			doc.load(dmf_data);

			Dom.XmlNode root = doc.getRootElement();
	        if (root.getName().equals('Errors')) {
	            //businessSearchResp.errors = parseAllErrors(root);
	        } else {
	        	System.debug(root);
	        	List <Dom.XmlNode> bodyLevelList = root.getChildElements();
	        	Dom.XmlNode bodyNode;
	        	if (!bodyLevelList.isEmpty() && bodyLevelList[0].getName()=='DMFTable') {
	        		bodyNode = bodyLevelList[0]; 
	        	} else {
	        		return null;
	        	}

	        	for (Dom.XmlNode node : bodyNode.getChildElements ()) {
					String name = node.getName ();
					String value = node.getText ();
					dmf_data_map.put (name, value);
				}
	        }

    		System.debug ('Death Master File data : ' + deathMateFileData);
			deathMateFileData+='<br><center><h1 style="color:green;">TinCheck Details</h1></center><br><br>';
			deathMateFileData += '<br><br><h3 style="color:blue;"><i>Death Master File Data : ' + dmf_details +'</i></h3><br>';
			deathMateFileData += '<table border ="1">';
			deathMateFileData += '<center><tr><th>' + 'DMF Id' + '</th><th>' + 'TIN' + '</th><th>' + 'Name' + '</th><th>' + 'Date of Death' + '</th><th>' + 'Date of Birth' + '</th><th>' + 'State' + '</th><th>' + 'Zip Code' + '</th></tr></center>';

			deathMateFileData += '<tr><td>' +
			(dmf_data_map.containsKey('DMF_ID')==true ? dmf_data_map.get('DMF_ID'):'') + '</td><td>' + 
			(dmf_data_map.containsKey('TIN')==true ? dmf_data_map.get('TIN'):'')  + '</td><td>' +
			(dmf_data_map.containsKey('Name')==true ? dmf_data_map.get('Name'):'')  + '</td><td>' + 
			(dmf_data_map.containsKey('Date_Of_Death')==true ? dmf_data_map.get('Date_Of_Death'):'')  + '</td><td>' +
			(dmf_data_map.containsKey('Date_Of_Birth')==true ? dmf_data_map.get('Date_Of_Birth'):'')  + '</td><td>' + 
			(dmf_data_map.containsKey('State_Of_Residency')==true ? dmf_data_map.get('State_Of_Residency'):'')  + '</td><td>' +
			(dmf_data_map.containsKey('ZipCode_Of_Residency') ? dmf_data_map.get('ZipCode_Of_Residency'):'')  + '</td></tr>';
			deathMateFileData += '</table>';
		}

		System.debug ('Death Master File data : ' + deathMateFileData);

		if (!String.isEmpty(ein_data) || !String.isEmpty(ein_details)) {
			deathMateFileData += '<br><br><h3 style="color:blue;">EIN Details : <br><br>' +
			'EIN DETAILS : ' + ein_details + '<br><br>' +
			'EIN_DATA : ' + ein_data +'</h3><br>';
		}
		return deathMateFileData;
	}


	//private void processIndividualAndBusinessIdentify (Integer ownershipsSize, String action, ValuePlus__c vp, Bank_Account__c ba, String product) {
	// TODO: There may be a different scenario for MYCASE and APM in case of Individual, Perhaps Mycase don't want to run BUSINESS in case of Individual 
	// but APM wants to run this
	/*
	* M4-inProgress
	* The assumption that both Business and Individual needs to run in case of MyCase breaks in this method. 
	* Currently This is running both of them which is not required. 
	* TODO: Remvoe Business for mycase in case of Individual.
	* TODO: As of now we are trying to process all of the entities. Take a look if it is required to process
	* 		All of the entities. I am talking about the Loop for all the 4. 
	* TODO: Check if there is an exception in between are you setting the Success/ Need Review for 
	* All of them. 
	*/
	private void processIndividualAndBusinessIdentify (Integer ownershipsSize, String action) {

		System.debug('***Preparing for Principal and Business Identify call***');
		SObject sobj = (isLegal==true ? vpQueriedRecord : vpQueriedRecord.getSObject ('Account__r'));
		List <NameValuePair>  ownerships = (isLegal==true ? ownershipsMyCase : ownershipsAPM);
        
        Integer startIndex = 0;
		String entityType = 'Business';

		for (Integer index = startIndex; index<ownershipsSize; index++) {
			System.debug('***Preparing for Principal and Business Identify call*** ' + index + ' ' + ownershipsSize);
			// Get the NameValuePair for this index
			NameValuePair nvp = ownerships[index];
			// Retrieves the Field which we need to look in the Record on value plus
			ssnToMatchWithAdvanced = (String)sObj.get (nvp.Name);

			//Flip the entityType if this is not the 0th Index
			if (index>0) {
				entityType = 'Individual';
			}

			// Integration will be called only when SSN in updated in the Principal field of the Account, Else it will not invoke the integration.
			if (action.toLowerCase() == 'gidentifyinquiry' && 
				GiactUtils.isReadyToTransmitToGiact(vpQueriedRecord, index)) {

				// This will add a new user experience in case of empty social security.
				if (String.isEmpty(ssnToMatchWithAdvanced) ) {
					throw new GIACTISException ('Social Security detail for ' + nvp.Name + ' is empty.');
				}
				
				System.debug('ProcessIndividualAndBusinessIdentify: ' + entityType + ' ' + GiactUtils.isReadyToTransmitToGiact(vpQueriedRecord, index) + ' Counter - ' + index);

				// This method returns true/false if true then stop the processing immediately.
				if (prepareAndCallGIdentify (index, entityType, action, nvp.value)) {
					break;
				}
			}
		}
	}

	private boolean prepareAndCallGIdentify (Integer index, String entityType, String action, String customerType) {
		String 		gIDBasicRequest;
		String 		gIDBasicResponse ;
		String 		gAuthenticateResponse;		
		String 		xmlRequest;
		String 		xmlResponse;		
		String 		uniqueRequestId = '';
		boolean 	isStopProcessing = false;

		GIACTRestRequestBuilder.GIACTRequestAPMIdentify 	bodyObj;
		Giact_AdvanceIdentifyService 						identifyService;
		PersonSearchResultRecords 							principalAdvanceResponse;
		BusinessSearchResultRecords 						businessAdvanceResponse;
		GIdentifyEntity dataHolder 							= new GIdentifyEntity (vpQueriedRecord.Id, index==0);
		
		System.debug('***Preparing to call GIdentify for Entity*** ' + index);
		bodyObj = GIACTRestRequestBuilder.createGIdentifyAPMRequest (index, vpQueriedRecord, customerType);
		if (vpQueriedRecord.GIdentifyCallVersion__c==null) {
			vpQueriedRecord.GIdentifyCallVersion__c = 0;
		}

		String nameStr = vpQueriedRecord.Account__r!=null?vpQueriedRecord.Account__r.Name : ''; 
		nameStr = (nameStr.length()>20)? nameStr.Substring(0,20) : nameStr;

		// This is required as the GIACT constraint is of 50 Characters.
		uniqueRequestId = vpQueriedRecord.Id+ '-' + nameStr + '-' + vpQueriedRecord.GIdentifyCallVersion__c;
		vpQueriedRecord.GIdentifyCallVersion__c = vpQueriedRecord.GIdentifyCallVersion__c+1;
		bodyObj.UniqueId = uniqueRequestId;
		System.debug('***Input Payload for APM GIdentify*** ' + JSON.serialize(bodyObj));
		
		// How are you handling a failure response here?
		gIDBasicResponse = makeAPMIdentifyCallout(bodyObj);

		System.debug('*** Giact Response Code - ' + this.responseCode);

		if (this.responseCode > 299) {
			// TODO: you need to set the status of the Value plus record here. 
			throw new GIACTISException ('Giact Identify Service failed to retrieve data from GIACT Server ' + entityType + ' ' + index);
		}

		System.debug('***APM GIdentify gIdentifyResponse*** ' + gIDBasicResponse);
		System.debug('***Body Object with all information*** ' + bodyObj);

		// Initialize the service 
		identifyService = new Giact_AdvanceIdentifyService ();
		String numberOfBankRuptcies='';
		String numberOfLiens ='';			
		String numberOfJudgements='';

		if (index==0) {
			System.debug('*** ' + index);
			// This calls the gIdentify advanced service and fetches the gIDBasicResponse. 
			businessAdvanceResponse = identifyService.gIdentifyBusinessAdvanceInquiry (bodyObj);
			
			if (businessAdvanceResponse!=null)  {
				consolidatedAdvancedResponse.businessSearchResult = businessAdvanceResponse;
				xmlResponse = businessAdvanceResponse.xmlResponse;
				xmlRequest = businessAdvanceResponse.xmlRequest;

				List <BusinessSearchResultRecord> listOfLBJ = businessAdvanceResponse.listOfLienAndBankruptcies;
				if (!listOfLBJ.isEmpty()) {
					numberOfBankRuptcies = listOfLBJ.get(0).numberOfBankruptcySubjectCount;
					numberOfLiens = listOfLBJ.get(0).numberOfLienDebtorCount;
					numberOfJudgements = listOfLBJ.get(0).numberOfJudgementDebtorCount;
				}
			}
			System.debug('***Business XML gIdentifyResponse*** ' + xmlResponse);
		} else {			
			// This calls the gIdentify advanced service and fetches the gIdentifyResponse. 
			principalAdvanceResponse = identifyService.gIdentifyAdvanceInquiry (bodyObj);
			if (principalAdvanceResponse!=null) {
				consolidatedAdvancedResponse.personSearchResult.add(principalAdvanceResponse);
				xmlResponse = principalAdvanceResponse.xmlResponse;
				xmlRequest = principalAdvanceResponse.xmlRequest;

				List <PersonSearchResultRecord> listOfLBJ = principalAdvanceResponse.listOfLienAndBankruptcies;
				if (!listOfLBJ.isEmpty()) {
					numberOfBankRuptcies = listOfLBJ.get(0).numberOfBankRuptcies;
					numberOfLiens = listOfLBJ.get(0).numberOfLiens;
					numberOfJudgements = listOfLBJ.get(0).numberOfJudgements;
				}

			}
			System.debug('*** Principal ' + index + ' Advanced Response' + xmlResponse);
		}

		System.debug('Bankruptcies ' + numberOfBankRuptcies + ' Liens ' + numberOfLiens + ' Judgements ' + numberOfJudgements);
		System.debug('FileName-GIACTIntegrationService- GIdentify Callout Response' + gIDBasicResponse);

		if (curGIdentifyResponse==null) {
			curGIdentifyResponse = new GIACTIdentifyResponses__c (Application__c = 'gIdentify', ValuePlus__c = vpQueriedRecord.id);
		}

		gIDBasicRequest = JSON.serialize(bodyObj);

		GiactIdentifyResponseResults.parseLevel0( 'CustomerResponseCode', gIDBasicResponse, dataHolder, entityType);		
		if (entityType.equalsIgnoreCase ('Business')) {
			dataHolder.Name = islegal? vpQueriedRecord.Account__r.Full_Company_Name_Legal__c : vpQueriedRecord.Account__r.Account_Legal_Name__c;

			GiactIdentifyResponseResults.parseBusinessData('BusinessData', gIDBasicResponse, dataHolder);
		} else if (entityType.equalsIgnoreCase ('Individual')) {

			String pName;

			if (vpQueriedRecord.RecordTypeid == InformationStrings.vPlusMycasePaymentsId) {
				if (index==1) pName = vpQueriedRecord.MC_Principal_1_First_Name__c + ' ' + vpQueriedRecord.MC_Principal_1_Last_Name__c;
				else if (index==2) pName = vpQueriedRecord.MC_Principal_2_First_Name__c + ' ' + vpQueriedRecord.MC_Principal_2_Last_Name__c;
				else if (index==3) pName = vpQueriedRecord.MC_Principal_3_First_Name__c + ' ' + vpQueriedRecord.MC_Principal_3_Last_Name__c;
				else if (index==4) pName = vpQueriedRecord.MC_Principal_4_First_Name__c + ' ' + vpQueriedRecord.MC_Principal_4_Last_Name__c;

			} 
			// else if (vpQueriedRecord.RecordTypeid == InformationStrings.vPlusAPMPaymentsId) {
			// 	if (index==1) pName = vpQueriedRecord.Principal_1_First_Name__c + ' ' + vpQueriedRecord.Principal_1_Last_Name__c;
			// 	else if (index==2) pName = vpQueriedRecord.Principal_2_First_Name__c + ' ' + vpQueriedRecord.Principal_2_Last_Name__c;
			// 	else if (index==3) pName = vpQueriedRecord.Principal_3_First_Name__c + ' ' + vpQueriedRecord.Principal_3_Last_Name__c;
			// 	else if (index==4) pName = vpQueriedRecord.Principal_4_First_Name__c + ' ' + vpQueriedRecord.Principal_4_Last_Name__c;
			// }
			dataHolder.Name = pName;
			// Check if the Advanced is having the matching Social Security Number Then set the tax Id matching to Success. 
			if (String.isEmpty(dataHolder.taxIdValidationStatus)) {

				List <PersonSearchResultRecord> listOfLBJ = principalAdvanceResponse.listOfLienAndBankruptcies;

				if (!listOfLBJ.isEmpty() && listOfLBJ.get(0).ssnRecords!=null) {
					validateTaxIdInAdvancedData (listOfLBJ.get(0).ssnRecords, dataHolder);
				} 
			}
			GiactIdentifyResponseResults.parsePersonData('MatchedPersonData', gIDBasicResponse, dataHolder);
		}

		String text1;
		String textBasic1;
		GiactResponseParser gResponseParser1 = new GiactResponseParser ();

		if (index==0) {
			System.debug('***Retrieves the Business response text for Basic and Advanced calls.***');
			text1 = gResponseParser1.prepareAdvancedHTMLResponseBusiness (businessAdvanceResponse);
			textBasic1 = gResponseParser1.prepareBasicResponseHTMLBusiness (gIDBasicResponse, dataHolder);

		} else {
			System.debug('***Retrieves the Business response text for Basic and Advanced calls.***');						
			 text1 = gResponseParser1.prepareAdvancedHTMLResponsePrincipal (principalAdvanceResponse);
			 textBasic1 = gResponseParser1.prepareBasicResponseHTMLPrincipal (gIDBasicResponse);
		}

		dataHolder.entityAttachments.add(GIACTUtils.saveXMLAsPdf(textBasic1, 'GIdentifyBasicResponse.pdf'));
		dataHolder.entityAttachments.add(GIACTUtils.saveXMLAsPdf(text1, 'GIdentifyAdvancedResponse.pdf'));
		dataHolder.gIDBasicRawRequest = gIDBasicRequest.replaceAll(',', ',\n');
		dataHolder.gIDBasicRawResponse = gIDBasicResponse.replaceAll(',', ',\n');
		dataHolder.uniqueId = uniqueRequestId;
		dataHolder.gIDAdvancedRawRequest = xmlRequest;
		dataHolder.gIDAdvancedRawResponse = xmlResponse;
		dataHolder.numberOfBankruptcies = numberOfBankRuptcies;
		dataHolder.numberOfLeins =  numberOfLiens;
		dataHolder.numberOfJudgements = numberOfJudgements;

		String identifyStatusOnVPlusEntities = 'Needs Review';
		String responseCode = dataHolder.responseReasonCode;

		if (!String.isEmpty(numberOfLiens) &&
			!String.isEmpty(numberOfBankRuptcies) && 
			!hasPositiveAdvancedInfo(numberOfBankRuptcies) &&
			 !hasPositiveAdvancedInfo (numberOfLiens) &&
			 !String.isEmpty(responseCode) &&
			 dataHolder.ofacInformation!='Potential Match ALERT') {
			if (responseCode.equalsIgnoreCase('CI11')) {				
				identifyStatusOnVPlusEntities = 'Automated Approval';
			} else if (responseCode.equalsIgnoreCase('CI01')) 	{
				//identifyStatusOnVPlusEntities = 'Declined';
				curGIdnetifyResponseCodes.add('Failed To Identify');
			}
		}
		
		curGIdnetifyResponseCodes.add(identifyStatusOnVPlusEntities);
		System.debug('Setting up the GIACT Status - ' + identifyStatusOnVPlusEntities +  ' i - ' + index);

		if (index==0) {
			vpQueriedRecord.GIACTBusinessValidation__c = identifyStatusOnVPlusEntities;
		} else if (index==1) {
			vpQueriedRecord.GIACTBusinessOwner_1_Validation__c = identifyStatusOnVPlusEntities;	
		} else if (index==2) {
			vpQueriedRecord.GIACTBusinessOwner_2_Validation__c = identifyStatusOnVPlusEntities;
		} else if (index==3) {
			vpQueriedRecord.GIACTBusinessOwner_3_Validation__c = identifyStatusOnVPlusEntities;
		} else if (index==4) {
			vpQueriedRecord.GIACTBusinessOwner_4_Validation__c = identifyStatusOnVPlusEntities;
		}
		entityDataList.add(dataHolder);
		return false;
	}

	private boolean hasPositiveAdvancedInfo (String advancedInfo) {
		if (!String.isEmpty(advancedInfo) && 
			Integer.valueOf(advancedInfo) > 0) {
			return true;
		}
		return false;
	}

	private boolean makeGVerifyWithGAuthenticate(Integer index, String entityType, String action, String customerType) {
		System.debug('FileName-GIACTIntegrationService-' + 'Processing makeGVerifyWithGAuthenticate');
		boolean isStopProcessing = false;
		List <GIACTInquiryError__c> inqErrors = new List <GIACTInquiryError__c> ();		

		// Create the GIACT Inquiry response
		GiactInquiryResponse__c gLog = new GiactInquiryResponse__c ();
		gLog.Application__c = 'gVerify';
		gLog.BankAccount__c = baQueriedRecord.Id;
		gLog.ValuePlus__c = baQueriedRecord.ValuePlus__c;
		gLog.OwnerId = baQueriedRecord.CreatedById;

		GIACTRestRequestBuilder.GIACTRequest bodyObj = GIACTRestRequestBuilder.createGVerifyAndGAuthenticateRequest(index, vpQueriedRecord, baQueriedRecord, customerType);

		String responseStr = makeCallout(bodyObj);		
		String request = JSON.serialize(bodyObj);
		system.debug('*****JSON Request: ' + request);
	
		if (String.isEmpty(responseStr)) {
			throw new GIACTISException ('Automation received empty response from Giact : Respnse Code - ' + this.response.getStatusCode());
		}

		request = request.replaceAll(',', ',\n');
		String formattedresponse = responseStr.replaceAll(',', ',\n');

		gLog.ResponseText__c = formattedresponse;
		gLog.RequestText__c = request;
		baQueriedRecord.GiactStatus__c = 'Needs Review';	

		// There are 2 scenarios here it is failed or passed. 
		// If the response code is more than 299 then we need to parse the error and set up the 
		if (this.response.getStatusCode() > 299) {
			gLog.ResponseStatus__c = 'Error';
		// Starting the Success block when the call to GIACT is successful
		} else {
			responseStr = GIACTUtils.sanitizeJson(responseStr);
			Map <String, Object> gResponse = GiactResponseResults.parse(responseStr);
			isStopProcessing = processGVerifyInquiryResponse (gResponse, gLog);
		// Completing the success block
		}

		// Update the version on the Bank Account Record. 
		Decimal ver = 0.0;
	    if (baQueriedRecord.GiactRequestVersion__c!=null) {
	        baQueriedRecord.GiactRequestVersion__c = baQueriedRecord.GiactRequestVersion__c+1;
	        ver = baQueriedRecord.GiactRequestVersion__c;
	    } else {
	        baQueriedRecord.GiactRequestVersion__c = 0.0;
	    }

	    String UId =baQueriedRecord.Id+'-'+customerType+'-' + String.valueOf(ver);
		gLog.UniqueId__c = UId;

		insert gLog;
		if (inqErrors!=null && !inqErrors.isEmpty()) {
			for (GIACTInquiryError__c inqEr : inqErrors) {
				inqEr.GiactInquiryResponse__c = gLog.Id;
			}
			insert inqErrors;
		}

		update baQueriedRecord;
		return isStopProcessing;
	}

	private boolean processGVerifyInquiryResponse (Map <String, Object> gResponse, GiactInquiryResponse__c gLog) {

		boolean isStopProcessing = false;

		gLog.Message__c = (String)gResponse.get('ErrorMessage');
		baQueriedRecord.Bank_Name__c = (String)gResponse.get('BankName');

		processOverallVerificationResponse (gResponse, gLog);
		Integer acntRespCode = processAccountVerificationResponse (gResponse, gLog);
		Integer custRespCode =  processCustAuthenticationResponse (gResponse, gLog); 

		gLog.ResponseStatus__c = 'Failure';

		// Keeping the following code as commented one as this may need in future. 
		if ((custRespCode==2 || custRespCode==5 || custRespCode==6) && 
			// Keeping these comments for the future reference
			//(acntRespCode==9 || acntRespCode==11 ||acntRespCode==12 || acntRespCode==13 || acntRespCode==15 ||acntRespCode==16 || acntRespCode==17 || acntRespCode==18)) {
			(acntRespCode==11 ||acntRespCode==12 || acntRespCode==13 ||acntRespCode==16 || acntRespCode==17 || acntRespCode==18)) {
			gLog.ResponseStatus__c = 'Success';
			baQueriedRecord.GiactStatus__c = 'Successfully Validated';
			isStopProcessing = true;

		//} else if (!(acntRespCode==9 || acntRespCode==11 ||acntRespCode==12 || acntRespCode==13 || acntRespCode==15 ||acntRespCode==16 || acntRespCode==17 || acntRespCode==18)){
		} else if (!(acntRespCode==11 ||acntRespCode==12 || acntRespCode==13 ||acntRespCode==16 || acntRespCode==17 || acntRespCode==18)){
			isStopProcessing = true;
		}

		return isStopProcessing;
	}

	private Integer processCustAuthenticationResponse (Map <String, Object> gResponse, GiactInquiryResponse__c gLog) {
		///********Completed the Account Verification details*******/		
		Integer custRespCode = 0;
		NameValuePair custRes = customerResponseCodes.get (custRespCode);
		if (gResponse.containsKey('CustomerResponseCode')) {
			custRespCode = (Integer) gResponse.get('CustomerResponseCode');

			if (customerResponseCodes.containskey (custRespCode)) {
				custRes = customerResponseCodes.get (custRespCode);
				gLog.gAuthenticateResponseCode__c = custRes.Name;
			}
		}
		gLog.gAuthenticateReason__c = custRes.Value;
		return custRespCode;
	}

	private void processOverallVerificationResponse (Map <String, Object> gResponse, GiactInquiryResponse__c gLog) {
		/********Setup the OverAll Verification details*******/
		Integer verRespCode = 0;
		NameValuePair verRes = verificationResponseCodes.get (verRespCode);
		gLog.gVerifyOverAllReasonCode__c = 'Error';
		if (gResponse.containsKey('VerificationResponse')) {
			verRespCode = (Integer) gResponse.get('VerificationResponse');
			if (verificationResponseCodes.containskey (verRespCode)) {
				verRes = verificationResponseCodes.get (verRespCode);
				gLog.gVerifyOverAllReasonCode__c = verRes.Name;
			}
		}

		gLog.gVerifyOverAllReason__c = verRes.Value;
		String ba_status = gLog.gVerifyOverAllReasonCode__c;
		if (gLog.gVerifyOverAllReasonCode__c=='Pass') {
			ba_status = 'Success';
		} else if (gLog.gVerifyOverAllReasonCode__c=='PassNdd') {
			ba_status = 'Success-No Demand Deposit Account';
		} else {
			ba_status = 'Failed-'+ba_status;
		}
		baQueriedRecord.Bank_Account_Verification_Status__c = ba_status;
	}

	private Integer processAccountVerificationResponse (Map <String, Object> gResponse, GiactInquiryResponse__c gLog) {		
		///********Setup the Account Verification details*******/		
		Integer acntRespCode = 0;
		NameValuePair acntRes = accountResponseCodes.get (acntRespCode);
		String acntRespName = '';
		String acntRespVal = '';

		if (gResponse.containsKey('AccountResponseCode')) {
			acntRespCode = (Integer) gResponse.get('AccountResponseCode');
			if (accountResponseCodes.containskey (acntRespCode)) {
				acntRes = accountResponseCodes.get (acntRespCode);
				acntRespName = acntRes.Name;
				acntRespVal = acntRes.Value;
				gLog.gVerifySpecificResponseCode__c = acntRes.Name;
			}
		}

		gLog.gVerifySpecificReason__c = acntRes.Value;
		return acntRespCode;
	}

	public Override String post(String url, Map<String, String> headers, String body) {
		this.afterTheFactConstructor(url, 'POST', headers, body);
		return this.responseBody;
	}

	Private String makeCallout(GIACTRestRequestBuilder.GIACTRequest bodyObj) 	{
		setStandardHeaders();
		setEnrollmentAuthHeader ();
		String url = GIACTUtils.ensureTrailingSlash(giactConfigMap.get(GIACT_CONFIG).giact_url_domain__c);
		String bodyTxt = JSON.serialize(bodyObj);
		
		if (bodyTxt !=null) {
			url = url.removeEnd('/');		
		}
		String response = post(url, this.headers, bodyTxt);
		return response;
	}

	private String makeAPMIdentifyCallout (GIACTRestRequestBuilder.GIACTRequestAPMIdentify bodyObj) {
		setStandardHeaders();
		setEnrollmentAuthHeader ();
		String url = GIACTUtils.ensureTrailingSlash(giactConfigMap.get(GIACT_CONFIG).giact_url_domain__c);
		String bodyTxt = JSON.serialize(bodyObj);

		if (bodyTxt !=null) {
			url = url.removeEnd('/');		
		}
		String response = post(url, this.headers, bodyTxt);
		return response;
	}

	Private void setStandardHeaders() {
		this.headers.put('Accept', 'application/vnd.api+json');
		this.headers.put('Content-Type', 'application/json');
	}

	Private void setEnrollmentAuthHeader() {
		Blob headerValue = Blob.valueOf(giactConfigMap.get(GIACT_CONFIG).giact_username__c + ':' + giactConfigMap.get(GIACT_CONFIG).giact_password__c);
		String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
		this.headers.put('Authorization', authorizationHeader);
	}	

	private void validateTaxIdInAdvancedData (List<GIACTIntegrationService.SSNRecord> ssnList, GIdentifyEntity dataHolder) {
		for (SSNRecord ssnRec : ssnList) {
			if (ssnToMatchWithAdvanced.equalsIgnoreCase(ssnRec.ssn)) dataHolder.taxIdValidationStatus = 'Success';
		}
	}
}