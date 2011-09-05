class quefee.Q
  @_compareJob: (jobA, jobB) =>
    jobA.priority() > jobB.priority()

  constructor: (jobs = [])->
    @_heap = new quefee.Heap(jobs, quefee.Q._compareJob)

  enqueue: (jobs...) =>
    for job in jobs
      @_heap.insert(job)

  dequeue: =>
    @_heap.extractTop()

