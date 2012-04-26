class queffee.Heap
  constructor: (@_array = [], @comp = (a, b) -> a > b) ->
    @_init()
    @reorder()

  size: =>
    @_array.length

  top: => @_root.value()

  extractTop: =>
    retVal = this.top()
    newRootVal = @_array.pop()
    @_init()
    @_root.value(newRootVal)
    @_root.siftDown()
    retVal

  insert: (newItem) =>
    @_array.push(newItem)
    @_last().siftUp()

  reorder: =>
    @_root.heapify()

  _last: => new queffee.Node(@_array, @_array.length - 1, @comp)

  _init: =>
    @_root = new queffee.Node(@_array, 0, @comp)