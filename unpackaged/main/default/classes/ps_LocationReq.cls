/*
* Test class: ps_LocationReqTest
*/
public with sharing class ps_LocationReq extends ProfitStarsIntegrationService{

	public ps_MaintRequestResults response {get; protected set;}

	public ps_LocationReq(Id id, String product){
		this.response = ps_MaintRequestResults.parse(makeRequestWithGuid('location', id, null, product));
	}
}