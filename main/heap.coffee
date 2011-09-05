class quefee.Heap
  constructor: (@_array, @comp = (a, b) -> a > b) ->
    this._init()
    this.reorder()

  size: =>
    @_array.length

  top: => @_root.value()

  extractTop: =>
    retVal = this.top()
    newRootVal = @_array.pop()
    this._init()
    @_root.value(newRootVal)
    @_root.siftDown()
    retVal

  insert: (newItem) =>
    @_array.push(newItem)
    this._last().siftUp()

  reorder: =>
    @_root.heapify()

  _last: => new quefee.Node(@_array, @_array.size - 1, @comp)

  _init: =>
    @_root = new quefee.Node(@_array, 0, @comp)