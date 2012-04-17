fs      = require 'fs'
stitch  = require 'stitch'

stitch.compilers.jade = (module, filename) ->
  jade = require 'jade'
  source = jade.compile fs.readFileSync(filename, 'utf8'),
    compileDebug: false
    client: true
    # This is used by jade's internal import to specify partial files.
    # Not used now because this 'import' expand templates inline.
    # Its inefficient that same templates appears in multiple places in application.js
    # so, using Stitch's 'require' instead now.
    filename: __dirname + '/view-partials/file'
  content = 'module.exports =' + source + ';'
  module._compile content, filename

module.exports = package = stitch.createPackage(
  # Specify the paths you want Stitch to automatically bundle up
  paths: [
    __dirname + '/app'
  ]

  # Specify your base libraries
  dependencies: [
    __dirname + '/lib/jquery-1.7.1.js'
    __dirname + '/lib/jquery.fancybox.pack.js'
    __dirname + '/lib/jquery.mousewheel-3.0.6.pack.js'
    __dirname + '/lib/jquery.asciimation-0.2.0.js'
    __dirname + '/lib/underscore.js'
    __dirname + '/lib/backbone.js'
    __dirname + '/lib/runtime.min.js' #jade runtime for client
  ]
)
