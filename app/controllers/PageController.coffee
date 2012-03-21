models = require 'models/models'

class PageController
  render: (view, root) ->
    if root
      $(root).html (require "views/#{view}")(this)
    else
      (require "views/#{view}")(this)

  index: (params) ->
    models.Media.liked
      success: (@media, @attr) =>
        console.log @media
        @render 'media/liked', document.body


module.exports = PageController