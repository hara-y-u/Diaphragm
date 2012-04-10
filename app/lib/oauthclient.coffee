utils = require 'lib/utils'

class OAuthClient
  # All OAuthClient instances reffer this
  accessToken = null

  constructor: (@authInfo) ->
    @authenticate()

  authenticate: () ->
    unless accessToken
      match = utils.parseUrl(location.href).hash
        .match /access_token=([^\#\/\?\&\;]+)/
      accessToken = if match then match[1]
      unless accessToken
        location.href = utils.makeUrl @authInfo

  accessToken: () ->
    accessToken

  request: (settings, noAuth) ->
    settings = $.extend true, dataType: 'jsonp', settings
    unless noAuth
      settings.data = $.extend
       access_token: @accessToken()
      , settings.data
    $.ajax settings

module.exports = OAuthClient
