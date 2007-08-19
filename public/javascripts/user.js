Event.addBehavior({
  "#feed-list input:change": function() {
    var value = this.id.match(/aggregate_feed_(\d+)/)
    if(!value) return;
    
    var parameters = $H({'feed[aggregate]': $F(this)});
    new Ajax.Request("/feeds/"+value[1],{method:'put',parameters:parameters,asynchronous:true,evalScripts:true});
  },
  
  "#affiliations input[type!=radio]:change, #affiliations input[type=radio]:click": function() {
    var value = this.id.match(/^group_(\d+)/)
    
    if(!value) return;
    var id = value[1];
    
    var parameters = $H({
      group_id:  id
    });
    
    if(this.id.match(/^group_(\d+)_linked$/) && !$F("group_"+id+"_linked")) {
      parameters['linked']    = false
    } else {
      parameters['linked']    = true
      parameters['presenter'] = $F("group_"+id+"_presenter")
      parameters['regular'] = $F("group_"+id+"_kind_regular")
      parameters['visitor'] = $F("group_"+id+"_kind_visitor")
    }

    new Ajax.Request("/users/"+ user_id +";link_affiliation",
      {method:'post',parameters:parameters,asynchronous:true,evalScripts:true});
  },
  
  "#facet_kind:change": function() {
    var value = $F(this);
    
    if( value == '-1') {
      Element.replace('facet_kind_form','<div id="facet_kind_form"></div>');
    } else if( value == '0' ) {
      document.location = "/facet_kinds/new";
    } else if( value == '-2' ) {
      document.location = "/facet_kinds";
    } else {
      var parameters = { user_id: user_id, facet_kind_id: value };
      new Ajax.Request('/facets/new',{method:'get',parameters:parameters,evalScripts:true});
    }
    return false;
  }
});
