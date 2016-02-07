Feature: complete verbal interview

  as a Candidate
  so that I can complete my interview
  I want to be able to complete the verbal portion

Background: candidate

  Given that I am a candidate
  And my campaign has two verbal questions
  And I have started the interview
  And I have completed the text interview
  And Twilio is working

Scenario: I can successfully start the voice interview
  When I visit the start voice interview page
  And I fill in "phone_number" with "5556598547"
  And I click on "Llamarme"
  Then I should see "Entrevista de Voz en Progreso"