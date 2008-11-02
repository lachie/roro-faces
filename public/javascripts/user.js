(function($) {
  
  
function delete_facet() {
  var a   = $(this),
      div = a.parents('tr:first')
             .hide();
  
  $.post(a.attr('href'),{_method:'delete'},function(data,status) {
    if(status == 'success') {
      div.remove()
    } else {
      div.show()
    }
  })
  
  return false;
};


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
  
  
  $('.delete_facet').click(delete_facet);
  
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
        
        $('form',this).submit(function() {
          $.post(this.action, $(this).serialize(), function(data) {
            var row = $(data)
            
            $('.delete_facet',row).click(delete_facet);
            
            $('#facet-list').append(row);
            $('#facet_kind_form').empty();
            $("#facet_kind").val('-1');
          })
          return false;
        })
        
      })
    }
    return false;
  })
  
});

})(jQuery);
