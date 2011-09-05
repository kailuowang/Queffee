class quefee.Heap
  constructor: (@array, @comp = (a, b) -> a > b) ->
    @_root = new quefee.Node(@array, 0, @comp)
    @_root.heapify()

  size: =>
    @array.length

  top: => @_root.value()

  extractTop: =>
    retVal = this.top()
    @_root.value(@array.pop())
    @_root.siftDown()
    retVal

  insert: (newItem) =>
    @array.push(newItem)
    this._last().siftUp()

  _last: => new quefee.Node(@array, @array.size - 1, @comp)
