require 'coffee-script'
fs      = require 'fs'
stitch  = require 'stitch'
express = require 'express'
stylus  = require 'stylus'
nib     = require 'nib'
argv    = process.argv.slice(2)

stitch.compilers.jade = (module, filename) ->
  jade = require 'jade'
  source = jade.compile fs.readFileSync(filename, 'utf8'),
    compileDebug: false
    client: true
    filename: __dirname + '/view-partials/file'
  content = 'module.exports =' + source + ';'
  module._compile content, filename

package = stitch.createPackage(
  # Stitchに自動的に結合して欲しいパスを指定する
  paths: [
    __dirname + '/app'
  ]

  # ベースとなるライブラリを指定する
  dependencies: [
    __dirname + '/lib/jquery-1.7.1.js'
    __dirname + '/lib/jquery.fancybox.pack.js'
    __dirname + '/lib/jquery.mousewheel-3.0.6.pack.js'
    __dirname + '/lib/underscore.js'
    __dirname + '/lib/backbone.js'
    __dirname + '/lib/runtime.min.js' #jade runtime for client
  ]
)

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
  app.get '/application.js', package.createServer()

port = argv[0] or process.env.PORT or 9294
console.log "Starting server on port: #{port}"
app.listen port