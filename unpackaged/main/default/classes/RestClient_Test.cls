@isTest
private class RestClient_Test {

	// private class TestRestClient extends RestClient {
	// 	// Just for testing.
	// }

	// Private static Map<String, Integer> HttpCodes = New Map<String, Integer> {
	// 	'Success' => 200,
	// 	'Redirect' => 302,
	// 	'Bad Request' => 400,
	// 	'Unauthorized' => 401,
	// 	'Payment Required' => 402,
	// 	'Forbidden' => 403,
	// 	'Not Found' => 404,
	// 	'Method Not Allowed' => 405
	// };

	// Private static Map<String, Integer> HttpCodes2 = New Map<String, Integer> {
	// 	'Unsupported Media Type' => 415,
	// 	'Internal Server Error' => 500,
	// 	'Not Implemented' => 501,
	// 	'Bad Gateway' => 502,
	// 	'Service Unavailable' => 503,
	// 	'Gateway Timeout' => 504,
	// 	'HTTP Version Not Supported' => 505
	// };

	// //@isTest static void test_logWithDEBUGTrue() {
	// //	TestRestClient trc = new TestRestClient();
	// //	trc.log('This is a Header', null, 'My Awesome Message');
	// //	System.Assert(trc.lastDebugMessage.contains('This is a Header'));
	// //	System.Assert(trc.lastDebugMessage.contains('No Obj set'));
	// //	System.Assert(trc.lastDebugMessage.contains('My Awesome Message'));
	// //}

	// @isTest static void test_GetConstructorWithUrlAndFirstSetOfResponseCodes() {
	// 	TestRestClient trc = new TestRestClient();
	// 	for (String key : HttpCodes.keySet()) {
	// 		RestClientCalloutMockFactory fakeResponse = new RestClientCalloutMockFactory(HttpCodes.get(key), key, key, new Map<String, String>());
	// 		Test.setMock(HttpCalloutMock.class, fakeResponse);
	// 		if (HttpCodes.get(key) > 299) {
	// 			try {
	// 				String result = trc.get('http://www.google.com');
	// 			} catch (RestClient.RestClientException rce) {
	// 				System.Assert(rce.getMessage().contains('Failed to recieve a success code from remote. Code was: ' + key));
	// 			}
	// 		} else {
	// 			String result = trc.get('http://www.google.com');
	// 			System.Assert(result.contains(key));
	// 		}
	// 	}
	// }

	// @isTest static void test_GetConstructorWithUrlAndSecondSetOfResponseCodes() {
	// 	TestRestClient trc = new TestRestClient();
	// 	for (String key : HttpCodes2.keySet()) {
	// 		RestClientCalloutMockFactory fakeResponse = new RestClientCalloutMockFactory(HttpCodes2.get(key), key, key, new Map<String, String>());
	// 		Test.setMock(HttpCalloutMock.class, fakeResponse);
	// 		if (HttpCodes2.get(key) > 299) {
	// 			try {
	// 				String result = trc.get('http://www.google.com');
	// 			} catch (RestClient.RestClientException rce) {
	// 				System.Assert(rce.getMessage().contains('Failed to recieve a success code from remote. Code was: ' + key));
	// 			}
	// 		} else {
	// 			String result = trc.get('http://www.google.com');
	// 			System.Assert(result.contains(key));
	// 		}
	// 	}
	// }

	// @isTest static void test_GetConstructorWithUrlAndHeadersAndFirstSetOfResponseCodes() {
	// 	TestRestClient trc = new TestRestClient();
	// 	Map<String, String> headers = new Map<String, String> {'q' => 'Awesome'};
	// 	for (String key : HttpCodes.keySet()) {
	// 		RestClientCalloutMockFactory fakeResponse = new RestClientCalloutMockFactory(HttpCodes.get(key), key, key, new Map<String, String>());
	// 		Test.setMock(HttpCalloutMock.class, fakeResponse);
	// 		if (HttpCodes.get(key) > 299) {
	// 			try {
	// 				String result = trc.get('http://www.google.com', headers);
	// 			} catch (RestClient.RestClientException rce) {
	// 				System.Assert(rce.getMessage().contains('Failed to recieve a success code from remote. Code was: ' + key));
	// 			}
	// 		} else {
	// 			// String result = trc.get('http://www.google.com', headers);
	// 			// System.Assert(result.contains(key));
	// 		}
	// 	}
	// }

	// @isTest static void test_GetConstructorWithUrlAndHeadersAndSecondSetOfResponseCodes() {
	// 	TestRestClient trc = new TestRestClient();
	// 	Map<String, String> headers = new Map<String, String> {'q' => 'Awesome'};
	// 	for (String key : HttpCodes2.keySet()) {
	// 		RestClientCalloutMockFactory fakeResponse = new RestClientCalloutMockFactory(HttpCodes2.get(key), key, key, new Map<String, String>());
	// 		Test.setMock(HttpCalloutMock.class, fakeResponse);
	// 		if (HttpCodes2.get(key) > 299) {
	// 			try {
	// 				String result = trc.get('http://www.google.com', headers);
	// 			} catch (RestClient.RestClientException rce) {
	// 				System.Assert(rce.getMessage().contains('Failed to recieve a success code from remote. Code was: ' + key));
	// 			}
	// 		} else {
	// 			String result = trc.get('http://www.google.com', headers);
	// 			System.Assert(result.contains(key));
	// 		}
	// 	}
	// }

	// @isTest static void test_GetConstructorWithUrlAndHeadersAndBodyAndFirstSetOfResponseCodes() {
	// 	TestRestClient trc = new TestRestClient();
	// 	Map<String, String> headers = new Map<String, String> {'q' => 'Awesome'};
	// 	for (String key : HttpCodes.keySet()) {
	// 		RestClientCalloutMockFactory fakeResponse = new RestClientCalloutMockFactory(HttpCodes.get(key), key, key, new Map<String, String>());
	// 		Test.setMock(HttpCalloutMock.class, fakeResponse);
	// 		if (HttpCodes.get(key) > 299) {
	// 			try {
	// 				String result = trc.get('http://www.google.com', headers, 'foo bar baz');
	// 			} catch (RestClient.RestClientException rce) {
	// 				System.Assert(rce.getMessage().contains('Failed to recieve a success code from remote. Code was: ' + key));
	// 			}
	// 		} else {
	// 			// String result = trc.get('http://www.google.com', headers, 'foo bar baz');
	// 			// System.Assert(result.contains(key));
	// 		}
	// 	}
	// }

	// @isTest static void test_GetConstructorWithUrlAndHeadersAndBodyAndSecondSetOfResponseCodes() {
	// 	TestRestClient trc = new TestRestClient();
	// 	Map<String, String> headers = new Map<String, String> {'q' => 'Awesome'};
	// 	for (String key : HttpCodes2.keySet()) {
	// 		RestClientCalloutMockFactory fakeResponse = new RestClientCalloutMockFactory(HttpCodes2.get(key), key, key, new Map<String, String>());
	// 		Test.setMock(HttpCalloutMock.class, fakeResponse);
	// 		if (HttpCodes2.get(key) > 299) {
	// 			try {
	// 				String result = trc.get('http://www.google.com', headers, 'foo bar baz');
	// 			} catch (RestClient.RestClientException rce) {
	// 				System.Assert(rce.getMessage().contains('Failed to recieve a success code from remote. Code was: ' + key));
	// 			}
	// 		} else {
	// 			// String result = trc.get('http://www.google.com', headers, 'foo bar baz');
	// 			// System.Assert(result.contains(key));
	// 		}
	// 	}
	// }

	// @isTest static void test_GetConstructorWithUrlAndHeadersAndMethodPUTAndFirstSetOfResponseCodes() {
	// 	TestRestClient trc = new TestRestClient();
	// 	Map<String, String> headers = new Map<String, String> {'q' => 'Awesome'};
	// 	for (String key : HttpCodes.keySet()) {
	// 		RestClientCalloutMockFactory fakeResponse = new RestClientCalloutMockFactory(HttpCodes.get(key), key, key, new Map<String, String>());
	// 		Test.setMock(HttpCalloutMock.class, fakeResponse);
	// 		if (HttpCodes.get(key) > 299) {
	// 			try {
	// 				String result = trc.request('http://www.google.com', 'PUT', headers);
	// 			} catch (RestClient.RestClientException rce) {
	// 				System.Assert(rce.getMessage().contains('Failed to recieve a success code from remote. Code was: ' + key));
	// 			}
	// 		} else {
	// 			// String result = trc.request('http://www.google.com', 'PUT', headers);
	// 			// System.Assert(result.contains(key));
	// 		}
	// 	}
	// }

	// @isTest static void test_GetConstructorWithUrlAndHeadersAndMethodPUTAndSecondSetOfResponseCodes() {
	// 	TestRestClient trc = new TestRestClient();
	// 	Map<String, String> headers = new Map<String, String> {'q' => 'Awesome'};
	// 	for (String key : HttpCodes2.keySet()) {
	// 		RestClientCalloutMockFactory fakeResponse = new RestClientCalloutMockFactory(HttpCodes2.get(key), key, key, new Map<String, String>());
	// 		Test.setMock(HttpCalloutMock.class, fakeResponse);
	// 		if (HttpCodes2.get(key) > 299) {
	// 			try {
	// 				String result = trc.request('http://www.google.com', 'PUT', headers);
	// 			} catch (RestClient.RestClientException rce) {
	// 				System.Assert(rce.getMessage().contains('Failed to recieve a success code from remote. Code was: ' + key));
	// 			}
	// 		} else {
	// 			// String result = trc.request('http://www.google.com', 'PUT', headers);
	// 			// System.Assert(result.contains(key));
	// 		}
	// 	}
	// }

	// @isTest static void test_GetConstructorWithUrlAndHeadersAndMethodPOSTAndFirstSetOfResponseCodes() {
	// 	TestRestClient trc = new TestRestClient();
	// 	Map<String, String> headers = new Map<String, String> {'q' => 'Awesome'};
	// 	for (String key : HttpCodes.keySet()) {
	// 		RestClientCalloutMockFactory fakeResponse = new RestClientCalloutMockFactory(HttpCodes.get(key), key, key, new Map<String, String>());
	// 		Test.setMock(HttpCalloutMock.class, fakeResponse);
	// 		if (HttpCodes.get(key) > 299) {
	// 			try {
	// 				String result = trc.request('http://www.google.com', 'POST', 'foo bar baz');
	// 			} catch (RestClient.RestClientException rce) {
	// 				System.Assert(rce.getMessage().contains('Failed to recieve a success code from remote. Code was: ' + key));
	// 			}
	// 		} else {
	// 			// String result = trc.request('http://www.google.com', 'POST', 'foo bar baz');
	// 			// System.Assert(result.contains(key));
	// 		}
	// 	}
	// }

	// @isTest static void test_GetConstructorWithUrlAndHeadersAndMethodPOSTAndSecondSetOfResponseCodes() {
	// 	TestRestClient trc = new TestRestClient();
	// 	Map<String, String> headers = new Map<String, String> {'q' => 'Awesome'};
	// 	for (String key : HttpCodes2.keySet()) {
	// 		RestClientCalloutMockFactory fakeResponse = new RestClientCalloutMockFactory(HttpCodes2.get(key), key, key, new Map<String, String>());
	// 		Test.setMock(HttpCalloutMock.class, fakeResponse);
	// 		if (HttpCodes2.get(key) > 299) {
	// 			try {
	// 				String result = trc.request('http://www.google.com', 'POST', 'foo bar baz');
	// 			} catch (RestClient.RestClientException rce) {
	// 				System.Assert(rce.getMessage().contains('Failed to recieve a success code from remote. Code was: ' + key));
	// 			}
	// 		} else {
	// 			// String result = trc.request('http://www.google.com', 'POST', 'foo bar baz');
	// 			// System.Assert(result.contains(key));
	// 		}
	// 	}
	// }

	// @isTest static void test_GetConstructorWithUrlAndMethodPOSTAndFirstSetOfResponseCodes() {
	// 	TestRestClient trc = new TestRestClient();
	// 	for (String key : HttpCodes.keySet()) {
	// 		RestClientCalloutMockFactory fakeResponse = new RestClientCalloutMockFactory(HttpCodes.get(key), key, key, new Map<String, String>());
	// 		Test.setMock(HttpCalloutMock.class, fakeResponse);
	// 		if (HttpCodes.get(key) > 299) {
	// 			try {
	// 				String result = trc.request('http://www.google.com', 'POST');
	// 			} catch (RestClient.RestClientException rce) {
	// 				System.Assert(rce.getMessage().contains('Failed to recieve a success code from remote. Code was: ' + key));
	// 			}
	// 		} else {
	// 			// String result = trc.request('http://www.google.com', 'POST');
	// 			// System.Assert(result.contains(key));
	// 		}
	// 	}
	// }

	// @isTest static void test_GetConstructorWithUrlAndMethodPOSTAndSecondSetOfResponseCodes() {
	// 	TestRestClient trc = new TestRestClient();
	// 	for (String key : HttpCodes2.keySet()) {
	// 		RestClientCalloutMockFactory fakeResponse = new RestClientCalloutMockFactory(HttpCodes2.get(key), key, key, new Map<String, String>());
	// 		Test.setMock(HttpCalloutMock.class, fakeResponse);
	// 		if (HttpCodes2.get(key) > 299) {
	// 			try {
	// 				String result = trc.request('http://www.google.com', 'POST');
	// 			} catch (RestClient.RestClientException rce) {
	// 				System.Assert(rce.getMessage().contains('Failed to recieve a success code from remote. Code was: ' + key));
	// 			}
	// 		} else {
	// 			// String result = trc.request('http://www.google.com', 'POST');
	// 			// System.Assert(result.contains(key));
	// 		}
	// 	}
	// }

	// //@isTest static void test_PostConstructorWithUrlAndHeadersAndBodyAndFirstSetOfResponseCodes() {
	// //  TestRestClient trc = new TestRestClient();
	// //  Map<String, String> headers = new Map<String, String> {'q' => 'Awesome'};
	// //  for (String key : HttpCodes.keySet()) {
	// //    RestClientCalloutMockFactory fakeResponse = new RestClientCalloutMockFactory(HttpCodes.get(key), key, key, new Map<String, String>());
	// //    Test.setMock(HttpCalloutMock.class, fakeResponse);
	// //    if (HttpCodes.get(key) > 299) {
	// //      try {
	// //        HttpResponse result = trc.post('http://www.google.com', headers, 'foo bar baz');
	// //      } catch (RestClient.RestClientException rce) {
	// //        System.Assert(rce.getMessage().contains('Failed to recieve a success code from remote. Code was: ' + key));
	// //      }
	// //    } else {
	// //      // HttpResponse result = trc.post('http://www.google.com', headers, 'foo bar baz');
	// //      // System.AssertEquals(result.getStatusCode(), HttpCodes.get(key));
	// //    }
	// //  }
	// //}

	// //@isTest static void test_PostConstructorWithUrlAndHeadersAndBodyAndSecondSetOfResponseCodes() {
	// //  TestRestClient trc = new TestRestClient();
	// //  Map<String, String> headers = new Map<String, String> {'q' => 'Awesome'};
	// //  for (String key : HttpCodes2.keySet()) {
	// //    RestClientCalloutMockFactory fakeResponse = new RestClientCalloutMockFactory(HttpCodes2.get(key), key, key, new Map<String, String>());
	// //    Test.setMock(HttpCalloutMock.class, fakeResponse);
	// //    if (HttpCodes2.get(key) > 299) {
	// //      try {
	// //        HttpResponse result = trc.post('http://www.google.com', headers, 'foo bar baz');
	// //      } catch (RestClient.RestClientException rce) {
	// //        System.Assert(rce.getMessage().contains('Failed to recieve a success code from remote. Code was: ' + key));
	// //      }
	// //    } else {
	// //      // HttpResponse result = trc.post('http://www.google.com', headers, 'foo bar baz');
	// //      // System.AssertEquals(result.getStatusCode(), HttpCodes2.get(key));
	// //    }
	// //  }
	// //}

}