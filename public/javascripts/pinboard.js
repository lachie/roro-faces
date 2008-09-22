$(function() {
  $('.pinuser').mouseover(function() {
    var offset = $(this).offset();

    $('#nick_'+this.id).css({
      'top' : offset.top+$(this).height()-4,
      'left': offset.left+7
    }).show()
    
  }).mouseout(function() {
    $('#nick_'+this.id).hide()
  })
})