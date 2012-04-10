class MediumView extends Backbone.View
  class: 'medium'

  events:
    'click .actions .view-info': 'viewInfo'
    'click .actions .like-this': 'toggleLiked'

  template: require 'templates/medium'
  infoTemplate: require 'templates/medium_info'

  initialize: ->
    @model.bind 'change', @render
    @medium = @model.toJSON()

  render: =>
    @html = @template medium: @medium
    @infoHtml = @infoTemplate medium: @medium

    $(@el).addClass(@class).html @html

    @el

  viewInfo: =>
    $.fancybox
      content: @infoHtml
      maxWidth: 700
      maxHetght: 600
      width: '70%'
      height: '80%'
      autoSize: false
      closeClick: false
      openEffect: 'none'
      closeEffect: 'none'
      afterShow: ->
        # Prevent main view from scroll.
        $inner = $('.fancybox-inner')
        $inner.on 'mousewheel', (e, d) ->
          height = $inner.height()
          scrollHeight = $inner.get(0).scrollHeight
          if (@scrollTop is (scrollHeight - height) and d < 0) or (this.scrollTop is 0 and d > 0)
            #console.log 'prevent scroll', height, scrollHeight
            e.preventDefault()
      afterClose: ->
        $('.fancybox-inner').off 'mousewheel'

  toggleLiked: =>
    isLiked = @$('.actions .like-this').hasClass('liked')
    @model.setLiked not isLiked, (err) =>
      unless err
        if isLiked
          @$('.actions .like-this').removeClass('liked')
        else
          @$('.actions .like-this').addClass('liked')


module.exports = class MediaView extends Backbone.View
  events:
    'click .controlls .fetch-next': 'fetchNext'

  template: require 'templates/media'

  initialize: ->
    @collection.bind 'add', @addOne
    @collection.bind 'reset', @addAll
    @collection.bind 'all', @render

  render: =>

  addOne: (medium) =>
    view = new MediumView model: medium
    @$('.content').append(view.render())

  toggleFetchNext: (bool) =>
    if bool
      @$('.controlls .fetch-next').show()
    else
      @$('.controlls .fetch-next').hide()

  toggleLoading: (bool) =>
    $loading = @$('.controlls .loading-next')
    if bool
      $loading.show()
      $loading.find('.loading').asciimation('start');
    else
      $loading.find('.loading').asciimation('stop');
      $loading.hide()

  hasNext: () =>
    @collection.hasNext()

  addAll: =>
    # Called only after first fetching.
    $(@el).html @template(media: @collection.toJSON())
    # At first, hide 'more'
    @toggleFetchNext(false)
    @toggleLoading(false)
    @collection.each @addOne
    @toggleFetchNext @hasNext()

  fetchNext: =>
    @toggleFetchNext(false)
    @toggleLoading(true)
    @collection.fetchNext
      success: () =>
        @toggleLoading(false)
        @toggleFetchNext @hasNext()

