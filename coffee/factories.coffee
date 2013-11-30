app.factory "Leap", [ ->
  console.log "connecting"
  controller = new Leap.Controller()

  controller.on "connect", ->
    console.log "Successfully connected."

# this goes constantly :-/
#  controller.on 'deviceConnected', ->
#    console.log("A Leap device has been connected.")

  controller.on "deviceDisconnected", ->
    console.log "A Leap device has been disconnected."

  previousValidHandIds = []
  controller.on "frame", ->
    newValidHandIds = controller.lastValidFrame.hands.map (hand)-> hand.id

    for id in previousValidHandIds
      unless newValidHandIds.includes(id)
        previousValidHandIds.remove(id)
        controller.emit('lostHand', id)

    for id in newValidHandIds
      unless previousValidHandIds.includes(id)
        previousValidHandIds.push(id)
        controller.emit('foundHand', id)

  controller.connect()
  controller
]