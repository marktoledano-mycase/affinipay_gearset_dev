/******************************************************************************************************
* copyright © 2016
*
* File		: ps_GetAllMerchantRespProcessor.cls
*
* Purpose	: This is a batch class for other(any) Update. Thi class identified the records for other update 
*				and instanciates the service class to send the request to profitstars
*
* Referred from 	: PS_BatchGetMidLid.cls
*-----------------------------------------------------------------------------
*
*Release Date		Request 	Updated By			Description
*----------------------------------------------------------------------------------------------------------------------
*					Nill							Initial Creation
*
*08/15/2016
*
** Latest Changes 08/16/2016

*******************************************************************************************************/
public with sharing class ps_GetAllMerchantRespProcessor {
// NEWCO MIGRATION COMMENT
	// // This map holds all the Merchant Name (Which is a Account DBA Name) and complete merchant information
	// public Map<Id, MerchantInfo> merchantInfoMap{get; set;}

	// public class MerchantInfo {

	// 	public MerchantInfo (String creationDateTime,
	// 							 String entityId,
	// 							 String merchantId,
	// 							 String merchantEnabled,
	// 							 String merchantName,
	// 							 String boardingRefId,
	// 							 Id valuePlusRecordid) {

	// 		// A Merchant can have multiple Locations to be So This map will hold all the Bank Account Label and its complete information.
	// 		locationMap = new Map <String, Location> ();
	// 		this.creationDateTime = creationDateTime;
	// 		this.entityId = entityId;
	// 		this.merchantId = merchantId;	
	// 		this.merchantEnabled = merchantEnabled;
	// 		this.merchantName = merchantName;
	// 		this.boardingRefId = valuePlusRecordid;
	// 		this.valuePlusRecordid = valuePlusRecordid;			
	// 	}

	// 	public String creationDateTime {get; set;}
	// 	public String entityId {get; set;}
	// 	public String merchantId {get; set;}
	// 	public String merchantEnabled {get; set;}
	// 	public String merchantName {get; set;}
	// 	public String boardingRefId {get; set;}
	// 	public String valuePlusRecordid {get; set;}		

	// 	public Map <String, Location> locationMap {get; set;}
	// }

	// public class Location {

	// 	public Location (String isEnaled,
	// 							 String locationId,
	// 							 String locationName) {

	// 		this.isEnaled = isEnaled;
	// 		this.locationId = locationId;
	// 		this.locationName = locationName;

	// 	}

	// 	public String isEnaled {get; set;}
	// 	public String locationId {get; set;}
	// 	public String locationName {get; set;}

	// }

	// public ps_GetAllMerchantRespProcessor () {
	// 	merchantInfoMap = new Map<Id, MerchantInfo>();
	// }

	// public List<String> merchantListToBeUpdated;
	// public List<String> bankAccountsToBeUpdated;
	// //public List<ValuePlus> valuePlusRecordsToBeUpdated;

	// /**
	// * Purpose: This method is responsible for retrieving all the Merchants and 
	// * their Bank Account information and building the merchantInfoMap. 
	// *
	// *
	// */
	// public boolean processResponse (String midLidXMLResponse, String transactionType) {

	// 	// Query a value plus record which is having a  Account as the Merchant Name and Bank Account Name

	// 	// Prepare the Data Structure from the Response, which can be used in updating the records. 

	// 	/* Following is the hierarchy of the response we are getting from the Profit Stars.

	// 		<Envelope>
	// 		<Header>
	// 			<Action mustUnderstand="1">https://ssl.selectpayment.com/IFileMaintenance/GetAllMerchantsResponse</Action>
	// 		</Header>
	// 		<Body>
	// 			<GetAllMerchantsResponse>
	// 				<GetAllMerchantsResult>
	// 	*/

	// 	Dom.Document responseDoc = new Dom.Document(); 
	// 	responseDoc.load(midLidXMLResponse);
	// 	Dom.XmlNode root = responseDoc.getRootElement();

	// 	// Get the Body Element
	// 	Dom.XmlNode body = root.getChildElement('Body',null);
	// 	Dom.XmlNode getAllMerchantsResponseNode = body.getChildElement('GetAllMerchantsResponse',null);
	// 	Dom.XmlNode merchantList = getAllMerchantsResponseNode.getChildElement('GetAllMerchantsResult',null);

	// 	for (Dom.XmlNode merchant : merchantList.getChildElements()) {

	// 		String merS1 = merchant.getChildElement ('MerchantName', null).getText();
	// 		String merTarget = 'amp;';
	// 		String merReplacement = '';
	// 		String mName = merS1.replace(merTarget, merReplacement);
	// 		System.debug('mName - ' + merS1 + ' ' + mName);


	// 		List<String> tokens = mName.split('-');
	// 		System.debug('Tokens - ' + tokens);

	// 		Id vPlusid;
	// 		String vPlusidString;

	// 		if (!tokens.isEmpty()) {
	// 			vPlusidString = tokens[tokens.size()-1];

	// 			String vid = String.escapeSingleQuotes(vPlusidString);
	// 	    	if((vid.length() == 15 || vid.length() == 18) && Pattern.matches('^[a-zA-Z0-9]*$', vid)) {
	// 	    		vPlusid = Id.valueOf(vid);
	// 	    	} else {
	// 	    		continue;
	// 	    	}
	// 		}
	// 		merTarget = '-' + vPlusid;
	// 		mName = mName.replace(merTarget,  merReplacement);

	// 		MerchantInfo mInfo = new MerchantInfo (
	// 			merchant.getChildElement ('CreationDateTime', null).getText(),
	// 			merchant.getChildElement ('CustServProviderId', null).getText(),
	// 			merchant.getChildElement ('EntityId', null).getText(),
	// 			merchant.getChildElement ('MerchantEnabled', null).getText(),
	// 			vPlusid,
	// 			mName,
	// 			vPlusid
	// 			);

	// 		System.debug('mINfo ' + mInfo);
	// 		Dom.XmlNode locationList = merchant.getChildElement('Locations',null);

	// 		if (locationList==null)
	// 			continue;

	// 		for (Dom.XmlNode wsMerLoc : locationList.getChildElements()) {

	// 			if (wsMerLoc.getChildElement ('LocationEnabled', null) != null &&
	// 				wsMerLoc.getChildElement ('LocationId', null) != null &&
	// 				wsMerLoc.getChildElement ('LocationName', null) != null)  {

	// 				String locs1 = wsMerLoc.getChildElement ('LocationName', null).getText();
	// 				String loctarget = 'amp;';
	// 				String locReplacement = '';
	// 				String locName = locs1.replace(loctarget, locReplacement);

	// 				System.debug('LocationEnabled ' + wsMerLoc.getChildElement ('LocationEnabled', null).getText());
	// 				System.debug('LocationId ' + wsMerLoc.getChildElement ('LocationId', null).getText());
	// 				System.debug('LocationName ' + locName);

	// 				mInfo.locationMap.put(wsMerLoc.getChildElement ('LocationName', null).getText(), 
	// 					new Location (
	// 						wsMerLoc.getChildElement ('LocationEnabled', null).getText(),
	// 						wsMerLoc.getChildElement ('LocationId', null).getText(),
	// 						locName 
	// 					));
	// 			}
	// 		}

	// 		System.debug('Merchant Parsing result : '  + JSON.serialize(mInfo) + ' ' + mInfo.merchantName);

	// 		// This map creates a list of all the Merchants with their merchant information. 
	// 		merchantInfoMap.put(mInfo.valuePlusRecordid, mInfo);
	// 		System.debug('Merchant Successfully Retrieved');
	// 	}

	// 	return true;
	// }
}