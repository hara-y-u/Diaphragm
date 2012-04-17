require 'coffee-script'
express = require 'express'
stylus  = require 'stylus'
nib     = require 'nib'

argv    = process.argv.slice(2)
stitchPackage  = require __dirname + '/stitch_package'

# stitch.compilers.jade = (module, filename) ->
#   jade = require 'jade'
#   source = jade.compile fs.readFileSync(filename, 'utf8'),
#     compileDebug: false
#     client: true
#     # This is used by jade's internal import to specify partial files.
#     # Not used now because this 'import' expand templates inline.
#     # Its inefficient that same templates appears in multiple places in application.js
#     # so, using Stitch's 'require' instead now.
#     filename: __dirname + '/view-partials/file'
#   content = 'module.exports =' + source + ';'
#   module._compile content, filename

# package = stitch.createPackage(
#   # Specify the paths you want Stitch to automatically bundle up
#   paths: [
#     __dirname + '/app'
#   ]

#   # Specify your base libraries
#   dependencies: [
#     __dirname + '/lib/jquery-1.7.1.js'
#     __dirname + '/lib/jquery.fancybox.pack.js'
#     __dirname + '/lib/jquery.mousewheel-3.0.6.pack.js'
#     __dirname + '/lib/jquery.asciimation-0.2.0.js'
#     __dirname + '/lib/underscore.js'
#     __dirname + '/lib/backbone.js'
#     __dirname + '/lib/runtime.min.js' #jade runtime for client
#   ]
# )

app = express.createServer()

app.configure ->
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.use stylus.middleware
    src: __dirname + '/public'
    compile: (str, path) ->
      stylus(str)
        .set('filename', path)
        .set('compress', true)
        .use(nib()).import('nib')
  app.use app.router
  app.use express.static(__dirname + '/public')
  app.get '/application.js', stitchPackage.createServer()

port = argv[0] or process.env.PORT or 9294
console.log "Starting server on port: #{port}"
app.listen port