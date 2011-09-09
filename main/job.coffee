class queffee.Job
  #@peform is a function that takes in a callback function as parameter and will call the call back upon finish
  constructor: (@_perform, @_priority, @_timeout) ->

  priority: =>
    @_priority?() || @_priority

  timeout: =>
    @_timeout?() || @_timeout

  perform: (callback)=>
    @running = true
    @_onJobDone = callback
    @_perform(this._done)
    if this.timeout()?
      setTimeout(this._done, this.timeout())

  _done: =>
    if @running
      @running = false
      @_onJobDone()