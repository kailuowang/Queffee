class queffee.Worker
  constructor: (@q, @onIdle) ->
    @_idle = true
    @q.jobsAdded this._work
    @_stopped = false

  start: =>
    @_stopped = false
    this._work()

  stop: => @_stopped = true

  idle: => @_idle

  _work: =>
    if @_idle and !@_stopped
      job = @q.dequeue()
      if @_idle = !job?
        @onIdle?()
      else
        job.perform this._onJobDone

  _onJobDone: =>
    @_idle = true
    this._work()
