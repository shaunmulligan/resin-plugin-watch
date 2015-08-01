###
The MIT License

Copyright (c) 2015 Resin.io, Inc. https://resin.io.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
###

_ = require('lodash')
path = require('path')
Promise = require('bluebird')
child_process = Promise.promisifyAll(require('child_process'))
rsync = require('rsync')

USERNAME = 'root'
DESTINATION_PATH = '/data/.resin-watch'
PORT = '80'

exports.buildCommand = (uuid, options = {}) ->
	hostName = uuid + '.resin'
	console.log('Hostname: ' + hostName)
	_.defaults options,
		destination: "#{USERNAME}@#{hostName}:#{DESTINATION_PATH}"

	command = Promise.promisifyAll(rsync.build(options))
	# command.set('password-file', path.join(__dirname, 'password.txt'))

	return command

exports.execute = (uuid, options = {}) ->

	command = exports.buildCommand(uuid, options)
	console.log(command.command())
	return command.executeAsync()

exports.perform = (uuid, directory) ->
	exports.execute uuid,
		source: directory

		# a = archive mode.
		# This makes sure rsync synchronizes the
		# files, and not just copies them blindly.
		#
		# v = verbose
		# z = compress during transfer
		# r = recursive
		flags: 'avzr'

		shell: 'ssh -p 80 -o \"ProxyCommand nc -X connect -x vpn.resinstaging.io:3128 %h %p\" -o StrictHostKeyChecking=no'
