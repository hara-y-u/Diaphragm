MediaController = require 'controllers/media_controller'

class FeedController extends MediaController
  constructor: (@el) ->
    @context = 'feed'

module.exports = FeedController