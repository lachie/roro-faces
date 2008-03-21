$(function() {  
  var change = function() {
    var value = this.id.match(/^group_(\d+)/)
    
    if(!value) return;
    var id = value[1];
    
    var data = {
      group_id:  id
    };
    
    var group_id = '#group_'+id
    
    if(this.id.match(/^group_(\d+)_linked$/) && $(group_id+"_linked:checked").length < 1) {
      data['linked']    = false
    } else {
      data['linked']    = true
      data['presenter'] = $(group_id+"_presenter:checked"   ).length > 0
      data['regular']   = $(group_id+"_kind_regular:checked").length > 0
      data['visitor']   = $(group_id+"_kind_visitor:checked").length > 0
    }

    $(group_id).load("/users/"+ user_id +"/link_affiliation",data,function() {
        $("#affiliations "+group_id+" input[type!=radio]").change(change)
        $("#affiliations "+group_id+" input[type=radio] ").click(change)
    })

  }
  
  $("#affiliations input[type!=radio]").change(change)
  $("#affiliations input[type=radio] " ).click(change)
  
  function delete_facet() {
    
  }
  
  $("#facet_kind").change(function() {
    var value = $(this).val();
    
    if( value == '-1') {
      $('#facet_kind_form').html('<div id="facet_kind_form"></div>')
    } else if( value == '0' ) {
      document.location = "/facet_kinds/new";
    } else if( value == '-2' ) {
      document.location = "/facet_kinds";
    } else {
      var parameters = { user_id: user_id, facet_kind_id: value };
      
      $('#facet_kind_form').load('/facets/new',parameters,function() {
        console.log("loaded",this)
        
        $('form',this).submit(function() {
          $.post(this.action, $(this).serialize(), function(data) {
            $('#facet-list').append(data)
            $('#facet_kind_form').html('<div id="facet_kind_form"></div>')
          })
          return false;
        })
      })
    }
    return false;
  })
});
