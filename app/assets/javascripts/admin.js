$(document).ready(function () {

  if($('#edit-attributes'))
  {
    $('#view-attribute').click(function(event){
      event.preventDefault();
      $("#ele-attributes").remove();
      var id = $("#item_id").val();
      var type = $('input:radio[name=item_type]:checked').val();
      var url = '/get_element_attributes';
      var data_obj = {item_id: id, item_type: type};
      $.get(url, data_obj, function(data,status){
        var html = '<div id="ele-attributes">'+'<ul>'+'</ul>'+'</div>';
        $(html).insertBefore('#wrapper');
        $.each(data, function(k,v){
          $('#ele-attributes ul').append('<li>'+k+": "+v+'</li>');
        });
      }, "json").error(function(data){
        var html = '<div id="ele-attributes">'+'</div>';
        $(html).insertBefore('#wrapper');
        $('#ele-attributes').append(data.responseText);
      });
    });
  }

});