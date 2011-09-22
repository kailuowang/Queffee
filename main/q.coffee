class queffee.Q
  @_compareJob: (jobA, jobB) => jobA.priority() > jobB.priority()

  constructor: (jobs = [])->
    this._initHeap(jobs)
    @newJobsAddedHandler = []

  jobsAdded: (handler) => @newJobsAddedHandler.push(handler)

  enqueue: (jobs...) =>
    for job in jobs
      @_heap.insert(job)
    this._newJobsAdded()

  enQ: (performFn, priority = this._priorityBySequence(), timeout) =>
    this.enqueue(new queffee.Job(performFn, priority, timeout))

  dequeue: => @_heap.extractTop()

  reorder: => @_heap.reorder()

  size: => @_heap.size()

  clear: => this._initHeap([])

  _priorityBySequence: => - 1 - this.size()

  _initHeap: (jobs) =>
    @_heap = new queffee.Heap(jobs, queffee.Q._compareJob)

  _newJobsAdded: =>
    handler() for handler in @newJobsAddedHandler