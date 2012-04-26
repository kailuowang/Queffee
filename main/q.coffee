class queffee.Q
  @_compareJob: (jobA, jobB) => jobA.priority() > jobB.priority()

  constructor: (jobs = [])->
    @_initHeap(jobs)
    @newJobsAddedHandler = []

  jobsAdded: (handler) => @newJobsAddedHandler.push(handler)

  enqueue: (jobs...) =>
    for job in jobs
      @_heap.insert(job)
    @_newJobsAdded()

  enQ: (performFn, opts = {}) =>
    opts.priority ?= @_priorityBySequence()
    @enqueue(new queffee.Job(performFn, opts))

  dequeue: => @_heap.extractTop()

  reorder: => @_heap.reorder()

  size: => @_heap.size()

  clear: => @_initHeap([])

  _priorityBySequence: => - 1 - @size()

  _initHeap: (jobs) =>
    @_heap = new queffee.Heap(jobs, queffee.Q._compareJob)

  _newJobsAdded: =>
    handler() for handler in @newJobsAddedHandler