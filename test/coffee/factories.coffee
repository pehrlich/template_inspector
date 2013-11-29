
app.factory "Leap", [ ->
  console.log "connecting"
  controller = new Leap.Controller()

  controller.on "connect", ->
    console.log "Successfully connected."

  #  controller.on('deviceConnected', function() {
  #    console.log("A Leap device has been connected.");
  #  });

  controller.on "deviceDisconnected", ->
    console.log "A Leap device has been disconnected."

  #  controller.on('frame', function() {
  #    console.log('frame', this, arguments);
  #    this.lastFrame.hands
  #  });

  controller.connect()
  controller
]