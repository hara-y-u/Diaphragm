class MediumView extends Backbone.View
  class: 'medium'
  template: require 'templates/medium'

  initialize: ->
    @model.bind 'change', @render

  render: =>
    $(@el).html @template this.model.toJSON()


module.exports = class MediaView extends Backbone.View
  events:
    'click #fetch-next': 'fetchNext'

  initialize: ->
    @collection.bind 'add', @addOne
    @collection.bind 'reset', @addAll
    @collection.bind 'all', @render
    @fetchNextEl = $('<a id="fetch-next">↓</span>')

  render: =>

  addOne: (medium) =>
    view = new MediumView model: medium
    $(@el).append view.render()

  addAll: =>
    @collection.each @addOne
    if @collection.additional.pagination.next_max_id
      $(@el).append @fetchNextEl

  fetchNext: =>
    @collection.fetchNext
      success: =>
        @fetchNextEl.remove()
