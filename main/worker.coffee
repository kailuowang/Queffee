class queffee.Worker
  #starts immediately unless set true in the last parameter
  constructor: (@q, @onIdle, @_stopped = false) ->
    @_job = null
    @q.jobsAdded this._work

  start: =>
    @_stopped = false
    this._work()

  stop: => @_stopped = true

  idle: => !@_job?

  retry: => this._kickOffJob() unless this.idle()

  _work: =>
    if this.idle() and !@_stopped
      this._pickupJob()
      if this.idle()
        @onIdle?()
      else
        this._kickOffJob()

  _onJobDone: =>
    @_job = null
    this._work()

  _kickOffJob: => @_job.perform this._onJobDone

  _pickupJob: => @_job = @q.dequeue()