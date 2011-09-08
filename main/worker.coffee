class queffee.Worker
  constructor: (@q, @onIdle) ->
    @idle_ = true
    @q.onNewJobAdded = =>
      this._work() if @idle_

  start: =>
    this._work()

  idle: => @idle_

  _work: =>
    job = @q.dequeue()
    if @idle_ = !job?
      @onIdle?()
    else
      job.perform(this._work)
      this._prepareForTimeout(job)

  _prepareForTimeout: (job) =>
    if job.timeout?()?
      setTimeout(this._work, job.timeout())
