window.app = angular.module("TemplateInspector", [])

app.controller "LeapController", ["$scope", "Leap", "$rootScope", ($scope, Leap, $rootScope) ->
  $scope.hands = []
  $scope.heightOffset = 0
  $scope.paused = false
  $scope.working = false
  $scope.hud = true

  $scope.keypress = (event) ->
    switch event.keyCode
      when 's'.charCodeAt(0), 'p'.charCodeAt(0)
        Leap.paused = not Leap.paused
        $rootScope.$broadcast('paused', Leap.paused)
      when 'h'.charCodeAt(0)
        $scope.hud = not $scope.hud
        $rootScope.$broadcast('hud', $scope.hud)


    $scope.style = ->
      console.log('style controller called')

  Leap.on "frame", ->
    return  if Leap.paused

    if $scope.working
      console.log "dropping frame"
      return

    $scope.working = true
#    for hand in $scope.hands
#      unless Leap.lastValidFrame.hands.map((hand) -> hand.id).includes(hand.id)
#        $rootScope.$broadcast('handLost')
#        console.log('hand lost')
#    if $scope.hands.map((hand)-> hand.id) != Leap.lastValidFrame.hands.map((hand)-> hand.id)
#      console.log('hand change')

    $scope.hands = Leap.lastValidFrame.hands
    $scope.$digest()
    $scope.working = false


  $scope.$on 'open', (scope, data)->
    console.log 'open', data

  $scope.$on 'close', (scope, data)->
    console.log 'close', data
]
