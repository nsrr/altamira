function point(x,y,width,color) {
  if (width == null) {
    width = 2;
  }
  if (color == null) {
    color = "#333333";
  }
  window.$ctx.fillStyle=color;
  window.$ctx.fillRect(x,window.$canvas.height-y,x+width,window.$canvas.height-y+width);
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

function line_label(x,y,text) {
  // window.$ctx.font="20px Georgia";
  window.$ctx.fillText(text,x,window.$canvas.height-y);
}

function offset_label(x,y,text,x_offset,y_offset) {
  line_label(x+x_offset,y+y_offset,text);
}

function drawSignal(array,x_offset,y_offset,label,samples_per_data_record) {
  if (y_offset == null) {
    y_offset = 150;
  }
  if (x_offset == null) {
    x_offset = 70;
  }

  offset_label(-100,0,label,x_offset,y_offset);


  var signal_canvas_width = window.$canvas.width - x_offset;
  var zoom_level = signal_canvas_width / $('#myCanvas').data('samples-per-page');

  offset_line(0,0,signal_canvas_width,0,1,"#ededed",x_offset,y_offset);

  var magnitude_x = zoom_level*1/samples_per_data_record;
  var magnitude_y = 1;
  for (var i=0, l=array.length; i < l; i+=1) {
    if ( i < l - 1 ) {
      offset_line(i*magnitude_x, array[i]*magnitude_y,(i+1)*magnitude_x, array[i+1]*magnitude_y,1,null,x_offset,y_offset);
    }
  }
}

function ready () {
  window.$canvas = $("#myCanvas")[0];
  window.$ctx = window.$canvas.getContext("2d");

  // line(window.$canvas.width, 0, window.$canvas.width, window.$canvas.height, 2, '#FF0000');

  var canvas_height = window.$canvas.height;
  var signal_height = 260;
  $("[data-object='signal-data']").each(function(index){
    drawSignal($(this).data('array'),100,canvas_height-((signal_height / 2) + index*signal_height),$(this).data('label'),parseInt($(this).data('samples-per-data-record')));
    $(this).removeAttr('data-array');
  });
}

$(document).ready(function() {
  ready();
});
$(document).on('page:load', ready)
$(document).on("page:change", function() {
  window.$prevPageYOffset = window.pageYOffset;
  window.$prevPageXOffset = window.pageXOffset;
});
$(document).on("page:load", function() {
  window.scrollTo(window.$prevPageXOffset, window.$prevPageYOffset);
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
