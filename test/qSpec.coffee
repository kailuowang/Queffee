describe 'Q', ->
  describe 'enqueue/dequeue', ->
    it 'returns the jobs in the order of priority', ->
      q = new queffee.Q
      lowP = new queffee.Job(null, -1)
      mediumP = new queffee.Job(null, 0)
      highP = new queffee.Job(null, 3)
      q.enqueue(mediumP, highP, lowP)
      expect(q.dequeue()).toEqual(highP)
      expect(q.dequeue()).toEqual(mediumP)
      expect(q.dequeue()).toEqual(lowP)

  describe 'enQ', ->
    it 'orders the job according to the priority passed in', ->
      q = new queffee.Q
      justDone = 0
      q.enQ (-> justDone = 2), 2
      q.enQ (-> justDone = 1), 3
      q.enQ (-> justDone = 3), 1
      q.dequeue().perform()
      expect(justDone).toEqual(1)
      q.dequeue().perform()
      expect(justDone).toEqual(2)
      q.dequeue().perform()
      expect(justDone).toEqual(3)

    it 'orders the jobs according to the sequence added when no priority is provided', ->
      q = new queffee.Q
      justDone = 0
      q.enQ(-> justDone = 1)
      q.enQ(-> justDone = 2)
      q.enQ(-> justDone = 3)
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
      lowP = new queffee.Job(null, -> lp)
      mediumP = new queffee.Job(null, -> mp)
      highP = new queffee.Job(null, -> hp)
      q.enqueue(mediumP, highP, lowP)
      [lp, mp, hp] = [3, 4, 5]
      q.reorder()
      expect(q.dequeue()).toEqual(highP)
      expect(q.dequeue()).toEqual(mediumP)
      expect(q.dequeue()).toEqual(lowP)

  describe 'clear', ->
    it 'clears the queue', ->
      q = new queffee.Q
      q.enQ(null, -> 3)
      q.enQ(null, -> 4)
      q.clear()
      expect(q.size()).toEqual(0)
      expect(q.dequeue()?).toBeFalsy()

  describe 'jobAdded', ->
    it 'call the handler when new jobs added', ->
      q = new queffee.Q
      worker = {newJobsAdded: (->)}
      spyOn(worker, 'newJobsAdded')
      q.jobsAdded(worker.newJobsAdded)
      q.enQ(null, -> 3)
      expect(worker.newJobsAdded).toHaveBeenCalled()
