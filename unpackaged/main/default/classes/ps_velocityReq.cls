/*
* Test class: ps_velocityReqTest
*/
public with sharing class ps_velocityReq extends ProfitStarsIntegrationService{

	public ps_MaintRequestResults response {get; protected set;}

	public ps_velocityReq(Id id, String product){
		this.response = ps_MaintRequestResults.parse(makeRequestWithGuid('velocity', id, null, product));
	}
}