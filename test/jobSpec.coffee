describe 'Job', ->
  describe 'priority', ->
    it 'returns the value if a priority value is passed in the constructor', ->
      expect(new quefee.Job(null, 23).priority()).toEqual(23)

    it 'returns the return value of the func if a priority func is passed in the constructor', ->
      expect(new quefee.Job(null, -> 23).priority()).toEqual(23)