models = require 'models/models'
view = require 'views/media'
detailView = require 'views/media/detail'

class MediaController
  constructor: (@el) ->
    @context = ''

  index: (params) ->
    models.Media[@context]
      success: (@media, @attr) =>
        @el.html(view this)

  detail: (params) ->
    result = (medium for medium in @media when medium.id is params.id)[0]
    $('#media-detail').html detailView(result) if result

module.exports = MediaController