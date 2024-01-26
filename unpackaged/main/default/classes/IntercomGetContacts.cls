global class IntercomGetContacts {
    
	@AuraEnabled
	public static List<Contact> getCurrentContactInfo(string contact_id){

		return [SELECT Id, Name, Email FROM Contact WHERE Id = : contact_id LIMIT 1];
	}

	@AuraEnabled
	public static List<Case> getCaseContactInfo(string case_id){

		return [SELECT Id, ContactId, Contact.Email FROM Case WHERE Id = : case_id LIMIT 1];
	}

	@AuraEnabled
	public static List<IntercomContact> searchIntercomContacts(string search_type, string search_term){

		Http h = new Http();
		HttpRequest req = new HttpRequest();
		req.setEndpoint('https://api.intercom.io/contacts/search?per_page=150');
		req.setMethod('POST');
		req.setHeader('Content-Type', 'application/json');
		string workspace = system.label.Intercom_Workspace;
		string bearer_key = [Select Workspace__c, Key__c from Intercom_Key__mdt WHERE IsActive__c=TRUE AND Workspace__c = : workspace LIMIT 1].Key__c;
		req.setHeader('Authorization', 'Bearer ' + bearer_key);
		String strBody = '{"query": {"operator": "AND","value": [{"field": "name","operator": "!=","value":null},{"field" : "email","operator": "=","value": "' + search_term  + '"}]},"pagination": {"page":1,"per_page":150} }';
		req.setBody(strBody);
		System.debug('Intercom Callout Body: ' + strBody);

        HttpResponse res = h.send(req);
		system.debug(res.getBody());
		string jsonStr = res.getBody();
		
		IntercomContactWrapper intercomContactWrapperList = (IntercomContactWrapper)JSON.deserialize(jsonStr, IntercomContactWrapper.class);
		List<IntercomContact> intercom_contactList = intercomContactWrapperList.data;
		return intercom_contactList;

	}

	@AuraEnabled
	public static List<Conversation> getConversations(string contact_id){
		Http h = new Http();
		HttpRequest req = new HttpRequest();
		req.setEndpoint('https://api.intercom.io/conversations/search?per_page=150');
		req.setMethod('POST');
		req.setHeader('Content-Type', 'application/json');
		string workspace = system.label.Intercom_Workspace;
		string bearer_key = [Select Workspace__c, Key__c from Intercom_Key__mdt WHERE IsActive__c=TRUE AND Workspace__c = : workspace LIMIT 1].Key__c;
		req.setHeader('Authorization', 'Bearer ' + bearer_key);
		String strBody = '{"query": {"operator": "AND","value": [{"field": "id","operator": "!=","value":null},{"field" : "contact_ids","operator": "=","value": "' + contact_id  + '"}]},"pagination": {"page":1,"per_page":150} }';
		req.setBody(strBody);
		System.debug('Intercom Conversation Callout Body: ' + strBody);

        HttpResponse res = h.send(req);
		system.debug(res.getBody());
		string jsonStr = res.getBody();

		ConversationsWrapper wrapper = (ConversationsWrapper)JSON.deserialize(jsonStr, ConversationsWrapper.class);

		// Access the list of conversations
		List<Conversation> conversationList = wrapper.conversations;
		
		// Iterate through the list as needed
		for (Conversation conversation : conversationList) {
			System.debug('Conversation ID: ' + conversation.id);
			// Access other conversation properties as needed
		}

		return conversationList;
	}
	@AuraEnabled
    public static Boolean doesCurrentUserHavePermission() {
        // Replace 'Custom_Permission_Name' with the actual API name of your custom permission
		system.debug('Tagging Permissions: ' + FeatureManagement.checkPermission('Intercom_Tagging'));
        return FeatureManagement.checkPermission('Intercom_Tagging');
    }

	@AuraEnabled
	public static List<ContactTag> getTags(string contact_id){
		Http h = new Http();
		HttpRequest req = new HttpRequest();
		req.setEndpoint('https://api.intercom.io/contacts/' + contact_id + '/tags');
		req.setMethod('GET');
		req.setHeader('Content-Type', 'application/json');
		string workspace = system.label.Intercom_Workspace;
		string bearer_key = [Select Workspace__c, Key__c from Intercom_Key__mdt WHERE IsActive__c=TRUE AND Workspace__c = : workspace LIMIT 1].Key__c;
		req.setHeader('Authorization', 'Bearer ' + bearer_key);

        HttpResponse res = h.send(req);
		system.debug(res.getBody());
		string jsonStr = res.getBody();

		TagsWrapper wrapper = (TagsWrapper)JSON.deserialize(jsonStr, TagsWrapper.class);

		// Access the list of conversations
		List<ContactTag> tagList = wrapper.data;
		
		// Iterate through the list as needed
		for (ContactTag contact_tag : tagList) {
			System.debug('Tag ID: ' + contact_tag.id);
			// Access other conversation properties as needed
		}

		return tagList;
	}

	@AuraEnabled
	public static String CreateTag(string tag_name){
		Http h = new Http();
		HttpRequest req = new HttpRequest();
		req.setEndpoint('https://api.intercom.io/tags');
		req.setMethod('POST');
		req.setHeader('Content-Type', 'application/json');
		string workspace = system.label.Intercom_Workspace;
		string bearer_key = [Select Workspace__c, Key__c from Intercom_Key__mdt WHERE IsActive__c=TRUE AND Workspace__c = : workspace LIMIT 1].Key__c;
		req.setHeader('Authorization', 'Bearer ' + bearer_key);

		String strBody = '{"name": "' + tag_name + '"}';
		req.setBody(strBody);

        HttpResponse res = h.send(req);
		system.debug(res.getBody());
		string jsonStr = res.getBody();

		CreatedTagWrapper createdTag = (CreatedTagWrapper)JSON.deserialize(jsonStr, CreatedTagWrapper.class);
		system.debug('Created Tag Id: ' + createdTag.id);
		return createdTag.id;
	}

	@AuraEnabled
	public static String addContactTag(string contact_id, string tag_id){
		Http h = new Http();
		HttpRequest req = new HttpRequest();
		req.setEndpoint('https://api.intercom.io/contacts/' + contact_id + '/tags');
		req.setMethod('POST');
		req.setHeader('Content-Type', 'application/json');
		string workspace = system.label.Intercom_Workspace;
		string bearer_key = [Select Workspace__c, Key__c from Intercom_Key__mdt WHERE IsActive__c=TRUE AND Workspace__c = : workspace LIMIT 1].Key__c;
		req.setHeader('Authorization', 'Bearer ' + bearer_key);
		String strBody = '{"id": "' + tag_id + '"}';
		req.setBody(strBody);

        HttpResponse res = h.send(req);
		system.debug(res.getBody());
		string jsonStr = res.getBody();

		return jsonStr;
	}

	@AuraEnabled
	public static String removeContactTag(string contact_id, string tag_id){
		Http h = new Http();
		HttpRequest req = new HttpRequest();
		req.setEndpoint('https://api.intercom.io/contacts/' + contact_id + '/tags/' + tag_id);
		req.setMethod('DELETE');
		req.setHeader('Content-Type', 'application/json');
		string workspace = system.label.Intercom_Workspace;
		string bearer_key = [Select Workspace__c, Key__c from Intercom_Key__mdt WHERE IsActive__c=TRUE AND Workspace__c = : workspace LIMIT 1].Key__c;
		req.setHeader('Authorization', 'Bearer ' + bearer_key);

        HttpResponse res = h.send(req);
		system.debug(res.getBody());
		string jsonStr = res.getBody();

		return jsonStr;

	}

	@AuraEnabled
	public static List<TagData> getAllTags(){
		Http h = new Http();
		HttpRequest req = new HttpRequest();
		req.setEndpoint('https://api.intercom.io/tags');
		req.setMethod('GET');
		req.setHeader('Content-Type', 'application/json');
		string workspace = system.label.Intercom_Workspace;
		string bearer_key = [Select Workspace__c, Key__c from Intercom_Key__mdt WHERE IsActive__c=TRUE AND Workspace__c = : workspace LIMIT 1].Key__c;
		req.setHeader('Authorization', 'Bearer ' + bearer_key);

        HttpResponse res = h.send(req);
		system.debug(res.getBody());
		string jsonStr = res.getBody();

		TagWrapper tagWrapper = (TagWrapper)JSON.deserialize(jsonStr, TagWrapper.class);
		List<TagData> allTags = tagWrapper.data;
		system.debug('Get all tags: ' + allTags);
		return allTags;

	}


	public class Location {
		@AuraEnabled public String type;
		@AuraEnabled public String country;
		@AuraEnabled public String region;
		@AuraEnabled public String city;
		@AuraEnabled public String country_code;
		@AuraEnabled public String continent_code;
	}
	
	public class SocialProfile {
		@AuraEnabled public String type;
		@AuraEnabled public List<String> data;
	}
	
	public class Tag {
		@AuraEnabled public String id;
		@AuraEnabled public String type;
		@AuraEnabled public String url;
	}
	
	public class CustomAttribute {
		@AuraEnabled public String salesforce_id;
		@AuraEnabled public Boolean Email_opt_out_SFDC;
		// Add more fields as needed
	}
	
	public class IntercomContact {
		@AuraEnabled  public String type;
		@AuraEnabled  public String id;
		@AuraEnabled  public String workspace_id;
		@AuraEnabled  public String external_id;
		@AuraEnabled  public String role;
		@AuraEnabled  public String email;
		@AuraEnabled  public String phone;
		@AuraEnabled  public String name;
		@AuraEnabled  public String avatar;
		@AuraEnabled  public Integer owner_id;
		@AuraEnabled  public SocialProfile social_profiles;
		@AuraEnabled  public Boolean has_hard_bounced;
		@AuraEnabled  public Boolean marked_email_as_spam;
		@AuraEnabled  public Boolean unsubscribed_from_emails;
		@AuraEnabled  public Long created_at;
		@AuraEnabled  public Long updated_at;
		@AuraEnabled  public Long signed_up_at;
		@AuraEnabled  public Long last_seen_at;
		// Add more fields as needed
		@AuraEnabled  public Location location;
		@AuraEnabled  public CustomAttribute custom_attributes;
		// @AuraEnabled  public List<Tag> tags;
	}
	
	public class IntercomContactWrapper {
		@AuraEnabled public String type;
		@AuraEnabled public List<IntercomContact> data;
	}

	// CONVERSATIONS OBJECT MODEL
	public class ConversationsWrapper {
	@AuraEnabled public String type;
    @AuraEnabled public Pages pages;
    @AuraEnabled public Integer total_count;
    @AuraEnabled public List<Conversation> conversations;
	}

    public class Pages {
        @AuraEnabled public String type;
        @AuraEnabled public Integer page;
        @AuraEnabled public Integer per_page;
        @AuraEnabled public Integer total_pages;
    }

    public class Conversation {
        @AuraEnabled public String type;
        @AuraEnabled public String id;
        @AuraEnabled public Integer created_at;
        @AuraEnabled public Integer updated_at;
        // @AuraEnabled public Object waiting_since;
        // @AuraEnabled public Object snoozed_until;
        @AuraEnabled public Source source;
        @AuraEnabled public IntercomContacts contacts;
        @AuraEnabled public FirstContactReply first_contact_reply;
        @AuraEnabled public Integer admin_assignee_id;
        @AuraEnabled public Integer team_assignee_id;
        @AuraEnabled public Boolean open;
        @AuraEnabled public String state;
        @AuraEnabled public Boolean read;
        @AuraEnabled public Tags tags;
        @AuraEnabled public String priority;
        // @AuraEnabled public Object sla_applied;
        @AuraEnabled public Statistics statistics;
        // @AuraEnabled public Object conversation_rating;
        @AuraEnabled public Teammates teammates;
        @AuraEnabled public String title;
        // @AuraEnabled public Map<String, Object> custom_attributes;
        @AuraEnabled public Topics topics;
        // @AuraEnabled public Object ticket;
        @AuraEnabled public LinkedObjects linked_objects;
	}

        public class Source {
            @AuraEnabled public String type;
            @AuraEnabled public String id;
            @AuraEnabled public String delivered_as;
            @AuraEnabled public String subject;
            @AuraEnabled public String body;
            @AuraEnabled public Author author;
            // @AuraEnabled public List<Object> attachments;
            // @AuraEnabled public Object url;
            @AuraEnabled public Boolean redacted;
        }

        public class Author {
            @AuraEnabled public String type;
            @AuraEnabled public String id;
            @AuraEnabled public String name;
            @AuraEnabled public String email;
        }

        public class IntercomContacts {
            @AuraEnabled public String type;
            @AuraEnabled public List<IntercomContact> contacts;
        }


        public class FirstContactReply {
            @AuraEnabled public Integer created_at;
            @AuraEnabled public String type;
            @AuraEnabled public String url;
        }

        public class Tags {
            @AuraEnabled public String type;
            // @AuraEnabled public List<Object> tags;
        }

        public class Statistics {
            @AuraEnabled public String type;
            @AuraEnabled public Integer time_to_assignment;
            // @AuraEnabled public Object time_to_admin_reply;
            @AuraEnabled public Integer time_to_first_close;
            @AuraEnabled public Integer time_to_last_close;
            // @AuraEnabled public Object median_time_to_reply;
            @AuraEnabled public Integer first_contact_reply_at;
            @AuraEnabled public Integer first_assignment_at;
            // @AuraEnabled public Object first_admin_reply_at;
            @AuraEnabled public Integer first_close_at;
            @AuraEnabled public Integer last_assignment_at;
            // @AuraEnabled public Object last_assignment_admin_reply_at;
            @AuraEnabled public Integer last_contact_reply_at;
            // @AuraEnabled public Object last_admin_reply_at;
            @AuraEnabled public Integer last_close_at;
            @AuraEnabled public Integer last_closed_by_id;
            @AuraEnabled public Integer count_reopens;
            @AuraEnabled public Integer count_assignments;
            @AuraEnabled public Integer count_conversation_parts;
        }

        public class Teammates {
            @AuraEnabled public String type;
            // @AuraEnabled public List<Object> admins;
        }

        public class Topics {
            @AuraEnabled public String type;
            // @AuraEnabled public List<Object> topics;
            @AuraEnabled public Integer total_count;
        }

        public class LinkedObjects {
            @AuraEnabled public String type;
            // @AuraEnabled public List<Object> data;
            @AuraEnabled public Integer total_count;
            @AuraEnabled public Boolean has_more;
        }
    
		public class ContactTag {
			@AuraEnabled public String type;
			@AuraEnabled public String id;
			@AuraEnabled public String name;
		}
		
		public class TagsWrapper {
			@AuraEnabled public String type;
			@AuraEnabled public List<ContactTag> data;
		}

		public class CreatedTagWrapper {
			@AuraEnabled public String type;
			@AuraEnabled public String id;
			@AuraEnabled public String name;
		}

		public class TagWrapper {
			@AuraEnabled public String type;
			@AuraEnabled public List<TagData> data;
		}
		
		public class TagData {
			@AuraEnabled public String type;
			@AuraEnabled public String id;
			@AuraEnabled public String name;
		}
}