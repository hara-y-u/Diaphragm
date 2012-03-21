confs = require 'confs'
client = new (require 'lib/OAuthClient') confs.auth
utils = require 'lib/utils'

class ModelsGenerator
  constructor: (settings) ->
    @models = {}
    @generate(settings)

  generate: (settings) ->
    _baseURL = settings.baseURL
    delete settings.baseURL
    # self = this

    # Make Models
    for model, methods of settings
      do (model, methods) =>
        @models[model] = class Model
          baseURL = _baseURL

          constructor: (data) ->
            $.extend true, @, data
            @baseURL = _baseURL

          # Define Methods
          for method, path of methods
            do (method, path) =>
              Model[method] = (settings) ->
                if path[0] == '!'
                  noAuth = true
                  path = path.substring 1
                url = utils.makeURL
                  baseURL: baseURL
                  path: path
                  replacers: settings.options
                client.request
                  url: url
                  data: settings.params
                  success: (res) ->
                    attr = {}
                    for key, val of res
                      attr[key] = val if key isnt 'data'
                    settings.success res.data, attr
                  error: settings.error
                  , noAuth

  exportTo: (root) ->
    for name, model of @models
      root[name] = model

mg = new ModelsGenerator confs.models
mg.exportTo module.exports
