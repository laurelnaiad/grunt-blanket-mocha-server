##
# grunt-blanket-mocha-server
#
# Copyright (c) 2013 Stu Salsbury
# Licensed under the MIT license.
#

"use strict"
###*
 * @module
 * @param  {Object} grunt grunt process object
###
module.exports = (grunt) ->

  require('matchdep').filterDev('grunt-*').forEach grunt.loadNpmTasks

  grunt.loadTasks './tasks'

  grunt.initConfig {

    pkg: grunt.file.readJSON('package.json')

    ##
    # demo config
    #
    blanket_mocha_server:
      demo:
        options:
          port: 3001
          htmlFile: 'demo/test-runner.html'
          sutFiles: [ 'demo/src/**/*.js' ]
          testFiles: [ 'demo/test/**/*.spec.js' ]
          blanketOptions: {
            'data-cover-only': '//demo\/src\//'
          }

    blanket_mocha:
      demo:
        options:
          urls: [ 'http://localhost:3001/demo/test-runner.html' ]
          reporter: 'Nyan'
          threshold: 80


    ##
    # test config
    #
    mochaTest:
      test:
        options:
          reporter: 'nyan'
          require: [
            'coffee-script'
            './test/blanket.js'
          ]
        src: [ 'test/**/*.spec.coffee' ]
      'mocha-lcov':
          options:
            reporter: 'mocha-lcov-reporter'
            quiet: true
            captureFile: 'test/coverage.log'
          src: [ 'test/**/*.spec.coffee' ]
      'html-cov':
          options:
            reporter: 'html-cov'
            quiet: true
            captureFile: 'test/coverage.html'
          src: [ 'test/**/*.spec.coffee' ]
      'travis-cov':
        options:
          reporter: 'travis-cov'
        src: [ 'test/**/*.spec.coffee' ]

    ##
    # repository management config
    #
    readme_generator:
      readme:
        options:
          readme_folder: './docs/readme'
          output: 'README.md'
          table_of_contents: true
          toc_extra_links: []
          banner: 'banner.md'
          generate_footer: true
          generate_title: false
          h1: '#'
          h2: '##'
          informative: false
        order:
          'introduction.md': 'Introduction'
          'getting-started.md': 'Getting Started'
          'overview.md': 'Overview'
          'options.md': 'Options'
          '../../CONTRIBUTING.md': 'Contributing'
          'faq.md': 'FAQ'
          'release-history.md': 'Release History'
          'license.md': 'License'

    changelog: {}

    watch: {}
  }

  # send coverage info to coveralls
  grunt.registerTask 'cov-to-coveralls',
      'Run node-coveralls with an lcov file',
      () ->

        lcovLogPath = 'test/coverage.log'
        coverallsPath = './node_modules/coveralls/bin/coveralls.js'

        coveralls = require('child_process').spawn coverallsPath,
            [],
            stdio: ['pipe', process.stdout, process.stderr]
        done = @async()
        coveralls.on 'exit', (code) ->
          done(code == 0)
        coveralls.stdin.end require('fs').readFileSync(lcovLogPath , 'utf8')

  # generate documentation
  grunt.registerTask 'docs', ['readme_generator']

  # basic demonstration
  grunt.registerTask 'demo', ['blanket_mocha_server:demo', 'blanket_mocha:demo']

  # for testing on workstation(s)
  grunt.registerTask 'test', [
    'mochaTest:test'
    'mochaTest:html-cov'
    'mochaTest:travis-cov'
  ]

  # to be run on travis -- lcov instead of html, report to coveralls
  grunt.registerTask 'test-travis', [
    'mochaTest:test'
    'mochaTest:mocha-lcov'
    'mochaTest:travis-cov'
    'cov-to-coveralls'
  ]
