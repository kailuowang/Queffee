# queffee

*A [CoffeeScript](http://jashkenas.github.com/coffee-script/ "CoffeeScript") dynamic priority work queue library.*

## To use
No other dependencies at all, simply:

[queffee.js](https://raw.github.com/kailuowang/Queffee/master/release/queffee.js)
or 
[queffee.min.js](https://github.com/kailuowang/Queffee/raw/master/release/queffee.min.js) (7.4k)


## Usage
Suppose you have two asyn functions: doSomething and doSomethingHigher, both take in callback function that they will call once they are done.

    q = new queffee.Q
    q.enQ (callback) -> doSomething (onSuccess: callback), 1  #add a job that has a fixed priority 1
    q.enQ (callback) -> doSomethingHigher(onSuccess: callback), () -> 2 #add a job that has priority function (for now it returns 2)
    q.enQ (callback) -> doSomethingThatMightTimeout(onSuccess: callback), 0, 2000) #timeout the job in 2 secs

    new queffee.Worker(q).start() #you can have multiple workers.
    
    q.reorder()   #you can call this to reorder the jobs based on their priority functions
    
    #you can also create an array of queffee.Job (constructor using the same signature as enQ) and create the q using the array
    job1 = new queffee.Job( (callback) -> doSomething1(callback), priority: 1)
    job2 = new queffee.Job( (callback) -> doSomething2(callback), priority: 0, timeout: 2000)
    q = new queffee.Q([job1, job2])
    
    #or
    q.enqueue(job1)
    q.enqueue(job2)

You can also create enQ work or create job using a synchronized parameterless function, queffee will run it asynchronously.
    
    doSomething = ->
      #...do something here
    q.enQ(doSomething)
    new queffee.Job( doSomething, priority: 0, timeout: 2000)

You can also create enQ work or create job using a parameterless function that returns a promise, queffee will run it and wait for promise to resolve.



The doSomethingHigher will be performed first, and then doSomething. Notice that the second parameter of enQ is the priority, it can be a function or a value.
If your works priority is dynamic using the priority function, you can call q.reorder() to re-prioritize you queue whenever you deem appropriate.

Another tool is collectionWorkQ which helps you run asynchronized operations on each items of a collection in a sequence ( meanning it only run one asynchronized operation at a time,
won't start the next one until the first one called the success callback)
example:

    new queffee.CollectionWorkQ(
      collection: [item1, item2]
      operation: 'someOperation'
      onProgress: -> count++
      onFinish: -> alert('finished')
    ).start()

or

    new queffee.CollectionWorkQ(
      collection: [item1, item2]
      operation: (item, callback) -> item.someOperation(callback)
      onProgress: -> count++
      onFinish: -> alert('finished')
    ).start()

###[For more examples, click here.](http://kailuowang.blogspot.com/2011/09/queffeejs-dynamic-priority-worker-queue.html)


## To do TDD

### Requirements
Based on the change to module management in [`npm` v1.0+](http://blog.nodejs.org/2011/03/23/npm-1-0-global-vs-local-installation/ "npm 1.0: Global vs Local installation &laquo; node blog"), the following modules are now local to this project:

* [coffee-script](https://github.com/jashkenas/coffee-script)
* [uglify-js](https://github.com/mishoo/UglifyJS)
* [growl](https://github.com/visionmedia/node-growl), which requires [growlnotify](http://growl.info/extras.php#growlnotify "Growl - Extras") to be available on your `PATH`

You shouldn't have to install them with `npm`.  If you're not running OS X, or don't have Growl available, you obviously won't see any pretty notifications.  But it should be trivial to replace that function with your OS specific variant if you'd like to.


From project root:

    cake watch:development

    and open SpecRunner.html in browser

## To build js and min js

    cake build

## Acknowledgment
* used skeleton project [InstantJasmineCoffee](https://github.com/krismolendyke/InstantJasmineCoffee "InstantJasmineCoffee")

## License

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
