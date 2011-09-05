describe 'Q', ->
  describe 'enqueue/dequeue', ->
    it 'returns the jobs in the order of priority', ->
      q = new quefee.Q
      lowP = new quefee.Job(null, 3)
      mediumP = new quefee.Job(null, 4)
      highP = new quefee.Job(null, 5)
      q.enqueue(mediumP, highP, lowP)
      expect(q.dequeue()).toEqual(highP)
      expect(q.dequeue()).toEqual(mediumP)
      expect(q.dequeue()).toEqual(lowP)

  describe 'reorder', ->
    it 'reorder the queue according to new priority', ->
      q = new quefee.Q
      [lp, mp, hp] = [5, 4, 3]
      lowP = new quefee.Job(null, -> lp)
      mediumP = new quefee.Job(null, -> mp)
      highP = new quefee.Job(null, -> hp)
      q.enqueue(mediumP, highP, lowP)
      [lp, mp, hp] = [3, 4, 5]
      q.reorder()
      expect(q.dequeue()).toEqual(highP)
      expect(q.dequeue()).toEqual(mediumP)
      expect(q.dequeue()).toEqual(lowP)
