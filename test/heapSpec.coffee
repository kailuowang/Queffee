describe "Heap", ->
  describe "constructor", ->
    it "should create from array", ->
      expect(new queffee.Heap([4,5]).size()).toEqual(2)

    it "creates empty when no array passed in", ->
      expect(new queffee.Heap().size()).toEqual(0)

  describe "#top", ->
    it "should return the top item in the binaryHeap", ->
      expect(new queffee.Heap([7, 6, 4, 3, 5, 10]).top()).toEqual(10)

  describe "#extractTop", ->
    it "should return the top and remove that item from the heap", ->
      heap = new queffee.Heap([6, 10, 7, 3, 9, 5])
      expect(heap.extractTop()).toEqual(10)
      expect(heap.extractTop()).toEqual(9)
      expect(heap.extractTop()).toEqual(7)

    it "return top based on the comp function", ->
      heap = new queffee.Heap([6, 10, 7, 3, 9, 5], (a,b)-> a < b)
      expect(heap.extractTop()).toEqual(3)
      expect(heap.extractTop()).toEqual(5)
      expect(heap.extractTop()).toEqual(6)

    it "retains rest of the items", ->
      heap = new queffee.Heap([6, 9, 5])
      expect(heap.extractTop()).toEqual(9)
      expect(heap.extractTop()).toEqual(6)
      expect(heap.extractTop()).toEqual(5)

    it "returns nothing if already empty", ->
      heap = new queffee.Heap([6, 9])
      heap.extractTop()
      heap.extractTop()
      expect(heap.extractTop()?).toBeFalsy()

  describe "#insert", ->
    it "should insert value into heap", ->
      heap = new queffee.Heap([6, 7, 2, 10, 3])
      heap.insert(8)
      expect(heap.extractTop()).toEqual(10)
      expect(heap.extractTop()).toEqual(8)

    it "add a new value to the heap", ->
      heap = new queffee.Heap([9,10])
      heap.insert(8)
      expect(heap.extractTop()).toEqual(10)
      expect(heap.extractTop()).toEqual(9)
      expect(heap.extractTop()).toEqual(8)

    it "insert new values if already empty", ->
      heap = new queffee.Heap([9,10])
      heap.extractTop()
      heap.extractTop()
      heap.insert(1)
      expect(heap.top()).toEqual(1)

    it 'inserts values in sequence into empty heap', ->
      heap = new queffee.Heap()
      heap.insert(4)
      heap.insert(5)
      heap.insert(3)
      expect(heap.extractTop()).toEqual(5)
      expect(heap.extractTop()).toEqual(4)
      expect(heap.extractTop()).toEqual(3)

  describe "#reorder", ->
    it "should reorder the heap", ->
      a = {p: 1}
      b = {p: 2}
      c = {p: 3}
      d = {p: 4}
      heap = new queffee.Heap([a, b, c, d], (x,y) -> x.p > y.p )
      expect(heap.top()).toEqual(d)
      d.p = 2
      b.p = 4
      heap.reorder()
      expect(heap.extractTop()).toEqual(b)
      expect(heap.extractTop()).toEqual(c)

