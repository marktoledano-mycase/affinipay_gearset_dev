/******************************************************************************************************
* copyright © 2015
*
* File		: ps_MaintRequestResults.cls
*
* Purpose	: This is a utility class to deserialize json into required format
*
* Referred from 	: All Maintenance request classes (Velocity, Location, Bank Update, Other)
*
* Test class: ps_MaintRequestResultsTest
*-----------------------------------------------------------------------------------------------------------
*
*Release Date		Request 	Updated By			Description
*----------------------------------------------------------------------------------------------------------------------
*					Nill							Initial Creation
*
*08/28/2015			R152441		Venkat Araveeti		Updated to accept new/updated response fields from ProfitStars
*******************************************************************************************************/
public class ps_MaintRequestResults{

	public String caseNumber;
	public String success;
	public String errorMessage;
	public String errorCode;

	public Map<Id, ps_MaintRequestResults> results;

	public static ps_MaintRequestResults parse(String json){
		System.debug('ps_MaintRequestResults json '+json);
	
		ps_MaintRequestResults parsed = (ps_MaintRequestResults) System.JSON.deserialize(json, ps_MaintRequestResults.class);
		System.debug('The ps_MaintRequestResults parsed is ' + parsed);
		return parsed;
	}
}