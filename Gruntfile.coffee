exports = module.exports = (grunt) ->

  grunt.initConfig
    mochacli:
      options:
        reporter: 'spec'
        compilers: ['coffee:coffee-script']
        'ignore-leaks': true
      all: ['test/unit/*.spec.coffee']

  grunt.loadNpmTasks 'grunt-mocha-cli'
  grunt.registerTask 'test', ['mochacli']