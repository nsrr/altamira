@getGraphMinMax = (element) ->
  if $(element).data("auto-scale") == 1 && $(element).data("minimum-value") != $(element).data("maximum-value")
    graph_minimum = $(element).data("minimum-value")
    graph_maximum = $(element).data("maximum-value")
  else
    graph_minimum = $(element).data("physical-minimum")
    graph_maximum = $(element).data("physical-maximum")
  return { min: graph_minimum, max: graph_maximum, distance: graph_maximum - graph_minimum }

@scaleAndOffset = (y_value, graph) ->
  return (y_value - graph.min) * (window.$signal_height / (graph.distance)) - (window.$signal_height / 2)

@drawGrid = (element, x_offset, y_offset) ->
  graph = getGraphMinMax(element)
  y_axis_top = scaleAndOffset(graph.max, graph)
  y_axis_bottom = scaleAndOffset(graph.min, graph)
  signal_canvas_width = window.$canvas.width - x_offset
  starting_number =  ($("#epoch_number").val() - 1) * 5
  ending_number = starting_number + 5

  for i in [starting_number..ending_number]
    spacing = signal_canvas_width / (ending_number-starting_number)
    total_seconds = i * $("#epoch_window").val() / (ending_number-starting_number)
    hours = Math.floor(total_seconds / 3600)
    minutes = Math.floor((total_seconds - (hours * 3600)) / 60)
    seconds = total_seconds - (hours * 3600) - (minutes * 60)
    time_label = pad(hours,2) + ":" + pad(minutes,2) + ":" + pad(Math.round(seconds * 100) / 100,2)
    if $(element).data("grid") == 2
      offset_label((i-starting_number)*spacing,y_axis_top,time_label,x_offset,y_offset,(if i == starting_number then "left" else (if i == ending_number then "right" else "center")),"bottom","#777")
    offset_line((i-starting_number)*spacing,y_axis_top,(i-starting_number)*spacing,y_axis_bottom,1,"#ededed",x_offset,y_offset)

@drawSignal = (array, x_offset = 70, y_offset = 150, label, samples_per_data_record, element) ->
  offset_label(-30,0,label,x_offset,y_offset,"right",null)

  signal_canvas_width = window.$canvas.width - x_offset
  zoom_level = signal_canvas_width / $("#myCanvas").data("samples-per-page")

  magnitude_x = zoom_level / samples_per_data_record

  graph = getGraphMinMax(element)

  y_axis_top = scaleAndOffset(graph.max, graph)
  y_axis_center = scaleAndOffset(0, graph)
  y_axis_bottom = scaleAndOffset(graph.min, graph)

  top_label = graph.max
  bottom_label = graph.min

  if $(element).data("physical-dimension")
    top_label = top_label + " " + $(element).data("physical-dimension")
    bottom_label = bottom_label + " " + $(element).data("physical-dimension")

  offset_label(-10,y_axis_top,top_label,x_offset,y_offset,null,"middle","#777")
  offset_label(-10,y_axis_bottom,bottom_label,x_offset,y_offset,null,"middle","#777")

  offset_line(0,y_axis_center,signal_canvas_width,y_axis_center,1,"#ededed",x_offset,y_offset)

  if parseFloat(graph.min) != 0 && parseFloat(graph.max) != 0
    offset_label(-10,y_axis_center,"0.0",x_offset,y_offset,null,"middle","#ededed")

  if $("#grid").val() != "0" && $(element).data("grid") != 0
    drawGrid(element, x_offset, y_offset)

  if $("#color").val() == "1"
    y_zero = scaleAndOffset(0, graph)
    y_max = scaleAndOffset(graph.max, graph)

    for i in [0..array.length-2]
      offset_box(i*magnitude_x, scaleAndOffset(array[i], graph),(i+1)*magnitude_x, scaleAndOffset(array[i+1], graph),x_offset,y_offset,y_zero,y_max)

  width = 1
  color = "#333333"
  window.$ctx.strokeStyle = color
  window.$ctx.lineWidth = width
  window.$ctx.beginPath()
  for i in [0..array.length-2]
    offset_line(i*magnitude_x, scaleAndOffset(array[i], graph),(i+1)*magnitude_x, scaleAndOffset(array[i+1], graph),width,color,x_offset,y_offset,true)
  window.$ctx.stroke()
