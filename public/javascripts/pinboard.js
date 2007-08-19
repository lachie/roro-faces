Event.addBehavior({
  'div.pinuser:mouseover': function() {
    var uname = $('nick_'+this.id);
    
    if(!uname.style.position || uname.style.position=='absolute') {
      uname.style.position = 'absolute';
      Position.clone(this, uname, {
        setHeight: false,
        setWidth: false,
        offsetTop: (this.offsetHeight-8),
        offsetLeft: 7
      });
    }
    
    uname.show();
  },
  'div.pinuser:mouseout': function() {
    $('nick_'+this.id).hide();
  }
});