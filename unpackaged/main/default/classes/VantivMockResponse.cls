@isTest
global class VantivMockResponse implements HttpCalloutMock {
	
	public String body;
	public Integer responseCode;
	public  VantivMockResponse(String Body, Integer statusCode)
	{
		this.body = body;
		this.responseCode = statusCode;
	}
	global HttpResponse respond(HttpRequest req)
	{
		HttpResponse response = new HttpResponse();
        
        response.setHeader('Content-Type', 'application/xml; charset=UTF-8');
        response.setBody(body);
        response.setStatusCode(responseCode);
        
        return response;
	}

}