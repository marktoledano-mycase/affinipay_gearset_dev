@isTest
public class IntercomArticleSearchTest {

    @isTest
    static void testGetArticleBody() {
        // Test data setup
        String articleId = '123456';
        String expectedUrl = 'https://api.intercom.io/articles/' + articleId;
        String expectedResponse = '{"id": "123456", "title": "Test Article", "body": "Test Body", "url": "https://example.com"}';

        // Set up HTTP mock
        Test.setMock(HttpCalloutMock.class, new IntercomHttpCalloutMock(expectedResponse));

        // Call the method to be tested
        String bodyContent = IntercomArticleSearch.GetArticleBody(articleId);

        // Verify the results
        System.assertEquals('<h1 class="slds-card__header-title">Test Article</h1><br/>Test Body', bodyContent);
    }

    @isTest
    static void testSearchArticles() {
        // Test data setup
        String searchTerm = 'Test';
        String expectedUrl = 'https://api.intercom.io/articles/search?phrase=Test';
        String expectedResponse = '{"type": "list", "total_count": 1, "data": {"articles": [{"id": "123456", "title": "Test Article", "body": "Test Body", "url": "https://example.com"}]}}';

        // Set up HTTP mock
        Test.setMock(HttpCalloutMock.class, new IntercomHttpCalloutMock(expectedResponse));

        // Call the method to be tested
        List<IntercomArticleSearch.ArticleWrapper> articles = IntercomArticleSearch.SearchArticles(searchTerm);

        // Verify the results
        System.assertEquals(1, articles.size());
        System.assertEquals('123456', articles[0].id);
        System.assertEquals('Test Article', articles[0].title);
        System.assertEquals('Test Body', articles[0].body);
        System.assertEquals('https://example.com', articles[0].url);
    }
    @isTest
    static void testSearchArticlesInfo() {
        // Test data setup
        String searchTerm = 'Test';
        String nextURL = 'https://api.intercom.io/articles/search?phrase=Test';
        String expectedResponse = '{"type": "pages", "total_count": 1, "data": {"articles": [{"id": "123456", "title": "Test Article", "body": "Test Body", "url": "https://example.com"}]}, "pages": {"type": "pages", "next": null, "page": 1, "total_pages": 1, "per_page": 10}}';

        // Set up HTTP mock
        Test.setMock(HttpCalloutMock.class, new IntercomHttpCalloutMock(expectedResponse));

        // Call the method to be tested
        List<IntercomArticleSearch.SearchInfoWrapper> resultList = IntercomArticleSearch.SearchArticlesInfo(searchTerm, nextURL);

        // Verify the results
        System.assertEquals(1, resultList.size());
        IntercomArticleSearch.SearchInfoWrapper apiResponse = resultList[0];
        System.assertEquals('pages', apiResponse.type);
        System.assertEquals(1, apiResponse.total_count);
        System.assertEquals(1, apiResponse.pages.page);
        System.assertEquals(1, apiResponse.pages.total_pages);
        System.assertEquals(10, apiResponse.pages.per_page);
        // Add more assertions based on your response structure
    }

    @isTest
    static void testSearchArticles_Next() {
        // Test data setup
        String searchTerm = 'Test';
        String nextURL = 'https://api.intercom.io/articles/search?phrase=Test';
        String expectedResponse = '{"type": "pages", "total_count": 1, "data": {"articles": [{"id": "123456", "title": "Test Article", "body": "Test Body", "url": "https://example.com"}]}, "pages": {"type": "pages", "next": null, "page": 1, "total_pages": 1, "per_page": 10}}';

        // Set up HTTP mock
        Test.setMock(HttpCalloutMock.class, new IntercomHttpCalloutMock(expectedResponse));

        // Call the method to be tested
        List<IntercomArticleSearch.ArticleWrapper> resultList = IntercomArticleSearch.SearchArticles_Next(searchTerm, nextURL);

        // Verify the results
        System.assertEquals(1, resultList.size());
        IntercomArticleSearch.ArticleWrapper article = resultList[0];
        System.assertEquals('123456', article.id);
        System.assertEquals('Test Article', article.title);
        // Add more assertions based on your response structure
    }

    @isTest
    static void testGetArticlePublicLink() {
          // Set up test data
          String articleId = '123456789'; // Replace with a valid article ID
          String expectedUrl = 'https://example.com/test-article';
  
          // Mock the HTTP callout
          Test.setMock(HttpCalloutMock.class, new IntercomURLHttpCalloutMock(expectedUrl));
  
          // Call the AuraEnabled method
          String result = IntercomArticleSearch.GetArticlePublicLink(articleId);
  
          // Assert the result
          System.assertEquals(expectedUrl, result);
    }
}