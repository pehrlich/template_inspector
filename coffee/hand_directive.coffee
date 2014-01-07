app.directive('hand', ['LeapController', 'Template',  (LeapController, Template)->
  {
  restrict: 'A',
  scope: {
    id: '=hand',
  },
  link: (scope, elem, attrs)->
    # For whatever reason, Angular isin't properly destroying this scope when the element is removed.
    # we trigger it manually here.
    elem.bind '$destroy', ->
      scope.$destroy()

    scope.$watch ()->
      LeapController.lastValidFrame.hands
    , (newHands, oldHands)->
      if newHands.length
        return unless hand = newHands.getById(scope.id)

        elem[0].style.left = "#{hand.screenPosition.x}px"
        elem[0].style.top = "#{hand.screenPosition.y}px"


    # we prevent the element from changing too much on roll.
    scope.cachedTopMostElement = undefined

    # hand.getById(id).on 'openPercent', (percentage)
    LeapController.on 'handOpenPercent', (hand_id, percentage) ->
      return unless hand_id == scope.id
        if !scope.cachedTopMostElement && (percentage > 20)
          return unless topMostElement = scope.topMostElement()
          console.log('saving element', percentage, topMostElement)
          scope.cachedTopMostElement = topMostElement

        else if scope.cachedTopMostElement && percentage < 20
          scope.cachedTopMostElement = undefined
          console.log('clearing element', percentage)

    LeapController.on 'handOpen', (hand_id)->
      return unless hand_id == scope.id
      console.log 'open hand', hand_id

      return unless topMostElement = (scope.cachedTopMostElement || scope.topMostElement())

  #    if $scope.cachedTopMostElement && ($scope.cachedTopMostElement != event.targetScope.topMostElement())
        # console.log 'good thing we saved it!'

      Template.open topMostElement

    scope.topMostElement = ->
      # Because the hand is above everything, we do a clever trick to get the second-topmost element
      # if this is ever not good enough: http://neverfear.org/blog/view/36/JavaScript_tip_How_to_find_the_document_elements_that_intersect_at_a_certain_coordinate
      originalZ = elem[0].style.zIndex
      elem[0].style.zIndex = -1
      topMostElement = document.elementFromPoint( scope.x, scope.y )
      elem[0].style.zIndex = originalZ
      topMostElement
  }
])