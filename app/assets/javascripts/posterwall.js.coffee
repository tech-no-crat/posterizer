$ ->
  cache = {}
  lastXhr = undefined
  $("#posterwall.edit").sortable()
  $("#posterwall").disableSelection()
  $("#poster-width-slider").slider
    value: window.poster_width,
    min: 60,
    max: 200,
    step: 5,
    slide: (event, ui) ->
      $("#poster-width-value").html("#{ui.value} pixels")
      window.poster_width = ui.value
      setPosterwallSize()
      $("button#save").addClass('important')

  $("#poster-width-value").html("#{$("#poster-width-slider").slider("value")} pixels")

  $("button#save").click (e) ->
    $("button#save").removeClass("important")
    $.post("/users/#{window.user}/update", {'user': {'poster_width': window.poster_width }}, (data) ->
      console.log "Update complete!"
    ).error ->
      console.log "Update not successful!"
    

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
  $(".delete-poster").click deletePosterClick
  $("#posterwall.edit").parent().parent().css("overflow", "scroll")

  clone()

  window.poster_count = $("#posterwall > li").length
  setPosterwallSize()
  $(window).resize setPosterwallSize

clone = ()->
  return unless $("#posterwall").hasClass("show")
  html = $("#posterwall.show").html()
  $("#posterwall.show").append(html) for [1...20]

deletePosterClick = (event)->
  id = $(event.target).parent().attr('id')
  id = id.slice(id.indexOf('-') + 1)
  deletePoster id
  $(event.target).parent().remove()

  window.poster_count--
  setPosterwallSize()

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
  $("#posterwall").append("<li><div id='poster-#{movie.id}' class='poster' style='background-image: url(#{movie.img})'><div class='poster-ui poster-info'>#{movie.title}</div><div class='poster-ui delete-poster'>X</div></div></li>")
  $("#poster-#{movie.id}").click deletePosterClick

  window.poster_count++
  setPosterwallSize()

min = (a, b) ->
  return a if a < b
  return b

setPosterwallSize = () ->
  $(".poster").css("width", window.poster_width)
  $(".poster").css("height", Math.floor(1.5 * window.poster_width))

  available_width = $("#posterwall").parent().width()
  width = window.poster_count * window.poster_width
  console.log "Want #{width} pixels, #{available_width} pixels available"
  if available_width < width
    width = window.poster_width * (Math.floor(window.poster_count * available_width/width))
  $("#posterwall").css("width", "#{width}px")

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

