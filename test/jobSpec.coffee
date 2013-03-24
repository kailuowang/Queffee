describe 'Job', ->
  describe 'priority', ->
    it 'returns the value if a priority value is passed in the constructor', ->
      expect(new queffee.Job(null, priority: 23).priority()).toEqual(23)

    it 'returns the return value of the func if a priority func is passed in the constructor', ->
      expect(new queffee.Job(null, priority: -> 23).priority()).toEqual(23)

    it 'return zero if the priroty func returns zero', ->
      expect(new queffee.Job(null, priority: -> 0).priority()).toEqual(0)

  describe 'perform', ->
    it 'runs an async function that takes in a callback', ->
      doSomething = jasmine.createSpy()
      workerCallback = jasmine.createSpy()
      fake_asyn_fun = (callback) ->
        doSomething()
        callback()
      job = new queffee.Job(fake_asyn_fun)
      job.perform(workerCallback)
      expect(doSomething).toHaveBeenCalled()
      expect(workerCallback).toHaveBeenCalled()
      expect(job.running).toBeFalsy()

    it 'runs the async function that returns a promise', ->
      dfd = $.Deferred()
      doSomething = jasmine.createSpy('real work')
      workerCallback = jasmine.createSpy('worker call back')
      asyn_fn_with_promise = ->
        doSomething()
        dfd.promise()
      job = new queffee.Job(asyn_fn_with_promise)
      runs ->
        job.perform(workerCallback)
      waits(200)
      runs ->
        expect(doSomething).toHaveBeenCalled()
        expect(workerCallback).not.toHaveBeenCalled()
        expect(job.running).toBeTruthy()
        dfd.resolve('success')
        expect(workerCallback).toHaveBeenCalled()
        expect(job.running).toBeFalsy()

    it 'run a synchronezed method asynchronously', ->
      fake_sync_func = jasmine.createSpy()
      workerCallback = jasmine.createSpy()
      job = new queffee.Job(fake_sync_func)
      runs ->
        job.perform(workerCallback)
      waits(200)
      runs ->
        expect(fake_sync_func).toHaveBeenCalled()
        expect(workerCallback).toHaveBeenCalled()
        expect(job.running).toBeFalsy()


  describe 'timeout', ->
    it 'returns the value if a timeout value is passed in the constructor', ->
      expect(new queffee.Job(null, priority: 1, timeout: 23).timeout()).toEqual(23)

    it 'returns the return value of the func if a timeout func is passed in the constructor', ->
      expect(new queffee.Job(null, priority: 1, timeout: -> 23).timeout()).toEqual(23)

    it 'returns undefined if not set', ->
      expect(new queffee.Job(null, priority: 1).timeout()).toBeUndefined()

    it "calls the call back after the timeout", ->
      runs ->
        @calledback = false
        job = new queffee.Job((->), priority: 1, timeout: 100)
        job.perform( => @calledback = true)
      waits(200)
      runs ->
        expect(@calledback).toBeTruthy()

    it "does not call the callback more than once", ->
      runs ->
        @calledback = 0
        job = new queffee.Job(((callback)-> callback()), priority: 1, timeout: 100)
        job.perform( => @calledback++)
      waits(200)
      runs ->
        expect(@calledback).toEqual(1)
