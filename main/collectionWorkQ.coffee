class queffee.CollectionWorkQ
  constructor: (opts) ->
    {
      collection: @collection
      operation: @operation
      onProgress: @onProgress
      onFinish: @onFinish
    } = opts

  start: =>
    q = new queffee.Q(this._createJobs())
    new queffee.Worker(q, @onFinish).start()

  _createJobs: =>
    for item, index in @collection
      this._createJob(item, index)

  _createJob: (item, index) =>
    jobFn =
      if(typeof @operation is 'string')
        (callback) =>
          item[@operation](=> this._itemDone(index, callback))
      else
        (callback) =>
          @operation(item, => this._itemDone(index, callback))

    new queffee.Job( jobFn , -index)

  _itemDone:(index, callback) =>
    @onProgress?(index + 1)
    callback()

