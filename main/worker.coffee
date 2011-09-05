class quefee.Worker
  constructor: (@q, @onIdle) ->
    @idle_ = true
    @q.onNewJobAdded = =>
      this._work() if @idle_

  start: =>
    this._work()

  _work: =>
    job = @q.dequeue()
    if job?
      @idle_ = false
      job.perform(this._work)
    else
      @idle_ = true
      @onIdle?()

