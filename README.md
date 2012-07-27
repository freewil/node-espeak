# node-espeak


[![Build Status](https://secure.travis-ci.org/freewil/node-espeak.png)](http://travis-ci.org/freewil/node-espeak)

This simply uses the [eSpeak](http://espeak.sourceforge.net/) cli program to 
generate wav audio data from text strings. You can then use the raw binary data 
to output to a file, send as a http download, get as a base64-encoded data URI 
string, or whatever else.

## Install

```
$ npm install espeak
```

## Usage

```js
var espeak = require('espeak');

// optionally set the path to the `espeak` cli program if it's not in your PATH
//espeak.cmd = '/usr/bin/espeak';

espeak.speak('hello world', function(err, wav) {
  if (err) return console.error(err);
  
  // get the raw binary wav data
  var buffer = wav.buffer;
  
  // get a base64-encoded data URI
  var dataUri = wav.toDataUri();
});

// optionally add custom cli arguments for things such as pitch, speed, wordgap, etc.
espeak.speak('hello world, slower', ['-p 60', '-s 90', '-g 30'], function(err, wav) {});

```

## Related Modules
There are some related modules, although there seems to be some scattered
forks and it wasn't clear to the author which was updated and/or compatible with
Node.js/npm at the time of writing this.

* speak.js
  * [kripken / speak.js](https://github.com/kripken/speak.js) 
  * [christopherdebeer / speak.js](https://github.com/christopherdebeer/speak.js)
  * [katsuyan / speak.js](https://github.com/katsuyan/speak.js)
