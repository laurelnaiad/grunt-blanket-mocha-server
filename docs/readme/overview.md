Below you will find the standard Grunt plugin documentation for the task.  For
the impatient, this is a typical configuration (using primarily defaults for configurable
options):

```
blanket_mocha_server: {
  demo: {
    options: {
      port: 3001,
      htmlFile: 'demo/test-runner.html',
      // system-under-test will be all js files below demo/src
      sutFiles: [ 'demo/src/**/*.js' ],
      // test files are *.spec.js files found under demo/test
      testFiles: [ 'demo/test/**/*.spec.js' ],
      blanketOptions: {
        // only demo/src files will be coverage-tested
        'data-cover-only': '//demo\/src\//'
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
