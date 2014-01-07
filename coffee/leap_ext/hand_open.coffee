Leap.service 'hand_open', (options)->
  options ||= {}

  # apparently leapjs won't let us know if it's a right or left hand we're working with.
  # we may have accidental gestures.
  # for now, we look at all the numbers absolutely
  # describing a gesture we'll call "open"
  # est range, left hand: -0.3 for flat, -1.3 for vertical?
  openGestureContants = {
    tips_at: options.tips_at || 0.6
    minTip: options.minTip || 0.3
    maxTip: options.maxTip || 1.3
  }

  # our factory is scoped to a per-controller level
  # we track hand data independently
  # this could be simplified if we were surely able to store extra data on persistent hands
  extra_hand_data = []

  {
    hand: (hand)->
      extra_hand_data[hand.id] ||= {}

      new_open_percent = Math.round(
        (Math.abs(hand.roll()) - openGestureContants.minTip) / (openGestureContants.maxTip - openGestureContants.minTip) * 100
      )

      # ideally, we would hand.emit here, but leapjs currently recreates the hand object with every frame.
      # we emit from the controller with an id instead.
      if new_open_percent != extra_hand_data[hand.id].old_open_percent
        extra_hand_data[hand.id].old_open_percent = new_open_percent
        # hand.emit('openPercent', new_open_percent)
        this.emit 'handOpenPercent', hand.id, new_open_percent

        if extra_hand_data[hand.id].open && new_open_percent < openGestureContants.tips_at
          extra_hand_data[hand.id].open = false
#          hand.emit('close')
          this.emit 'handClose', hand.id

        if !extra_hand_data[hand.id].open && new_open_percent >= openGestureContants.tips_at
          extra_hand_data[hand.id].open = true
#          hand.emit('open')
          this.emit 'handOpen', hand.id

  }
