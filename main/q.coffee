class queffee.Q
  @_compareJob: (jobA, jobB) =>
    jobA.priority() > jobB.priority()

  constructor: (jobs = [])->
    this._initHeap(jobs)
    @onNewJobAdded = null

  enqueue: (jobs...) =>
    for job in jobs
      @_heap.insert(job)
    @onNewJobAdded?()

  enQ: (performFn, priorityFn, timeout) =>
    this.enqueue(new queffee.Job(performFn, priorityFn, timeout))

  dequeue: =>
    @_heap.extractTop()

  reorder: => @_heap.reorder()

  size: => @_heap.size()

  clear: => @_heap = this._initHeap([])

  _initHeap: (jobs) =>
    @_heap = new queffee.Heap(jobs, queffee.Q._compareJob)