models = require 'models/models'
MediaView = require 'views/mediaview'
RecentMediaView = require 'views/recentmediaview'

module.exports = class AppView extends Backbone.View
  template: require 'templates/app'

  initialize: ->
    $(@el).html(@template())

  index: ->
    @$('#media > div').hide()
    @$('#media #feed').show()

    unless @feed
      @feed = new models.MediaFeed
      new MediaView el: @$('#media #feed'), collection: @feed

    @feed.fetch()
    console.log 'feed', @feed

  likes: ->
    @$('#media > div').hide()
    @$('#media #likes').show()

    unless @likedMedia
      @likedMedia = new models.LikedMedia
      new MediaView el: @$('#media #likes'), collection: @likedMedia

    @likedMedia.fetch()
    console.log 'liked media', @likedMedia

  user: (id) ->
    @$('#media > div').hide()
    @$('#media #user').show()
    $.fancybox.close()

    unless @recentMedia
      @recentMedia = new models.RecentMedia
      new RecentMediaView el: @$('#media #user'), collection: @recentMedia

    if @recentMedia.userId isnt id
      @recentMedia.setUserId id

    @recentMedia.fetch()
    console.log 'recent media', @recentMedia
