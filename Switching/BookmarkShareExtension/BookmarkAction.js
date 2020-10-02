var BookmarkAction = function() {};

BookmarkAction.prototype = {
    run: function(arguments) {
        arguments.completionFunction({
            "URL": document.URL,
            "selectedText": document.getSelection().toString(),
            "title": document.title
        });
    },
    finalize: function(arguments) {

    }
};

var ExtensionPreprocessingJS = new BookmarkAction

