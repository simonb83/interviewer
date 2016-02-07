Feature: create a new campaign

  as a Recruiter
  so that I can manage my recruitment campaign
  I want to be able to create a new campaign

Background: recruiter setup

  Given that I am logged in as a recruiter

Scenario: I can create a campaign and am redirected to add text questions
  When I am on the new campaign page
  And I fill in "position-name-field" with "some text"
  And I choose "receive-apps-yes"
  And I choose "receive-copy-yes"
  And I choose "recommend-yes"
  And I choose "references-yes"
  And I click on "Continuar"
  Then I should be on the campaign choose text questions path
  And the campaign should have name "some text"
  And the campaign should have attribute "receive_applications" as "true"
  And the campaign should have attribute "forward_applications" as "true"
  And the campaign should have attribute "recommend_friends" as "true"
  And the campaign should have attribute "candidate_references" as "true"
  And the campaign should have company_name as "company"

Scenario: I can create a campaign and change the company name of the campaign
  When I am on the new campaign page
  And I fill in "company-name-field" with "Separate Company"
  And I fill in "position-name-field" with "some text"
  And I click on "Continuar"
  Then the campaign should have company_name as "Separate Company"

Scenario: I can create a campaign with gateway questions
  When I am on the new campaign page
  And I fill in "position-name-field" with "some text"
  And I choose "gateway-yes"
  And I click on "Continuar"
  Then I should be on the campaign choose filter questions path
  And I should see "Agregar preguntas de filtro"

Scenario: I can remove text questions from my new campaign
  Given that I have an active campaign
  And I have added 2 "text" questions to the campaign
  And I am on the questions confirmation path
  Then I should see a link for "Editar Preguntas Escritas"
  When I click on "Editar Preguntas Escritas"
  Then I should be on the edit questions page
  And I should see "Pregunta 1"
  And I should see "Pregunta 2"
  When I click on "delete_question_1"
  Then I should be on the edit questions page
  And I should see "Pregunta 1"
  And I should not see "Pregunta 2"

Scenario: I can remove verbal questions from my new campaign
  Given that I have an active campaign
  And I have added 2 "verbal" questions to the campaign
  And I am on the questions confirmation path
  And I should see a link for "Editar Preguntas de Voz"
  When I click on "Editar Preguntas de Voz"
  Then I should be on the edit questions page
  And I should see "Pregunta 1"
  And I should see "Pregunta 2"
  When I click on "delete_question_1"
  Then I should be on the edit questions page
  And I should see "Pregunta 1"
  And I should not see "Pregunta 2"
