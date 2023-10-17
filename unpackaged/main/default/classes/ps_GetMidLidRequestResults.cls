/******************************************************************************************************
* copyright © 2016
*
* File		: ps_GetMidLidRequestResults.cls
*
* Purpose	: This is a utility class to deserialize json into required format
*
* Referred from 	: All Maintenance request classes (Velocity, Location, Bank Update, Other)
*
* Test class: PS_BatchGetMidLidTest
*-----------------------------------------------------------------------------------------------------------
*
*Release Date		Request 	Updated By			Description
*----------------------------------------------------------------------------------------------------------------------
*					Nill							Initial Creation
*
*09/09/2016			R152441		Rohit Kumar Malik	Updated to accept new/updated response fields from ProfitStars
*******************************************************************************************************/

public class ps_GetMidLidRequestResults{

	public ps_GuidResp.GetAllMerchantsResults resp;

	public static ps_GuidResp.GetAllMerchantsResults parse_new(String json){
		json = ProfitStarsUtils.sanitizeJson(json);
		System.debug('Sanitized Json Response - ' + json);
		ps_GuidResp.GetAllMerchantsResults parsed = (ps_GuidResp.GetAllMerchantsResults) System.JSON.deserialize(json, ps_GuidResp.GetAllMerchantsResults.class);
		return parsed;
	}
}