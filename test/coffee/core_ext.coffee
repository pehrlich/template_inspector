Array.prototype.includes = (item)->
  @indexOf(item) >= 0

Array.prototype.getById = (id)->
  for item in this
    return item if item.id == id
