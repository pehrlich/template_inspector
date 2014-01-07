window.app = angular.module("TemplateInspector", [])

app.controller "Leap", ["$scope", "LeapController", "Template", "Menu", "$rootScope", '$compile', ($scope, LeapController, Template, Menu, $rootScope, $compile) ->
  $scope.heightOffset = 0
  $scope.working = false
  $scope.hud = true

  # as we don't have access to the DOM in a chrome extension content script, we track appended elements here.
  $scope.hand_elements = {}

  Menu.initialize()

  $scope.keypress = (event) ->
    switch event.keyCode
      when 's'.charCodeAt(0), 'p'.charCodeAt(0)
        LeapController.paused = not LeapController.paused
        $rootScope.$broadcast('paused', LeapController.paused)
      when 'h'.charCodeAt(0)
        $scope.hud = not $scope.hud
        $rootScope.$broadcast('hud', $scope.hud)


  LeapController.on 'foundHand', (id)->
    console.log 'found hand', id
    $scope.hand_elements[id] = angular.element("<div data-hand='#{id}' class='hand'></div>")
    angular.element(document.body).append $scope.hand_elements[id]
    $compile($scope.hand_elements[id])($scope);

  LeapController.on 'lostHand', (id)->
    console.log 'lost hand', id
    $scope.hand_elements[id].remove()

  # updates the HUD and hand directives
  LeapController.on "frame", (frame) ->
    return  if LeapController.paused

    if $scope.working
      console.log "dropping frame"
      return

    $scope.working = true
    $scope.hands = frame.hands
    $scope.$digest()
    $scope.working = false

  LeapController.on 'handClose', (event)->
#    console.log 'close hand', event.targetScope.hand.id
]
