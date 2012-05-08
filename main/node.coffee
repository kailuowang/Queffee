#internal class used in heap
class queffee.Node
  constructor: (@array, @index, @comp = (a,b) -> a > b ) ->

  value: (newVal) =>
    if newVal? and @_valid()
      @array[@index] = newVal
    else
      @array[@index]

  left: =>
    @_left ?= @_child(2 * @index + 1)

  right: =>
    @_right ?= @_child(2 * @index + 2)

  parent: =>
    @_parent ?= new Node(@array, Math.floor(@index / 2), @comp)

  heapify: =>
    if @left()? then @left().heapify()
    if @right()? then @right().heapify()
    @siftDown()

  siftDown: =>
    smallerChild = @_findSmallerChildren()
    if smallerChild? and @_comp(smallerChild, this)
      @_swap(smallerChild)
      smallerChild.siftDown()

  siftUp: =>
    unless @_isRoot()
      if @_comp(this, @parent())
        @_swap @parent()
        @parent().siftUp()

  _child: (childIndex) =>
    if (childIndex < @array.length) then new Node(@array, childIndex, @comp) else null

  _findSmallerChildren: =>
    if @left()? and @right()?
      if @_comp(@left(), @right()) then @left() else @right()
    else
      if @left()? then @left() else @right()

  _swap: (that) =>
    tmp = @value()
    @value(that.value())
    that.value(tmp)

  _isRoot: => @index is 0

  _comp: (na, nb) =>
    @comp(na.value(), nb.value())

  _valid: =>
    @index < @array.length
