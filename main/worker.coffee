class queffee.Worker
  constructor: (@q, @onIdle) ->
    @idle_ = true
    @q.onNewJobAdded = =>
      this._work()

  start: =>
    this._work()

  idle: => @idle_

  _work: =>
    if @idle_
      job = @q.dequeue()
      if @idle_ = !job?
        @onIdle?()
      else
        job.perform this._onJobDone

  _onJobDone: =>
    @idle_ = true
    this._work()
