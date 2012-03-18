IG = {}

IG.settings =
  auth:
    clientId: "59f22efc72bb499eb00b125d6d58e36d"
    baseURL: "https://instagram.com"
    path: "/oauth/authorize/"
    params:
      client_id: '{client_id}'
      redirect_uri: location.href
      response_type: "token"

  apis:
    baseURL: "https://api.instagram.com/v1"
    liked:
      path: "/users/self/media/liked"
      # params:
      #   access_token: "{access_token}"


IG.utils =
  extractStr: (str, options = {}) ->
    str.replace /\{[^\}]+\}/g, (str, p1, p2, offset, s) ->
      options[str.match(/\{([^\}]+)\}/)[1]]
  makeURL: (baseURL, path = "", params = {}, hash, options = {}) ->
    extract = IG.utils.extractStr
    _params = []
    for key, val in params
      _params.push key + "=" + val
    _params = '&' + _params.join("&")
    hash ?= '#' + hash
    extract(baseURL + path + hash, options) +
      encodeURIComponent(extract(_params, options))
  parseURL: (url) ->
    # From http://snipplr.com/view.php?codeview&id=12659
    a = document.createElement('a')
    a.href = url
    {
      source: url
      protocol: a.protocol.replace ':',''
      host: a.hostname
      port: a.port
      search: a.search
      params: () ->
        ret = {}
        segs = a.search.replace(/^\?/,'').split('&')
        for seg in segs
          s = seg.split('=')
          ret[s[0]] = s[1]
        ret
      file: (a.pathname.match(/\/([^\/?#]+)$/i) || ['',''])[1]
      hash: a.hash.replace('#','')
      path: a.pathname.replace(/^([^\/])/,'/$1')
      relative: (a.href.match(/tp:\/\/[^\/]+(.+)/) || ['',''])[1]
      segments: a.pathname.replace(/^\//,'').split('/')
    }


# サーバーとのインタラクション
class IG.OAuthClient
  utils = IG.utils
  constructor: (@authInfo) ->
  authenticate: () ->
    @accessToken = utils.parseURL(location.href).params.access_token
    i = @authInfo
    if !@accessToken
      location.href = utils.makeURL i.baseURL, i.path, i.params, {client_id: i.clientId}
  request: (settings) ->
    settings.data = $.extend(settings.data, { access_token: @accessToken })
    $.ajax settings




# ユーザーとのインタラクションを担当
class IG.Controller
  constructor: (@options) ->

class IG.LikedMediasController extends IG.Controller

# Base Class of View
class IG.View
  constructor: (@data) ->

# お気に入りのためのView
class IG.LikedMediasView extends IG.View
  render: () ->
   # 表示処理


# データを操作するためのクラス。クラスメソッドで集合を返す
class IG.Model
  constructor: (@data) ->

# ひとつのメディアのModel
class IG.Media extends IG.Model
  # いろいろなメソッド here
  # あとで汎用的に使えそうなものを IG.Model に移してく
  @_url: (conditions) ->

  @get: (conditions) ->
    $.get @_url(conditions), (res) ->
      console.log(res)
