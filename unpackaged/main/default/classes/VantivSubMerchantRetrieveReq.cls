public with sharing class VantivSubMerchantRetrieveReq {
	
	public VantivPostResponse response;
	public VantivSubMerchantRetrieveReq(Id id)
	{
		VantivIntegrationService service = new VantivIntegrationService();
		response = service.makeRequestforAction('SubMerchantRetrieveRequest', id);
	}

}