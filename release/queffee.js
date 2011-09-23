/*
queffee
- A js dynamic priority work queue

version: 1.0RC1

Copyright (c) 2011 Kailuo Wang

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

*/
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __slice = Array.prototype.slice;
this.queffee = {};
queffee.Node = (function() {
  function Node(array, index, comp) {
    this.array = array;
    this.index = index;
    this.comp = comp != null ? comp : function(a, b) {
      return a > b;
    };
    this._valid = __bind(this._valid, this);
    this._comp = __bind(this._comp, this);
    this._isRoot = __bind(this._isRoot, this);
    this._swap = __bind(this._swap, this);
    this._findSmallerChildren = __bind(this._findSmallerChildren, this);
    this.child_ = __bind(this.child_, this);
    this.siftUp = __bind(this.siftUp, this);
    this.siftDown = __bind(this.siftDown, this);
    this.heapify = __bind(this.heapify, this);
    this.parent = __bind(this.parent, this);
    this.right = __bind(this.right, this);
    this.left = __bind(this.left, this);
    this.value = __bind(this.value, this);
  }
  Node.prototype.value = function(newVal) {
    if ((newVal != null) && this._valid()) {
      return this.array[this.index] = newVal;
    } else {
      return this.array[this.index];
    }
  };
  Node.prototype.left = function() {
    var _ref;
    return (_ref = this._left) != null ? _ref : this._left = this.child_(2 * this.index + 1);
  };
  Node.prototype.right = function() {
    var _ref;
    return (_ref = this._right) != null ? _ref : this._right = this.child_(2 * this.index + 2);
  };
  Node.prototype.parent = function() {
    var _ref;
    return (_ref = this._parent) != null ? _ref : this._parent = new Node(this.array, Math.floor(this.index / 2), this.comp);
  };
  Node.prototype.heapify = function() {
    if (this.left() != null) {
      this.left().heapify();
    }
    if (this.right() != null) {
      this.right().heapify();
    }
    return this.siftDown();
  };
  Node.prototype.siftDown = function() {
    var smallerChild;
    smallerChild = this._findSmallerChildren();
    if ((smallerChild != null) && this._comp(smallerChild, this)) {
      this._swap(smallerChild);
      return smallerChild.siftDown();
    }
  };
  Node.prototype.siftUp = function() {
    if (!this._isRoot()) {
      if (this._comp(this, this.parent())) {
        this._swap(this.parent());
        return this.parent().siftUp();
      }
    }
  };
  Node.prototype.child_ = function(childIndex) {
    if (childIndex < this.array.length) {
      return new Node(this.array, childIndex, this.comp);
    } else {
      return null;
    }
  };
  Node.prototype._findSmallerChildren = function() {
    if ((this.left() != null) && (this.right() != null)) {
      if (this._comp(this.left(), this.right())) {
        return this.left();
      } else {
        return this.right();
      }
    } else {
      if (this.left() != null) {
        return this.left();
      } else {
        return this.right();
      }
    }
  };
  Node.prototype._swap = function(that) {
    var tmp;
    tmp = this.value();
    this.value(that.value());
    return that.value(tmp);
  };
  Node.prototype._isRoot = function() {
    return this.index === 0;
  };
  Node.prototype._comp = function(na, nb) {
    return this.comp(na.value(), nb.value());
  };
  Node.prototype._valid = function() {
    return this.index < this.array.length;
  };
  return Node;
})();
queffee.Heap = (function() {
  function Heap(_array, comp) {
    this._array = _array != null ? _array : [];
    this.comp = comp != null ? comp : function(a, b) {
      return a > b;
    };
    this._init = __bind(this._init, this);
    this._last = __bind(this._last, this);
    this.reorder = __bind(this.reorder, this);
    this.insert = __bind(this.insert, this);
    this.extractTop = __bind(this.extractTop, this);
    this.top = __bind(this.top, this);
    this.size = __bind(this.size, this);
    this._init();
    this.reorder();
  }
  Heap.prototype.size = function() {
    return this._array.length;
  };
  Heap.prototype.top = function() {
    return this._root.value();
  };
  Heap.prototype.extractTop = function() {
    var newRootVal, retVal;
    retVal = this.top();
    newRootVal = this._array.pop();
    this._init();
    this._root.value(newRootVal);
    this._root.siftDown();
    return retVal;
  };
  Heap.prototype.insert = function(newItem) {
    this._array.push(newItem);
    return this._last().siftUp();
  };
  Heap.prototype.reorder = function() {
    return this._root.heapify();
  };
  Heap.prototype._last = function() {
    return new queffee.Node(this._array, this._array.length - 1, this.comp);
  };
  Heap.prototype._init = function() {
    return this._root = new queffee.Node(this._array, 0, this.comp);
  };
  return Heap;
})();
queffee.Job = (function() {
  function Job(_perform, _priority, _timeout) {
    this._perform = _perform;
    this._priority = _priority;
    this._timeout = _timeout;
    this._try = __bind(this._try, this);
    this._done = __bind(this._done, this);
    this.perform = __bind(this.perform, this);
    this.timeout = __bind(this.timeout, this);
    this.priority = __bind(this.priority, this);
  }
  Job.prototype.priority = function() {
    return this._try(this._priority);
  };
  Job.prototype.timeout = function() {
    return this._try(this._timeout);
  };
  Job.prototype.perform = function(callback) {
    this.running = true;
    this._onJobDone = callback;
    this._perform(this._done);
    if (this.timeout() != null) {
      return setTimeout(this._done, this.timeout());
    }
  };
  Job.prototype._done = function() {
    if (this.running) {
      this.running = false;
      return this._onJobDone();
    }
  };
  Job.prototype._try = function(func_or_val) {
    if (typeof func_or_val === 'function') {
      return typeof func_or_val === "function" ? func_or_val() : void 0;
    } else {
      return func_or_val;
    }
  };
  return Job;
})();
queffee.Q = (function() {
  Q._compareJob = function(jobA, jobB) {
    return jobA.priority() > jobB.priority();
  };
  function Q(jobs) {
    if (jobs == null) {
      jobs = [];
    }
    this._newJobsAdded = __bind(this._newJobsAdded, this);
    this._initHeap = __bind(this._initHeap, this);
    this._priorityBySequence = __bind(this._priorityBySequence, this);
    this.clear = __bind(this.clear, this);
    this.size = __bind(this.size, this);
    this.reorder = __bind(this.reorder, this);
    this.dequeue = __bind(this.dequeue, this);
    this.enQ = __bind(this.enQ, this);
    this.enqueue = __bind(this.enqueue, this);
    this.jobsAdded = __bind(this.jobsAdded, this);
    this.Q = __bind(this.Q, this);
    this._initHeap(jobs);
    this.newJobsAddedHandler = [];
  }
  Q.prototype.jobsAdded = function(handler) {
    return this.newJobsAddedHandler.push(handler);
  };
  Q.prototype.enqueue = function() {
    var job, jobs, _i, _len;
    jobs = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    for (_i = 0, _len = jobs.length; _i < _len; _i++) {
      job = jobs[_i];
      this._heap.insert(job);
    }
    return this._newJobsAdded();
  };
  Q.prototype.enQ = function(performFn, priority, timeout) {
    if (priority == null) {
      priority = this._priorityBySequence();
    }
    return this.enqueue(new queffee.Job(performFn, priority, timeout));
  };
  Q.prototype.dequeue = function() {
    return this._heap.extractTop();
  };
  Q.prototype.reorder = function() {
    return this._heap.reorder();
  };
  Q.prototype.size = function() {
    return this._heap.size();
  };
  Q.prototype.clear = function() {
    return this._initHeap([]);
  };
  Q.prototype._priorityBySequence = function() {
    return -1 - this.size();
  };
  Q.prototype._initHeap = function(jobs) {
    return this._heap = new queffee.Heap(jobs, queffee.Q._compareJob);
  };
  Q.prototype._newJobsAdded = function() {
    var handler, _i, _len, _ref, _results;
    _ref = this.newJobsAddedHandler;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      handler = _ref[_i];
      _results.push(handler());
    }
    return _results;
  };
  return Q;
})();
queffee.Worker = (function() {
  function Worker(q, onIdle, _stopped) {
    this.q = q;
    this.onIdle = onIdle;
    this._stopped = _stopped != null ? _stopped : false;
    this._pickupJob = __bind(this._pickupJob, this);
    this._kickOffJob = __bind(this._kickOffJob, this);
    this._onJobDone = __bind(this._onJobDone, this);
    this._work = __bind(this._work, this);
    this.retry = __bind(this.retry, this);
    this.idle = __bind(this.idle, this);
    this.stop = __bind(this.stop, this);
    this.start = __bind(this.start, this);
    this._job = null;
    this.q.jobsAdded(this._work);
  }
  Worker.prototype.start = function() {
    this._stopped = false;
    return this._work();
  };
  Worker.prototype.stop = function() {
    return this._stopped = true;
  };
  Worker.prototype.idle = function() {
    return !(this._job != null);
  };
  Worker.prototype.retry = function() {
    if (!this.idle()) {
      return this._kickOffJob();
    }
  };
  Worker.prototype._work = function() {
    if (this.idle() && !this._stopped) {
      this._pickupJob();
      if (this.idle()) {
        return typeof this.onIdle === "function" ? this.onIdle() : void 0;
      } else {
        return this._kickOffJob();
      }
    }
  };
  Worker.prototype._onJobDone = function() {
    this._job = null;
    return this._work();
  };
  Worker.prototype._kickOffJob = function() {
    return this._job.perform(this._onJobDone);
  };
  Worker.prototype._pickupJob = function() {
    return this._job = this.q.dequeue();
  };
  return Worker;
})();
queffee.CollectionWorkQ = (function() {
  function CollectionWorkQ(opts) {
    this._itemDone = __bind(this._itemDone, this);
    this._createJob = __bind(this._createJob, this);
    this._createJobs = __bind(this._createJobs, this);
    this.start = __bind(this.start, this);    this.collection = opts.collection, this.operation = opts.operation, this.onProgress = opts.onProgress, this.onFinish = opts.onFinish;
  }
  CollectionWorkQ.prototype.start = function() {
    var q;
    q = new queffee.Q(this._createJobs());
    return new queffee.Worker(q, this.onFinish).start();
  };
  CollectionWorkQ.prototype._createJobs = function() {
    var index, item, _len, _ref, _results;
    _ref = this.collection;
    _results = [];
    for (index = 0, _len = _ref.length; index < _len; index++) {
      item = _ref[index];
      _results.push(this._createJob(item, index));
    }
    return _results;
  };
  CollectionWorkQ.prototype._createJob = function(item, index) {
    var jobFn;
    jobFn = typeof this.operation === 'string' ? __bind(function(callback) {
      return item[this.operation](__bind(function() {
        return this._itemDone(index, callback);
      }, this));
    }, this) : __bind(function(callback) {
      return this.operation(item, __bind(function() {
        return this._itemDone(index, callback);
      }, this));
    }, this);
    return new queffee.Job(jobFn, -index);
  };
  CollectionWorkQ.prototype._itemDone = function(index, callback) {
    if (typeof this.onProgress === "function") {
      this.onProgress(index + 1);
    }
    return callback();
  };
  return CollectionWorkQ;
})();