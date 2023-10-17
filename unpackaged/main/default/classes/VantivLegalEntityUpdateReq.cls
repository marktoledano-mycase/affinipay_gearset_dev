public with sharing class VantivLegalEntityUpdateReq {
	public VantivPostResponse response;
	public VantivLegalEntityUpdateReq(Id id)
	{
		VantivIntegrationService service = new VantivIntegrationService();
		response = service.makeRequestforAction('LegalEntityUpdateRequest', id);
	}
}