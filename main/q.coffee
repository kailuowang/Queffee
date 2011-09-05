class quefee.Q
  @_compareJob: (jobA, jobB) =>
    jobA.priority() > jobB.priority()

  constructor: (jobs = [])->
    @_heap = new quefee.Heap(jobs, quefee.Q._compareJob)
    @onNewJobAdded = null

  enqueue: (jobs...) =>
    for job in jobs
      @_heap.insert(job)
    @onNewJobAdded?()

  enQ: (performFn, priorityFn) =>
    enqueue(new quefee.Job(performFn, priorityFn))

  dequeue: =>
    @_heap.extractTop()

  reorder: => @_heap.reorder()
