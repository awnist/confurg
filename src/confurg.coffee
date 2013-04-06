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

# Tries to find .cson and then .json files if the initial file does not exist
_confurg = (file) ->
	if typeof file is "string"
		for f in [file, "#{file}.cson", "#{file}.json"]
			if f? and fs.existsSync(f) and fs.statSync(f).isFile()
				return cson.parseFileSync f

	else if file?
		return file

confurg = module.exports =

	init: (settings={}, defaults={}) ->

		# Shorthand mode
		settings = { namespace: settings } if typeof settings is "string"

		throw "Need namespace config parameter" unless settings.namespace?.match /^\w+$/

		# default_settings =
		#	merge: true
		#	deep: true

		# Use custom CWD or parent's directory
		cwd = settings?.cwd ? path.dirname(module.parent.filename)

		# Find env variables that match our namespace
		re = new RegExp "^#{settings.namespace}_(\\w+)"
		envs = {}
		envs[matched] = val for key, val of process.env when matched = key.match(re)?[1]

		merged = {}

		# Locate configuration files
		defaultConfigPath = "#{cwd}/config"
		defaultHomePath = "#{process.env.HOME}/.#{settings.namespace}"	

		# Confurg files and overrides
		configConfurg = _confurg(settings?.config ? defaultConfigPath)
		homeConfurg = _confurg(settings?.home ? defaultHomePath)
		envConfurg = if settings?.env? then _confurg settings?.env else envs

		# Various config locations together based on increasing precedence
		merge(merged, c) for c in [
			# Defaults
			defaults

			# ./config.cson
			configConfurg

			# ~/.project.cson
			homeConfurg

			# ENV variables
			envConfurg

			# Command line
			optimist
		] when typeof c is 'object'

		merged
