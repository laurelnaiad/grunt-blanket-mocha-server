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
