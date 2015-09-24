
/*
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
 */
var DESTINATION_PATH, PORT, Promise, USERNAME, child_process, path, rsync, _;

_ = require('lodash');

path = require('path');

Promise = require('bluebird');

child_process = Promise.promisifyAll(require('child_process'));

rsync = require('rsync');

USERNAME = 'root';

DESTINATION_PATH = '/data/.resin-watch';

PORT = '80';

exports.buildCommand = function(uuid, options) {
  var hostName;
  if (options == null) {
    options = {};
  }
  hostName = uuid + '.resin';
  console.log('Hostname: ' + hostName);
  _.defaults(options, {
    destination: "" + USERNAME + "@" + hostName + ":" + DESTINATION_PATH
  });
  return Promise.promisifyAll(rsync.build(options));
};

exports.execute = function(uuid, options) {
  var command;
  if (options == null) {
    options = {};
  }
  command = exports.buildCommand(uuid, options);
  console.log(command.command());
  return command.executeAsync();
};

exports.perform = function(uuid, directory) {
  return exports.execute(uuid, {
    source: directory,
    flags: 'avzr',
    shell: 'ssh -p 80 -o \"ProxyCommand nc -X connect -x vpn.resinstaging.io:3128 %h %p\" -o StrictHostKeyChecking=no'
  });
};
