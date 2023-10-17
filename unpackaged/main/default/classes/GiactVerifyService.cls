/**********************************************************************************************************************
* copyright © 2017
* File		: GiactVerifyService.cls
* Purpose	: This class validates a set of custom Setting records. Based on the custom setting records this class
* determines, if the all the required fields are available on the SObject record. For eg. if The custom setting is
* gVerify and The SObject is Bank Account. Then it validates if all the Required fields on the Custom Setting is
* avaialble in the BankAccount Record. 
*
* @author Rohit Kumar Malik
* @version 1.0
* @since 2017-10-20
**********************************************************************************************************************/

global without sharing class GiactVerifyService {
	Static Set <Id> processedBankAccountRecords = new Set <Id> ();

	@future (callout = true)
	public static void verifyService (Id valuePlusId, Id baId) {
		// First Check if the String is empty or not. 
		if (valuePlusId==null) {
			return;
		}

		System.debug('*** Preparing to process GIdentify.');
		// Intatntiate the Class. 
		GIACTIntegrationService gis = new GIACTIntegrationService ();
		gis.pull_GiactVerifyData ('gverifyinquiry', valuePlusId, baId);
	}

	public static Boolean IsVerifyProcessingRequired (Bank_Account__c ba) {

		if (!processedBankAccountRecords.contains(ba.Id) &&
			(ba.GiactStatus__c=='Ready to Transmit to GIACT')) {
			return true;
		}

		return false;
	}

	public static void processBankAccountRecordsForGiact (List<Bank_Account__c> newList) {

		for (Bank_Account__c ba : newList) {
			System.debug ('*** Checking if the record needs to be processed with Giact');
			if (IsVerifyProcessingRequired (ba))  {
				System.debug ('*** Processing Giact - Returning True');
				// Add to the set to that it is not processed again. 
				processedBankAccountRecords.add (ba.Id);
                GiactVerifyService.verifyService(ba.ValuePlus__c, ba.id); 
			}
		}
	}
}