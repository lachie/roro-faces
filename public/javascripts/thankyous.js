$(function() {
  $('img.beer').mouseover(function() {
    var m = this.id.match(/(u_\d+)_(\d+)/);
    var r = reasons[m[2]]

    $('#'+m[1]).html("<span class='byline'>for <strong>" + r[0] + "</strong> (from " 
                                       + r[1] + " &mdash;" 
                                       + r[2] + " ago)</span>");
  })
  
  $('img.beer').mouseout(function() {
    var m = this.id.match(/(u_\d+)_\d+/);
    $('#'+m[1]).html('&nbsp;');
  })
})