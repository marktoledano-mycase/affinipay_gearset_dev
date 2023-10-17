/*
* Test Class:
*		RestClientTest
*		RestClientTests
*/
Public with sharing virtual class RestClient {
	Public class RestClientException extends Exception {}

	/*

	  RestClient is not intended for direct use, but rather to be extended by an implementation specific
	  Class. Thus, if you had two Rest integrations, one to :ServiceA and one to :ServiceB,
	  both classes would extend this one, and have access to the Get(), Put(), Post(), Patch() etc. methods.

	 */

	/*
	 * class variables - DO NOT EDIT
	 */

	Public Map<String, String> headers           = new Map<String, String>();
	Public String              url               = '';
	Public String              method            = '';
	Public String              body              = '';
	Public HttpRequest         request;
	Public HttpResponse        response;
	Public Integer             responseCode;
	Public String              responseBody;
	Public String              lastDebugMessage;
	Public Http                httpObj;
	Public String              clientCert;

	/*
	 * Constants - Edit to your satisfaction
	 */

	Public Static Integer TIMEOUT = 120000; // Default HTTP Timeout
	Public Boolean DEBUG = TRUE; // should we print debug statements?

	/*
	 * Constructors:
	 */
	/**
	 * Empty RestClient constructor
	 * @return RestClient obj
	 */
	Public RestClient() {}

	/*
	 * All in constructor
	 * @param  url                     URL to act on
	 * @param  method                  ENUM of [put|post|patch|get|delete]
	 * @param  Map<String,headers>     Headers map
	 * @param  body                    request body
	 * @return                         RestClient Obj
	 */
	Public RestClient(String url, String method, Map<String, String> headers, String body) {
		afterTheFactConstructor(url, method, headers, body);
	}

	/*
	 * All in after the fact constructor
	 * To be used when this class is override and integrated into bigger stack
	 * @param  url                     URL to act on
	 * @param  method                  ENUM of [put|post|patch|get|delete]
	 * @param  Map<String,headers>     Headers map
	 * @param  body                    request body
	 * @return                         RestClient Obj
	 */
	Public void afterTheFactConstructor(String url, String method, Map<String, String> headers, String body) {
		try {
			this.httpObj = new Http();
			this.request = buildRequest(headers, url, method.toUpperCase(), body);
			this.response = makeRequest(this.httpObj, this.request);
			this.responseBody = handleResponse(this.response);
		} catch (Exception e) {
			log.error('Failed to execute callout. SFDC Reports: ', e, e.getMessage());
			if (headers != null) this.headers = headers;
			this.body = body;
			this.url = url;
			this.method = method.toUpperCase();
		}
	}

	/**
	 * Constructor without headers
	 * @param  url    Url to act on
	 * @param  method ENUM of [put|post|patch|get|delete]
	 * @param  body   body of HttpRequest
	 * @return        RestClient obj
	 */
	Public RestClient(String url, String method, String body) {
		this(url, method, null, body);
	}

	/**
	 * All in after the fact constructor
	 * to be used when an extending class is using this.
	 * @param  url    Url to act on
	 * @param  method ENUM of [put|post|patch|get|delete]
	 * @param  body   body of HttpRequest
	 * @return        self
	 */
	Public Void afterTheFactConstructor(String url, String method, String body) {
		afterTheFactConstructor(url, method, null, body);
	}

	/**
	 * Constructor without Body
	 * @param  url                 Url to act on
	 * @param  method              ENUM of [put|post|patch|get|delete]
	 * @param  Map<String,headers> Headers map - header name : header value
	 * @return                     RestClient Obj
	 */
	Public RestClient(String url, String method, Map<String, String> headers) {
		this(url, method, headers, null);
	}

	/**
	 * after the fact constructor without Body
	 * to be used by an extending class
	 * @param  url                 Url to act on
	 * @param  method              ENUM of [put|post|patch|get|delete]
	 * @param  Map<String,headers> Headers map - header name : header value
	 * @return                     RestClient Obj
	 */
	Public Void afterTheFactConstructor(String url, String method, Map<String, String> headers) {
		afterTheFactConstructor(url, method, headers, null);
	}

	/**
	 * Constructor with just url and method
	 * @param  url    Url to act on
	 * @param  method ENUM of [put|post|patch|get|delete]
	 * @return        RestClient Obj
	 */
	Public RestClient(String url, String method) {
		this(url, method, new Map<String, String>(), null);
	}

	/**
	 * after the fact constructor without Body
	 * to be used by an extending class
	 * @param  url    Url to act on
	 * @param  method ENUM of [put|post|patch|get|delete]
	 * @return        RestClient Obj
	 */
	Public Void afterTheFactConstructor(String url, String method) {
		afterTheFactConstructor(url, method, null, null);
	}

	/*
	 * Helper Methods - These do the actual work.
	 */

	Public HttpRequest buildRequest(map<String, String> headers, String url, String method, String body) {
		if (DEBUG) {
			log.info('Restclient buildRequest details', headers + '\n' + url + '\n' + method + '\n' + body, 'set RestClient.DEBUG = false to suppress this message');
		}
		HttpRequest request = new HttpRequest();
		if (this.clientCert != null) {
			request.setClientCertificateName(this.clientCert);
		}
		request.setTimeout(TIMEOUT); // timeout in milliseconds
		if (this.headers != null) {
			for (String hkey : this.headers.keySet()) {
				request.setHeader(hkey, headers.get(hkey));
			}
		}

		if (headers != null) {
			for (String hkey : headers.keySet()) {
				request.setHeader(hkey, headers.get(hkey));
			}
		}
		request.setEndpoint(url);
		request.setMethod(method);
		if (body != null && body.length() > 0) {
			request.setBody(body);
		}
		return request;
	}

	Public HttpResponse makeRequest(Http h, HttpRequest request) {
		HttpResponse response = h.send(request);
		if (response.getStatusCode() > 299) {
			log.error('Failed to receive a success code from remote. Code was: ' + response.getStatusCode() + ' request was ' + request + ' Response Body is: ' + response.getBody(), response, response.getBody());
		}
		log.log('RAW RESPONSE OBJ', response, 'END RAW RESPONSE');
		return response;
	}

	Public string handleResponse(HttpResponse response) {
		return response.getBody();
	}

	Public Virtual String put(String url, Map<String, String> headers, String body) {
		this.afterTheFactConstructor(url, 'put', headers, null);
		return this.responseBody;
	}	

	/**
	* GET Convenance Methods.
	**/
	// RestClient.get('http://www.google.com/?q=convenance')
	Public Virtual String get(String url) {
		this.afterTheFactConstructor(url, 'get', null, null);
		return this.responseBody;
	}

	// RestClient.get('http://www.google.com/', HeaderMap{'q', 'convenance'})
	Public Virtual String get(String url, map<String, String> headers) {
		this.afterTheFactConstructor(url, 'get', headers, null);
		return this.responseBody;
	}

	// RestClient.get('http://www.google.com/', HeaderMap{'q', 'convenance'}, 'some body of text for unknown reason.')
	Public Virtual String get(String url, map<String, String> headers, String body) {
		this.afterTheFactConstructor(url, 'get', headers, body);
		return this.responseBody;
	}

	Public Virtual String post(String url, Map<String, String> headers, String Body) {
		this.afterTheFactConstructor(url, 'POST', headers, body);
		return this.responseBody;
	}

	Public Virtual String request(String url, String method, Map<String, String> headers) {
		this.afterTheFactConstructor(url, method, headers);
		return this.responseBody;
	}

	Public Virtual String request(String url, String method, String body) {
		this.afterTheFactConstructor(url, method, body);
		return this.responseBody;
	}

	Public Virtual String request(String url, String method) {
		this.afterTheFactConstructor(url, method);
		return this.responseBody;
	}

}