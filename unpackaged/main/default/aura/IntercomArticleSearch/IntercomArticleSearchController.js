// AccountSearchComponentController.js
({
    doInit: function (component, event, helper) {

    },

    handleKeyUp: function(component, event, helper) {
        console.log('Key pressed:', event.keyCode);
        if (event.keyCode === 13) {
            console.log('Enter Key Pressed');
        $A.enqueueAction(component.get('c.search'));
        }
    },

    search : function(component, event, helper) {
        var searchTerm = component.get("v.searchTerm");
        component.set("v.total_articles",null);
        component.set("v.total_pages",null);
        component.set("v.current_page",null);
        component.set("v.next_url",null);
        console.log('Search Term: ' + searchTerm);

        var action = component.get("c.SearchArticles");
        action.setParams({
            "searchTerm": searchTerm
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result_data = response.getReturnValue();
                console.log('Id: ' + result_data[0].id + ' title: ' + result_data[0].title);
                component.set("v.searchResults", response.getReturnValue());
                console.log('Search Results: ' + response.getReturnValue());
            } else {
                console.log("Error: " + JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
        $A.enqueueAction(component.get('c.search_Info'));

    },
    search_Info : function(component, event, helper) {
        var searchTerm = component.get("v.searchTerm");
        console.log('Search Info NEXT: ' + component.get("v.next_url"));
        var nextURL = null;
        if(component.get("v.next_url")!=null){
            nextURL = component.get("v.next_url");
        }

        var action = component.get("c.SearchArticlesInfo");
        action.setParams({
            "searchTerm": searchTerm,
            "nextURL": nextURL
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result_data = response.getReturnValue();
                console.log('Total Articles: ' + result_data[0].total_count );
                console.log('Total Pages: ' + result_data[0].pages.total_pages);
                console.log('Current Page: ' + result_data[0].pages.page);
                console.log('Next: ' + result_data[0].pages.next);
                component.set("v.searchInfo", response.getReturnValue());
                component.set("v.total_articles", result_data[0].total_count);
                component.set("v.total_pages", result_data[0].pages.total_pages);
                component.set("v.current_page", result_data[0].pages.page);
                component.set("v.next_url", result_data[0].pages.next);

            } else {
                console.log("Error: " + JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    get_next : function(component, event, helper) {
        var searchTerm = component.get("v.searchTerm");
        var nextURL = component.get("v.next_url");
        console.log('Search Term: ' + searchTerm);

        var action = component.get("c.SearchArticles_Next");
        action.setParams({
            "searchTerm": searchTerm,
            "nextURL": nextURL
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result_data = response.getReturnValue();
                console.log('Id: ' + result_data[0].id + ' title: ' + result_data[0].title);
                component.set("v.searchResults", response.getReturnValue());
                console.log('Search Results: ' + response.getReturnValue());
            } else {
                console.log("Error: " + JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
        $A.enqueueAction(component.get('c.search_Info'));

    },
    get_previous : function(component, event, helper) {
        var nextURL = component.get("v.next_url");
        var parts = nextURL.split("&page=");
        if (parts.length > 1) {
            // Get characters after "="
            var charactersAfterEquals = parts[1];
            console.log('Current page in url: ' + charactersAfterEquals);
            // Replace characters after "="
            var replacedCharacters = charactersAfterEquals.replace(charactersAfterEquals, charactersAfterEquals-2);
        
            // Join the parts back into a string
            var resultString = parts[0] + "&page=" + replacedCharacters;
            console.log('PREVIOUS URL:' + resultString);
            component.set("v.next_url", resultString);
        }
        $A.enqueueAction(component.get('c.get_next'));

    },
    select_article : function(component, event, helper) {
        const itemId = event.currentTarget.dataset.id;
        console.log('Clicked Article id:', itemId);
        
        var ArticleId = itemId;

        var action = component.get("c.GetArticleBody");
        action.setParams({
            "ArticleId": ArticleId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.selected_article_body", response.getReturnValue());
            } else {
                console.log("Error: " + JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    
    },
    toggleCollapse : function(component, event, helper) {
        var isCollapsed = component.get("v.isCollapsed");
        component.set("v.isCollapsed", isCollapsed);
    },
});