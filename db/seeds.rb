# encoding: UTF-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Create site admin
Admin.create(email: "simon.bedford@gmail.com", password: "gb7Tqu4bY", password_confirmation: "gb7Tqu4bY")

@organization = Organization.create(name: 'First Organization')
recruiters = Recruiter.create([{
  name: "John Smith",
  email: "johnsmith@email.com",
  password: "abcdefgh",
  password_confirmation: "abcdefgh",
  organization: @organization
  },
  {
  name: "Jane Doe",
  email: "janedoe@email.com",
  password: "abcdefgh",
  password_confirmation: "abcdefgh",
  organization: @organization
  }])

#Category 1 - Los Básicos
basicos = ["¿Qué te interesa de esta vacante?", "¿Qué es lo que te atrae de esta empresa?", "¿Qué sabes acerca de nuestra empresa?", "¿Qué sabes acerca de esta industria?", "¿Cuáles son tus fortalezas? Descríbelas con 3 adjetivos", "¿Cuáles son tus debilidades? Descríbelas con 3  adjetivos", "¿Estás trabajando en algún plan de mejora de las debilidades mencionadas previamente?", "¿Cómo utilizas tus fortalezas en tu vida profesional diaria?", "¿Por qué deberíamos de contratarte en lugar de otra persona con las mismas cualidades?", "Si habláramos a tus empleos anteriores, ¿qué referencias darían de ti?", "Si fueras contratado, ¿qué harías durante los primeros 30 días?", "Describe que hiciste durante los primeros 30 días de un empleo anterior.", "¿Cuál es tu expectativa de compensación?", "En tus tiempos libres, ¿qué te gusta hacer?"]

basico = Category.create(name: 'Los Básicos')
basicos.each do |q|
  Question.create(content: q, kind: 'text', category: basico)
  Question.create(content: q, kind: 'verbal', category: basico)
end

#Category 2 - Carácter y Motivaciones
caracter_mot = ["¿Qué es lo que más disfrutas de tu profesión o trabajo actual?", "Enlista 5 palabras que te describen como persona.", "¿Cómo te describirían tus amigos?", "¿De qué estás más orgulloso en tu vida?", "¿Quién ha impactado más en tu vida? ¿Por qué?", "¿Cuáles son las técnicas y/o herramientas que utilizas para organizar tu tiempo?", "¿Cuál ha sido la decisión profesional más difícil que has tenido que tomar?", "¿Qué decisión tomaste que no resultó como tu querías? ¿Cuál fue el resultado?", "¿Cómo te sentirías al trabajar para alguien que sepa menos que tu?", "Si tuvieras que entrevistar a alguien para este puesto, ¿Qué buscarías en el candidato?"]

caracter = Category.create(name: 'Carácter y Motivaciones')
caracter_mot.each do |q|
  Question.create(content: q, kind: 'text', category: caracter)
  Question.create(content: q, kind: 'verbal', category: caracter)
end

#Category 3 - Desarrollo Profesional
des_profesional = ["¿Qué buscas en términos de desarrollo profesional?", "¿Qué quieres desarrollar o mejorar profesionalmente durante el próximo año?", "Si pregunto a tu supervisor actual o anterior cuáles son tus áreas de oportunidad, ¿qué respuestas obtendría?", "Si pregunto a tu supervisor actual o anterior cuáles son las áreas técnicas que necesitas mejorar, ¿qué respuestas obtendría?", "¿Cuál fue la retroalimentación más significativa que has recibido y qué hiciste con ella?", "Describe tu puesto ideal; toma en cuenta responsabilidades y metas profesionales.", "Describe las características que debería tener tu empleador ideal.", "¿Cuáles son las metas para tu carrera a corto, mediano y largo plazo?"]

cat_des_profesional = Category.create(name: 'Desarrollo Profesional')
des_profesional.each do |q|
  Question.create(content: q, kind: 'text', category: cat_des_profesional)
  Question.create(content: q, kind: 'verbal', category: cat_des_profesional)
end

#Category 4 - Educación
education = ["¿Por qué escogiste tu especialidad de estudios?", "¿Cuál es o era la parte favorita de tus estudios?", "Explica tu especialidad de estudios como si fuera a una persona que no la conoce.", "Después de conocer tu carrera ¿La cambiarías si tuvieras una segunda oportunidad de escoger? Explica por qué."]

cat_education = Category.create(name: 'Educación')
education.each do |q|
  Question.create(content: q, kind: 'text', category: cat_education)
  Question.create(content: q, kind: 'verbal', category: cat_education)
end

#Category 5 - Experiencia Laboral
exp_laboral = ["¿Cuáles fueron tus últimos dos empleos?", "¿Cuál ha sido tu experiencia laboral más significativa?", "Describe tu experiencia relevante para una posición en ventas.", "Describe tu experiencia relevante para una posición en servicio a clientes.", "Describe tu experiencia relevante para una posición en mercadotecnia o publicidad.", "¿Por qué estás dejando tu puesto actual?", "¿Por qué dejaste tu último puesto?", "¿Cuáles fueron tus responsabilidades más importantes en tu último puesto?", "¿Cuándo estuviste más satisfecho laboralmente? Explica por qué y qué estabas haciendo.", "¿Cuándo estuviste menos satisfecho laboralmente? Explica por qué y qué estabas haciendo."]

cat_exp_laboral = Category.create(name: 'Experiencia Laboral')
exp_laboral.each do |q|
  Question.create(content: q, kind: 'text', category: cat_exp_laboral)
  Question.create(content: q, kind: 'verbal', category: cat_exp_laboral)
end

#Category 6 - Valores e Integridad
valores_integridad = ["Para ti ¿qué es integridad?", "¿Cómo ganas la confianza de los demás?", "En una escala del 1 al 10 ¿Qué tan íntegro te consideras? ¿Por qué?", "¿Puedes describir una ocasión cuando tu trabajo fue criticado? ¿Qué hiciste y cuál fue el resultado?", "¿Puedes describir una ocasión en donde tu integridad haya sido cuestionada? ¿Qué hiciste y cuál fue el resultado?", "¿Qué valores, con los que te identificas, buscas en una empresa?", "¿En qué contexto laboral o de negocios sería justificada la deshonestidad?", "¿Qué harías si descubres que tu empleador (compañía y/o líder) está haciendo algo ilegal, como cometer fraudes?"]

valores = Category.create(name: 'Valores e Integridad')
valores_integridad.each do |q|
  Question.create(content: q, kind: 'text', category: valores)
  Question.create(content: q, kind: 'verbal', category: valores)
end

#Category 7 - Comunicación
comunicacion = ["¿Cómo calificas tus habilidades de comunicación en una escala de 1 al 5, donde 1 es deficiente y 5 es excelente. Da 3 ejemplos de tus experiencias que justifican esta calificación.", "Cuando entras a una nueva organización, ¿qué haces para conocer y construir relaciones con otras personas?", "Describe una ocasión donde tuviste una conversación difícil con otra persona. ¿Qué hiciste y cuál fue el resultado?", "¿Puedes dar un ejemplo de cuando eras parte de un proyecto o equipo, y no sabías lo que hacían los otros miembros del equipo? ¿Qué hiciste y cuál fue el resultado?", "¿Puedes dar un ejemplo de cuando pudiste comunicarte exitosamente con una persona difícil, mientras otros no lo lograron? ¿Qué hiciste y cuál fue el resultado?", "¿Cómo comunicarías tu punto de vista en una junta si supieras que los demás no lo quieren escuchar o aceptar?", "¿Cuál fue tu experiencia más exitosa al hablar en público? ¿Qué hiciste y cuál fue el resultado?"]

coms = Category.create(name: 'Comunicación')
comunicacion.each do |q|
  Question.create(content: q, kind: 'text', category: coms)
  Question.create(content: q, kind: 'verbal', category: coms)
end

#Category 8 - Enfoque en el Cliente
enfoque_cliente = ["Describe una ocasión cuando ayudaste a otra persona a lograr un objetivo o meta importante. ¿Qué hiciste?", "Nombra a una empresa que, para ti, ofrece excelente servicio al cliente. ¿Qué es lo que le da la diferencia?", "Para ti, ¿cuál es la esencia de un servicio al cliente extraordinario?", "Describe la mejor experiencia de servicio al cliente que has tenido. ¿Qué fue lo que lo hizo especial?", "Describe la peor experiencia de servicio al cliente que has tenido. ¿Qué fue lo que salió mal?"]

customer_focus = Category.create(name: 'Enfoque en el Cliente')
enfoque_cliente.each do |q|
  Question.create(content: q, kind: 'text', category: customer_focus)
  Question.create(content: q, kind: 'verbal', category: customer_focus)
end

#Category 9 - Liderazgo
liderazgo = ["Describe las cualidades de un buen líder.", "Describe al mejor líder con quien has trabajado.", "Describe las características de un mal líder.", "Describe al peor líder con quien has trabajado.", "¿Con qué tipo de liderazgo te identificas mejor?", "Menciona la característica más importante que un buen líder debe tener (sólo menciona una)."]

leadership = Category.create(name: 'Liderazgo')
liderazgo.each do |q|
  Question.create(content: q, kind: 'text', category: leadership)
  Question.create(content: q, kind: 'verbal', category: leadership)
end

#Category 10 - Logro de Resultados
lograr_resultados = ["¿Cuál fue el último proyecto en el que participaste, y cuál fue el resultado? ¿Cómo contribuiste personalmente?", "¿Cuál es la meta más importante que has logrado en tu vida? ¿Qué hiciste y cuál fue el resultado?", "Describe una situación donde tuviste que lograr una meta muy agresiva. ¿Cuál fue la situación? ¿Qué hiciste y cuál fue el resultado?", "Describe cómo manejaste una situación donde tuviste que terminar muchas cosas antes del fin del día, pero fue imposible lograrlo.", "Describe una situación donde no lograste una meta. ¿Cuál era la meta? ¿Qué hiciste y cuál fue el resultado?"]

resultados = Category.create(name: 'Logro de Resultados')
lograr_resultados.each do |q|
  Question.create(content: q, kind: 'text', category: resultados)
  Question.create(content: q, kind: 'verbal', category: resultados)
end

#Category 11 - Trabajo en Equipo
trabajo_equipo = ["Describe las tres cosas que haces para pertenecer a un nuevo equipo.", "¿Cómo te sientes más motivado: analizando datos e información interesante, o colaborando con otras personas? ¿Por qué?", "Describe una experiencia positiva de trabajar en equipo. ¿Qué disfrutaste de ella?", "¿Puedes describir una experiencia trabajando en equipo que te haya decepcionado? ¿Qué pudiste haber hecho para prevenirlo?", "Describe una situación de trabajo en equipo donde otro miembro no contribuyó apropiadamente? ¿Qué hiciste y cuál fue el resultado?", "¿Cuáles son los aspectos de trabajar en equipo que representan un reto para ti?"]

teamwork = Category.create(name: 'Trabajo en Equipo')
trabajo_equipo.each do |q|
  Question.create(content: q, kind: 'text', category: teamwork)
  Question.create(content: q, kind: 'verbal', category: teamwork)
end

#Category 12 - Preguntas en Inglés
english = ["What attracts you to this position?", "How would your friends describe you?", "What was the most significant piece of feedback you received and how did you use it?", "What do you most enjoy about your profession or your current job?", "What has been your most significant piece of work experience?", "How do you go about earning the trust of other people?", "When you enter a new organization, what do you do to start meeting and building relationships with others?", "Name a company that you believe offers excellent customer service. What makes them different?", "Describe the qualities of a good leader.", "What is the most important goal you have achieved in your life? How did you achieve it and what was the result?", "Describe a positive experience you have had of working in a team. What did you enjoy about it?"]

english_questions = Category.create(name: 'Preguntas en Inglés')
english.each do |q|
  Question.create(content: q, kind: 'text', category: english_questions)
  Question.create(content: q, kind: 'verbal', category: english_questions)
end
