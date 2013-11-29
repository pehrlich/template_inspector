// Generated by CoffeeScript 1.6.3
(function() {
  app.factory("Leap", [
    function() {
      var controller;
      console.log("connecting");
      controller = new Leap.Controller();
      controller.on("connect", function() {
        return console.log("Successfully connected.");
      });
      controller.on("deviceDisconnected", function() {
        return console.log("A Leap device has been disconnected.");
      });
      controller.connect();
      return controller;
    }
  ]);

}).call(this);
