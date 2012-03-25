utils = require 'lib/utils'

class OAuthClient
  # All OAuthClient instances reffer this
  accessToken = null

  constructor: (@authInfo) ->
    @authenticate()

  authenticate: () ->
    unless accessToken
      match = utils.parseURL(location.href).hash
        .match /access_token=([^\#\/\?\&\;]+)/
      accessToken = if match then match[1]
      unless accessToken
        location.href = utils.makeURL @authInfo

  accessToken: () ->
    accessToken

  request: (settings, noAuth) ->
    settings = $.extend true, settings,
      dataType: 'jsonp'
    unless noAuth
      settings.data = $.extend settings.data,
        access_token: @accessToken()
    $.ajax settings

module.exports = OAuthClient
