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
