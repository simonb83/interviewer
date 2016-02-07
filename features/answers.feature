Feature: add answers to questions

  as a Candidate
  so that I can complete my interview
  I want to be able to add answers to written questions

Background: candidate

  Given that I am a candidate
  And my campaign has two text questions
  And I have started the interview
  And I am on the text questions page

Scenario: am redirected back to answers page if I leave an answer blank
  When I fill in the first question with "text"
  And I click on "Continuar"
  Then I should see " Entrevista Virtual Paso 1 - Entrevista Escrita Pregunta 1"
  And I should see "Por favor, responde a todas las preguntas antes de continuar."

Scenario: if I answer all questions, then answers are saved and am redirected to start voice interview
  When I fill in the first question with "text"
  And I fill in the second question with "text"
  And I click on "Continuar"
  Then I should be on the start voice interview page
  And I should have two answers
