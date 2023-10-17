/*
* Test class: PS_BatchBankAccountUpdatesTest
*/
public with sharing class ps_BankAccountReq extends ProfitStarsIntegrationService{

	public ps_MaintRequestResults response {get; protected set;}

	public ps_BankAccountReq(Id id, String product){
		this.response = ps_MaintRequestResults.parse(makeRequestWithGuid('bank account', id, null, product));
	}
}