fs      = require 'fs'
path    = require 'path'
express = require 'express'
stylus  = require 'stylus'
nib     = require 'nib'
spawn   = require('child_process').spawn

stitchPackage = require __dirname + '/stitch_package'

existsSync = fs.existsSync || path.existsSync

mkdirP = (path) ->
  dirs = path.split '/'
  _path = ''
  for dir in dirs
    _path = _path + dir + '/'
    unless existsSync _path
      fs.mkdirSync _path

task 'build:js', 'Build js', ->
  mkdirP 'build'
  stitchPackage.compile (err, source) ->
    fs.writeFile __dirname + '/build/application.js', source, (err) ->
      throw err if err
      console.log 'Wrote build/application.js'

task 'build:css', 'Build css', ->
  mkdirP 'build/stylesheets'
  str = fs.readFileSync __dirname + '/public/stylesheets/main.styl', 'utf-8'
  stylus.render str, {filename: 'public/stylesheets/main.styl'}, (err, css) ->
    throw err if err
    fs.writeFile __dirname + '/build/stylesheets/main.css', css, (err) ->
      throw err if err
      console.log 'Wrote build/stylesheets/main.css'

task 'build:html', 'Build html', ->
  mkdirP 'build'
  fs.writeFile __dirname + '/build/index.html'
    , fs.readFileSync __dirname + '/public/index.html', 'utf-8'
    , (err) ->
      throw err if err
      console.log 'Wrote build/index.html'

task 'build', 'Build all', ->
  invoke 'build:js'
  invoke 'build:css'
  invoke 'build:html'


option '-r', '--repo [URL]', 'Ropository URL for deploying branch "gh-pages". Repository must be Github read/write.'

task 'deploy:gh-pages', 'deploy to Github Pages', ->
  invoke 'build'
  mkdirP 'deploy'
  # TODO
