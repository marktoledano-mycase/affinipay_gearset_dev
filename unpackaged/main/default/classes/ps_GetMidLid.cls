/******************************************************************************************************
* copyright © 2016
*
* File		: ps_GetMidLid.cls
*
* Purpose	: This class implements the Intergration Service Class
*
* Test class: PS_BatchGetMidLidTest
*-----------------------------------------------------------------------------
*
*Release Date		Request 	Updated By			Description
*----------------------------------------------------------------------------------------------------------------------
*					Nill							Initial Creation
*
*09/13/2016			R163756		Rohit Kumar Malik	Create a batch to update MID and LIDs (GET Request) from ProfitStars
*09/13/2016			R164098		Rohit Kumar Malik	MYCase
*
* Latest Changes 09/19/2016
*/
public with sharing class ps_GetMidLid extends ProfitStarsIntegrationService{

	public ps_GuidResp.GetAllMerchantsResults response {get; set;}

	// This method calls sends the request and receives the response in the ps_GetMidLidRequestResults object
	public ps_GetMidLid(Id id, String product){  
		//this.response = ps_GetMidLidRequestResults.parse(makeRequestWithGuid('midlid', id, product));
		this.response = ps_GetMidLidRequestResults.parse_new(makeRequestWithGuid('midlid', id, null, product));
		System.debug('Response received - ' + this.response);
	}
}