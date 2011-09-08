describe 'Node', ->
  describe "#heapify", ->
    it "should ensure the tree underneath the node satisfies the heap property", ->
      node = new queffee.Node([5,6,3], 0)
      node.heapify()
      expect(node.left().value()).toBeLessThan(node.value())
      expect(node.right().value()).toBeLessThan(node.value())

  describe "#value", ->
    it "returns nothing if the node is invalid", ->
      node = new queffee.Node([5], 1)
      expect(node.value()?).toBeFalsy()

  describe "#parent", ->
    it "returns the parent of the node", ->
      node = new queffee.Node([5,3], 1)
      expect(node.parent().value()).toEqual(5)
