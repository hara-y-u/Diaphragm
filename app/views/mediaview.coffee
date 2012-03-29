class MediumView extends Backbone.View
  class: 'medium'
  template: require 'templates/medium'
  infoTemplate: require 'templates/medium_info'

  initialize: ->
    @model.bind 'change', @render
    @medium = @model.toJSON()

  render: =>
    @html = @template medium: @medium
    @infoHtml = @infoTemplate medium: @medium

    $(@el).addClass(@class).html @html

    @$('.actions .view-info').on 'click', =>
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
          console.log this
          $inner = $('.fancybox-inner')
          $inner.on 'mousewheel', (e, d) ->
            height = $inner.height()
            scrollHeight = $inner.get(0).scrollHeight
            if (@scrollTop is (scrollHeight - height) and d < 0) or (this.scrollTop is 0 and d > 0)
              #console.log 'prevent scroll', height, scrollHeight
              e.preventDefault()
        afterClose: ->
          $('.fancybox-inner').off 'mousewheel'

    @el


module.exports = class MediaView extends Backbone.View
  events:
    'click .controlls #fetch-next': 'fetchNext'

  initialize: ->
    @collection.bind 'add', @addOne
    @collection.bind 'reset', @addAll
    @collection.bind 'all', @render
    $(@el)
      .append($('<div class="content">'))
      .append($('<div class="controlls"><a id="fetch-next">more</a></div>'))
    # At first, hide.
    @$('#fetch-next').hide()

  render: =>

  addOne: (medium) =>
    view = new MediumView model: medium
    @$('.content').append(view.render())

  addAll: =>
    @collection.each @addOne
    if @collection.additional.pagination.next_max_id
      @$('.controlls #fetch-next').show()
    else
      @$('.controlls #fetch-next').hide()

  fetchNext: =>
    @collection.fetchNext()
