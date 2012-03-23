MediaController = require 'controllers/MediaController'

class PageController
  constructor: (@el = $(document.body)) ->
    @el.html (require "views/pageLayout")(this)

  index: (params) =>
    mediaController = new MediaController(@el.find('#media'))
    mediaController.feeds(params)

  user: (params) =>
    console.log params

module.exports = PageController