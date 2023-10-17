/*
* Test class: ps_EnrollmentReqTest
*/
public with sharing class ps_EnrollmentReq extends ProfitStarsIntegrationService{

	public ps_GuidResp.PS_Resp resp;

	public ps_EnrollmentReq(Id id, String product){
		//response = ps_KeyValueResponse.parse(makeRequestWithGuid('enrollment', id, product));
		resp = ps_GuidResp.parse_new(makeRequestWithGuid('enrollment', id, null, product));
		System.debug('resp: '+ resp);
	}
}