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
* <a href="http://mochajs.org/" target="_blank" title="Mocha Website">Mocha</a>

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

The `blanket-mocha-server` task is primarily a shortcut to creating
and a means for programmatically controlling a test runner html file.  *By default,
it also serves the test runner using `grunt-contrib-connect`, but you can disable this.*

It works by allowing you to specify paths and options that are inserted using
Grunt's JST template system into a test runner template.

A typical basic configuration follows.  More information can be found in the
[Options](#options) section.

```javascript
blanket_mocha_server: {
  demo: {
    options: {
      port: 3001,
      htmlFile: 'demo/test-runner.html',  // the file to create (and serve as the test runner)
      sutFiles: [ 'demo/src/**/*.js' ], // system-under-test will be all js files below demo/src
      testFiles: [ 'demo/test/**/*.spec.js' ], // test files are *.spec.js files found under demo/test
      blanketOptions: {
        'data-cover-only': '//demo\/src\//' // only demo/src files will be evaluated for coverage
      }
    }
  }
},

blanket_mocha: { // basic config for the grunt-blanket-mocha task
  demo: {
    options: {
      urls: [ 'http://localhost:3001/demo/test-runner.html' ], // the file created by blanket_mocha_server
      reporter: 'Nyan',
      threshold: 80
    }
  }
}
```


## Options
[[Back To Top]](#jump-to-section)

### In General

*Don't let the number of options intimidate you.*  Almost all of them
have sane defaults and need not be modified.

If you don't specify `server: false`, then this task will run a grunt-
contrib-connect server after generating the test runner.  Any options
that you specify which apply to grunt-contrib-connect will be passed
through to that task -- so, for example, you can (and might want to)
set the `port` to something other than the default (3000).

<a id="optionsIndex">**Index**</a>:

* [Note on Default Paths](####Note-On-Default-Paths)
* [assertionLibs](#assertionLibs)
* [assertionsSetupScript](#assertionsSetupScript)
* [blanketOptions](#blanketOptions)
* [blanketPath](#blanketPath)
* [blanketPhantomOptions](#blanketPhantomOptions)
* [gruntReporterPath](#gruntReporterPath)
* [htmlFile](#htmlFile)

---

#### Note On Default Paths

Many of the default values for options are relative to three directories:

* **gbmsLib**: `__dirname + '/../lib/'`.  The lib directory of this package.
* **gbmsSupport**: `__dirname + '/support/'`. The support tasks/support directory of this package.
* **gbmSupport**:  `process.cwd() + '/node_modules/grunt-blanket-mocha/support/'`. The `grunt-blanket-mocha` support directory. It is assumed that `grunt-blanket-mocha` is installed as a peer of this task.

In general, you can use the defaults and the files they specify.  If you specify your own paths, they will be interpreted as relative to the directory from which you run grunt (i.e. `process.cwd()`).

Aside from assertion libraries, the primary reason that you might
override default paths is to bring your own copy of blanket, mocha or
grunt-blanket-mocha files -- if you want to use a version that is not
bundled with this plugin, for example.  As of this release, the mocha, blanket and chai libraries
are included as js files in this plugin distribution.  Feedback is welcome as to whether to npm-depend
on their packages or use bower so that they are more likely to stay up-to-date.  Including the libraries directly was
chosen because it dramatically reduces the resulting footprint of using the plugin. You can always use
bower or npm dependencies and manually assign the paths.

[Return to Index](#optionsIndex)

#### <a id="assertionLibs">options.assertionLibs</a>

Type: `{(string|Array.<string>)}` Default value: `gbmsLib + 'chai.js'`

The path to one or more assertion libraries.  As it is the most popular choice with mocha, chai is included as the only default.

If you are testing in IE8, you may wish to override this default and specify <a href="https://github.com/LearnBoost/expect.js" target="_blank">expect.js</a> as the assertion library because chai is not compatible with IE8.

[Return to Index](#optionsIndex)

#### <a id="assertionsSetupScript">options.assertionsSetupScript</a>

Type: `{string}` Default value: `'window.expect = chai.expect; var should = chai.should();'`

Script to configure an assertion library (or libraries).  The default script makes chai's expect function globally available and installs chai's should decorator to Object (see chai should documentation).

[Return to Index](#optionsIndex)

#### <a id="blanketOptions">options.blanketOptions</a>

Type: `{?Object.<string, string>}` Default value: `null`

Name value pairs to be assigned to blanket as options.  **You will probably at a minimum
want to set data-cover-only to inform blanket of which files should be covered.
Make sure to escape your backslashes!**

If you set:

```js
blanketOptions: {
  'data-cover-only': '//build\\/.*/',
  'data-cover-modulepattern': 'build\\/(.*)\\/[^\\/]+$'
}
```
  Then in the test runner you will have:

```html
<script type="text/javascript" charset="utf-8"
  src="<%= gbmsLib + 'blanket.js' %>"
  data-cover-only: "//build\/.*/"
  data-cover-modulepattern="build\/(.*)\/[^\/]+$"
</script>
```

[Return to Index](#optionsIndex)

#### <a id="blanketPath">options.blanketPath</a>

Type: `{string}` Default value: `gbmsLib + 'blanket.js'`

The path to blanket.js.

[Return to Index](#optionsIndex)

#### <a id="blanketPhantomOptions">options.blanketPhantomOptions</a>

Type: `{?Object.<string, string>}` Default value: `null`

Name value pairs to be assigned to blanket as options **only when running tests from grunt** (which
uses PhantomJS).  The options specified here will have no impact on tests that run in your browser.

Note that the `reporter` option is set for you by default in a separate configuration property --
[gruntReporterPath](#gruntReporterPath).

If you set:

```js
blanketPhantomOptions: {
  'dataCoverFlags': 'branchTracking'
}
```
  Then in the test runner you will have:

```html
<script type="text/javascript" charset="utf-8">
  if (window.PHANTOMJS) {
    blanket.options( // reporter is set set by default
      "reporter",
      "<%= gbmSupport + 'grunt-reporter.js' %>"
    );
    blanket.options(
      "dataCoverFlags",
      "branchTracking"
    );
  }
</script>
```

[Return to Index](#optionsIndex)

#### <a id="gruntReporterPath">options.gruntReporterPath</a>

Type: `{string}` Default value: `<%= gbmSupport + 'grunt-reporter.js' %>`

The path to grunt-blanket-mocha's grunt reporter.

[Return to Index](#optionsIndex)

#### <a id="htmlFile">options.htmlFile</a>

Type: `{string}` Default value: `null`

The path where the HTML file that this task generates will be saved.  You must specify this option.
The combination of this path and the port on which you serve the test runner should match the
grunt-blanket-mocha configuration if you are using grunt-blanket-mocha.

Example:
```js
  htmlFile: 'test/test-runner.html'
```

[Return to Index](#optionsIndex)

        mochaBlanketPath:       gbmSupport + 'mocha-blanket.js'
        mochaCssPath:           gbmsLib + 'mocha.css'
        mochaPath:              gbmsLib + 'mocha.js'
        mochaSetupScript:       'mocha.setup(\'bdd\');'
        noCoverage:             false
        runnerTemplate:         gbmsSupport + 'test-runner-template.html'
        server:                 true
        sutFiles:               null
        testFiles:              null


## Contributing
[[Back To Top]](#jump-to-section)

Contributions, as feedback in the [issues list](issues) or as pull requests, are encouraged.

For pull requests:

* In lieu of a formal styleguide, take care to maintain the existing
coding style. ~~Add unit tests for any new or changed functionality.~~
* Yes, please use CoffeeScript.
~~* Yes, please ensure that all code is **covered** by tests! It's a very simple grunt task, people -- setting
up the test framework was more work than authoring the task -- coverage
is a walk in the park. :)  Just run `grunt test` -- unit tests are reported to the console, and if they succeed,
then coverage stats are also reported in the console and the html report is made available at `'./test/coverage.html'`.~~
* As of now, youi're off the hook on unit tests until a (real) testing suite is in place! :)


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
<small>_This readme has been automatically generated by [readme generator](https://github.com/aponxi/grunt-readme-generator) on Tue Oct 01 2013 09:45:50 GMT-0700 (PDT)._</small>
