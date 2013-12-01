app.factory 'Template', [->
  object = {
    # @param target {element} The element for which the template will be returned.
    # @description
    # Searches the dom ancestry of the given element, to find the nearest enclosing begin/end template block.
    # @returns {string, false} The path to a file on the local filesytem, or false if none found.
    template_for: (target)->
      encompassing_templates = []
      node = undefined
      parent = undefined

      loop
        parent = target.parentNode
        return false unless parent

        # Algo: Search until finding self node.  If "begin partial" not found, go up and repeat.
        # If found, it will be the correct partial unless it is closed or a new partial opened
        # before finding the self node.
        for node in parent.childNodes

          if node.substringData
            if node.substringData(0, 13) == "begin partial"
              encompassing_templates.push node
            else if node.substringData(0, 11) is "end partial"
              encompassing_templates.pop()

          else if node == target
            if encompassing_templates.length
              return encompassing_templates.pop().substringData(14, 256)
            else
              target = parent
              break


    open: (element)->
      if path = object.template_for(element)
        console.log 'setting location', "x-mine://open?file=#{path}"
        window.location.assign "x-mine://open?file=#{path}"
        # for some reason, subsquent calls to window.location.assign with an external protocol from a content script
        # will fail unless padded.  Here we use a hash.
        window.location.assign "#"

  }
  return object
]