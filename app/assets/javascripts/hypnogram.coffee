@setupHypnogram = ->
  window.$hypnogramCanvas = $("#hypnogram")[0]
  window.$hypnogramContext = window.$hypnogramCanvas.getContext("2d")
  window.$maxPage = $("[data-object='hypnogram-data']").data('max-page')

  $(document).on('mouseup', '#hypnogram', (evt) ->
    x_offset = 100
    signal_canvas_width = window.$hypnogramCanvas.width - x_offset
    mousePos = getMousePos(evt)
    realX = parseInt(((mousePos.x - x_offset) / signal_canvas_width) * window.$maxPage) + 1
    realX = 1 if realX < 1
    $("#hypnogram-link").attr('href', $("#hypnogram-link").attr('href').replace(/&page=(.*)/, "&page=#{realX}"))
    $("#hypnogram-link")[0].click()
    evt.stopPropagation()
  )

@drawHypnogram = ->
  # window.$signal_height = $("#myCanvas").data('signal-height')
  # window.$signal_padding = $("#myCanvas").data('signal-padding')
  element = $("[data-object='hypnogram-data']")
  array = element.data('array')
  $(element).removeAttr('data-array')
  x_offset = 100
  y_offset = window.$hypnogramCanvas.height - (window.$signal_padding + (window.$signal_height / 2))

  signal_canvas_width = window.$hypnogramCanvas.width - x_offset
  zoom_level = signal_canvas_width / $('#hypnogram').data('samples-per-page')
  samples_per_data_record = parseInt($(element).data('samples-per-data-record'))
  magnitude_x = zoom_level / samples_per_data_record

  width = 1
  color = "#333333"
  window.$hypnogramContext.strokeStyle = color
  window.$hypnogramContext.lineWidth = width

  graph = getGraphMinMax(element)

  drawCurrentWindow(element, x_offset, y_offset, signal_canvas_width)

  window.$hypnogramContext.beginPath()
  for i in [0..array.length-2]
    offset_line(i*magnitude_x, scaleAndOffset(array[i], graph),(i+1)*magnitude_x, scaleAndOffset(array[i+1], graph),width,color,x_offset,y_offset,true,window.$hypnogramCanvas,window.$hypnogramContext)
  window.$hypnogramContext.stroke()

  top_label = graph.max
  bottom_label = graph.min
  y_axis_top = scaleAndOffset(graph.max, graph)
  y_axis_bottom = scaleAndOffset(graph.min, graph)

  offset_label(-30,0,'Hypnogram',x_offset,y_offset,'right',null,null,window.$hypnogramCanvas,window.$hypnogramContext)
  offset_label(-10,y_axis_top,top_label,x_offset,y_offset,null,'middle',"#777",window.$hypnogramCanvas,window.$hypnogramContext)
  offset_label(-10,y_axis_bottom,bottom_label,x_offset,y_offset,null,'middle',"#777",window.$hypnogramCanvas,window.$hypnogramContext)


@gray_box = (x, y, x2, y2, canvas = window.$canvas, context = window.$ctx, color = '#f2f2f2') ->
  context.fillStyle = color
  context.beginPath()
  context.moveTo(x, canvas.height-y)
  context.lineTo(x, canvas.height-y2)
  context.lineTo(x2, canvas.height-y2)
  context.lineTo(x2, canvas.height-y)
  context.closePath()
  context.fill()

@gray_offset_box = (x, y, x2, y2, x_offset, y_offset, canvas, context, color) ->
  gray_box(x+x_offset, y+y_offset, x2+x_offset, y2+y_offset, canvas, context, color)

@drawCurrentWindow = (element, x_offset, y_offset, signal_canvas_width) ->
  element = $("[data-object='hypnogram-data']")
  graph = getGraphMinMax(element)

  left_window = $(element).data('left-window')
  center_window = $(element).data('center-window')
  right_window = $(element).data('right-window')

  center_width = Math.max(center_window * signal_canvas_width, 1.0)

  left_box_x = 0
  left_box_x2 = left_window*signal_canvas_width
  y = scaleAndOffset(-0.1, graph)
  y2 = scaleAndOffset(5.1, graph)
  right_box_x = (left_window)*signal_canvas_width + center_width
  right_box_x2 = signal_canvas_width

  gray_offset_box(left_box_x,y,left_box_x2,y2,x_offset,y_offset,window.$hypnogramCanvas,window.$hypnogramContext)
  # gray_offset_box(left_box_x2,y,right_box_x,y2,x_offset,y_offset,window.$hypnogramCanvas,window.$hypnogramContext, '#00ff00')
  gray_offset_box(right_box_x,y,right_box_x2,y2,x_offset,y_offset,window.$hypnogramCanvas,window.$hypnogramContext)



