# quefee

*A [CoffeeScript](http://jashkenas.github.com/coffee-script/ "CoffeeScript") dynamic priority work queue library. (created from skeleton project [InstantJasmineCoffee](https://github.com/krismolendyke/InstantJasmineCoffee "InstantJasmineCoffee")*

## Requirements
Based on the change to module management in [`npm` v1.0+](http://blog.nodejs.org/2011/03/23/npm-1-0-global-vs-local-installation/ "npm 1.0: Global vs Local installation &laquo; node blog"), the following modules are now local to this project:

* [coffee-script](https://github.com/jashkenas/coffee-script)
* [uglify-js](https://github.com/mishoo/UglifyJS)
* [growl](https://github.com/visionmedia/node-growl), which requires [growlnotify](http://growl.info/extras.php#growlnotify "Growl - Extras") to be available on your `PATH`

You shouldn't have to install them with `npm`.  If you're not running OS X, or don't have Growl available, you obviously won't see any pretty notifications.  But it should be trivial to replace that function with your OS specific variant if you'd like to.

## Usage

From project root:

    cake watch:all

