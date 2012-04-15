utils = require 'lib/utils'
confs = require 'confs'
AppView = require 'views/appview'
# router = new (require 'router')()
# history = window.history
# root = exports ? this

# router.add '/', pageController.index
# router.add '/user/:id', pageController.user
# router.add '/media/:id/info', pageController.mediaInfo

appview = new AppView el: $(document.body)

class Router extends Backbone.Router
  routes:
    "": "index"
    "likes/": "likes"
    "users/:id": "user"

  index: ->
    console.log 'index'
    appview.index()

  likes: ->
    console.log 'likes'
    appview.likes()

  user: (id) ->
    console.log 'user', id
    appview.user id

module.exports = App =
  init: ->
    router = new Router
    # ルートでないパスへのURL指定。サーバでindex.htmlが返せればよいが、そうでない場合はhashchangeなどでの対応が必須
    Backbone.history.start()

    url = utils.parseUrl location.href
    fragment = utils.makeUrl
      path: url.path
      params: url.params

    router.navigate fragment,
      trigger: true
      replace: true

    # router.route location.href
    # history.replaceState
    #   url: location.href
    #   document.title, location.href

    # $('a').live 'click', (ev) ->
    #   #router.route ev.target.href #modify title here?
    #   history.pushState
    #     url: ev.target.href
    #     document.title, ev.target.href
    #   ev.preventDefault()
    #   false

    # $(window).on 'popstate', (ev) ->
    #   if ev.originalEvent.state
    #     router.route ev.originalEvent.state.url
