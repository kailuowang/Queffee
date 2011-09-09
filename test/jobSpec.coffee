describe 'Job', ->
  describe 'priority', ->
    it 'returns the value if a priority value is passed in the constructor', ->
      expect(new queffee.Job(null, 23).priority()).toEqual(23)

    it 'returns the return value of the func if a priority func is passed in the constructor', ->
      expect(new queffee.Job(null, -> 23).priority()).toEqual(23)

    it 'return zero if the priroty func returns zero', ->
      expect(new queffee.Job(null, -> 0).priority()).toEqual(0)


  describe 'timeout', ->
    it 'returns the value if a timeout value is passed in the constructor', ->
      expect(new queffee.Job(null, 1, 23).timeout()).toEqual(23)

    it 'returns the return value of the func if a timeout func is passed in the constructor', ->
      expect(new queffee.Job(null, 1, -> 23).timeout()).toEqual(23)

    it 'returns undefined if not set', ->
      expect(new queffee.Job(null, 1).timeout()).toBeUndefined()

    it "calls the call back after the timeout", ->
      runs ->
        @calledback = false
        job = new queffee.Job((->), 1, 100)
        job.perform( => @calledback = true)
      waits(200)
      runs ->
        expect(@calledback).toBeTruthy()

    it "does not call the callback more than once", ->
      runs ->
        @calledback = 0
        job = new queffee.Job(((callback)-> callback()), 1, 100)
        job.perform( => @calledback++)
      waits(200)
      runs ->
        expect(@calledback).toEqual(1)
