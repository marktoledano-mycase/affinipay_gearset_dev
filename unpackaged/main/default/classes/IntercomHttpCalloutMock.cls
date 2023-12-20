@isTest
public class IntercomHttpCalloutMock implements HttpCalloutMock {
    private String expectedResponse;

    public IntercomHttpCalloutMock(String expectedResponse) {
        this.expectedResponse = expectedResponse;
    }

    public HTTPResponse respond(HTTPRequest req) {
        HTTPResponse res = new HTTPResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(expectedResponse);
        res.setStatusCode(200);
        return res;
    }

}