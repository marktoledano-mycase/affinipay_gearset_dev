@isTest
public class IntercomURLHttpCalloutMock implements HttpCalloutMock {
    private String expectedUrl;

    public IntercomURLHttpCalloutMock(String expectedUrl) {
        this.expectedUrl = expectedUrl;
    }

    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"url": "' + expectedUrl + '"}');
        res.setStatusCode(200);
        return res;
    }
}