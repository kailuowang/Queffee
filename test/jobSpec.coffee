describe 'Job', ->
  describe 'priority', ->
    it 'returns the value if a priority value is passed in the constructor', ->
      expect(new queffee.Job(null, 23).priority()).toEqual(23)

    it 'returns the return value of the func if a priority func is passed in the constructor', ->
      expect(new queffee.Job(null, -> 23).priority()).toEqual(23)

  describe 'timeout', ->
    it 'returns the value if a timeout value is passed in the constructor', ->
      expect(new queffee.Job(null, 1, 23).timeout()).toEqual(23)

    it 'returns the return value of the func if a timeout func is passed in the constructor', ->
      expect(new queffee.Job(null, 1, -> 23).timeout()).toEqual(23)

    it 'returns undefined if not set', ->
      expect(new queffee.Job(null, 1).timeout()).toBeUndefined()
