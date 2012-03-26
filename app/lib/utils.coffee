module.exports = utils =
  extractStr: (str, options = {}) ->
    str.toString().replace /\{[^\}]+\}/g, (str, p1, p2, offset, s) ->
      options[str.match(/\{([^\}]+)\}/)[1]]

  makeUrl: (options) ->
    s = baseURL:'', path: '', params: {}, hash: '', replacers: {}
    $.extend true, s, options

    extract = (str) ->
      utils.extractStr str, s.replacers
    enc = encodeURIComponent

    _params = []
    for key, val of s.params
      _params.push "#{enc extract key}=#{enc extract val}"

    _params = if _params.length then '?' + _params.join '&' else ''
    s.hash = if s.hash then '#' + s.hash else ''

    extract(s.baseURL + s.path) + _params + extract(s.hash)

  parseUrl: (url) ->
    # From http://snipplr.com/view.php?codeview&id=12659
    a = document.createElement('a')
    a.href = url
    {
      source: url
      protocol: a.protocol.replace ':',''
      host: a.hostname
      port: a.port
      search: a.search
      params: ( ()->
        ret = {}
        segs = a.search.replace(/^\?/,'').split('&')
        for seg in segs
          s = seg.split('=')
          ret[s[0]] = s[1]
        ret )()
      file: (a.pathname.match(/\/([^\/?#]+)$/i) || ['',''])[1]
      hash: a.hash.replace('#','')
      path: a.pathname.replace(/^([^\/])/,'/$1')
      relative: (a.href.match(/tp:\/\/[^\/]+(.+)/) || ['',''])[1]
      segments: a.pathname.replace(/^\//,'').split('/')
    }

