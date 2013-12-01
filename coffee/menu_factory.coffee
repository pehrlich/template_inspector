app.factory 'Menu', ['Template', (Template) ->
  {
    initialize: ->
      unless chrome.runtime
        console.warn "menu item customization only available when being run as an extension"
        return

      path = undefined

      # http://developer.chrome.com/extensions/contextMenus.html
      document.addEventListener 'contextmenu', (event) ->
        path = Template.template_for(event.target)
        chrome.runtime.sendMessage enabled: !!path

      chrome.runtime.onMessage.addListener (request, sender, sendResponse) ->
        if request.event == "click"
          window.location = "x-mine://open?file=" + path
  }
]