$(document).ready(function () {

  if($('#main-content').hasClass('select_questions_1'))
  {
    $(".category-select").change(function() {
    var current_val = $(this).val();
    var url = '/get_drop_down_options?category_id=' + current_val + '&question_type=' + qType;
    var currentID = $(this).attr('id');
    var idVal = currentID.match(/[0-9]+/)
    var questionId = "#question-select-"+idVal
    $.get(url, function(data){
      $(questionId).empty();
      if(jQuery.isEmptyObject(data)) {$(questionId).addOption("", "Seleccionar Pregunta");}
      // $(questionId).addOption(data, false);
      $.each(data, function(val, text) {
        $(questionId).append(
        $('<option></option>').val(val).html(text)
        );
      });

    }, "json");
    });

    $("#add-question-link").click (function() {
      var lastQuestion = $(".category-select:last").attr('id');
      var idVal = parseInt(lastQuestion.match(/[0-9]+/));
      var newId = idVal + 1;
      var content = '<div class="text-question-wrapper">\n'+
                            '<div class="campaign-step-2-left-col">\n'+
                            '<strong>Pregunta '+(newId+1)+':</strong>\n'+
                            '</div> <!-- Campaign Step 2 Left Column -->\n'+
                            '<div class="campaign-step-2-right-col">\n'+
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
                            '</div> <!-- Campaign Step 2 Right Column -->\n'+
                            '</div><!-- text-question-wrapper -->\n';
      console.log(content);
      $(content).insertBefore('#wrapper-for-add-question');
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