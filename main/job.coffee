class queffee.Job
  #@_peform must be a function that takes in a callback function as parameter and will call the call back upon finish
  constructor: (@_perform, opts = {}) ->
    [@_priority, @_timeout] = [opts.priority, opts.timeout]

  priority: =>
    @_try(@_priority)

  timeout: =>
    @_try(@_timeout)

  perform: (callback)=>
    @running = true
    @_onJobDone = callback
    @_perform_job()
    if @timeout()?
      setTimeout(@_done, @timeout())

  _perform_job: =>
    if @_perform.length is 1
      @_perform(@_done)
    else if @_perform.length is 0
      setTimeout =>
        @_perform()
        @_done()
    else
      throw "#{@_perform} should be either an async function that takes in callback function as a parameter or a synchronized function that does not have any arguments."


  _done: =>
    if @running
      @running = false
      @_onJobDone?()

  _try: (func_or_val) =>
    if (typeof func_or_val is 'function')
      func_or_val?()
    else
      func_or_val
