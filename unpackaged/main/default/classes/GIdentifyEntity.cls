/*
* Test Class: GiactVerifyServiceTest
*/
public with sharing class GIdentifyEntity {

	public class GIdentifyEntityException extends Exception {}

	public Boolean isBusinessRecord {get; set;}
	public Id ParentId {get; set;}
	public Id vPlusId {get; set;}


	public String Name {get; set;}

	public String gIDAdvancedRawRequest {get; set;}
	public String gIDAdvancedRawResponse {get; set;}

	public String gIDBasicRawRequest {get; set;}
	public String gIDBasicRawResponse {get; set;}

	public String responseReasonCode {get; set;}
	public String responseReason {get; set;}

	public String nameValidationStatus {get; set;}
	public String dobValidationStatus {get; set;}	
	public String addressValidationStatus {get; set;}
	public String taxIdValidationStatus {get; set;}

	public String numberOfBankruptcies {get; set;}
	public String numberOfLeins {get; set;}
	public String numberOfJudgements {get; set;}

	public String ofacInformation {get; set;}
	public String registrationType {get; set;}
	public String secStatus {get; set;}	

	public String uniqueId {get; set;}

	public List<Attachment> entityAttachments {get; set;}

	GIdentifyEntityInformation__c entityDBRecord {get; set;}

	public GIdentifyEntity() {
		entityAttachments =  new List<Attachment> ();
		entityDBRecord = new GIdentifyEntityInformation__c ();

		nameValidationStatus = 'N/A';
		dobValidationStatus = 'N/A';
		addressValidationStatus = 'N/A';
		taxIdValidationStatus = 'N/A';

		numberOfBankruptcies = 'N/A';
		numberOfLeins = 'N/A';
		numberOfJudgements = 'N/A';

		secStatus = 'N/A';
	}

	public GIdentifyEntity(Id valuePlus, Boolean isBusiness) {
		this.vPlusId = valuePlus;
		this.isBusinessRecord = isBusiness; 
		entityAttachments =  new List<Attachment> ();
		entityDBRecord = new GIdentifyEntityInformation__c ();
	}

	public void updateDataOnDBRecord () {
		if (isBusinessRecord) {
    		entityDBRecord.RecordTypeId = Schema.SObjectType.GIdentifyEntityInformation__c.getRecordTypeInfosByName().get('Business').getRecordTypeId();
    	} else {
    		entityDBRecord.RecordTypeId = Schema.SObjectType.GIdentifyEntityInformation__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
    	}

		entityDBRecord.Name = name;
		Integer maxLength1 = GIdentifyEntityInformation__c.GIdentifyAdvanceResponse__c.getDescribe().getLength();
		entityDBRecord.GIdentifyAdvanceRequest__c = gIDAdvancedRawRequest;
		if (!String.isEmpty(gIDAdvancedRawResponse)){
			entityDBRecord.GIdentifyAdvanceResponse__c = gIDAdvancedRawResponse.length() > maxLength1 ? gIDAdvancedRawResponse.substring(0, maxLength1-5) : gIDAdvancedRawResponse;
		}

		Integer maxLength2 = GIdentifyEntityInformation__c.gIdentifyResponseText__c.getDescribe().getLength();
		entityDBRecord.gIdentifyRequestText__c = gIDBasicRawRequest;
		if (!String.isEmpty(gIDBasicRawResponse)){
			entityDBRecord.gIdentifyResponseText__c = gIDBasicRawResponse.length() > maxLength2 ? gIDBasicRawResponse.substring(0, maxLength2-5) : gIDBasicRawResponse;
		}

		List<String> fraudString = System.Label.GIACT_Keyword_List.split(',');
		for (String fraud : fraudString) {
			if ((!String.isEmpty(gIDAdvancedRawResponse) && gIDAdvancedRawResponse.containsIgnoreCase(fraud)) || 
				(!String.isEmpty(gIDBasicRawResponse) && gIDBasicRawResponse.containsIgnoreCase(fraud))){
				entityDBRecord.Fraud_Activity_Found__c = true;
				break;
			}
		}

		entityDBRecord.gIdentifyResponseCode__c = responseReasonCode;
		entityDBRecord.gIdentifyResponseReason__c = responseReason;

		entityDBRecord.NameValidationStatus__c = nameValidationStatus;
		entityDBRecord.DOB_Status__c = dobValidationStatus;
		entityDBRecord.AddressValidationStatus__c = addressValidationStatus;
		entityDBRecord.SSNTaxIdValidationStatus__c = taxIdValidationStatus;


		entityDBRecord.NumberofBankruptcies__c = (!String.isEmpty(numberOfBankruptcies)) ? Integer.valueOf(numberOfBankruptcies) : null;
		entityDBRecord.NumberofLiens__c = (!String.isEmpty(numberOfLeins)) ? Integer.valueOf(numberOfLeins) : null;
		entityDBRecord.NumberOfJudgements__c = (!String.isEmpty(numberOfJudgements)) ? Integer.valueOf(numberOfJudgements) : null;

		System.debug(entityDBRecord.NumberofBankruptcies__c + ' ----- ' + ((String.isEmpty(numberOfBankruptcies)==false) ? Integer.valueOf(numberOfBankruptcies) : null));

		entityDBRecord.OFACInformation__c = ofacInformation;
		entityDBRecord.RegistrationType__c = ((String.isEmpty(registrationType)||registrationType.equals('null'))? 'N/A' : registrationType);		
		entityDBRecord.SECStatus__c = ((String.isEmpty(secStatus)||secStatus.equals('null'))? 'N/A' : secStatus);
		entityDBRecord.RequestUniqueId__c = uniqueId;
		entityDBRecord.GIACTIdentifyResponse__c = ParentId;

		System.debug(entityDBRecord.NumberofBankruptcies__c + ' ----- ' + ((String.isEmpty(numberOfBankruptcies)==false) ? Integer.valueOf(numberOfBankruptcies) : null));
	}

	public void  insertEntity () {

		updateDataOnDBRecord ();

		try {
			if (ParentId==null) {
				throw new GIdentifyEntityException ('Parent Id is not updated. Please update the parent Id. This happens when GIDResponse insert has failed.');
			}

			insert entityDBRecord;

			for (Attachment att : entityAttachments) {
				att.parentId = entityDBRecord.Id;
			}

			if (!entityAttachments.isEmpty()) {
				insert entityAttachments; 
			}
		} catch (Exception ex) {
			SystemExceptionLogger.insertSystemExceptionLogEntry(ex, 
										 							'GIACT Identify',  
										 							'InsertEntity : InsertEntity', 
										 							SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL,
										 							'Error while inserting the Entity Result in Database.',
										 							'ValuePlus',
													 				vPlusId,
										 							true);
		}
	}

}