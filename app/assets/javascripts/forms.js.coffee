$(document).ready( ->
  $("form input").focus( (e) -> skipErrorDiv($(e.target)).prev(".hint").slideDown(500) )
  $("form input").focusout( (e) -> skipErrorDiv($(e.target)).prev(".hint").slideUp(500) )
  $("form .group input").focus( (e) -> skipErrorDiv($(e.target)).parent().prev(".hint").slideDown(500) )
  $("form .group input").focusout( (e) -> skipErrorDiv($(e.target)).parent().prev(".hint").slideUp(500) )

  #$("input[type='text']:first").focus()
)

skipErrorDiv = (el) ->
  el = el.parent() if el.parent().hasClass("field_with_errors")
  el
