$(document).ready(function() {

  var displayQuestion = function(data,id) {
    var lastQuestion = $(".edit-questions-left-internal:last").attr('id') || '';
    var idVal = parseInt(lastQuestion.match(/[0-9]+/)) || 0;
    var newId = idVal + 1;
    var content = '<div class="edit-questions-wrapper">\n'+
                          '<div class="edit-questions-left-internal" id="question_'+newId+'">\n'+
                          '<strong>Pregunta '+newId+'</strong>\n'+
                          '</div>\n'+
                          '<div class="edit-questions-right-internal">\n'+
                          data+'\n'+
                          '</div>\n'+
                          '<div class="edit-questions-right-right-internal">\n'+
                          '<a href="/campaigns/'+c_id+'/remove_question?question_id='+id+'" class="button button-small" data-method="delete" id="delete_question_'+newId+'" rel="nofollow">Borrar Pregunta</a>\n'+
                          '</div>\n'+
                          '<div class="clear">\n'+
                          '</div>\n'+
                          '</div>\n';
    $(content).insertBefore('#end-edit-questions');
  };

  if($('#main-content').hasClass('select_questions_2'))
  {
    $('#save-question').live("click", function() {
      var id = $('#question-select-1').val();
      var url = '/campaigns/'+c_id+'/add_question';
      console.log(id,url);
      $.post( url, { campaign_id: c_id, question_id: id }, function(data) {
        console.log(data);
        displayQuestion(data['content'], data['id']);}, "json")
        .fail(function(data) {
          console.log(data);
          var obj = $.parseJSON(data.responseText);
          if(obj['question_id']){
            alert('La pregunta ya fue seleccionada para tu entrevista');
          }
          else if(obj['max_questions_error']){
            alert(obj['max_questions_error']);
          }
          else{
            alert("No su puedo agregar la pregunta");
          }
        });
    });

    $(".category-select").change(function() {
    var url = '/get_drop_down_options?category_id=' + $(this).val() + '&question_type=' + qType;
    var currentID = $(this).attr('id');
    var idVal = currentID.match(/[0-9]+/)
    var questionId = "#question-select-"+idVal
    $.get(url, function(data){
      $(questionId).empty();
      if(jQuery.isEmptyObject(data)) $(questionId).addOption("", "Seleccionar Pregunta");
      $.each(data, function(val, text) {
        $(questionId).append(
        $('<option></option>').val(val).html(text)
        );
      });
    }, "json");
    });

    $("#add-question-link").click (function() {
      // var lastQuestion = $(".category-select:last").attr('id');
      // var idVal = parseInt(lastQuestion.match(/[0-9]+/));
      var newId = 1;
      var content = '<div class="add-question-wrapper">\n'+
                            '<div class="edit-questions-step-2-right-col">\n'+
                            '<select id="category-select-'+newId+'" class="category-select"\n'+
                            'name="Integer['+newId+']">\n'+
                            '<option value="">Seleccionar Categoría</option>\n'+
                            '<option value="1">Los Básicos</option>\n'+
                            '<option value="2">Carácter y Motivaciones</option>\n'+
                            '<option value="3">Desarrollo Profesional</option>\n'+
                            '<option value="4">Educación</option>\n'+
                            '<option value="5">Experiencia Laboral</option>\n'+
                            '<option value="6">Valores e Integridad</option>\n'+
                            '<option value="7">Comunicación</option>\n'+
                            '<option value="8">Enfoque en el Cliente</option>\n'+
                            '<option value="9">Liderazgo</option>\n'+
                            '<option value="10">Logro de Resultados</option>\n'+
                            '<option value="11">Trabajo en Equipo</option>\n'+
                            '<option value="12">Preguntas en Inglés</option>\n'+
                            '</select>\n'+
                            '&nbsp;&nbsp;&nbsp;\n'+
                            '<select id="question-select-'+newId+'" class="question-select"\n'+
                            'name="Integer['+newId+']">\n'+
                            '<option value="">Seleccionar Pregunta</option>\n'+
                            '</select>\n'+
                            '&nbsp;&nbsp;&nbsp;\n'+
                            '<button id="save-question" class="button">Agregar</button>\n'+
                            '</div> <!-- Campaign Step 2 Right Column -->\n'+
                            '</div><!-- text-question-wrapper -->\n';
      $('#add-question-link').remove();
      $('#add-question').append(content);
      // $('#add-question-link').hide();
      var categoryId = "#category-select-"+newId;
      var questionId = "#question-select-"+newId;
      $(categoryId).change(function() {
        var url = '/get_drop_down_options?category_id=' + $(this).val() + '&question_type=' + qType;
        $.get(url, function(data){
          $(questionId).empty();
          if(jQuery.isEmptyObject(data)) $(questionId).addOption("", "Seleccionar Pregunta");
          $.each(data, function(val, text) {
            $(questionId).append(
              $('<option></option>').val(val).html(text)
            );
          });
          }, "json");
      });
    });
  }
});