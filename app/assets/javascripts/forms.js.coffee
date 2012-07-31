$(document).ready( ->
  $("form input").focus( (e) -> $(e.target).prev(".hint").slideDown(500) )
  $("form input").focusout( (e) -> $(e.target).prev(".hint").slideUp(500) )
  $("form .group > input").focus( (e) -> $(e.target).parent().prev(".hint").slideDown(500) )
  $("form .group > input").focusout( (e) -> $(e.target).parent().prev(".hint").slideUp(500) )

  #$("input[type='text']:first").focus()
)
