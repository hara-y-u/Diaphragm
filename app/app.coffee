utils = require 'lib/utils'
confs = require 'confs'
router = new (require 'router')()
pageController = new (require 'controllers/page_controller')()
history = window.history
root = exports ? this

router.add '/', pageController.index
router.add '/user/:id', pageController.user
router.add '/media/:id/info', pageController.mediaInfo

module.exports = App =
  init: ->
    router.route location.href
    history.replaceState
      url: location.href
      document.title, location.href

    $('a').live 'click', (ev) ->
      router.route ev.target.href #modify title here?
      history.pushState
        url: ev.target.href
        document.title, ev.target.href
      ev.preventDefault()
      false

    $(window).on 'popstate', (ev) ->
      if ev.originalEvent.state
        router.route ev.originalEvent.state.url
