# Function from http://stackoverflow.com/a/10073788/1611947
@pad = (n, width, z) ->
  z = z || '0'
  n = n + ''
  return if n.length >= width then n else new Array(width - n.length + 1).join(z) + n

@point = (x,y,width = 2,color = "#ADFF2F", context = window.$ctx) ->
  context.fillStyle = color
  context.fillRect(x,y,width,width)

@line = (x, y, x2, y2, width, color = "#333333", path_only = false, canvas = window.$canvas, context = window.$ctx) ->
  unless path_only
    context.strokeStyle = color
    context.beginPath()
    context.lineWidth = width
  context.moveTo(x, canvas.height-y)
  context.lineTo(x2, (canvas.height-y2))
  unless path_only
    context.stroke()

@offset_line = (x, y, x2, y2, width, color, x_offset, y_offset, path_only, canvas, context) ->
  line(x+x_offset,y+y_offset,x2+x_offset,y2+y_offset,width,color,path_only, canvas, context)

@box = (x,y,x2,y2,y_zero,y_max, canvas = window.$canvas, context = window.$ctx) ->
  grd = context.createLinearGradient(0, canvas.height-y_zero, 0, canvas.height-y_max)
  grd.addColorStop(0, 'red')
  grd.addColorStop(0.5, 'yellow')
  grd.addColorStop(1, 'green')
  context.fillStyle = grd # '#f00'

  # context.fillStyle = '#ed0000'
  context.beginPath()
  context.moveTo(x, canvas.height-y)
  context.lineTo(x2, canvas.height-y2)
  context.lineTo(x2, canvas.height-y_zero)
  context.lineTo(x, canvas.height-y_zero)
  context.closePath()
  context.fill()

@offset_box = (x,y,x2,y2,x_offset,y_offset,y_zero,y_max,canvas,context) ->
  box(x+x_offset,y+y_offset,x2+x_offset,y2+y_offset,y_zero+y_offset,y_max+y_offset,canvas,context)

@line_label = (x,y,text,align,baseline,color = "#333333", canvas = window.$canvas, context = window.$ctx) ->
  context.textAlign    = align    if align
  context.textBaseline = baseline if baseline
  context.fillStyle = color
  # alert(context.font);
  # context.font="10px sans-serif";
  context.fillText(text,x,canvas.height-y)

@offset_label = (x,y,text,x_offset,y_offset,align,baseline,color,canvas,context) ->
  line_label(x+x_offset,y+y_offset,text,align,baseline,color,canvas,context)

