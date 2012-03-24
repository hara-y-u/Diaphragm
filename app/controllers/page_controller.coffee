FeedController = require 'controllers/feed_controller'

class PageController
  constructor: (@el = $(document.body)) ->
    @el.html (require "views/page_layout")(this)
    @feedController = new FeedController(@el.find('#media #feed'))

  index: (params) =>
    @feedController.index params

  mediaInfo: (params) =>
    @feedController.detail params

  user: (params) =>
    console.log params

module.exports = PageController