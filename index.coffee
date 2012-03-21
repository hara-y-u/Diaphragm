require("coffee-script")
stitch  = require("stitch")
express = require("express")
argv    = process.argv.slice(2)

package = stitch.createPackage(
  # Stitchに自動的に結合して欲しいパスを指定する
  paths: [ __dirname + "/app" ]

  # ベースとなるライブラリを指定する
  dependencies: [
    __dirname + '/lib/jquery-1.7.1.js'
  ]
)
app = express.createServer()

app.configure ->
  app.set "views", __dirname + "/views"
  app.use app.router
  app.use require('stylus').middleware( src: __dirname + '/public' )
  app.use express.static(__dirname + "/public")
  app.get "/application.js", package.createServer()

port = argv[0] or process.env.PORT or 9294
console.log "Starting server on port: #{port}"
app.listen port