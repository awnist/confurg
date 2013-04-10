path = require 'path'

exports = module.exports = (grunt) ->

  grunt.initConfig
    mochacli:
      options:
        reporter: 'spec'
        compilers: ['coffee:coffee-script']
        'ignore-leaks': true
      all: ['test/unit/*.spec.coffee']
    clean:
      src: ['docs']
    docs:
      all:
        src: ['README.md', './src/confurg.coffee']

  grunt.loadNpmTasks 'grunt-mocha-cli'
  grunt.loadNpmTasks 'grunt-contrib-clean'

  grunt.registerTask 'test', ['mochacli']

  # Generate documentation
  grunt.registerMultiTask 'docs', 'Generate documentation', ->
    done = @async()

    child = grunt.util.spawn {
      cmd: './node_modules/.bin/docco'
      grunt: false
      args: @filesSrc
    }, (error, result, code) ->
      grunt.log.ok 'Generated documentation at ./docs/'
      done()

    child.stdout.pipe process.stdout
    child.stderr.pipe process.stderr

  grunt.registerTask 'doc', ['docs']
