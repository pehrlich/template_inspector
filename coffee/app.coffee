window.app = angular.module("TemplateInspector", [])

app.controller "LeapController", ["$scope", "Leap", "Template", "Menu", "$rootScope", '$compile', ($scope, Leap, Template, Menu, $rootScope, $compile) ->
  $scope.heightOffset = 0
  $scope.working = false
  $scope.hud = true

  # as we don't have access to the DOM in a chrome extension content script, we track appended elements here.
  $scope.hand_elements = {}

  Menu.initialize()

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

  # updates the HUD and hand directives
  Leap.on "frame", ->
    return  if Leap.paused

    if $scope.working
      console.log "dropping frame"
      return

    $scope.working = true
    $scope.$digest()
    $scope.working = false

  # we prevent the element from changing too much on roll.
  $scope.cachedTopMostElement = undefined

  $scope.$on 'openPercent', (event, percentage) ->

    if !$scope.cachedTopMostElement && (percentage > 20)
      return unless topMostElement = event.targetScope.topMostElement()
      console.log('saving element', percentage, topMostElement)
      $scope.cachedTopMostElement = topMostElement

    else if $scope.cachedTopMostElement && percentage < 20
      $scope.cachedTopMostElement = undefined
      console.log('clearing element', percentage)


  $scope.$on 'open', (event)->
    console.log 'open hand', event.targetScope.hand.id
    return unless topMostElement = ($scope.cachedTopMostElement || event.targetScope.topMostElement())

    if $scope.cachedTopMostElement && ($scope.cachedTopMostElement != event.targetScope.topMostElement())
      console.log 'good thing we saved it!'

    Template.open topMostElement

  $scope.$on 'close', (event)->
    console.log 'close hand', event.targetScope.hand.id
]
