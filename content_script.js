// This content script
// a) Listens to the menu opened event, and determines the closest parent template.
// b) sends a message to the background enabling or disabling the menu
// c) receives messages to launch an external editor

console.log('Template Inspector loading')

// what happens if there is already angular on this page?
// todo: reduce scope.
angular.element(document.body).attr('data-ng-controller', 'LeapController').attr('data-ng-keypress', 'keypress($event)')
angular.bootstrap(document.body, ['TemplateInspector'])
