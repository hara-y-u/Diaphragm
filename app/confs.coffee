module.exports = confs =
  auth:
    baseURL: "https://instagram.com"
    path: "/oauth/authorize/"
    params:
      client_id: "59f22efc72bb499eb00b125d6d58e36d"
      redirect_uri: location.href
      response_type: "token"

  api:
    baseURL: "https://api.instagram.com/v1"

  # These are used to generate Models.
  models:
    baseURL: "https://api.instagram.com/v1"
    User:
      get: "/users/{user_id}"
      search: "/users/search"
      follows: "/users/{user_id}/follows"
      followedBy: "/users/{user_id}/followed-by"
    Media:
      get: "/media/{media_id}"
      feed: "/users/self/feed"
      recent: "/users/{user_id}/media/recent"
      liked: "/users/self/media/liked"
      search: "/media/search"
      popular: "/media/search"
