app.factory "LeapController", [ ->
  console.log "connecting"
  controller = new Leap.Controller()

  controller.on "connect", ->
    console.log "Successfully connected."

  controller.on "deviceDisconnected", ->
    console.log "A Leap device has been disconnected."


  # LeapController.use extension_name, options
  # extension name is registered when the extension is included
  # options will be passed to the extension "constructor"
  # the if option is special.  It is extracted before reaching the contructor, and used
  # to deterministally pipeline
  controller.use 'hand_position', {
    positioning: 'absolute',
    if: (hand) ->
      hand.side == 'left'
  }

  controller.use 'hand_position', {
    positioning: {
      CDGain: 14
    },
    if: (hand) ->
      hand.side == 'right'
  }

  controller.connect()
  controller
]