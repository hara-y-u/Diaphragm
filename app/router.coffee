utils = require 'lib/utils'

class Router
  constructor: () ->
    @routes = {}

  add: (pat, fn) ->
    @routes[pat] =
      route: @compilePat pat
      callback: fn

  compilePat: (pat) ->
    match = pat.match(/:[\w]+/g)
    unless match
      match = pat
      keys = []
    else
      keys = for key in match
        key.substr(1)

    rx = if $.type(pat) is 'regexp'
        pat
      else
        new RegExp "^#{pat.replace(/:[\w]+/g, '([\\w\\d]+)')}$"

    keys: keys
    regexp: rx

  match: (url, route) ->
    url = utils.parseURL url
    ret = route.regexp.exec url.path
    return unless ret
    params = {}
    ret = ret.slice(1)
    params[key] = ret[i] for key, i in route.keys
    $.extend url.params, params

  route: (url) ->
    for key, opts of @routes
      params = @match url, opts.route
      if params
        return opts.callback params
    console.error "No Route"

module.exports = Router
