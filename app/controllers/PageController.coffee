models = require 'models/models'

class PageController
  constructor: ->
    @init()

  render: (view, root) ->
    $(root).html (require "views/#{view}")(this)

  init: ->
    @render 'pageLayout', document.body

  index: (params) ->
    models.Media.feed
      success: (@media, @attr) =>
        console.log @media
        @render 'media', $('#feed')


module.exports = PageController