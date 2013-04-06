exports = module.exports = (grunt) ->

  # Default settings
  defaults =
    

  # Project configuration.
  config = grunt.initConfig _.extend(defaults, config.grunt)

  # Use for generating documentation
  grunt.loadNpmTasks 'grunt-groc'

  # Use for continuous build
  grunt.loadNpmTasks 'grunt-karma'

  # Use for cleaning directory
  grunt.loadNpmTasks 'grunt-contrib-clean'

  # Modernizr builder - custom builds based on references in our code and styles.
  # $ grunt modernizr
  # https://github.com/doctyper/grunt-modernizr
  grunt.loadNpmTasks 'grunt-modernizr'

  # Default, just launches the server  
  grunt.registerTask 'default', ['server']

  # Shortcut to groc
  grunt.registerTask 'doc', ['groc']

  # Launch unit tests
  grunt.registerTask 'test', ['test:unit', 'test:e2e']
  grunt.registerTask 'test:unit', 'Runs all unit tests with PhantomJS', () ->
    grunt.task.run 'karma:unit'

  # Launch continuous unit tests
  grunt.registerTask 'cont', ['continuous:unit']
  grunt.registerTask 'cont:unit', ['continuous:unit']
  grunt.registerTask 'continuous', ['continuous:unit']
  grunt.registerTask 'continuous:unit', 'Runs all unit tests continuously with PhantomJS', () ->
    config.karma.unit.singleRun = false;
    config.karma.unit.autoWatch = true;
    grunt.task.run 'karma:unit'

  # Launch the server and continuous e2e tests
  grunt.registerTask 'cont:e2e', ['continuous:e2e']
  grunt.registerTask 'continuous:e2e', 'Runs all end to end tests continuously with Chrome', () ->
    config.karma.e2e.singleRun = false;
    config.karma.e2e.autoWatch = true;
    grunt.config.set 'http.async', false
    grunt.task.run 'server'
    grunt.task.run 'karma:e2e'

  # Launch the server and e2e tests
  grunt.registerTask 'test:e2e', 'Runs all end to end tests with Chrome', () ->
    grunt.config.set 'http.async', false
    grunt.task.run 'server'
    grunt.task.run 'karma:e2e'

  grunt.registerTask 'server', ['http']

  # Start up the web server
  grunt.registerTask 'http', 'Start a web server.', () ->
    context = require './server.coffee'
    context.config.spdy.enable = false
    server = context.start()

    useAsync = config.http?.async ? true
    if useAsync
      done = @async() if useAsync
      server.on('close', done)

  # Start up the spdy server
  grunt.registerTask 'spdy', 'Start a web server.', () ->
    context = require './server.coffee'
    context.config.spdy.enable = true
    server = context.start()

    useAsync = config.spdy?.async ? true
    if useAsync
      done = @async() if useAsync
      server.on('close', done)
