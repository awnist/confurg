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

  grunt.loadNpmTasks 'grunt-mocha-cli'
  grunt.loadNpmTasks 'grunt-contrib-clean'

  grunt.registerTask 'test', ['mochacli']

  # Generate documentation
  grunt.registerTask 'doc', 'Generate documentation', ->
    done = @async()

    child = grunt.util.spawn {
      cmd: './node_modules/.bin/docco'
      grunt: false
      args: ['README.md', './src/confurg.coffee']
    }, (error, result, code) ->
      grunt.log.ok 'Generated documentation at ./docs/'
      done()

    child.stdout.pipe process.stdout
    child.stderr.pipe process.stderr

  grunt.registerTask 'docs', ['doc']
