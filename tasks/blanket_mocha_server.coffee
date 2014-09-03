##
# grunt-blanket-mocha-server
#
# Copyright (c) 2013 Stu Salsbury
# Licensed under the MIT license.
#

###* @module ###
module.exports = (grunt) ->

  path = require('path')
  fs = require('fs')
  _ = grunt.util._

  ###*
   * Fail with message if array is not of minimum length or any file
   * does not exist.  obj[prop] may be a single file path or an array of them.
   * @param  {string} grunt   The grunt process object
   * @param  {string} prop    Name of the property being tested
   * @param  {number} min     Minimum acceptable extant files
   * @return {undefined}
  ###
  minViolationTest = (obj, prop, min) ->
    if _.isUndefined(min) then min = 0

    if obj[prop]

      files = if _.isArray(obj[prop]) then obj[prop] else [obj[prop]]

      if files.length < min
        grunt.fatal "Configuration property \"#{prop}\" did not match the " +
            "minimum of #{min} files (it matched #{files.length})."

      _.each files, (file) ->
        if !fs.existsSync(file)
          grunt.fatal "File not found: \"#{file}\""
    else
      if min > 0
        grunt.fatal "Configuration property \"#{prop}\" needs to specify at " +
            "least one file."

    undefined

  ###*
   * Return a normalized path with the process directory stripped.
   * Result is suitable for a src reference that is absolute to the root
   * of the webserver.
   * @param  {object} obj   The config object
   * @param  {[type]} prop  The property to modify
   * @return {undefined}
  ###
  resolveFile = (obj, prop) ->
    obj[prop] = path.resolve obj[prop]
    minViolationTest obj, prop

    preNodeModulesMatch = obj[prop].match /^(.*\/)node_modules\/.*$/
    if preNodeModulesMatch
      obj[prop] = obj[prop].replace preNodeModulesMatch[1], ''
    else
      inAppPath = process.cwd() + path.sep + 'node_modules' + path.sep + 'grunt-blanket-mocha-server'
      if !(fs.existsSync(inAppPath))
        obj[prop] = obj[prop].replace(
          path.resolve(__dirname + '/..'),
          ''
        )
      else
        # console.log obj[prop].red
        # console.log path.resolve(__dirname + '/../..').green
        # console.log path.resolve(__dirname + '\\..\\..').green
        obj[prop] = obj[prop].replace(
          path.resolve(__dirname + '/../..'),
#          path.resolve(__dirname + '/..'),
          '/node_modules'
#          '/node_modules/grunt-blanket-mocha-server'
        )
        # console.log obj[prop].yellow
    obj[prop] = obj[prop].replace /[\\]/g, '/'
    undefined

  ###*
   * Applies grunt.file.expand to the property of the object and optionally can
   * ensures that a minimum number of files matches.
   * @param  {Object} grunt The Grunt object
   * @param  {Object} obj   The object with the property on which to operate
   * @param  {string} prop  The name of the property to expand
   * @param  {number} [min] If specified, the minimum number of matching files
   *                        that is considered valid for configuration.
   * @return {undefined}
  ###
  expandFiles = (obj, prop, min) ->
    cwd = process.cwd() # seek files relative to the grunt process

    if obj[prop]
      obj[prop] = grunt.file.expand { cwd: cwd },
          if _.isArray(obj[prop]) then obj[prop] else [obj[prop]]

    minViolationTest obj, prop, min

    if obj[prop]
      # passed the tests -- no clean up the dir base
      _.each obj[prop], (val, index) ->
        obj[prop][index] = path.resolve(val)
            .replace(path.resolve(process.cwd()) + '/', '')
            .replace(/[\\]/g, '/')

    undefined

  # ###*
  #  * Wraps each specified path in an html script tag specifying type
  #  * text/javascript and charset utf-8.
  #  * @param  {Array.<string>} patterns of paths to wrap
  #  * @param  {number}         minimum number of scripts that should match pattern
  #  * @return {undefined}         html script tags for each script file in patterns
  # ###
  # wrapScriptTags = (obj, prop, min) ->
  #   paths = expandFiles obj, prop, process.cwd(), min

  #   if paths && paths.length
  #     joinedPaths = paths.join(
  #       '" type="text/javascript" charset="utf-8"></script>\n' +
  #       '<script src="/'
  #     )
  #     obj[prop] = "<script src=\"#{joinedPaths}\" type=\"text/javascript\" " +
  #         "charset=\"utf-8\"></script>\n"
  #   else
  #     obj[prop] = ''
  #   undefined

  ###*
   * Produce html attributes for key value pairs
   * @param  {Object} attributes Key value pairs
   * @return {string} space-separated html attributes
  ###
  produceAttributes = (attributes) ->
    _.reduce(
      attributes,
      (result, attributeVal, attributeKey) ->
        result += " #{attributeKey}=\"#{attributeVal}\" "
      , ''
    )

  ###*
   * Produce html attributes for key value pairs
   * @param  {Object} blanketOptions Key value pairs representing runtime options
   *                                 to set on blanket
   * @return {string} script statements to assign options, e.g.
   *                         'blanket.options('myKey', 'myVal');'
  ###
  producePhantomOptions = (blanketOptions) ->
    _.reduce(
      blanketOptions,
      (result, optionVal, optionKey) ->
        result += "blanket.options('#{optionKey}', '#{optionVal}');\n"
      , '\n'
    )




  grunt.registerMultiTask 'blanket_mocha_server',
    'Serve runtime-configured browser-based mocha tests with ' +
        'blanket.js coverage.',
    () ->
      myDirName = __dirname.replace /[\\]/g, '/'

      gbmsLib = myDirName + '/../lib/'
      gbmsSupport = myDirName + '/support/'


      gbmPath = '/node_modules/grunt-blanket-mocha/support'
      if fs.existsSync(myDirName + '/..' + gbmPath)
        gbmSupport = myDirName + '/..' + gbmPath + '/'
      else
        gbmSupport = process.cwd() + gbmPath + '/'

      defaultOptions =
        server:                 true
        htmlFile:               null
        sutFiles:               null
        testFiles:              null
        blanketOptions:         null
        blanketPhantomOptions:  null
        noCoverage:             false
        mochaPath:              gbmsLib + 'mocha.js'
        mochaCssPath:           gbmsLib + 'mocha.css'
        mochaSetupScript:       'mocha.setup(\'bdd\');'
        blanketPath:            gbmsLib + 'blanket.js'
        gruntReporterPath:      gbmSupport + 'grunt-reporter.js'
        mochaBlanketPath:       gbmSupport + 'mocha-blanket.js'
        assertionLibs:          gbmsLib + 'chai.js'
        assertionsSetupScript:
            'window.expect = chai.expect; var should = chai.should();'
        runnerTemplate:         gbmsSupport + 'test-runner-template.html'

      options = _.merge defaultOptions, @options()

      config = options

      resolveFile config, 'mochaPath', 1
      resolveFile config, 'mochaCssPath', 0
      resolveFile config, 'blanketPath', 0
      resolveFile config, 'gruntReporterPath', 0
      resolveFile config, 'mochaBlanketPath', 0

      expandFiles config, 'assertionLibs', 1

      expandFiles config, 'sutFiles'
      expandFiles config, 'testFiles'

      config.runnerTemplate = path.resolve config.runnerTemplate
      if !fs.existsSync(config.runnerTemplate)
        grunt.fatal "Specified runnerTemplate (#{config.runnerTempalate} " +
            ") not found."

      config.assertionsSetupScript

      config.blanketOptions = produceAttributes config.blanketOptions

      config.blanketPhantomOptions =
              producePhantomOptions config.blanketPhantomOptions

      runnerTarget = path.resolve config.htmlFile
      runnerTargetDir = path.dirname(runnerTarget) # runnerTarget.replace /\/[^\/]*$/, '/'
      if !fs.existsSync(runnerTargetDir)
        grunt.log.writeln 'making runner directory: ' + runnerTargetDir
        fs.mkdirSync runnerTargetDir

      grunt.log.writeln 'writing runner: ' + runnerTarget
      fs.writeFileSync(
        runnerTarget,
        grunt.template.process(
          fs.readFileSync(config.runnerTemplate, 'utf8'),
          { data: config }
        )
      )

      if options.server
        cwd = process.cwd()
        process.chdir __dirname + '/..'
        grunt.loadNpmTasks 'grunt-contrib-connect'
        process.chdir cwd

        grunt.config 'connect', {blanket_mocha_server_connect: {options: options}}

        grunt.task.run 'connect:blanket_mocha_server_connect'
