/*
* Test class: ps_buttonMethodsTest
*/
public with sharing class ps_addOnBatchReq extends ProfitStarsIntegrationService{
	public ps_MaintRequestResults response {get; protected set;}
	public ps_addOnBatchReq(Id id, Id bankId, String product){
		//this.response = ps_MaintRequestResults.parse(makeRequestWithGuid('addon', id, product));
		this.response = ps_MaintRequestResults.parse(makeRequestWithGuid('location', id, bankId, product));
	}
}