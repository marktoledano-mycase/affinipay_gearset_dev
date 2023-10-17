@isTest
private class AwsSQSImplementationTest {
    private static testMethod void testSendMessageToPSQueue(){
        TestUtils.createAWSTestSettings();
        AwsSQSImplementation.sendMessageToPSQueue('testMessage');
        System.assertEquals('testQueue', AwsSQSImplementation.awsQueue);
    }

    private static testMethod void testAWSServiceException(){
        TestUtils.createAWSTestSettings();
        HttpResponse errorResponse = new HttpResponse();
        errorResponse.setHeader('Content-type', 'application/json');
        errorResponse.setBody('{"Error":{"Code":"InvalidAddress","Message":"The address appfolio-bs-salesforce-poc-tobedeleted is not valid for this endpoint.","Type":"Sender"},"RequestId":"6d4fb579-c6eb-5908-b66a-e22d167e21ca"}');
        errorResponse.setStatusCode(404);
        AwsBase.AWSServiceException serviceException = new AwsBase.AWSServiceException(errorResponse);
        System.assertNotEquals(null, serviceException.requestId);
        System.assertEquals('6d4fb579-c6eb-5908-b66a-e22d167e21ca', serviceException.requestId);
    }
}