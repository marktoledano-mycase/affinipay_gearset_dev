@isTest
public with sharing class IntercomGetContactsTest {

    @isTest
    static void testGetCurrentContactInfo() {
      // Create a test contact
      Contact testContact = new Contact(
        FirstName = 'Test',
        LastName = 'Contact',
        LeadSource = 'Email',
        Lead_Channel__c = 'Customer',
        Email = 'test.contact@example.com'
    );
    insert testContact;

    // Call the method
    List<Contact> result = IntercomGetContacts.getCurrentContactInfo(testContact.Id);

    // Assert the result
    System.assertEquals(1, result.size());
    System.assertEquals(testContact.Id, result[0].Id);
}

@isTest
    static void testGetasetContactInfo() {
      // Create a test contact
      Contact testContact = new Contact(
        FirstName = 'Test',
        LastName = 'Contact',
        LeadSource = 'Email',
        Lead_Channel__c = 'Customer',
        Email = 'test.contact@example.com'
    );
    insert testContact;

    Case testCase = new Case(
        ContactId = testContact.Id
    );
    insert testCase;

    // Call the method
    List<Case> result = IntercomGetContacts.getCaseContactInfo(testCase.Id);

    // Assert the result
    System.assertEquals(1, result.size());
    System.assertEquals(testCase.Id, result[0].Id);
}

@isTest
static void testSearchIntercomContacts() {
    // Mock HTTP response
    Test.setMock(HttpCalloutMock.class, new IntercomCalloutMock());

    // Call the method
    List<IntercomGetContacts.IntercomContact> result = IntercomGetContacts.searchIntercomContacts('name', 'test');

    // Assert the result
    System.assertNotEquals(null, result);
    // Add more assertions based on your specific requirements
}

// Create a mock class for HTTP callout
private class IntercomCalloutMock implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest req) {
        // Create a mock response
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setBody('{"type": "list", "data": []}');
        return res;
    }
}

@isTest
static void testGetConversations() {
    // Mock HTTP response
    Test.setMock(HttpCalloutMock.class, new IntercomCalloutMockConversations());

    // Call the method
    List<IntercomGetContacts.Conversation> result = IntercomGetContacts.getConversations('test_contact_id');

    // Assert the result
    System.assertNotEquals(null, result);
    // Add more assertions based on your specific requirements
}

// Create a mock class for HTTP callout
private class IntercomCalloutMockConversations implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest req) {
        // Create a mock response
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setBody('{"type": "conversation.list", "conversations": []}');
        return res;
    }
}

@isTest
    static void testGetTags() {
        // Mock HTTP response
        Test.setMock(HttpCalloutMock.class, new IntercomCalloutMockTags());

        // Call the method
        List<IntercomGetContacts.ContactTag> result = IntercomGetContacts.getTags('test_contact_id');

        // Assert the result
        System.assertNotEquals(null, result);
        // Add more assertions based on your specific requirements
    }

    // Create a mock class for HTTP callout
    private class IntercomCalloutMockTags implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            // Create a mock response
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('{"type": "list", "data": [{"type": "tag", "id": "123", "name": "Test Tag"}]}');
            return res;
        }
    }
    @isTest
    static void testDoesCurrentUserHavePermission() {
        // Create a test user
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User testUser = new User(
            ProfileId = p.Id,
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@intercomtest.com',
            Username = 'testuser@intercomtest.com',
            Alias = 'TUser',
            CommunityNickname = 'testuser',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles'
        );
        insert testUser;

        // Run test as the test user
        System.runAs(testUser) {
            // Call the AuraEnabled method
            Boolean hasPermission = IntercomGetContacts.doesCurrentUserHavePermission();

            // Assert that the method returns the expected result
            System.assertEquals(false, hasPermission, 'User should not have permission by default');
        }
    }

    @isTest
    static void testCreateTag() {
        // Mock the HTTP response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Call the AuraEnabled method
        String createdTagId = IntercomGetContacts.CreateTag('TestTag');

        // Verify that the tag was created successfully
        System.assertNotEquals(null, createdTagId, 'Tag should have been created successfully');

    }

    // Mock HTTP response generator
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            
            if (req.getEndpoint().contains('tags')) {
                // Mock a successful response
                res.setBody('{"id": "mockedTagId"}');
                res.setStatusCode(200);
            } else {
                // Mock a failed response
                res.setStatusCode(500);
            }

            return res;
        }
    }

    @isTest
    static void testAddContactTag() {
        // Mock the HTTP response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorAddTag());

        // Call the AuraEnabled method
        String jsonResponse = IntercomGetContacts.addContactTag('mockedContactId', 'mockedTagId');

        // Verify that the tag was added to the contact successfully
        System.assertNotEquals(null, jsonResponse, 'Tag should have been added to the contact successfully');

    }

    // Mock HTTP response generator
    public class MockHttpResponseGeneratorAddTag implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            
            if (req.getEndpoint().contains('contacts') && req.getMethod() == 'POST') {
                // Mock a successful response
                res.setBody('{"status": "success"}');
                res.setStatusCode(200);
            } else {
                // Mock a failed response
                res.setStatusCode(500);
            }

            return res;
        }
    }

    @isTest
    static void testRemoveContactTag() {
        // Mock the HTTP response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorRemove());

        // Call the AuraEnabled method
        String jsonResponse = IntercomGetContacts.removeContactTag('mockedContactId', 'mockedTagId');

        // Verify that the tag was removed from the contact successfully
        System.assertNotEquals(null, jsonResponse, 'Tag should have been removed from the contact successfully');

    }

    // Mock HTTP response generator
    public class MockHttpResponseGeneratorRemove implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            
            if (req.getEndpoint().contains('contacts') && req.getEndpoint().contains('tags') && req.getMethod() == 'DELETE') {
                // Mock a successful response
                res.setBody('{"status": "success"}');
                res.setStatusCode(200);
            } else {
                // Mock a failed response
                res.setStatusCode(500);
            }

            return res;
        }
    }

    @isTest
    static void testGetAllTags() {
        // Mock the HTTP response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorAllTags());

        // Call the AuraEnabled method
        IntercomGetContacts.getAllTags();

        // Verify that the tags were retrieved successfully
        // System.assertNotEquals(null, allTags, 'Tags should have been retrieved successfully');
        // System.assertNotEquals(0, allTags.size(), 'At least one tag should be present');

    }

    // Mock HTTP response generator
    public class MockHttpResponseGeneratorAllTags implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            
            if (req.getEndpoint().contains('tags') && req.getMethod() == 'GET') {
                // Mock a successful response
                res.setBody('{"data": [{"id": "tag1", "name": "Tag 1"}, {"id": "tag2", "name": "Tag 2"}]}');
                res.setStatusCode(200);
            } else {
                // Mock a failed response
                res.setStatusCode(500);
            }

            return res;
        }
    }

}