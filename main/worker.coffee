class queffee.Worker
  #starts immediately unless set true in the last parameter
  constructor: (@q, @onIdle, @_stopped = false) ->
    @_job = null
    @q.jobsAdded @_work

  start: =>
    @_stopped = false
    @_work()

  stop: => @_stopped = true

  idle: => !@_job?

  retry: => @_kickOffJob() unless @idle()

  _work: =>
    if @idle() and !@_stopped
      @_pickupJob()
      if @idle()
        @onIdle?()
      else
        @_kickOffJob()

  _onJobDone: =>
    @_job = null
    @_work()

  _kickOffJob: => @_job.perform @_onJobDone

  _pickupJob: => @_job = @q.dequeue()