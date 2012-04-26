describe 'Worker', ->
  describe '#start', ->

    nullJob = (priority_ = 1) ->
      new queffee.Job(((callback) -> callback()),  priority: priority_)

    it 'performs the first job', ->
      job = nullJob()
      spyOn(job, 'perform')
      q = new queffee.Q([job])
      new queffee.Worker(q).start()
      expect(job.perform).toHaveBeenCalled()

    it 'goes to the next job when the current job is done', ->
      job1 = nullJob(2)
      job2 = nullJob(1)
      spyOn(job2, 'perform')

      q = new queffee.Q([job1, job2])
      new queffee.Worker(q).start()
      expect(job2.perform).toHaveBeenCalled()

    it 'calls onIdle once all jobs are done', ->
      done = false
      q = new queffee.Q([nullJob(1)])
      new queffee.Worker(q, (-> done = true)).start()
      expect(done).toBeTruthy()

    describe "#picking up newly inserted jobs", ->
      it 'automatically picks up the newly added job when idle', ->
        job1 = nullJob(2)
        job2 = nullJob(1)
        spyOn(job2, 'perform')
        q = new queffee.Q([job1])
        new queffee.Worker(q).start()
        q.enqueue(job2)
        expect(job2.perform).toHaveBeenCalled()

      it 'does not automatically picks up the newly added job if is running a job', ->
        job1 = new queffee.Job ((callback) -> @done = callback), 1
        job2 = nullJob()
        spyOn(job2, 'perform')
        q = new queffee.Q([job1])
        new queffee.Worker(q).start()
        q.enqueue(job2)
        expect(job2.perform).not.toHaveBeenCalled()
        job1.done()
        expect(job2.perform).toHaveBeenCalled()

    describe "when timeout set on job", ->
      it "picks up the next job after timeout even when callback never happend", ->
        runs ->
          job1 = new queffee.Job( (->),  priority: 1, timeout: 100 )
          @job2 = nullJob()
          spyOn(@job2, 'perform')
          new queffee.Worker(new queffee.Q([job1, @job2])).start()

        waits(200)
        runs ->
          expect(@job2.perform).toHaveBeenCalled()
      it "does not picks up the next job when callback never happend without timeout being set", ->
        runs ->
          job1 = new queffee.Job( ((callback)-> ),  priority: 1 )
          @job2 = nullJob()
          spyOn(@job2, 'perform')
          new queffee.Worker(new queffee.Q([job1, @job2])).start()

        waits(200)
        runs ->
          expect(@job2.perform).not.toHaveBeenCalled()

      it "went back to idle if the last job timed out", ->
        runs ->
          job1 = new queffee.Job( (->),  priority: 1, timeout: 100 )
          @worker = new queffee.Worker(new queffee.Q([job1]))
          @worker.start()

        waits(200)
        runs ->
          expect(@worker.idle()).toBeTruthy()

    describe "#stop", ->
      it 'stops picking up next job in the queue when stopped', ->
        job1 = new queffee.Job ((callback) -> @done = callback), 1
        job2 = nullJob()
        spyOn(job2, 'perform')
        q = new queffee.Q([job1, job2])
        worker = new queffee.Worker(q)
        worker.start()
        worker.stop()
        job1.done()
        expect(job2.perform).not.toHaveBeenCalled()

      it 'stops picking new jobs added to the queue', ->
        job = nullJob()
        spyOn(job, 'perform')
        q = new queffee.Q
        worker = new queffee.Worker(q)
        worker.start()
        worker.stop()
        q.enqueue(job)
        expect(job.perform).not.toHaveBeenCalled()

    describe 'multiple workers', ->
      it 'pick up newly added job', ->
        q = new queffee.Q
        worker1 = new queffee.Worker(q)
        worker2 = new queffee.Worker(q)
        worker1.start()
        worker2.start()
        q.enQ(->)
        q.enQ(->)
        expect(worker1.idle()).toBeFalsy()
        expect(worker2.idle()).toBeFalsy()

    describe '#retry', ->
      it 'retries the stuck job and continue', ->
        job1Stuck = true
        job2Done = false
        job1 = ((callback) -> callback() unless job1Stuck)
        job2 = ((callback) -> job2Done = true ; callback())
        q = new queffee.Q
        worker = new queffee.Worker(q)
        q.enQ job1
        q.enQ job2
        expect(job2Done).toBeFalsy()
        job1Stuck = false
        worker.retry()
        expect(job2Done).toBeTruthy()

      it 'does nothing if idle', ->
        q = new queffee.Q
        worker = new queffee.Worker(q)
        q.  enqueue nullJob()
        worker.retry()

