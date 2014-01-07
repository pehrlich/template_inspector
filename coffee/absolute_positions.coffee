Leap.pipeline 'interactable_coordinates', ->
  # strings will be used as a selector, or a jq object can be passed in
  selector = 'a'
  {
    global: true # scope: 'controller', 'hand', etc?
    onFrame: (frame)->
      frame.interactableCoordinates = $(selector).absolutePositions()
  }

$.fn.absolutePositions = ->
  top = $(window).scrollTop()
  left = $(window).scrollLeft()
  out = []

  @each (i, el) ->
    el = $(el)
    offset = el.offset()
    out.push([
      offset.top - top,
      offset.left - left,
      offset.top - top + el.height()
      offset.left - left + el.width()
    ])

  out

