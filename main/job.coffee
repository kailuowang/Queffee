class quefee.Job
  #@peform is a function that takes in a callback function as parameter and will call the call back upon finish
  constructor: (@perform, @_priority, @_timeout) ->

  priority: =>
    @_priority?() || @_priority

  timeout: =>
    @_timeout?() || @_timeout

