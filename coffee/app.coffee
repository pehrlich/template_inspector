window.app = angular.module("TemplateInspector", [])

app.controller "LeapController", ["$scope", "Leap", "Template", "$rootScope", '$compile', ($scope, Leap, Template, $rootScope, $compile) ->
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
    console.log 'found hand', id
    $scope.hand_elements[id] = angular.element("<div data-hand='#{id}' class='hand'></div>")
    angular.element(document.body).append $scope.hand_elements[id]
    $compile($scope.hand_elements[id])($scope);

  Leap.on 'lostHand', (id)->
    console.log 'lost hand', id
    $scope.hand_elements[id].remove()

  Leap.on "frame", ->
    return  if Leap.paused

    if $scope.working
      console.log "dropping frame"
      return

    $scope.working = true
    $scope.$digest()
    $scope.working = false


  $scope.$on 'open', (event, handElement)->
    console.log 'open hand', event.targetScope.hand.id

    # Because the hand is above everything, we do a clever trick to get the second-topmost element
    # if this is ever not good enough: http://neverfear.org/blog/view/36/JavaScript_tip_How_to_find_the_document_elements_that_intersect_at_a_certain_coordinate
    originalZ = handElement.style.zIndex
    handElement.style.zIndex = -1
    topmostElement = document.elementFromPoint( parseInt(event.targetScope.x), parseInt(event.targetScope.y) )
    handElement.style.zIndex = originalZ

    Template.open topmostElement if topmostElement

  $scope.$on 'close', (event)->
    console.log 'close hand', event.targetScope.hand.id
]
