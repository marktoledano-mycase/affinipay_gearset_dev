@isTest
global class GiactHttpMock implements HttpCalloutMock{


	protected Integer code;
    protected String status;
    protected List<String> body;
    protected Map<String, String> responseHeaders;

    public Integer responseIndex;    
    private List<Integer> code_list;

  	public GiactHttpMock (List<Integer> a_code_list, String a_status, List<String> a_body, Map<String, String> a_responseHeaders) {
        code = a_code_list[0];
        status = a_status;
        body = a_body;
        responseHeaders = a_responseHeaders;
        responseIndex = 0;
        code_list = a_code_list;
    }


	public HttpResponse respond(HttpRequest a_request) {
        HttpResponse l_response = new HttpResponse();
        
        for (String l_key : responseHeaders.keySet()) {
            l_response.setHeader(l_key, responseHeaders.get(l_key));
        }
        l_response.setBody(body[responseIndex]);
        l_response.setStatusCode(code);
        l_response.setStatusCode(code_list.size()>1 ? code_list[responseIndex] : code);
        l_response.setStatus(status);
        responseIndex++;

        System.debug('Response From the httmp mock class - ' + l_response);
        
        return l_response;
    }

}