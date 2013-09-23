# grunt-blanket-mocha-server
[![Build Status](https://secure.travis-ci.org/stu-salsbury/grunt-blanket-mocha-server.png?branch=master)](http://travis-ci.org/stu-salsbury/grunt-blanket-mocha-server)
[![Coverage Status](https://coveralls.io/repos/stu-salsbury/grunt-blanket-mocha-server/badge.png)](https://coveralls.io/r/stu-salsbury/grunt-blanket-mocha-server)
[![Dependency Status](https://gemnasium.com/stu-salsbury/grunt-blanket-mocha-server.png)](https://gemnasium.com/stu-salsbury/grunt-blanket-mocha-server)

> Easily serve mocha tests with (or without) blanket coverage. "Goes Great" with grunt-blanket-mocha

## Jump to Section

* [Introduction](#introduction)
* [Getting Started](#getting-started)
* [Overview](#overview)
* [Options](#options)
* [Contributing](#contributing)
* [FAQ](#faq)
* [Release History](#release-history)
* [License](#license)

## Introduction
[[Back To Top]](#jump-to-section)

`grunt-blanket-mocha-server` is a lightweight helper task to easily
configure a server for use with <a
href="https://github.com/ModelN/grunt-blanket-mocha" target="_blank">grunt-blanket-mocha</a>.

It helps automate the use of the three great tools:

* <a href="http://gruntjs.com" target="_blank" title="Grunt Website">Grunt</a>
* <a href="http://blanketjs.org/" target="_blank" title="BlanketJS Website">Blanket</a>
* <a href="http://visionmedia.github.io/mocha/" target="_blank" title="Mocha Website">Mocha</a>

**It is not distributed, maintained nor recommended by the
authors of any of these tools.**

<div style="clear: both"></div>

Absent this task, when you want to run your grunt-blanket-mocha
task(s), you need to author a test runner file and run a server
*(blanket cannot be run on local files without browser tweaks)*.  The
**purpose** of this task is to:

* provide a test runner template;
* to allow task-based configuration of the aspects of that runner that
matter when you're testing; and
* to serve the test runner files on the port of your choice.

This can be useful if you don't feel like bothering to author
this file, you're not sure *how* to author the file, or you need to
  configure your test runner on-the-fly during your
grunt process.  Most of what this task does can be overridden in your
Gruntfile.

__If you are not already using grunt-blanket-mocha__, consider this a
recommendation to <a
href="https://github.com/ModelN /grunt-blanket-mocha"
target="_blank">take a look now</a>.  It is assumed you know
why you would use it and that you will refer to its documentation to
understand how to use it.

It is also possible to use this task *without* `grunt-blanket-mocha`
-- to run your tests in a browser, for example.


## Getting Started
[[Back To Top]](#jump-to-section)

This plugin requires Grunt ~0.4.0.

If you haven't used <a href="http://gruntjs.com" target="_blank">Grunt</a> before, be sure to check out the <a href="http://gruntjs.com/getting-started"
target="_blank">Getting
Started</a> guide, as it explains how to create a <a href="http://gruntjs.com/sample-gruntfile"
target="_blank">Gruntfile</a> as well as
install and use Grunt plugins. Once you're familiar with that process,
you may install this plugin with this command:

```
npm install grunt-blanket-mocha-server --save-dev
```

Once the plugin has been installed, it may be enabled inside your Gruntfile with this line of JavaScript:

```
grunt.loadNpmTasks('grunt-blanket-mocha-server');
```


## Overview
[[Back To Top]](#jump-to-section)

Below you will find the standard Grunt plugin documentation for the task.  For
the impatient, this is a typical configuration (using primarily defaults for configurable
options):

```
blanket_mocha_server: {
  demo: {
    options: {
      port: 3001,
      testConfig: {
        htmlFile: 'demo/test-runner.html',
        // system-under-test will be all js files below demo/src
        sutFiles: [ 'demo/src/**/*.js' ],
        // test files are *.spec.js files found under demo/test
        testFiles: [ 'demo/test/**/*.spec.js' ]
        blanketOptions: {
          // only demo/src files will be coverage-tested
          'data-cover-only': '//demo\/src\//'
        }
      }
    }
  }
},
// basic blanket_mocha configuration -- note that the path
// corresponds to the one specified for the server to serve
blanket_mocha: {
  demo: {
    options: {
      urls: [ 'http://localhost:3001/demo/test-runner.html' ],
      reporter: 'Nyan',
      threshold: 80
    }
  }
}
```


## Options
[[Back To Top]](#jump-to-section)

options here


## Contributing
[[Back To Top]](#jump-to-section)

Contributions, as feedback in the [issues list](issues) or as pull requests, are encouraged.

For pull requests:

* In lieu of a formal styleguide, take care to maintain the existing
coding style. Add unit tests for any new or changed functionality.
* Yes, please use CoffeeScript.
* Yes, please ensure that all code is **covered** by tests! It's a very simple grunt task, people -- setting
up the test framework was more work than authoring the task -- coverage
is a walk in the park. :)  Just run `grunt test` -- unit tests are reported to the console, and if they succeed,
then coverage stats are also reported in the console and the html report is made available at `'./test/coverage.html'`.


## FAQ
[[Back To Top]](#jump-to-section)

No questions have been asked, yet! :)


## Release History
[[Back To Top]](#jump-to-section)

See the [changelog](CHANGELOG.md).


## License
[[Back To Top]](#jump-to-section)

(The MIT License)

Copyright (c) 2013 Stu Salsbury

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the 'Software'), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.




--------
<small>_This readme has been automatically generated by [readme generator](https://github.com/aponxi/grunt-readme-generator) on Mon Sep 23 2013 12:49:25 GMT-0700 (PDT)._</small>