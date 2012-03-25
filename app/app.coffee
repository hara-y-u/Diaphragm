utils = require 'lib/utils'
confs = require 'confs'
models = require 'models/models'
MediaView = require 'views/mediaview'
# router = new (require 'router')()
# history = window.history
# root = exports ? this


# router.add '/', pageController.index
# router.add '/user/:id', pageController.user
# router.add '/media/:id/info', pageController.mediaInfo

class Router extends Backbone.Router
  routes:
    "":                 "index"
    "media/:id/info":    "mediaInfo"  # /media/12/info

  index: () ->
    feed = new models.MediaFeed
    new MediaView el: $('#media'), collection: feed
    feed.fetch()
    console.log feed

  mediaInfo: (id) ->
    console.log 'media-info'


module.exports = App =
  init: ->
    new Router
    Backbone.history.start
      pushState: true

    # router.route location.href
    # history.replaceState
    #   url: location.href
    #   document.title, location.href

    # $('a').live 'click', (ev) ->
    #   router.route ev.target.href #modify title here?
    #   history.pushState
    #     url: ev.target.href
    #     document.title, ev.target.href
    #   ev.preventDefault()
    #   false

    # $(window).on 'popstate', (ev) ->
    #   if ev.originalEvent.state
    #     router.route ev.originalEvent.state.url
