Leap.service 'hand_entry_events', ->
  previousValidHandIds = []
  {
    frame: (frame)->
      newValidHandIds = frame.hands.map (hand)-> hand.id

      for id in previousValidHandIds
        unless newValidHandIds.includes(id)
          previousValidHandIds.remove(id)
          @emit('lostHand', id)

      for id in newValidHandIds
        unless previousValidHandIds.includes(id)
          previousValidHandIds.push(id)
          @emit('foundHand', id)
  }

