
app.directive('hand', ['Leap', (Leap)->
  {
    restrict: 'A',
    link: (scope, elem, attrs)->

      scope.$watch 'hands', (newHands, oldHands)->
        if scope.hand = newHands[0]
#          scope.hand = newHands.getById(scope.id)
          elem[0].style.left = (document.body.offsetWidth / 2) + (scope.hand.palmPosition[0] * 8) + "px"
          elem[0].style.top  = (document.body.offsetHeight / 2) + ((scope.hand.palmPosition[1] - 150) * -8) + "px"
  }
])