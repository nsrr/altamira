# Function from http://stackoverflow.com/a/10073788/1611947
@pad = (n, width, z) ->
  z = z || '0'
  n = n + ''
  return if n.length >= width then n else new Array(width - n.length + 1).join(z) + n

@point = (x,y,width = 2,color = "#ADFF2F") ->
  window.$ctx.fillStyle = color
  window.$ctx.fillRect(x,y,width,width)

@line = (x, y, x2, y2, width, color = "#333333", path_only = false) ->
  unless path_only
    window.$ctx.strokeStyle = color
    window.$ctx.beginPath()
    window.$ctx.lineWidth = width
  window.$ctx.moveTo(x, window.$canvas.height-y)
  window.$ctx.lineTo(x2, (window.$canvas.height-y2))
  unless path_only
    window.$ctx.stroke()

@offset_line = (x, y, x2, y2, width, color, x_offset, y_offset, path_only) ->
  line(x+x_offset,y+y_offset,x2+x_offset,y2+y_offset,width,color,path_only)

@box = (x,y,x2,y2,y_zero,y_max) ->
  grd = window.$ctx.createLinearGradient(0, window.$canvas.height-y_zero, 0, window.$canvas.height-y_max)
  grd.addColorStop(0, 'red')
  grd.addColorStop(0.5, 'yellow')
  grd.addColorStop(1, 'green')
  window.$ctx.fillStyle = grd # '#f00'

  # window.$ctx.fillStyle = '#ed0000'
  window.$ctx.beginPath()
  window.$ctx.moveTo(x, window.$canvas.height-y)
  window.$ctx.lineTo(x2, window.$canvas.height-y2)
  window.$ctx.lineTo(x2, window.$canvas.height-y_zero)
  window.$ctx.lineTo(x, window.$canvas.height-y_zero)
  window.$ctx.closePath()
  window.$ctx.fill()

@offset_box = (x,y,x2,y2,x_offset,y_offset,y_zero,y_max) ->
  box(x+x_offset,y+y_offset,x2+x_offset,y2+y_offset,y_zero+y_offset,y_max+y_offset)

@line_label = (x,y,text,align,baseline,color = "#333333") ->
  window.$ctx.textAlign    = align    if align
  window.$ctx.textBaseline = baseline if baseline
  window.$ctx.fillStyle = color
  # alert(window.$ctx.font);
  # window.$ctx.font="10px sans-serif";
  window.$ctx.fillText(text,x,window.$canvas.height-y)

@offset_label = (x,y,text,x_offset,y_offset,align,baseline,color) ->
  line_label(x+x_offset,y+y_offset,text,align,baseline,color)

