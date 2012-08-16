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
      window.unsavedChanges = true
      $("button#save").addClass('important')

  $("#poster-width-value").html("#{$("#poster-width-slider").slider("value")} pixels")
  window.unsavedChanges = false

  $("button#save").click saveChanges
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
  $("button#export").click exportPosterwall
  window.footerStatus = "retracted"
  $("button#expand-footer").click expandOrRetractFooter

  getPosters()

  window.space_taken = window.poster_width * Math.ceil(1.5 * poster_width) * window.posters.length
  fillPosterwall()

  window.poster_count = $("#posterwall > li").length
  setPosterwallSize()
  $(window).resize setPosterwallSize
  setInterval( getExportInfo, 30000)
  getExportInfo()

renderExportInfo = (data) ->
  if data.found
    html = "<p>You last exported your posterwall #{data.time_ago} ago. Current status: <span>#{data.status}</span></p>"
    if data.status == "Completed"
      html += "<a id='download' class='btn simple' href='#{data.path}' target='_blank'>Download</a>"
  else
    html = "You haven't yet exported your posterwall to an image!"
  $("#export-info > .content").html(html)

getExportInfo = () ->
  $.ajax(
    method: "get",
    url: "/users/#{window.user}/export",
    data: {},
    datatype: 'json',
    success: (data) -> renderExportInfo(data)
    error: -> renderExportInfo({})
  )

saveChanges = () ->
  window.unsavedChanges = false
  $("button#save").removeClass("important")
  $.post("/users/#{window.user}/update", {'user': {'poster_width': window.poster_width }}, (data) ->
  ).error ->
    console.log "Update not successful!"

expandOrRetractFooter = () ->
  if(window.footerStatus == "retracted")
    $("footer").animate({"height": "200px"})
    $("button#expand-footer").html("Close")
    $("button#expand-footer").addClass("close")
    window.footerStatus = "expanded"
  else
    $("footer").animate({"height": "20px"})
    $("button#expand-footer").html("Options")
    $("button#expand-footer").removeClass("close")
    window.footerStatus = "retracted"
    saveChanges() if window.unsavedChanges

getPosters = () ->
  window.posters = []
  $("#posterwall > li").each ->
    window.posters.push this

fillPosterwall = () ->
  return unless $("#posterwall").hasClass("show")
  available_space = $(window).width() * $(window).height()

  until available_space < window.space_taken
    shuffle(window.posters)
    for i in window.posters
      window.space_taken += window.poster_width * Math.ceil(1.5 * poster_width) 
      $("#posterwall").append($(i).clone())

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

exportMsg = (cl, msg) ->
  $("#export-message").removeAttr('class')
  $("#export-message").addClass(cl)
  $("#export-message").html(msg)
  $("#export-message").css('display', 'block')
  setTimeout( (-> $("#export-message").css('display', 'none')), 30000)
  
exportPosterwall = () ->
  width = $("#export-width").val()
  height = $("#export-height").val()
  $("#export-info .content").html("Loading...")
  $.ajax(
    type: 'post',
    url: '/exports',
    data: {'width': width, 'height': height},
    dataType: 'json',
    statusCode:
      269: (data) ->
        exportMsg("success", "Your request has been submitted and will be processed shortly. We'll let you know when your posterwall is ready for downloading.")
        setTimeout(getExportInfo, 8000)
    error: (data) ->
        exportMsg("failure", JSON.parse(data.responseText).error)
  )

addPoster = (movie) ->
  $.post('/posters', {'ref': movie.cache_key, 'order': 1}, (data) ->
  ).error( (data) ->
    console.log "ERROR"
    console.log data.responseText
  )
  $("#posterwall").append("<li><div id='poster-#{movie.id}' class='poster' style='background-image: url(#{movie.img})'><div class='poster-ui poster-info'>#{movie.title}</div><div class='poster-ui delete-poster'>X</div></div></li>")
  #$("#poster-#{movie.id} > .delete-poster").click deletePosterClick

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
  if available_width < width
    width = window.poster_width * (Math.floor(window.poster_count * available_width/width))
  $("#posterwall").css("width", "#{width}px")
  fillPosterwall()

deletePoster = (id) ->
  $.post("/posters/#{id}/destroy", (data) ->
  ).error( ->
    "Deletion was not successful"
  )

img = new Image()
img.src = '/assets/loading.gif'

setIconLoading = () ->
  $("#add").addClass('loading')

unsetIconLoading = () ->
  $("#add").removeClass('loading')

shuffle = (array) ->
  tmp = undefined
  current = undefined
  top = array.length
  if top
    while --top
      current = Math.floor(Math.random() * (top + 1))
      tmp = array[current]
      array[current] = array[top]
      array[top] = tmp
  array
