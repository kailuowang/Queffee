class queffee.Q
  @_compareJob: (jobA, jobB) =>
    jobA.priority() > jobB.priority()

  constructor: (jobs = [])->
    this._initHeap(jobs)
    @newJobsAddedHandler = []

  jobsAdded: (handler) =>
    @newJobsAddedHandler.push(handler)

  enqueue: (jobs...) =>
    for job in jobs
      @_heap.insert(job)
    this._newJobsAdded()

  enQ: (performFn, priorityFn, timeout) =>
    this.enqueue(new queffee.Job(performFn, priorityFn, timeout))

  dequeue: =>
    @_heap.extractTop()

  reorder: => @_heap.reorder()

  size: => @_heap.size()

  clear: => this._initHeap([])

  _initHeap: (jobs) =>
    @_heap = new queffee.Heap(jobs, queffee.Q._compareJob)


  _newJobsAdded: =>
    handler() for handler in @newJobsAddedHandler