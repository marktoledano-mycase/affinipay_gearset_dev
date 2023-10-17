/*
* Test Class: GiactVerifyServiceTest
*/
global without sharing class GiactIdentifyService {
	Static Set <Id> alreadyProcessedRecords = new Set <Id> ();
	static List<ValuePlus__c> vpList;

	// This method will receive only those records which are having the Change in status from to 'Ready to Transmit to Giact'
	@future (callout = true)
	public static void identifyService (Id valuePlusId) {
		try {
			// First Check if the String is empty or not. 
			if (valuePlusId==null) {
				return;
			}

			System.debug('*** Preparing to process GIdentify.');
			// Intatntiate the Class. 
			GIACTIntegrationService gis = new GIACTIntegrationService ();
			gis.pull_GiactIdentifyData ('gidentifyinquiry', valuePlusId);
        }catch(Exception ex){
            SystemExceptionLogger.fireSystemExceptionLogEvent (ex, 'GiactIdentifyService', 'identifyService',
			 	SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, ex.getMessage(), 'ValuePlus', valuePlusId, false);
        }
	}

	public static Boolean IsIdetifyProcessingRequired (ValuePlus__c vp) {
		// if (!alreadyProcessedRecords.contains(vp.Id) && (vp.RecordTypeId == InformationStrings.vPlusMycasePaymentsId || vp.RecordTypeId== InformationStrings.vPlusAPMPaymentsId) &&
		// if (!alreadyProcessedRecords.contains(vp.Id) && (vp.RecordTypeId == InformationStrings.vPlusMycasePaymentsId) &&
		if (!alreadyProcessedRecords.contains(vp.Id) &&
			(vp.Stage__c.equals('Sold/Not Started') || vp.Stage__c.equals('On-Boarding') || vp.Stage__c.equals('Live') || vp.Stage__c.equals('Active')) &&
			(vp.TIN_Match__c=='Ready To Transmit' || 
				vp.GIACTBusinessValidation__c =='Ready To Transmit To GIACT' ||								
				vp.GIACTBusinessOwner_1_Validation__c =='Ready To Transmit To GIACT' ||
				vp.GIACTBusinessOwner_2_Validation__c =='Ready To Transmit To GIACT' ||
				vp.GIACTBusinessOwner_3_Validation__c =='Ready To Transmit To GIACT' ||
				vp.GIACTBusinessOwner_4_Validation__c =='Ready To Transmit To GIACT'
			)) {

			return true;
		}

		return false;
	}

	public static void doCallOut(){
		try {
			if(vpList != null && !vpList.isEmpty()){
				for(ValuePlus__c vp : vpList){
					System.debug ('*** Processing Giact - Returning True');
					// Add to the set to that it is not processed again. 
					alreadyProcessedRecords.add (vp.Id);
					GiactIdentifyService.identifyService(vp.Id); 
				}
			}
        }catch(Exception ex){
            SystemExceptionLogger.fireSystemExceptionLogEvent (ex, 'GiactIdentifyService', 'doCallOut',
			 	SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, ex.getMessage(), 'ValuePlus__c', null, false);
        }
	}

	public static void processValuePlusRecordsForGiact(ValuePlus__c newRecord){
		try {
			System.debug ('*** Checking if the record needs to be processed with Giact');
			
			if(vpList == null){
				vpList = new List<ValuePlus__c>();
			}

			if(IsIdetifyProcessingRequired(newRecord)){
				vpList.add(newRecord);
			}
        }catch(Exception ex){
            SystemExceptionLogger.fireSystemExceptionLogEvent (ex, 'GiactIdentifyService', 'filterValueAPMWebsites',
			 	SystemExceptionLogger.EXCEPTION_LEVEL_CRITICAL, ex.getMessage(), null, (newRecord != null ? newRecord.Id : null), false);
        }
	}
}