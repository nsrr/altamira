@getMousePos = (evt) ->
  rect = window.$canvas.getBoundingClientRect()
  return {
    x: evt.clientX - rect.left
    y: evt.clientY - rect.top
  }

@ready = ->
  window.$canvas = $("#myCanvas")[0]
  window.$ctx = window.$canvas.getContext("2d") if window.$canvas
  window.$signal_height = $("#myCanvas").data('signal-height')
  window.$signal_padding = $("#myCanvas").data('signal-padding')

  start = new Date().getTime()

  if $("[data-object='hypnogram-data']").length > 0
    setupHypnogram()
    drawHypnogram()

  $("[data-object='signal-data']").each( (index) ->
    drawSignal($(this).data('array'),100,window.$canvas.height-(window.$signal_padding + (window.$signal_height / 2) + index*(window.$signal_height+window.$signal_padding)),$(this).data('label'),parseInt($(this).data('samples-per-data-record')),$(this))
    $(this).removeAttr('data-array')
  )

  end = new Date().getTime()
  time = end - start
  $("#drawing-time").html('&middot; Browser: ' + time + ' ms')

  # window.$canvas.addEventListener('mouseup', (evt) ->
  #   mousePos = getMousePos(evt)
  #   point(mousePos.x, mousePos.y)
  # , false)

$(document).ready(ready)
$(document).on('turbolinks:load', ->
  ready()
  window.scrollTo(window.$prevPageXOffset, window.$prevPageYOffset)
  window.$prevPageYOffset = window.pageYOffset
  window.$prevPageXOffset = window.pageXOffset
)

$(document).keydown((e) ->
  if e.which == 37 && !$("input, textarea, select, a").is(":focus")
    $("#retreat")[0].click()
    return false
  if e.which == 39 && !$("input, textarea, select, a").is(":focus")
    $("#advance")[0].click()
    return false
)
