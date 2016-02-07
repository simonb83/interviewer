$(document).ready(function () {

  if($('#main-content').hasClass('select_questions_gateway'))
  {
    function removeQuestion(id) {
      var question = $(document).find("#gateway-question-wrapper-1");
      console.log(question);
    }

    $("#add-gateway-question-link").click (function(event) {
      event.preventDefault();
      if ($(".gateway-question:last").length){
        var lastQuestion = $(".gateway-question:last").attr('id');
        var idVal = parseInt(lastQuestion.match(/[0-9]+/));
        var eliminateQID = "#eliminate-question-"+idVal;
        $(eliminateQID).hide();
      }
      else{
        var idVal = 0;
      }
      var newId = idVal + 1;
      var content = '<div class="text-question-wrapper">\n'+
                            '<div class="campaign-step-1A-left-col">\n'+
                            '<strong>Pregunta '+(newId)+':</strong>\n'+
                            '</div> <!-- Campaign Step 1A Left Column -->\n'+
                            '<div class="campaign-step-1A-middle-col">\n'+
                            '<textarea class="gateway-question" id="gateway-question-'+newId+'" name="questions[q_'+newId+'][content]" cols="45"></textarea>\n'+
                            '<br>Opción requerida: Sí \n'+
                            '<input id="requirement_true" type="radio" value="true" name="questions[q_'+newId+'][req]">\n'+
                            'No\n'+
                            '<input id="requirement_false" type="radio" value="false" name="questions[q_'+newId+'][req]">\n'+
                            '</div> <!-- Campaign Step 1A Middle Column -->\n'+
                            '<div class="campaign-step-1A-right-col">\n'+
                            '<a href="#" class="button button-small eliminate-question" id="eliminate-question-'+newId+'">Eliminar</a>\n'+
                            '</div> <!-- Campaign Step 1A Right Column -->\n'+
                            '<div class="clear"></div>\n'+
                            '</div><!-- text-question-wrapper -->\n';
      $(content).insertBefore('#wrapper-for-add-question');
      $(".eliminate-question").on("click", function(event){
        event.preventDefault();
        var id = parseInt($(this).attr('id').match(/[0-9]+/));
        var idVal = id-1;
        $(document).find("#eliminate-question-"+idVal).show();
        $(this).parentsUntil("form").remove();
      });
    });
  }
});