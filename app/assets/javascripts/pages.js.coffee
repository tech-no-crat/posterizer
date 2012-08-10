$(document).ready ->
  console.log("Starting")
  setInterval(flicker, 8000)

turn_on = ->
  $(".flicker").removeClass("off")
  $(".flicker").addClass("on")

turn_off = ->
  $(".flicker").removeClass("on")
  $(".flicker").addClass("off")

# Quick and dirty flickering effect
flicker = ->
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

