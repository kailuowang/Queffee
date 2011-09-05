class quefee.CollectionWorkQ
  constructor: (opts) ->
    {
      collection: @collection
      operation: @operation
      onProgress: @onProgress
      onFinish: @onFinish
    } = opts

  start: =>
    q = new quefee.Q(this._createJobs())
    new quefee.Worker(q, @onFinish).start()

  _createJobs: =>
    for item, index in @collection
      this._createJob(item, index)

  _createJob: (item, index) =>
    jobFn =
      if(typeof @operation is 'string')
        (callback) =>
          item[@operation] =>
            @onProgress?()
            callback()
      else
        (callback) =>
          @operation item, =>
            @onProgress?()
            callback()

    new quefee.Job( jobFn , -index)


