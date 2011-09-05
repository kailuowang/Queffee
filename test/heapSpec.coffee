describe "Heap", ->
  describe "constructor", ->
    it "should create from array", ->
      expect(new quefee.Heap([4,5]).size()).toEqual(2)

  describe "#top", ->
    it "should return the top item in the binaryHeap", ->
      expect(new quefee.Heap([7, 6, 4, 3, 5, 10]).top()).toEqual(10)

  describe "#extractTop", ->
    it "should return the top and remove that item from the heap", ->
      heap = new quefee.Heap([6, 10, 7, 3, 9, 5])
      expect(heap.extractTop()).toEqual(10)
      expect(heap.extractTop()).toEqual(9)
      expect(heap.extractTop()).toEqual(7)

    it "return top based on the comp function", ->
      heap = new quefee.Heap([6, 10, 7, 3, 9, 5], (a,b)-> a < b)
      expect(heap.extractTop()).toEqual(3)
      expect(heap.extractTop()).toEqual(5)
      expect(heap.extractTop()).toEqual(6)

  describe "#insert", ->
    it "should insert value into heap", ->
      heap = new quefee.Heap([6, 7, 2, 10, 3])
      heap.insert(8)
      expect(heap.extractTop()).toEqual(10)
      expect(heap.extractTop()).toEqual(8)

