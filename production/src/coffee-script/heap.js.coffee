class Heap
  constructor: (@array, @comp = (a, b) -> a > b) ->
    this._root().heapify()

  _root: => new Node(@array, 0, @comp)

  size: =>
    @array.length

  top: => this._root().value()

  extractTop: =>
    retVal = this.top()
    this._root().value(@array.pop())
    this._root().siftDown()
    retVal

  insert: (newItem) =>
    @array.push(newItem)
    this._last().siftUp()


  _last: => new Node(@array, @array.size - 1, @comp)
