
describe 'CollectionWorkQ', ->
  describe 'start', ->
    it 'runs operation on items one at a time', ->
      [item1, item2, item3] = [new MockItem(), new MockItem(), new MockItem()]
      new queffee.CollectionWorkQ(
        collection: [item1, item2, item3]
        operation: 'someOperation'
      ).start()

      expect(item1.called).toBeTruthy()
      expect(item2.called).toBeFalsy()
      expect(item3.called).toBeFalsy()
      item1.reportSuccess()

      expect(item2.called).toBeTruthy()
      expect(item3.called).toBeFalsy()

      item2.reportSuccess()
      expect(item3.called).toBeTruthy()

    it 'reports progress', ->
      progress = 0
      [item1, item2] = [new MockItem(), new MockItem()]
      new queffee.CollectionWorkQ(
        collection: [item1, item2]
        operation: 'someOperation'
        onProgress: (prog) -> progress = prog
      ).start()
      expect(progress).toEqual(0)
      item1.reportSuccess()
      expect(progress).toEqual(1)
      item2.reportSuccess()
      expect(progress).toEqual(2)


    it 'reports finish', ->
      finished = false
      new queffee.CollectionWorkQ(
        collection: [item1 = new MockItem()]
        operation: 'someOperation'
        onFinish: -> finished = true
      ).start()
      expect(finished).toBeFalsy()
      item1.reportSuccess()
      expect(finished).toBeTruthy()


    it 'takes in function that takes an item and callback as the operation', ->
      new queffee.CollectionWorkQ(
        collection: [item1 = new MockItem(), item2 = new MockItem()]
        operation: (item, callback) -> item.someOperation(callback)
      ).start()
      item1.reportSuccess()
      expect(item2.called).toBeTruthy()



class MockItem
  constructor: ->
    @called = false

  someOperation: (onSuccess) =>
    @called = true
    @onSuccess = onSuccess

  reportSuccess: => @onSuccess()
