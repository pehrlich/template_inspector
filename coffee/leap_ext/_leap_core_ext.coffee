Leap._extensionFactories = []
Leap._extensionInstances = []

# Registers an extension with Leap.js
# This factory should return an object with exacty one key and callback: frame, hand, finger, pointable, or tool.
# The callback method will receive one argument: its namesake
# Services will be registered and active on every controller by default.
Leap.service = (name, factory)->
  throw "Service \"#{name}\" already registered" if Leap.extensionFactory(name)

  this._extensionFactories.push({name: name, factory: factory})

# returns an extension factory
Leap.extensionFactory = (extension_name) ->
  for extension in Leap._extensionFactories
    return extension.factory if extension.name == extension_name


# set options.if to specify execution conditions for the extension
# this can be a boolean value, or a function which will be evaluated inside the loop.
# returns an instance, which can be passed to stop_using
# This will replace any preregistered service of the same type.
Leap.Controller.prototype.use = (extension_name, options...) ->
  extensionFactory = Leap.extensionFactory(extension_name)
  throw "Leap Service \"#{extension_name}\" not found." unless extensionFactory
  options ||= {}
  # we set "if" to true if it has not yet been configured, to be true to the name "use"
  run_callback = typeof(options.if) == 'undefined' || options.if
  delete options.if

  step = undefined
  controller = this

  for type, callback of extensionFactory(options)
    (
      (type) ->
        step = (frame)->
          dependencies = switch type
            when 'frame'
              [frame]
            when 'hand'
              frame.hands || []

          for dependency in dependencies
            if (angular.isFunction(run_callback) && run_callback.call(controller, dependency)) || run_callback
              callback.call(controller, dependency)

          frame
    )(type)

  if this._preregisteredExtensions[extension_name]
    this.stopUsing this._preregisteredExtensions[extension_name]
    delete  this._preregisteredExtensions[extension_name]

  this._registeredExtensions[extension_name] = step

  this.addStep step


Leap.Controller.prototype.setupServices = ->
  this._registeredExtensions = {}
  this._preregisteredExtensions = {}
  for extension in Leap._extensionFactories
    this._preregisteredExtensions[extension.name] = this.use(extension.name)



# Clears all instances of this extension
Leap.Controller.prototype.stopUsing = (stepOrName) ->
  this.removeStep (angular.isFunction(stepOrName) && stepOrName) || Leap._registeredExtensions[stepOrName]

# Accepts a function
#Leap.Pipeline.prototype.removeStep = (step)->
Leap.Controller.prototype.removeStep = (step)->
  this.steps.splice(this.steps.indexOf(step) , 1)
