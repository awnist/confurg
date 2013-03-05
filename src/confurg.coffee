# This module handles configuration chaining.
#
# In decreasing order of precedence:
# 	command line options > ENV variables > ~/.project.cson > ./config.json > defaults

fs = require 'fs'
path = require 'path'
# Reads coffeescript-json files
cson = require 'cson'
# Reads from commandline
optimist = require("optimist").argv
# Object extensions
merge = require 'tea-merge'

# Tries to find .cson and then .json files
confurgFile = (file) ->
	for e in ["cson", "json"]
		if fs.existsSync file+"."+e
			return cson.parseFileSync file+"."+e

confurg = module.exports =

	init: (settings={}, defaults={}) ->

		# Shorthand mode
		settings = { namespace: settings } if typeof settings is "string"

		throw "Need namespace config parameter" unless settings.namespace?.match /^\w+$/

		# default_settings =
		#	merge: true
		#	deep: true

		# Find env variables that match our namespace
		re = new RegExp "^#{settings.namespace}_(\\w+)"
		envs = {}
		envs[matched] = val for key, val of process.env when matched = key.match(re)?[1]

		merged = {}

		# Various config locations together based on increasing precedence
		merge(merged, c) for c in [
			# Defaults
			defaults

			# ./config.cson
			confurgFile path.dirname(module.parent.filename) + "/config"

			# ~/.project.cson
			confurgFile process.env.HOME + "/.#{settings.namespace}"

			# ENV variables
			envs

			# Command line
			optimist
		] when typeof c is 'object'

		merged
