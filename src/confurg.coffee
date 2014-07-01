# This module handles configuration chaining.
#
# In decreasing order of precedence:
# 	command line options > ENV variables > ~/.project.cson > ./config.json > defaults

fs = require 'fs'
path = require 'path'
cson = require 'cson-safe'
# Object extensions
merge = require 'tea-merge'
# Find topmost parent
root = require 'root-finder'

confurg = module.exports =

	init: (config={}, defaults={}) ->

		# Shorthand mode, confurg.init("foo")
		config = { namespace: config } if typeof config is "string"

		throw "Need namespace config parameter" unless config.namespace?.match /^[\w\-\.]+$/

		# config
		#	merge: true
		#	deep: true

		config.cwd ?= root.path

		config.defaults ?= defaults
		config.config ?= path.join(config.cwd, "config")
		config.home ?= path.join(process.env.HOME, "."+config.namespace)
		# Optimist reads from commandline
		config.cli ?= require("yargs").argv

		unless config.env
			# If env wasn't overriden, let's build it from ENV variables matching (namespace)_*
			re = new RegExp "^#{config.namespace}_(\\w+)"
			config.env = {}
			config.env[matched] = val for key, val of process.env when matched = key.match(re)?[1]

		merged = {}

		# Let's glue all of the pieces together in a merged object.
		for key in ['defaults', 'config', 'home', 'env', 'cli']
			val = config[key]
			switch typeof val
				when 'string'
					# If we end in .json or .cson, use that file, otherwise try both extensions.
					for f in val.match(/\.[jc]son$/) && [val] or ["#{val}.cson", "#{val}.json"]
						if fs.existsSync(f)
							merge(merged, cson.parse fs.readFileSync f)
							break
				when 'object'
					# If this is an object, the data has already been resolved to what we want, just merge.
					merge(merged, val)
				else
					throw "Don't know what to do with content in #{key} (#{typeof val})"

		merged
