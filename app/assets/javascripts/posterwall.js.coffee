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

$.ui.autocomplete.prototype._renderItem = (ul, item) ->
  html = "<a>"
  html += "<img src='#{item.img}' width=40 height=60 />#{item.title}"
  html += "<span class='release'>(#{item.release})</span>" if item.release
  html += "</a>"
  return $("<li></li>").data( "item.autocomplete", item ).append(html).appendTo( ul )

addPoster = (movie) ->
  console.log "Adding movie #{movie.title}, tmdb id #{movie.id}"
  $("#posterwall").append("<li><img src='#{movie.img}'/></li>")

img = new Image()
img.src = '/assets/loading.gif'

setIconLoading = () ->
  console.log "loading"
  $("#add").addClass('loading')

unsetIconLoading = () ->
  console.log "done"
  $("#add").removeClass('loading')

