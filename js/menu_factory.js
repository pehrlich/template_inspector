// Generated by CoffeeScript 1.6.3
(function() {
  app.factory('Menu', [
    'Template', function(Template) {
      return {
        initialize: function() {
          var path;
          if (!chrome.runtime) {
            console.warn("menu item customization only available when being run as an extension");
            return;
          }
          path = void 0;
          document.addEventListener('contextmenu', function(event) {
            path = Template.template_for(event.target);
            return chrome.runtime.sendMessage({
              enabled: !!path
            });
          });
          return chrome.runtime.onMessage.addListener(function(request, sender, sendResponse) {
            if (request.event === "click") {
              return window.location = "x-mine://open?file=" + path;
            }
          });
        }
      };
    }
  ]);

}).call(this);