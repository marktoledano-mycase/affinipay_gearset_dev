/*
* Test class: ps_buttonMethodsTest
*/
public with sharing class ps_FieldUpdateReq extends ProfitStarsIntegrationService{

	public ps_MaintRequestResults response {get; protected set;}

	public ps_FieldUpdateReq(String action, Id id, String product){
		this.response = ps_MaintRequestResults.parse(makeRequestWithGuid(action, id, null, product));
	}
}