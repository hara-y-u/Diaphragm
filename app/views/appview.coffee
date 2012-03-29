models = require 'models/models'
MediaView = require 'views/mediaview'

module.exports = class AppView extends Backbone.View
  el: $(document.body)

  template: require 'templates/app'

  initialize: ->
    $(@el).html(@template())

    feed = new models.MediaFeed
    new MediaView el: $('#media'), collection: feed
    feed.fetch()
    console.log feed

