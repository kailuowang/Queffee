class queffee.Worker
  #starts immediately unless set true in the last parameter
  constructor: (@q, @onIdle, @_turnedOff = false) ->
    @_job = null
    @q.jobsAdded @_work

  start: =>
    @_turnedOff = false
    @_work()

  stop: => @_turnedOff = true

  idle: => !@_job?

  retry: => @_kickOffJob() unless @idle()

  _work: =>
    if @idle() and !@_turnedOff
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