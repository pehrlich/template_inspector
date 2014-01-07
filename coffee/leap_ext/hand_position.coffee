Leap.service 'hand_position', (options)->
  # instance of extension should be tied to instance of hand
  # positioning can be one of a series of predefined position identifiers, or a custom method.
  positioning = options.positioning || 'absolute'

  position_methods = {
    absolute: (hand)->
      scale = 8
      vertical_offset = -150
      {
          x: (document.body.offsetWidth / 2) + (hand.palmPosition[0] * scale)
          y: (document.body.offsetHeight / 2) +
                ((hand.palmPosition[1] + vertical_offset) * scale * -1)
      }
  }

  {
    hand: (hand)->
      # absolute positioning
      hand.screenPosition = if angular.isFunction(positioning)
          positioning(hand)
        else
          position_methods[positioning](hand)
  }
