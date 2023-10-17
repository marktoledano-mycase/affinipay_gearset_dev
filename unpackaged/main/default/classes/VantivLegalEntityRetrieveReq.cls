public with sharing class VantivLegalEntityRetrieveReq {
	
	public VantivPostResponse response;
	public VantivLegalEntityRetrieveReq(Id id)
	{
		VantivIntegrationService service = new VantivIntegrationService();
		response = service.makeRequestforAction('LegalEntityRetrieveRequest', id);
	}

}