position_constants = {
  scale: 8,
  vertial_offset: -150
}

# apparently leapjs won't let us know if it's a right or left hand we're working with.
# we may have accidental gestures.
# for now, we look at all the numbers absolutely
# describing a gesture we'll call "open"
# est range, left hand: -0.3 for flat, -1.3 for vertical?
open_gesture_contants = {
  tips_at: 50
  min_tip: 0.3
  max_tip: 1.3
}

app.directive('hand', ['Leap', (Leap)->
  {
  restrict: 'A',
  scope: {
    id: '=hand',
  },
  link: (scope, elem, attrs)->
    scope.open = undefined
    scope.old_open_percent = undefined


    # For whatever reason, Angular isin't properly destroying this scope when the element is removed.
    # we trigger it manually here.
    elem.bind '$destroy', ->
      scope.$destroy()

    scope.$watch ()->
      Leap.lastValidFrame.hands
    , (newHands, oldHands)->
      if newHands.length
        return unless scope.hand = newHands.getById(scope.id)

        scope.setPosition()
        scope.setOpenGesture()


    scope.setOpenGesture = ->
      new_open_percent = Math.round(
        (Math.abs(scope.hand.roll()) - open_gesture_contants.min_tip) / (open_gesture_contants.max_tip - open_gesture_contants.min_tip) * 100
      )

      if new_open_percent != scope.old_open_percent
        scope.old_open_percent = new_open_percent
        scope.$emit('openPercent', new_open_percent)

        if scope.open && new_open_percent < open_gesture_contants.tips_at
          scope.open = false
          scope.$emit('close')

        if !scope.open && new_open_percent >= open_gesture_contants.tips_at
          scope.open = true
          scope.$emit('open')

    scope.setPosition = ->
      scope.x = (document.body.offsetWidth / 2) +
            (scope.hand.palmPosition[0] * position_constants.scale)
      scope.y = (document.body.offsetHeight / 2) +
            ((scope.hand.palmPosition[1] + position_constants.vertial_offset) * position_constants.scale * -1)

      elem[0].style.left = "#{scope.x}px"
      elem[0].style.top = "#{scope.y}px"

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