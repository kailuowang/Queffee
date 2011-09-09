class queffee.Job
  #@peform is a function that takes in a callback function as parameter and will call the call back upon finish
  constructor: (@_perform, @_priority, @_timeout) ->

  priority: =>
    this._try(@_priority)

  timeout: =>
    this._try(@_timeout)

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

  _try: (func_or_val) =>
    if (typeof func_or_val is 'function')
      func_or_val?()
    else
      func_or_val
