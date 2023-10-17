public with sharing class VantivLegalEntityReq 
{
	public VantivPostResponse response;
	public VantivLegalEntityReq(Id id)
	{
		VantivIntegrationService service = new VantivIntegrationService();
		response = service.makeRequestforAction('LegalEntityCreateRequest', id);
	}
	
	

}