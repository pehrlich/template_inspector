var controller = new Leap.Controller();


controller.on('connect', function() {
  console.log("Successfully connected.");
});

controller.on('deviceConnected', function() {
  console.log("A Leap device has been connected.");
});

controller.on('deviceDisconnected', function() {
  console.log("A Leap device has been disconnected.");
});


controller.on('frame', function() {
  console.log('frame', this, arguments);
  // your code here
});


controller.connect();















































// This content script
// a) Listens to the menu opened event, and determines the closest parent template.
// b) sends a message to the background enabling or disabling the menu
// c) receives messages to launch an external editor

window.path = undefined;

// http://developer.chrome.com/extensions/contextMenus.html
document.addEventListener("contextmenu", function (event) {
  var indicator = closestTemplateIndicator(event.target);
  window.path = indicator.substringData(14, 256);

  chrome.runtime.sendMessage({enabled: !!window.path});
});

chrome.runtime.onMessage.addListener(
  function (request, sender, sendResponse) {
    console.log("message received", request)
    if (request.event == "click"){
      window.location = "x-mine://open?file=" + window.path;
    };
  }
);


function closestTemplateIndicator(target) {
  var encompassing_templates = [], node;
  var parent;

  while (true) {
    parent = target.parentNode;
    if (!parent) return;

    // Algo: Search until finding self node.  If "begin partial" not found, go up and repeat.
    // If found, it will be the correct partial unless it is closed or a new partial opened
    // before finding the self node.
    for (var i = 0; i < parent.childNodes.length; i++) {
      node = parent.childNodes[i];

      if (node.substringData) {

        if (node.substringData(0, 13) == 'begin partial') {
          encompassing_templates.push(node);
        } else if (node.substringData(0, 11) == 'end partial') {
          encompassing_templates.pop();
        }

      } else if (node == target) {

        if (encompassing_templates.length) {
          return encompassing_templates.pop();
        } else {
          target = parent;
          break;
        }

      }

    }

  }
}