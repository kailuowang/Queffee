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