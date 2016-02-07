Feature: complete online interview

  as a Candidate
  so that I can try and get a job
  I want to be able to complete my online interview

Background: candidate setup

  Given that I am a Candidate

Scenario: am directed to interview start page if I have not completed it and is not closed
  When I go to the start interview link
  Then I should see "Bienvenido a tu entrevista virtual para el puesto de"

Scenario: am directed to interview start page if I have not completed it and is not closed
  Given I have completed my interview
  When I go to the start interview link
  Then I should see "Parece que ya has terminado tu entrevista virtual para el puesto de"

Scenario: am directed to interview start page if I have not completed it and is not closed
  Given my campaign is closed
  When I go to the start interview link
  Then I should see "Desafortunadamente ha pasado la fecha límite de "

Scenario: I can start the interview, add demographic data, complete text questions and move on to the voice interview and add my phone number
  Given that my campaign has 1 text question
  When I go to the start interview link
  And I fill in "candidate_profile_attributes_name" with "Simon"
  And I fill in "candidate_profile_attributes_surname_paternal" with "Bedford"
  And I select "Masculino" from "candidate_profile_attributes_gender"
  And I select "Soltero" from "candidate_profile_attributes_estado_civil"
  And I select "1" from "candidate_profile_attributes_dob_3i"
  And I select "Feb" from "candidate_profile_attributes_dob_2i"
  And I select "1983" from "candidate_profile_attributes_dob_1i"
  And I select "5,000" from "candidate_profile_attributes_desired_salary"
  And I check "privacy-consent"
  And I click on "Iniciar"
  Then I should be on the "text" interview page
  And I should see "Entrevista Virtual Paso 1 - Entrevista Escrita"
  When I fill in "answer_1" with "some text"
  And I click on "Continuar"
  Then I should be on the "voice" interview page
  And I should see "Entrevista Virtual Paso 2"
  And I should see "Número Telefónico"
  And the page should have input with id "phone_number"
  And I should not see "Celular"

Scenario: If there are additional filter questions, I can see them and answer them
	Given I have added a "filter" question to the campaign with content "Do you have experience in sales?"
  Given I have added a "text" question to the campaign with content "some text"
	When I go to the start interview link
  And I fill in "candidate_profile_attributes_name" with "Simon"
  And I fill in "candidate_profile_attributes_surname_paternal" with "Bedford"
  And I select "Masculino" from "candidate_profile_attributes_gender"
  And I select "Soltero" from "candidate_profile_attributes_estado_civil"
  And I select "1" from "candidate_profile_attributes_dob_3i"
  And I select "Feb" from "candidate_profile_attributes_dob_2i"
  And I select "1983" from "candidate_profile_attributes_dob_1i"
  And I select "5,000" from "candidate_profile_attributes_desired_salary"
  And I check "privacy-consent"
  And I click on "Iniciar"
  Then I should be on the answer filter questions page
  And I should see "Do you have experience in sales?"
  When I select a filter question answer
  And I click on "Continuar"
  Then I should be on the "text" interview page

Scenario: If I have an associated cel number, when I get to the voice interview I should see my cel number and also have the option of providing a landline number
  Given that my campaign has 1 text question
  And I have cel "5555555555"
  And I have started the interview
  And I have completed the text interview
  When I go to the start voice interview page
  Then I should see "Celular"
  And I should see "5555555555"
  And I should see "Número Telefónico"
  And the page should have input with id "phone_number"

Scenario: I can add friends if it is allowed
  Given I have started the interview
  And I have completed my interview
  When I go to the recommend friends page
  And I fill in "Candidate_friend_list" with "string1, string2, string3"
  And I click on "Agregar Amigos"
  Then I should be on the interview confirmation path
  And I should have "3" friends

Scenario: I can provide contact details for references, if required
  Given I have started the interview
  Given I have completed my interview
  When I go to the provide references page
  And I fill in "reference_1_name" with "reference_string_1"
  And I fill in "reference_1_email" with "reference_email_1"
  And I fill in "reference_1_relationship" with "reference_relationship_1"
  And I fill in "reference_2_name" with "reference_string_2"
  And I fill in "reference_2_email" with "reference_email_2"
  And I fill in "reference_2_relationship" with "reference_relationship_2"
  And I click on "Guardar"
  Then I should have 2 references
  And I should be on the recommend friends path

Scenario: I can submit a request for technical support
  When I go to the candidate technical support page
  And I fill in "issue_content" with "string"
  And I click on "Enviar"
  Then I should be on the issue page
  And I should see "Estaremos en contacto lo más pronto posible para ayudarte con tu problema."
  And the issue email should be the candidate email
  And the issue interview id should be the candidate uid
  And the issue category should be "candidate"
  And the issue content should be "string"
  And I should not see "Delete Issue"

Scenario: I can read the FAQs
  When I go to the start interview link
  And I click on "Preguntas Frecuentes"
  Then I should be on the Candidate FAQ path
  And I should see "Preguntas Frecuentes "
