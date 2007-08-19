Math.scale = function(v,lo,hi) {
  return lo + v * (hi-lo)
}

Math.clamped_random = function(lo,hi) {
  return lo + (hi-lo) * Math.random();
}

var Bubble = Class.create();

Object.extend(Bubble.prototype,{
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
    
    var e = this.element = document.createElement('img');
    e.setAttribute('class','user');
    e.setAttribute('src',this.image);
    
    Event.observe(e,'mouseover',this.mouseover.bindAsEventListener(this));
    Event.observe(e,'mouseout',this.mouseout.bindAsEventListener(this));
    Event.observe(e,'click',this.click.bindAsEventListener(this));
  },
  
  setup_shape: function() {
    this.element.setStyle({position: 'absolute'});
    
    this.dimensions = this.element.getDimensions();
    this.height = this.dimensions.height
    this.width  = this.dimensions.width
    
    //alert("dim:"+this.dimensions.height+" w:"+this.dimensions.width);
  },
  
  mouseover: function(e) {
    if(this.floating) {
      this.floating = false;
      this.element.setStyle({'z-index':'500'});
      this.glass.show_button_info(this);
    }
  },
  
  mouseout: function(e) {
    if(!this.floating) {
      this.floating = true;
      this.element.setStyle({'z-index':'2'})
      this.glass.hide_button_info();
    }
  },
  
  click: function(e) {
    document.location = '/users/'+this.id;
  },
  
  loop: function(position) {
    if(!this.floating) return;
    this.y = this.y + this.velocity * position;
    
    this.cumulative_time += position;
    
    if( this.y >= this.glass.height-40 ) {
      this.remove();
      return;
    }
    

    this.element.style['top']  = this.glass.scale_y(this.height-this.y)+'px';
    this.element.style['left'] = (this.wiggle()+this.glass.scale_x(this.x,this.y)-24)+'px';
  },
  
  wiggle: function() {
    return Math.round( 10 * Math.sin( (this.cumulative_time+this.wiggle_tweak) / this.wiggle_period) );
  },
  
  remove: function() {
    this.glass.remove_bubble(this);
    this.element.remove();
  },
  
  set_position: function(x,y) {
    this.y = y;
    this.x = x;
    
    this.element.style['top']  = this.glass.scale_y(this.height-y)+'px';
    this.element.style['left'] = (this.glass.scale_x(x)-24)+'px';
  },
  set_velocity: function(v) {
    this.velocity = v;
  }
});

Glass = {
  setup: function() {
    Glass.container = $('floaters');
    if(!Glass.container) return;
    
    Glass.dimensions = Glass.container.getDimensions();
    
    var delta = Position.positionedOffset(Glass.container);
    
    Glass.height = Glass.dimensions.height - delta[1] - 48;
    Glass.width  = Glass.dimensions.width; //  - 48
    
    Glass.mid_x = Math.round(Glass.width / 2);
    
    Glass.name_box = $('name-box');

    Glass.bubbles = $A();
    
    Glass.start();
  },
  
  start: function(time) {
    this.last_loop = new Date().getTime();
    
    if(!this.interval) 
      this.interval = setInterval(this.loop.bind(this), 40);
  },
  
  loop: function() {
    var timePos = new Date().getTime();
    var delta = timePos - this.last_loop;
    this.last_loop = timePos;
    
    this.loop_emitter(delta);
    this.bubbles.invoke('loop', delta);
  },
  
  emit_rate: 200,
  max_bubbles: 10,
  last_emit: 0,
  
  loop_emitter: function(position) {
    if(this.bubbles.size() >= this.max_bubbles ) {
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
    
    b.set_position(x,14);
    b.set_velocity(v);
    
    this.add_bubble(b);
    
    b.setup_shape();
  },
  
  scale_x: function(x,y) {
    return x + this.mid_x;
  },
  
  scale_y: function(y) {
    return Math.round(this.height + y);
  },
  
  add_bubble: function(bubble) {
    this.bubbles.push(bubble);
    this.container.appendChild(bubble.element);
  },
  
  remove_bubble: function(bubble) {
    this.bubbles = this.bubbles.reject(function(b) {
      return b == bubble
    })
  },
  
  show_button_info: function(b) {
    Position.clone(b.element,this.name_box,{
      setHeight: false,
      setWidth: false,
      offsetTop: b.element.offsetHeight
    });
    this.name_box.show();
    this.name_box.innerHTML = b.name;
  },
  hide_button_info: function() {
    this.name_box.hide();
  }
};


Event.observe(window,'load',function() {
  if(typeof Rules != 'undefined') {
    EventSelectors.start(Rules);
  }
});

Event.observe(window,'load',Glass.setup);