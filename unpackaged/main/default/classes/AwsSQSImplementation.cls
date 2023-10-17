public without sharing class AwsSQSImplementation {

    public class AwsSQSImplementationException extends Exception {}
    public static String awsQueue, awsEndpoint, AwsRegion, awsAccesskey, awsSecKey;

    public abstract class Core extends AwsBase {
        
        Core(){
            super();
            method = HttpMethod.XGET;
            payload = Blob.valueOf('');
        }

        public virtual override void init() {
            endpoint = new Url(awsEndpoint);
            accessKey = awsAccesskey;
            region = AwsRegion;
            service = 'sqs';
            host = String.join(new String[] { service, region, 'amazonaws.com' },'.');
	        setHeader('Date', requestTime.formatGmt('yyyyMMdd\'T\'HHmmss\'Z\''));
            setQueryParam('AWSAccessKeyID', accessKey);
            setQueryParam('Timestamp', requestTime.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''));
            setQueryParam('SignatureVersion', '4');
            setQueryParam('SignatureMethod','HmacSHA256');
            setHeader('Accept','application/json');
            //Prevent leaking the secret key by only exposing the signing key
            createSigningKey(awsSecKey);
        }
    }

    public class SendMessageRequest extends Core {
        public void execute(String data) {
        	resource = awsQueue;
            setQueryParam('Action','SendMessage');
            setQueryParam('MessageBody', data);
            setQueryParam('QueueUrl', resource);
            sendRequest();
        }
    }

    public class AwsMessageWrapper {
        @AuraEnabled public String recordId {get; set;}
    	@AuraEnabled public String operation {get; set;}
    }

    public static void sendMessageToPSQueue(String message) {
        getAWSConfig();
        SendMessageRequest req = new SendMessageRequest();
        req.execute(message);
    }

    private static void getAWSConfig() {
        //Access the AWS config deatils from the custom settings data
        AmazonSQS__c queueConfig = AmazonSQS__c.getOrgDefaults();

        if(queueConfig != null){
            awsQueue = queueConfig.Queue_Name__c;
            awsEndpoint = queueConfig.Endpoint__c;
            AwsRegion = queueConfig.Region__c;
            awsAccesskey = queueConfig.Access_Key__c;
            awsSecKey = queueConfig.Secret_Key__c;
        } else{
            throw new AwsSQSImplementationException('No related AWS SQS configuration found. Please check the AmazonSQS__c custom settings data!');
        }
    }
}