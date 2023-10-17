public with sharing class VantivSubMerchantUpdateReq {
	public VantivPostResponse response;
	public VantivSubMerchantUpdateReq(Id id)
	{
		VantivIntegrationService service = new VantivIntegrationService();
		response = service.makeRequestforAction('SubMerchantUpdateRequest', id);
	}

}