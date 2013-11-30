window.app = angular.module("TemplateInspector", [])

app.controller "LeapController", ["$scope", "Leap", "$rootScope", '$compile', ($scope, Leap, $rootScope, $compile) ->
  $scope.heightOffset = 0
  $scope.working = false
  $scope.hud = true

  # as we don't have access to the DOM in a chrome extension content script, we track appended elements here.
  $scope.hand_elements = {}

  $scope.keypress = (event) ->
    switch event.keyCode
      when 's'.charCodeAt(0), 'p'.charCodeAt(0)
        Leap.paused = not Leap.paused
        $rootScope.$broadcast('paused', Leap.paused)
      when 'h'.charCodeAt(0)
        $scope.hud = not $scope.hud
        $rootScope.$broadcast('hud', $scope.hud)


  Leap.on 'foundHand', (id)->
    console.log 'found hand'
    $scope.hand_elements[id] = angular.element("<div data-hand='#{id}' class='hand'></div>")
    angular.element(document.body).append $scope.hand_elements[id]
    $compile($scope.hand_elements[id])($scope);

  Leap.on 'lostHand', (id)->
    console.log 'lost hand'
    $scope.hand_elements[id].remove()

  Leap.on "frame", ->
    return  if Leap.paused

    if $scope.working
      console.log "dropping frame"
      return

    $scope.working = true
    $scope.$digest()
    $scope.working = false


  $scope.$on 'open', (scope, data)->
    console.log 'open', data

  $scope.$on 'close', (scope, data)->
    console.log 'close', data
]
