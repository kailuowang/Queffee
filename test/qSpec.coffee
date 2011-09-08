describe 'Q', ->
  describe 'enqueue/dequeue', ->
    it 'returns the jobs in the order of priority', ->
      q = new queffee.Q
      lowP = new queffee.Job(null, 3)
      mediumP = new queffee.Job(null, 4)
      highP = new queffee.Job(null, 5)
      q.enqueue(mediumP, highP, lowP)
      expect(q.dequeue()).toEqual(highP)
      expect(q.dequeue()).toEqual(mediumP)
      expect(q.dequeue()).toEqual(lowP)

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
