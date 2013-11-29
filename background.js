// This background file
// a) Initializes the Template Inspector menu item
// b) Listens for menu clicks, and alerts the tab

window.path = undefined;

window.menu_id = chrome.contextMenus.create({
    "title": "Template Inspector",
    "contexts": ["all"],
    "onclick": function (info, tab) {
      console.log('inspector click');
      chrome.tabs.sendMessage(
        tab.id,
        {
          event: "click"
        }
      );
    }
  });


chrome.runtime.onMessage.addListener(
  function (request, sender, sendResponse) {
    console.log('data received', request);
    window.path = request.path;
    chrome.contextMenus.update(
      window.menu_id,
      request
    )
    sendResponse({status: "ok"})
  }
);