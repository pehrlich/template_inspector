// This content script
// a) Listens to the menu opened event, and determines the closest parent template.
// b) sends a message to the background enabling or disabling the menu
// c) receives messages to launch an external editor

console.log('Template Inspector loading')

angular.element(document.body).attr('data-ng-controller', 'LeapController').attr('data-ng-keypress', 'keypress($event)')
angular.bootstrap(document.body, ['TemplateInspector'])
//
//window.path = undefined;
//
//// http://developer.chrome.com/extensions/contextMenus.html
//document.addEventListener("contextmenu", function (event) {
////  var indicator = closestTemplateIndicator(event.target);
////  window.path = indicator.substringData(14, 256);
//
//  chrome.runtime.sendMessage({enabled: !!window.path});
//});
//
//chrome.runtime.onMessage.addListener(
//  function (request, sender, sendResponse) {
//    if (request.event == "click"){
//      window.location = "x-mine://open?file=" + window.path;
//    };
//  }
//);
//
