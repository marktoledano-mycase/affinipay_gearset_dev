public with sharing class VantivSubMerchantCreateReq 
{
	public VantivPostResponse response;
	public VantivSubMerchantCreateReq(Id id)
	{
		VantivIntegrationService service = new VantivIntegrationService();
		response = service.makeRequestforAction('SubMerchantCreateRequest', id);
		System.debug(response.toString());
	}

}