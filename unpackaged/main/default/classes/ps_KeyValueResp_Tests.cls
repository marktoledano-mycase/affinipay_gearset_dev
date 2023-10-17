@isTest
public class ps_KeyValueResp_Tests {
	// @testVisible
	// Public static String json = '{\"list\":{\"NameValue\":[{\"name\":\"message\",\"value\":\"Partial Content: Request did NOT pass validation.\"},{\"name\":\"result\",\"value\":\"Rejected\"},{\"name\":\"description\",\"value\":\"{\\\"code\\\": \\\"405\\\",\\\"messages\\\": [{\\\"message\\\": \\\"Request field \\\"request_email\\\" is required. Please contact ProfitStars in order to validate account email address.\\\"}]}\"},{\"name\":\"code\",\"value\":\"206\"}]}}';

	// /**
	//  * Provides only a positive test case for now.
	//  */
	// @isTest static void testParse() {
	// 	ps_KeyValueResponse obj = ps_KeyValueResponse.parse(ps_KeyValueResp_Tests.json);
	// 	System.assert(obj != null);
	// 	System.assert(obj.san_list != null);
	// 	System.assert(obj.raw_json != null);
	// 	System.assert(obj.san_list.NameValueMap != null);
	// 	System.assert(obj.san_list.NameValue != null);
	// }

	// /**
	//  * In my humble opinion, the Apex Code Coverage calculator is horribly
	//  * broken on this one small thing, inner classes used only by
	//  * JSON.deserialize are not recognized as used / exercised.
	//  * This test exists just to construct and exercise those inner classes
	//  * to provide "coverage" for them, even though they are *FULLY*
	//  * exercised by other tests.
	//  */
	// @isTest static void uselessTestToProvideCoverageToInnerClasses() {
	// 	Test.startTest();
	// 	ps_KeyValueResponse x = new ps_KeyValueResponse();
	// 	Test.stopTest();

	// }
}