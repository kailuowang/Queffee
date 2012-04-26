describe 'Q', ->
  describe 'enqueue/dequeue', ->
    it 'returns the jobs in the order of priority', ->
      q = new queffee.Q
      lowP = new queffee.Job(null, priority: -1)
      mediumP = new queffee.Job(null, priority: 0)
      highP = new queffee.Job(null, priority: 3)
      q.enqueue(mediumP, highP, lowP)
      expect(q.dequeue()).toEqual(highP)
      expect(q.dequeue()).toEqual(mediumP)
      expect(q.dequeue()).toEqual(lowP)

  describe 'enQ', ->
   

    it 'orders the job according to the priority passed in', ->
      q = new queffee.Q
      justDone = 0
      work = (number)->
        (callback) ->
          justDone = number
          callback()

      q.enQ (work(2)), priority: 2
      q.enQ (work(1)), priority: 3
      q.enQ (work(3)), priority: 1
      q.dequeue().perform()
      expect(justDone).toEqual(1)
      q.dequeue().perform()
      expect(justDone).toEqual(2)
      q.dequeue().perform()
      expect(justDone).toEqual(3)

    it 'orders the jobs according to the sequence added when no priority is provided', ->
      q = new queffee.Q
      justDone = 0
      work = (number)->
        (callback) ->
          justDone = number
          callback()
      q.enQ(work 1)
      q.enQ(work 2)
      q.enQ(work 3)
      q.dequeue().perform()
      expect(justDone).toEqual(1)
      q.dequeue().perform()
      expect(justDone).toEqual(2)
      q.dequeue().perform()
      expect(justDone).toEqual(3)

  describe 'reorder', ->
    it 'reorder the queue according to new priority', ->
      q = new queffee.Q
      [lp, mp, hp] = [5, 4, 3]
      lowP = new queffee.Job(null,  priority: -> lp)
      mediumP = new queffee.Job(null,  priority: -> mp)
      highP = new queffee.Job(null,  priority: -> hp)
      q.enqueue(mediumP, highP, lowP)
      [lp, mp, hp] = [3, 4, 5]
      q.reorder()
      expect(q.dequeue()).toEqual(highP)
      expect(q.dequeue()).toEqual(mediumP)
      expect(q.dequeue()).toEqual(lowP)

  describe 'clear', ->
    it 'clears the queue', ->
      q = new queffee.Q
      q.enQ(null, priority: -> 3)
      q.enQ(null, priority: -> 4)
      q.clear()
      expect(q.size()).toEqual(0)
      expect(q.dequeue()?).toBeFalsy()

  describe 'jobAdded', ->
    it 'call the handler when new jobs added', ->
      q = new queffee.Q
      worker = {newJobsAdded: (->)}
      spyOn(worker, 'newJobsAdded')
      q.jobsAdded(worker.newJobsAdded)
      q.enQ(null, priority: -> 3)
      expect(worker.newJobsAdded).toHaveBeenCalled()
