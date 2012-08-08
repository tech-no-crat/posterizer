$ ->
  cache = {}
  lastXhr = undefined
  $("#posterwall").sortable()
  $("#posterwall").disableSelection()
  $("#add").autocomplete
    minLength: 2
    source: (request, response) ->
      term = request.term
      if term of cache
        response cache[term]
        return
      setIconLoading()
      lastXhr = $.getJSON("/suggest/#{request.term}", null, (data, status, xhr) ->
        cache[term] = data
        if xhr is lastXhr
          unsetIconLoading()
          response data
      )
    select: (event, ui) ->
      addPoster(ui.item)
  $(".delete-poster").click (event)->
    id = $(event.target).parent().attr('id')
    id = id.slice(id.indexOf('-') + 1)
    deletePoster id
    $(event.target).parent().remove()


$.ui.autocomplete.prototype._renderItem = (ul, item) ->
  html = "<a>"
  html += "<img src='#{item.img}' width=40 height=60 />#{item.title}"
  html += "<span class='release'>(#{item.release})</span>" if item.release
  html += "</a>"
  return $("<li></li>").data( "item.autocomplete", item ).append(html).appendTo( ul )

addPoster = (movie) ->
  console.log "Adding movie #{movie.title}, tmdb id #{movie.id}"
  $.post('/posters', {'ref': movie.cache_key, 'order': 1}, (data) ->
    console.log "reply back:"
    console.log data
  ).error( (data) ->
    console.log "ERROR"
    console.log data.responseText
  )
  $("#posterwall").append("<li><img src='#{movie.img}'/></li>")

deletePoster = (id) ->
  console.log "deleting..."
  $.post("/posters/#{id}/destroy", (data) ->
    console.log "Deleted ok!"
  ).error( ->
    "Deletion was not successful"
  )

img = new Image()
img.src = '/assets/loading.gif'

setIconLoading = () ->
  console.log "loading"
  $("#add").addClass('loading')

unsetIconLoading = () ->
  console.log "done"
  $("#add").removeClass('loading')

