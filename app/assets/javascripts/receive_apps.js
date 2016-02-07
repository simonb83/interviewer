$(document).ready(function(){


  $("#auto_receive_app").hide();

  $("#toggle_auto_receive_apps").click(function(event){
    event.preventDefault();
    $("#auto_receive_app").toggle();
  });

  $("#show_receive_apps_details").click(function(event){
    event.preventDefault();
    $("#auto_receive_app").toggle();
  });

});