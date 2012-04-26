class queffee.CollectionWorkQ
  constructor: (opts) ->
    { @collection, @operation, @onProgress, @onFinish } = opts

  start: =>
    q = new queffee.Q(@_createJobs())
    new queffee.Worker(q, @onFinish).start()

  _createJobs: =>
    for item, index in @collection
      @_createJob(item, index)

  _createJob: (item, index) =>
    jobFn =
      if(typeof @operation is 'string')
        (callback) =>
          item[@operation](=> @_itemDone(index, callback))
      else
        (callback) =>
          @operation(item, => @_itemDone(index, callback))

    new queffee.Job(jobFn, priority: -index)

  _itemDone:(index, callback) =>
    @onProgress?(index + 1)
    callback()

