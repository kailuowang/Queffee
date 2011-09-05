describe 'Node', ->
  describe "#heapify", ->
    it "should ensure the tree underneath the node satisfies the heap property", ->
      node = new quefee.Node([5,6,3], 0)
      node.heapify()
      expect(node.left().value()).toBeLessThan(node.value())
      expect(node.right().value()).toBeLessThan(node.value())