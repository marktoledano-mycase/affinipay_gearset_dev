/*
* Test class for the ps_GuidResp class.
*/
@isTest
private class ps_GuidResp_Tests{

	// static String validEnrollCallJson = '{"transaction_id":"006M000000JcyDsIAJ","result":"Application Created","message":"Success","code":"200","application_id":"00000939"}';
	// static String errorEnrollCallJson = '{"transaction_id":null,"result":"Error","message":"Failed","code":"400","application_id":null}';
	
	// static testmethod void testParse_Error_Message(){
	// 	ps_GuidResp.PS_Resp obj = ps_GuidResp.parse_new(errorEnrollCallJson);
	// 	System.assert(obj != null);
	// }

	// static testmethod void testParse_Success_Message(){
	// 	ps_GuidResp.PS_Resp obj = ps_GuidResp.parse_new(validEnrollCallJson);
	// 	System.assert(obj != null);
	// }

	/**
	 * In my humble opinion, the Apex Code Coverage calculator is horribly
	 * broken on this one small thing, inner classes used only by
	 * JSON.deserialize are not recognized as used / exercised.
	 * This test exists just to construct and exercise those inner classes
	 * to provide "coverage" for them, even though they are *FULLY*
	 * exercised by other tests.
	 */
	/*static testmethod void uselessTestToProvideCoverageToInnerClasses(){
		Test.startTest();
		ps_GuidResp x = new ps_GuidResp();
		Test.stopTest();
	}*/
}