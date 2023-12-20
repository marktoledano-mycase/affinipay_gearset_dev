public class IntercomArticleSearch{



@AuraEnabled
public static String GetArticleBody(String ArticleId){
    Http h = new Http();
    HttpRequest req = new HttpRequest();
    req.setEndpoint('https://api.intercom.io/articles/'+ ArticleId);
    req.setMethod('GET');
    req.setHeader('Content-Type', 'application/json');
    string workspace = system.label.Intercom_Workspace;
    string bearer_key = [Select Workspace__c, Key__c from Intercom_Key__mdt WHERE Workspace__c = : workspace LIMIT 1].Key__c;
    req.setHeader('Intercom-Version', '2.10');
    req.setHeader('Authorization', 'Bearer ' + bearer_key);
    
    HttpResponse res = h.send(req);
    string jsonStr = res.getBody();
    system.debug('Response: ' + jsonStr);

    ArticleBodyWrapper article = (ArticleBodyWrapper) JSON.deserialize(jsonStr, ArticleBodyWrapper.class);
    
    String bodyContent = '<h1 class="slds-card__header-title">' + article.title + '</h1><br/>' + article.body;
    return bodyContent;
}

@AuraEnabled
public static String GetArticlePublicLink(String ArticleId){
    Http h = new Http();
    HttpRequest req = new HttpRequest();
    req.setEndpoint('https://api.intercom.io/articles/'+ ArticleId);
    req.setMethod('GET');
    req.setHeader('Content-Type', 'application/json');
    string workspace = system.label.Intercom_Workspace;
    string bearer_key = [Select Workspace__c, Key__c from Intercom_Key__mdt WHERE Workspace__c = : workspace LIMIT 1].Key__c;
    req.setHeader('Intercom-Version', '2.10');
    req.setHeader('Authorization', 'Bearer ' + bearer_key);
    
    HttpResponse res = h.send(req);
    string jsonStr = res.getBody();
    system.debug('Response: ' + jsonStr);

    ArticleBodyWrapper article = (ArticleBodyWrapper) JSON.deserialize(jsonStr, ArticleBodyWrapper.class);
    return article.url;

}

@AuraEnabled
public static List<ArticleWrapper> SearchArticles(String searchTerm){

    String urlSafeString = searchTerm.replace(' ', '%20');

    Http h = new Http();
    HttpRequest req = new HttpRequest();
    req.setEndpoint('https://api.intercom.io/articles/search?phrase='+ urlSafeString);
    req.setMethod('GET');
    req.setHeader('Content-Type', 'application/json');
    string workspace = system.label.Intercom_Workspace;
    string bearer_key = [Select Workspace__c, Key__c from Intercom_Key__mdt WHERE Workspace__c = : workspace LIMIT 1].Key__c;
    req.setHeader('Intercom-Version', '2.10');
    req.setHeader('Authorization', 'Bearer ' + bearer_key);
    
    HttpResponse res = h.send(req);
    string jsonStr = res.getBody();
    system.debug('Response: ' + jsonStr);

    ApiResponseWrapper response = (ApiResponseWrapper) JSON.deserialize(jsonStr, ApiResponseWrapper.class);

    if (response.data != null && response.data.articles != null) {
        system.debug('Parsed List Response: ' + response.data.articles);
        return response.data.articles;
    } else {
        return new List<ArticleWrapper>();
    }

}

@AuraEnabled
public static List<SearchInfoWrapper> SearchArticlesInfo(String searchTerm, String nextURL){
    
    String urlSafeString = searchTerm.replace(' ', '%20');
    String api_endpoint;
    if(nextURL != null){
        api_endpoint = nextURL;
    }else{
        api_endpoint = 'https://api.intercom.io/articles/search?phrase='+ urlSafeString;
    }
    System.debug('NEXT ENDPOINT: ' + api_endpoint);
    Http h = new Http();
    HttpRequest req = new HttpRequest();
    req.setEndpoint(api_endpoint);
    req.setMethod('GET');
    req.setHeader('Content-Type', 'application/json');
    string workspace = system.label.Intercom_Workspace;
    string bearer_key = [Select Workspace__c, Key__c from Intercom_Key__mdt WHERE Workspace__c = : workspace LIMIT 1].Key__c;
    req.setHeader('Intercom-Version', '2.10');
    req.setHeader('Authorization', 'Bearer ' + bearer_key);
    
    HttpResponse res = h.send(req);
    string jsonStr = res.getBody();
    system.debug('Response: ' + jsonStr);

    List<SearchInfoWrapper> resultList = new List<SearchInfoWrapper>();

  // Parse the JSON string
  SearchInfoWrapper apiResponse = (SearchInfoWrapper)JSON.deserialize(jsonStr, SearchInfoWrapper.class);
    resultList.add(apiResponse);
    System.debug('Search Info List: ' + resultList);
    return resultList;

}

@AuraEnabled
public static List<ArticleWrapper> SearchArticles_Next(String searchTerm, String nextURL){

    String urlSafeString = searchTerm.replace(' ', '%20');

    Http h = new Http();
    HttpRequest req = new HttpRequest();
    req.setEndpoint(nextURL);
    req.setMethod('GET');
    req.setHeader('Content-Type', 'application/json');
    string workspace = system.label.Intercom_Workspace;
    string bearer_key = [Select Workspace__c, Key__c from Intercom_Key__mdt WHERE Workspace__c = : workspace LIMIT 1].Key__c;
    req.setHeader('Intercom-Version', '2.10');
    req.setHeader('Authorization', 'Bearer ' + bearer_key);
    
    HttpResponse res = h.send(req);
    string jsonStr = res.getBody();
    system.debug('Response: ' + jsonStr);

    ApiResponseWrapper response = (ApiResponseWrapper) JSON.deserialize(jsonStr, ApiResponseWrapper.class);

    if (response.data != null && response.data.articles != null) {
        system.debug('Parsed List Response: ' + response.data.articles);
        return response.data.articles;
    } else {
        return new List<ArticleWrapper>();
    }

}

public class ArticleWrapper {
    @AuraEnabled public String id;
    @AuraEnabled public String type;
    @AuraEnabled public String workspace_id;
    @AuraEnabled public Integer parent_id;
    @AuraEnabled public String parent_type;
    @AuraEnabled public List<Integer> parent_ids;
    @AuraEnabled public String title;
    @AuraEnabled public String description;
    @AuraEnabled public String body;
    @AuraEnabled public Integer author_id;
    @AuraEnabled public String state;
    @AuraEnabled public Long created_at;
    @AuraEnabled public Long updated_at;
    @AuraEnabled public String url;
}

public class ArticleDataWrapper {
    @AuraEnabled public List<ArticleWrapper> articles;
}

public class ApiResponseWrapper {
    @AuraEnabled public String type;
    @AuraEnabled public Integer total_count;
    @AuraEnabled public ArticleDataWrapper data;
}


public class ArticleBodyWrapper {
    @AuraEnabled public String id;
    @AuraEnabled public String type;
    @AuraEnabled public String workspace_id;
    @AuraEnabled public Integer parent_id;
    @AuraEnabled public String parent_type;
    @AuraEnabled public List<Integer> parent_ids;
    @AuraEnabled public Statistics statistics;
    @AuraEnabled public String title;
    @AuraEnabled public String description;
    @AuraEnabled public String body;
    @AuraEnabled public Integer author_id;
    @AuraEnabled public String state;
    @AuraEnabled public Long created_at;
    @AuraEnabled public Long updated_at;
    @AuraEnabled public String url;

}
     public class Statistics {
        @AuraEnabled public String type;
        @AuraEnabled public Integer views;
        @AuraEnabled public Integer conversations;
        @AuraEnabled public Integer reactions;
        @AuraEnabled public Decimal happy_reaction_percentage;
        @AuraEnabled public Decimal neutral_reaction_percentage;
        @AuraEnabled public Decimal sad_reaction_percentage;
    }

    public class Pages {
        @AuraEnabled public String type;
        @AuraEnabled public String next;
        @AuraEnabled public Integer page;
        @AuraEnabled public Integer total_pages;
        @AuraEnabled public Integer per_page;
    }

    public class SearchInfoWrapper {
        @AuraEnabled public String type;
        @AuraEnabled public Integer total_count;
        // @AuraEnabled public List<MyApiItem> data;
        @AuraEnabled public Pages pages;

    }

    public class MyApiItem {
        @AuraEnabled public String id;
        @AuraEnabled public String type;
        @AuraEnabled public String workspace_id;
        @AuraEnabled public Integer parent_id;
        @AuraEnabled public String parent_type;
        @AuraEnabled public List<Integer> parent_ids;
        @AuraEnabled public String title;
        @AuraEnabled public String description;
        @AuraEnabled public String body;
        @AuraEnabled public Integer author_id;
        @AuraEnabled public String state;
        @AuraEnabled public Integer created_at;
        @AuraEnabled public Integer updated_at;
        @AuraEnabled public String url;
    }

}