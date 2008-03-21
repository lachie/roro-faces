Math.scale = function(v,lo,hi) {
  return lo + v * (hi-lo)
}

Math.clamped_random = function(lo,hi) {
  return lo + (hi-lo) * Math.random();
}

var Bubble = function Bubble(glass,id,name,image) {
  this.initialize(glass,id,name,image);
}

Bubble.prototype = {
  initialize: function(glass,id,name,image) {
    this.glass = glass;
    this.id = id
    this.name = name
    this.image = image
    
    this.floating = true;
    this.wiggle_tweak = Math.clamped_random(20,40);
    this.wiggle_period = Math.clamped_random(50,70);
    
    this.cumulative_time = 0;
    
    this.add_element();
  },
  
  add_element: function() {

    var e = this.element = $('<img class="user" src="'+this.image+'"/>');
    $('#floaters').after(e)
    e.get(0).bubble = this
    
    // Event.observe(e,'mouseover',this.mouseover.bindAsEventListener(this));
    // Event.observe(e,'mouseout',this.mouseout.bindAsEventListener(this));
    // Event.observe(e,'click',this.click.bindAsEventListener(this));
    
    e.mouseover(this.mouseover)
    e.mouseout(this.mouseout)
    e.click(this.click)
  },
  
  setup_shape: function() {
    this.element.css('position','absolute');
    
    this.height = this.element.height()
    this.width  = this.element.width()
  },
  
  
  set_position: function(x,y) {
    this.y = y;
    this.x = x;
    
    var e = this.element.get(0)
    
    // this.element.css('top' ,this.glass.scale_y(this.height-y))
    // this.element.css('left',this.glass.scale_x(x)-24)

    e.style['top']  = this.glass.scale_y(this.height-y)+'px';
    e.style['left'] = (this.glass.scale_x(x)-24)+'px';
  },
  
  
  mouseover: function() {
    if(this.bubble.floating) {
      this.bubble.floating = false;
      this.bubble.element.css('z-index','500');
      Glass.show_button_info(this.bubble);
    }
  },
  
  mouseout: function() {
    if(!this.bubble.floating) {
      this.bubble.floating = true;
      this.bubble.element.css('z-index','2')
      Glass.hide_button_info();
    }
  },
  
  click: function(e) {
    document.location = '/users/'+this.bubble.id;
  },
  
  loop: function(position) {
    if(!this.floating) return;
    this.y = this.y + this.velocity * position;
    
    this.cumulative_time += position;
    
    if( this.y >= this.glass.height-40 ) {
      this.remove();
      return;
    }
    
    var e = this.element.get(0)
    
    // this.element.css('top' , this.glass.scale_y(this.height-this.y));
    // this.element.css('left', this.wiggle()+this.glass.scale_x(this.x,this.y)-24);

   e.style['top']  = this.glass.scale_y(this.height-this.y)+'px';
   e.style['left'] = (this.wiggle()+this.glass.scale_x(this.x,this.y)-24)+'px';
  },
  
  wiggle: function() {
    return Math.round( 10 * Math.sin( (this.cumulative_time+this.wiggle_tweak) / this.wiggle_period) );
  },
  
  remove: function() {
    this.glass.remove_bubble(this);
    this.element.remove();
  },

  set_velocity: function(v) {
    this.velocity = v;
  }
}

Glass = {
  setup: function() {
    Glass.container = $('#floaters');
    if(!Glass.container) return;
    
    var delta = Glass.container.offset();
    
    Glass.height = Glass.container.height() - delta.top - 48;
    Glass.width  = Glass.container.width(); //  - 48
    
    Glass.mid_x = Math.round(Glass.width / 2);
    
    Glass.name_box = $('#name-box');

    Glass.bubbles = [];
    
    Glass.start();
  },
  
  start: function(time) {
    this.last_loop = new Date().getTime();
    
    if(!this.interval) 
      this.interval = setInterval(Glass.loop, 40);
  },
  
  loop: function() {
    var timePos = new Date().getTime();
    var delta = timePos - Glass.last_loop;
    Glass.last_loop = timePos;
    
    Glass.loop_emitter(delta);
    
    $.each(Glass.bubbles,function(i,b) {
      b.loop(delta);
    })
  },
  
  emit_rate: 200,
  max_bubbles: 10,
  last_emit: 0,
  
  loop_emitter: function(position) {
    if(this.bubbles.length >= this.max_bubbles ) {
      this.last_emit = 0;
      return;
    }
    
    this.last_emit += position;
    
    if(this.last_emit > this.emit_rate) {
      this.last_emit = 0;
      this.emit_bubble();
    }
  },
  
  random_user: function() {
    return this.users[ Math.floor(Math.clamped_random(0,this.users.length)) ];
  },
  
  emit_bubble: function() {
    var u = this.random_user();
    if(!u) return;
    
    var b = new Bubble(this,u[0],u[1],u[2]);
    
    var x = Math.clamped_random(-106,106);
    var v = Math.clamped_random(0.02,0.05);
    
    this.add_bubble(b);

    b.setup_shape();
    b.set_position(x,14);
    b.set_velocity(v);

  },
  
  scale_x: function(x,y) {
    return x + this.mid_x;
  },
  
  scale_y: function(y) {
    return Math.round(this.height + y);
  },
  
  add_bubble: function(bubble) {
    this.bubbles.push(bubble);
    $(this.container).append(bubble.element);
  },
  
  remove_bubble: function(bubble) {
    this.bubbles = $.grep(this.bubbles,function(b) {
      return b != bubble
    })
  },
  
  show_button_info: function(b) {
    var offset = b.element.offset()
    
    this.name_box.css({
      top: offset.top+b.element.height(),
      left: offset.left
    })
    
    this.name_box.show();
    this.name_box.text(b.name);
  },
  hide_button_info: function() {
    this.name_box.hide();
  }
};

$(function() {
  Glass.setup();
})