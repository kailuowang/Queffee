class quefee.Job
 #@peform is a function that takes in a callback function as parameter and will call the call back upon finish
 constructor: (@perform, @_priority) ->

 priority: =>
  @_priority?() || @_priority

