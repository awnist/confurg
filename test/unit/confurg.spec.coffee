expect = require('chai').expect
path = require 'path'
sinon = require 'sinon'

homeCson = path.resolve path.join __dirname, '../shared/cson/home'
homeJson = path.resolve path.join __dirname, '../shared/json/home'

projectCson = path.resolve path.join __dirname, '../shared/cson/project'
projectJson = path.resolve path.join __dirname, '../shared/json/project'

envCson = path.resolve path.join __dirname, '../shared/cson/env'
envJson = path.resolve path.join __dirname, '../shared/json/env'

home = process.env.HOME
mfn = module.filename
envConfurgType = process.env['confurg_envtype']
envConfurgEnv = process.env['confurg_env']

confurgFile = path.resolve path.join __dirname, '../../src/confurg.coffee'

describe 'confurg', ->
  describe 'namespace', ->
    it 'should fail when no namespace is supplied', ->
      fn = () ->
        require(confurgFile).init()

      expect(fn).to.throw()

    it 'should not fail when a namespace is supplied', ->
      fn = () ->
        require(confurgFile).init 'confurg'

      expect(fn).to.not.throw()

  dataTypes =
    cson:
      homePath: homeCson
      projectPath: projectCson
      envPath: envCson
    json:
      homePath: homeJson
      projectPath: projectJson
      envPath: envJson

  for own type, options of dataTypes
    do (type, options) ->
      describe type, ->
        describe 'home', ->
          beforeEach ->
            process.env.HOME = options.homePath
            module.filename = path.join options.projectPath, path.basename mfn
            process.env['confurg_envtype'] = type
            process.env['confurg_env'] = 'default'

          afterEach ->
            process.env.HOME = home
            module.filename = mfn
            process.env['confurg_envtype'] = envConfurgType
            process.env['confurg_env'] = envConfurgEnv

          it 'should load the config files', ->
            config = require(confurgFile).init 'confurg'

            expect(config.hometype).to.equal type
            expect(config.home).to.equal 'default'
            expect(config.projecttype).to.equal type
            expect(config.project).to.equal 'default'
            expect(config.envtype).to.equal type
            expect(config.env).to.equal 'default'

          it 'should override the config files with new files that have extensions', ->
            config = require(confurgFile).init
              namespace: 'confurg'
              home: path.join options.homePath, "override.#{type}"
              config: path.join options.projectPath, "override.#{type}"
              env: path.join options.envPath, "override.#{type}"

            expect(config.hometype).to.equal type
            expect(config.home).to.equal 'override'
            expect(config.projecttype).to.equal type
            expect(config.project).to.equal 'override'
            expect(config.envtype).to.equal type
            expect(config.env).to.equal 'override'

          it 'should override the config files with new files that do not extension', ->
            config = require(confurgFile).init
              namespace: 'confurg'
              home: path.join options.homePath, 'override'
              config: path.join options.projectPath, 'override'
              env: path.join options.envPath, 'override'

            expect(config.hometype).to.equal type
            expect(config.home).to.equal 'override'
            expect(config.projecttype).to.equal type
            expect(config.project).to.equal 'override'
            expect(config.envtype).to.equal type
            expect(config.env).to.equal 'override'

          it 'should override the config files with objects', ->
            config = require(confurgFile).init
              namespace: 'confurg'
              home: 
                hometype: 'obj'
                home: 'obj'
              config:
                projecttype: 'obj'
                project: 'obj'
              env:
                envtype: 'obj'
                env: 'obj'

            expect(config.hometype).to.equal 'obj'
            expect(config.home).to.equal 'obj'
            expect(config.projecttype).to.equal 'obj'
            expect(config.project).to.equal 'obj'
            expect(config.envtype).to.equal 'obj'
            expect(config.env).to.equal 'obj'