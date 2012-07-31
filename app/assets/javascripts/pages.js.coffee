$(document).ready ->
  console.log("Starting")
  setInterval(play_logo, 8000)

turn_on = ->
  $("#logo").addClass("on")

turn_off = ->
  $("#logo").removeClass("on")

# Quick and dirty flickering effect
play_logo = ->
  turn_on()
  setTimeout( ->
      turn_off()
      setTimeout( ->
        turn_on()
        setTimeout( ->
          turn_off()
        , 500)
      , 200)
    , 400)

