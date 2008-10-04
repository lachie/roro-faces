function blank(f) {
  return !f || !f.val() || $.trim(f.val()) == '';
}

jQuery(function($) {
  var txt = 'find your romates';
  var us = $('.user-search input');
  
  us.focus(function() {
    if(us.val() == txt) {
      us.val('');
      us.removeClass('blurred')
    }
  }).blur(function() {
    if(blank(us)) {
      us.val(txt);
      us.addClass('blurred');
    }
  }).blur();
  
  
  // var t = $('.toggler');
  // console.log(t.classes);
  
})