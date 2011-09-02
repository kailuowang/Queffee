class Node
  constructor: (@array, @index, @comp = (a,b) -> a > b ) ->

  value: (newVal) =>
    if newVal?
      @array[@index] = newVal
    else
      @array[@index]

  left: =>
    @_left ?= this.child_(2 * @index + 1)

  right: =>
    @_right ?=  this.child_(2 * @index + 2)

  parent: =>
    @_parent ?= new Node(@array, @index / 2, @comp)

  heapify: =>
    if this.left()? then this.left().heapify()
    if this.right()? then this.right().heapify()
    this.siftDown()

  siftDown: =>
    smallerChild = this._findSmallerChildren()
    if smallerChild? and this._comp(smallerChild, this)
      this._swap(smallerChild)
      smallerChild.siftDown()

  siftUp: =>
    unless this._isRoot()
      if this.parent().value() > this.value()
        this._swap this.parent()
        this.parent().siftUp()

  child_: (childIndex) =>
    if (childIndex < @array.length) then new Node(@array, childIndex, @comp) else null

  _findSmallerChildren: =>
    if this.left()? and this.right()?
      if this._comp(this.left(), this.right()) then this.left() else this.right()
    else
      if this.left()? then this.left() else this.right()

  _swap: (that) =>
    tmp = this.value()
    this.value(that.value())
    that.value(tmp)

  _isRoot: => @index is 0

  _comp: (na, nb) =>
    @comp(na.value(), nb.value())

this.Node = Node