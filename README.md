# quefee

*A [CoffeeScript](http://jashkenas.github.com/coffee-script/ "CoffeeScript") dynamic priority work queue library.*

## Requirements
Based on the change to module management in [`npm` v1.0+](http://blog.nodejs.org/2011/03/23/npm-1-0-global-vs-local-installation/ "npm 1.0: Global vs Local installation &laquo; node blog"), the following modules are now local to this project:

* [coffee-script](https://github.com/jashkenas/coffee-script)
* [uglify-js](https://github.com/mishoo/UglifyJS)
* [growl](https://github.com/visionmedia/node-growl), which requires [growlnotify](http://growl.info/extras.php#growlnotify "Growl - Extras") to be available on your `PATH`

You shouldn't have to install them with `npm`.  If you're not running OS X, or don't have Growl available, you obviously won't see any pretty notifications.  But it should be trivial to replace that function with your OS specific variant if you'd like to.

## To do TDD

From project root:

    cake watch:development

    and open SpecRunner.html in browser

## To build min js

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
