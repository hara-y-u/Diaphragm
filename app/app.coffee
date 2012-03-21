utils = require 'lib/utils'
confs = require 'confs'
#ModelsGenerator = require 'models/models_generator'
pageController = new (require 'controllers/PageController')()
root = exports ? this

module.exports = App =
  init: ->
    url = utils.parseURL location.href
    App.route url.path, url.params, url.hash

  route: (path, params, hash) ->
    console.log path, params, hash, root
    switch path
      when "/" then pageController.index params
