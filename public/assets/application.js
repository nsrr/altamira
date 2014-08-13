/* Function from http://stackoverflow.com/a/10073788/1611947 */
function pad(n, width, z) {
  z = z || '0';
  n = n + '';
  return n.length >= width ? n : new Array(width - n.length + 1).join(z) + n;
}

function point(x,y,width,color) {
  if (width == null) {
    width = 2;
  }
  if (color == null) {
    color = "#ADFF2F";
  }
  window.$ctx.fillStyle=color;
  window.$ctx.fillRect(x,y,width,width);
}

function line(x,y,x2,y2,width,color) {
  // console.log("(" + x + ", " + y + ") to (" + x2 + ", " + y2 + ")");
  if (color == null) {
    color = "#333333";
  }
  window.$ctx.strokeStyle=color;
  window.$ctx.beginPath();
  window.$ctx.moveTo(x, window.$canvas.height-y);
  window.$ctx.lineTo(x2, (window.$canvas.height-y2));
  window.$ctx.lineWidth = width;
  window.$ctx.stroke();
}

function offset_line(x,y,x2,y2,width,color,x_offset,y_offset) {
  if (color == null) {
    color = "#333333";
  }
  line(x+x_offset,y+y_offset,x2+x_offset,y2+y_offset,width,color)
}

function box(x,y,x2,y2,y_zero,y_max) {
  var grd = window.$ctx.createLinearGradient(0, window.$canvas.height-y_zero, 0, window.$canvas.height-y_max);
  grd.addColorStop(0, 'red');
  grd.addColorStop(0.5, 'yellow');
  grd.addColorStop(1, 'green');
  window.$ctx.fillStyle = grd;// '#f00';

  // window.$ctx.fillStyle = '#ed0000';
  window.$ctx.beginPath();
  window.$ctx.moveTo(x, window.$canvas.height-y);
  window.$ctx.lineTo(x2, window.$canvas.height-y2);
  window.$ctx.lineTo(x2, window.$canvas.height-y_zero);
  window.$ctx.lineTo(x, window.$canvas.height-y_zero);
  window.$ctx.closePath();
  window.$ctx.fill();
}

function offset_box(x,y,x2,y2,x_offset,y_offset,y_zero,y_max) {
  box(x+x_offset,y+y_offset,x2+x_offset,y2+y_offset,y_zero+y_offset,y_max+y_offset);
}

function line_label(x,y,text,align,baseline,color) {
  if (align != null) {
    window.$ctx.textAlign = align;
  }
  if (baseline != null) {
    window.$ctx.textBaseline = baseline;
  }
  if (color == null) {
    color = "#333333";
  }
  window.$ctx.fillStyle=color;
  // alert(window.$ctx.font);
  // window.$ctx.font="10px sans-serif";
  window.$ctx.fillText(text,x,window.$canvas.height-y);
}

function offset_label(x,y,text,x_offset,y_offset,align,baseline,color) {
  line_label(x+x_offset,y+y_offset,text,align,baseline,color);
}

function scaleAndOffset(y_value, element) {
  var distance = $(element).data('physical-maximum') - $(element).data('physical-minimum');
  return (y_value - $(element).data('physical-minimum')) * (window.$signal_height / (distance)) - (window.$signal_height / 2);
}

function drawGrid(element, x_offset, y_offset) {
  y_axis_top = scaleAndOffset($(element).data('physical-maximum'), element);
  y_axis_bottom = scaleAndOffset($(element).data('physical-minimum'), element);
  signal_canvas_width = window.$canvas.width - x_offset;
  starting_number =  ($("#epoch_number").val() - 1) * 5;
  ending_number = starting_number + 5; // $("#epoch_window").val()

  for (var i=starting_number, l=ending_number+1; i < l; i+=1) {
    spacing = signal_canvas_width / (ending_number-starting_number);
    total_seconds = i * $("#epoch_window").val() / (ending_number-starting_number);
    hours = Math.floor(total_seconds / 3600);
    minutes = Math.floor((total_seconds - (hours * 3600)) / 60);
    seconds = total_seconds - (hours * 3600) - (minutes * 60);
    time_label = pad(hours,2) + ":" + pad(minutes,2) + ":" + pad(Math.round(seconds * 100) / 100,2);
    offset_label((i-starting_number)*spacing,y_axis_top,time_label,x_offset,y_offset,(i == starting_number ? 'left' : (i == ending_number ? 'right' : 'center')),'bottom','#777');
    offset_line((i-starting_number)*spacing,y_axis_top,(i-starting_number)*spacing,y_axis_bottom,1,"#ededed",x_offset,y_offset);
  }
}

function drawSignal(array,x_offset,y_offset,label,samples_per_data_record,element) {
  if (y_offset == null) {
    y_offset = 150;
  }
  if (x_offset == null) {
    x_offset = 70;
  }

  offset_label(-30,0,label,x_offset,y_offset,'right',null);

  var signal_canvas_width = window.$canvas.width - x_offset;
  var zoom_level = signal_canvas_width / $('#myCanvas').data('samples-per-page');

  var magnitude_x = zoom_level*1/samples_per_data_record;

  var y_axis_top = scaleAndOffset($(element).data('physical-maximum'), element);
  var y_axis_center = scaleAndOffset(0, element);
  var y_axis_bottom = scaleAndOffset($(element).data('physical-minimum'), element);

  offset_label(-10,y_axis_top,$(element).data('physical-maximum'),x_offset,y_offset,null,'middle',null);
  offset_label(-10,y_axis_bottom,$(element).data('physical-minimum'),x_offset,y_offset,null,'middle',null);

  offset_line(0,y_axis_center,signal_canvas_width,y_axis_center,1,"#ededed",x_offset,y_offset);

  if ($(element).data('physical-minimum') != 0 && $(element).data('physical-maximum') != 0){
    offset_label(-10,y_axis_center,"0.0",x_offset,y_offset,null,'middle','#ededed');
  }

  if ($("#grid").val() != '0') {
    drawGrid(element, x_offset, y_offset);
  }

  for (var i=0, l=array.length; i < l; i+=1) {
    if ( i < l - 1 ) {
      y_start = scaleAndOffset(array[i], element);
      y_end = scaleAndOffset(array[i+1], element);

      if ($("#color").val() == '1') {
        y_zero = scaleAndOffset(0, element);
        y_max = scaleAndOffset($(element).data('physical-maximum'), element);
        offset_box(i*magnitude_x, y_start,(i+1)*magnitude_x, y_end,x_offset,y_offset,y_zero,y_max);
      }

      offset_line(i*magnitude_x, y_start,(i+1)*magnitude_x, y_end,1,null,x_offset,y_offset);
    }
  }
}

function getMousePos(evt) {
  var rect = window.$canvas.getBoundingClientRect();
  return {
    x: evt.clientX - rect.left,
    y: evt.clientY - rect.top
  };
}

function ready () {
  window.$canvas = $("#myCanvas")[0];
  window.$ctx = window.$canvas.getContext("2d");
  window.$signal_height = $("#myCanvas").data('signal-height');
  window.$signal_padding = $("#myCanvas").data('signal-padding');

  // line(window.$canvas.width, 0, window.$canvas.width, window.$canvas.height, 2, '#FF0000');

  $("[data-object='signal-data']").each(function(index){
    drawSignal($(this).data('array'),100,window.$canvas.height-(window.$signal_padding + (window.$signal_height / 2) + index*(window.$signal_height+window.$signal_padding)),$(this).data('label'),parseInt($(this).data('samples-per-data-record')),$(this));
    $(this).removeAttr('data-array');
  });

  // window.$canvas.addEventListener('mouseup', function(evt) {
  //   var mousePos = getMousePos(evt);
  //   point(mousePos.x, mousePos.y);
  // }, false);
}

$(document).ready(ready);
$(document).on("page:load", function() {
  ready();
  window.scrollTo(window.$prevPageXOffset, window.$prevPageYOffset);
});
$(document).on("page:change", function() {
  window.$prevPageYOffset = window.pageYOffset;
  window.$prevPageXOffset = window.pageXOffset;
});

$(document).keydown( function(e) {
  if(e.which == 37 && !$("input, textarea, select, a").is(":focus")){
    $("#retreat")[0].click();
    return false;
  }
  if(e.which == 39 && !$("input, textarea, select, a").is(":focus")){
    $("#advance")[0].click();
    return false;
  }
});
