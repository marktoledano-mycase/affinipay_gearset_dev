public abstract class AwsBase {
    //Post initialization logic (after constructor, before call)
    protected abstract void init();
    
    //Things we need to know about the service. Set these values in init()
	protected String host, region, service, resource, accessKey, payloadSha256, endpointUrl;
	public Url endpoint { get { return endpointUrl==null? null: new Url(endpointUrl); } set { endpointUrl = value==null? null: value.toExternalForm(); } }
	protected HttpMethod method;
	protected Blob payload;
	protected DateTime requestTime;

    //Not used externally, so we hide these values
	Blob signingKey;
	Map<String, String> queryParams, headerParams;

	public enum HttpMethod { XGET, XPUT, XHEAD, XOPTIONS, XDELETE, XPOST }

	protected void setHeader(String key, String value) {
		headerParams.put(key.toLowerCase(), value);
	}

    //Add a query param
	protected void setQueryParam(String key, String value) {
		queryParams.put(key, uriEncode(value));
	}

    //Call this constructor with super() in subclasses
	protected AwsBase() {
		requestTime = DateTime.now();
		queryParams = new Map<String, String>();
		headerParams = new Map<String, String>();
	}
	
    //Create a canonical query string (used during signing)
	String createCanonicalQueryString() {
		String[] results = new String[0], keys = new List<String>(queryParams.keySet());
        keys.sort();
        for(String key: keys) {
            results.add(key+'='+queryParams.get(key));
        }
        return String.join(results, '&');
	}

    //Create the canonical headers (used for signing)
	String createCanonicalHeaders(String[] keys) {
		keys.addAll(headerParams.keySet());
		keys.sort();
		String[] results = new String[0];
		for(String key: keys) {
			results.add(key+':'+headerParams.get(key));
		}
		return String.join(results, '\n')+'\n';
	}

    //Create the entire canonical request
	String createCanonicalRequest(String[] headerKeys) {
		return String.join(
			new String[] {
				method.name().removeStart('X'),			//	METHOD
				new Url(endPoint, resource).getPath(),	//	RESOURCE
				createCanonicalQueryString(),			//	CANONICAL QUERY STRING
				createCanonicalHeaders(headerKeys),		//	CANONICAL HEADERS
               	String.join(headerKeys, ';'),			//	SIGNED HEADERS
				payloadSha256							//	SHA256 PAYLOAD
			},
			'\n'
		);
	}
    
    //We have to replace ~ and " " correctly, or we'll break AWS on those two characters
    protected string uriEncode(String value) {
        return value==null? null: EncodingUtil.urlEncode(value, 'utf-8').replaceAll('%7E','~').replaceAll('\\+','%20');
    }
    
    //Create the entire string to sign
    String createStringToSign(String[] signedHeaders) {
        String result = createCanonicalRequest(signedHeaders);
        return String.join(
            new String[] {
                'AWS4-HMAC-SHA256',
                headerParams.get('date'),
                String.join(new String[] { requestTime.formatGMT('yyyyMMdd'), region, service, 'aws4_request' },'/'),
                EncodingUtil.convertToHex(Crypto.generateDigest('sha256', Blob.valueof(result)))
            },
            '\n'
        );
    }
    
    //Create the signing key
    protected void createSigningKey(String secretKey) {
        signingKey = Crypto.generateMac('hmacSHA256', Blob.valueOf('aws4_request'),
            Crypto.generateMac('hmacSHA256', Blob.valueOf(service),
                Crypto.generateMac('hmacSHA256', Blob.valueOf(region),
                    Crypto.generateMac('hmacSHA256', Blob.valueOf(requestTime.formatGMT('yyyyMMdd')), Blob.valueOf('AWS4'+secretKey))
                )
            )
        );
    }
    
    //Creating the actual request
    HttpRequest createRequest() {
        init();
        if(payload == null) {
            payload = Blob.valueOf('');
        }
        payloadSha256 = EncodingUtil.convertToHex(Crypto.generateDigest('sha-256', payload));
        setHeader('x-amz-content-sha256', payloadSha256);
        if(host == null) {
            host = endpoint.getHost();
        }
        setHeader('host', host);
        HttpRequest request = new HttpRequest();
        request.setMethod(method.name().removeStart('X'));
        if(payload.size() > 0) {
            setHeader('Content-Length', String.valueOf(payload.size()));
            request.setBodyAsBlob(payload);
        }
        String
            finalEndpoint = new Url(endpoint, resource).toExternalForm(), 
            queryString = createCanonicalQueryString();
        if(queryString != '') {
            finalEndpoint += '?'+queryString;
        }
        request.setEndpoint(finalEndpoint);
        for(String key: headerParams.keySet()) {
            request.setHeader(key, headerParams.get(key));
        }
        String[] headerKeys = new String[0];
        String stringToSign = createStringToSign(headerKeys);
        request.setHeader(
            'Authorization', 
            String.format(
                'AWS4-HMAC-SHA256 Credential={0},SignedHeaders={1},Signature={2}',
                new String[] {
                    String.join(new String[] { accessKey, requestTime.formatGMT('yyyyMMdd'), region, service, 'aws4_request' },'/'),
                    String.join(headerKeys,';'), EncodingUtil.convertToHex(Crypto.generateMac('hmacSHA256', Blob.valueOf(stringToSign), signingKey))}
            ));
        return request;
    }
    
    //Executing the request, and throw exception if response code is not valid
    protected HttpResponse sendRequest(Set<Integer> validCodes) {
        if(!Test.isRunningTest()){
            HttpResponse response = new Http().send(createRequest());
            if(!validCodes.contains(response.getStatusCode())) {
                if(response.getBody() != null) {
                    throw new AWSServiceException(response);
                }
            }
            return response;
        } else{
            createRequest();
            HttpResponse response = new HttpResponse();
            return response;
        }
	}
	
    //Same as above, but assume that only 200 is valid
    //This method exists because most of the time, 200 is what we expect
	protected HttpResponse sendRequest() {
		return sendRequest(new Set<Integer> { 200 });
	}

    //Exception class for parsing the error message from the AWS queue call
    public class AWSServiceException extends Exception {
        Error errorDetails;
	    public String requestId; 
	
		public AWSServiceException(HttpResponse response) {
            System.JSONParser parser = System.JSON.createParser(response.getBody());
            while(parser.nextToken() != System.JSONToken.END_OBJECT) {
                if(parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if(parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if(text == 'Error') {
                            errorDetails = new Error(parser);
                        } else if(text == 'RequestId') {
                            requestId = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'AWSServiceException consuming unrecognized property: ' + text);
                        }
                    }
                }
            }

            if(errorDetails != null){
                setMessage(errorDetails.errorMessage);
            }
		}
	}

    public class Error {
		public String errorCode {get;set;} 
		public String errorMessage {get;set;} 
		public String errorType {get;set;}

		public Error(JSONParser parser) {
			while(parser.nextToken() != System.JSONToken.END_OBJECT) {
				if(parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if(parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if(text == 'Code') {
							errorCode = parser.getText();
						} else if(text == 'Message') {
							errorMessage = 'Error transferring data to the AWS Queue: ' + parser.getText();
						} else if(text == 'Type') {
							errorType = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Error consuming unrecognized property: ' + text);
						}
					}
				}
			}
		}
	}
}