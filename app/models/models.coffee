confs = require 'confs'
base = confs.api.baseURL
oauthclient = new (require 'lib/oauthclient')(confs.auth)

# Override Backbone.sync
sync = (method, model, options = {}) ->
  Backbone.sync method, model, _.extend
    data:
      access_token: oauthclient.accessToken()
    dataType: 'jsonp'
    , options

class ModelForAPI extends Backbone.Model
  sync: sync

class Media extends Backbone.Model
  urlRoot: base + '/media'

  setLiked: (bool, fn) =>
    # unless @waitingResponse
    #   @waitingResponse = true
      oauthclient.request
        dataType: '*/*'
        type: if bool then 'POST' else 'DELETE'
        url: base + '/media/' + this.id + '/likes/'
        # Return error = false always, because cross-domain POST fails
        # because of absence of Access-Control-Allow-Origin header in Response.
        complete: () ->
          fn false
    #       @waitingResponse = false
    # else
    #   console.log 'Media::setLiked - Last request not completed.'
    #   fn true


class User extends Backbone.Model
  urlRoot: base + '/users'


class CollectionForAPI extends Backbone.Collection
  # url: 'https://api.instagram.com/v1/users/self/feed',
  sync: sync
  parse: (res) =>
    this.additional ={}
    for key,val of res
      if key isnt 'data'
        @additional[key] = val
    res.data

  hasNext: () =>
    #console.log @additional.pagination.next_url
    @additional.pagination.hasOwnProperty('next_url')

  fetchNext: (options) =>
    this.fetch _.extend
        url: @additional.pagination.next_url
        add: true
      , options

class UserSpecificCollection extends CollectionForAPI
  initialize: (models, options = {}) ->
    @userId = if options.userId then options.userId else 'self'

  setUserId: (id) =>
    if id
      @userId = id
    else
      @userId

class MediaFeed extends UserSpecificCollection
  model: Media
  url: ->
    base + "/users/#{@userId}/feed"

class LikedMedia extends UserSpecificCollection
  model: Media
  url: ->
    base + "/users/#{@userId}/media/liked"

class RecentMedia extends UserSpecificCollection
  model: Media
  url: ->
    base + "/users/#{@userId}/media/recent"

class FollowingUsers extends UserSpecificCollection
  model: User
  url: ->
    base + "/users/#{@userId}/follows"

class FollowedUsers extends UserSpecificCollection
  model: User
  url: ->
    base + "/users/#{@userId}/followed-by"

module.exports =
  Media: Media
  User: User
  MediaFeed: MediaFeed
  LikedMedia: LikedMedia
  RecentMedia: RecentMedia
  FollowingUsers: FollowingUsers
  FollowedUsers: FollowedUsers
