models = require 'models/models'
viewHtml = require 'views/media'

class MediaController
  constructor: (@el) ->

  feeds: (params) ->
    models.Media.feed
      success: (@media, @attr) =>
        @el.html(viewHtml this)

module.exports = MediaController