Feature: manage campaigns

  as a Recruiter
  so that I can manage my recruitment campaigns
  I want to be able to modify my existing campaigns

Background: recruiter setup

  Given that I am logged in as a recruiter

Scenario: Can add candidates to an active campaign
  Given that I have an active campaign
  And I am on the campaign page
  And I click on "Agregar Candidatos"
  Then I should be on the enter more candidates page

Scenario: Cannot add candidates to a closed campaign
  Given that I have a closed campaign
  And I am on the campaign page
  And I click on "Agregar Candidatos"
  Then I should be back on the campaign page
  And I should see "Sorry, your campaign is closed"

Scenario: Can change deadline on an active campaign
  Given that I have an active campaign
  And I am on the campaign page
  And I click on "Modificar Fecha Límite"
  Then I should be on the change deadline page
  When I select "30" from "campaign[deadline(3i)]"
  And I select "Diciembre" from "campaign[deadline(2i)]"
  And I click on "Guardar"
  Then my campaign deadline should have day "30"
  And my campaign deadline should have month "12"
  And I should be back on the campaign page
  And I should see "Fecha Límite Modificada Exitosamente."

Scenario: Can modify the questions on a campaign
  Given that I have an active campaign
  And I have added a "text" question to the campaign with content "my_question"
  And I am on the campaign page
  And I click on "Editar Preguntas"
  Then I should be on the show questions page
  And I should see "my_question"
  When I click on "Editar Preguntas Escritas"
  Then I should be on the edit text questions page
  When I click on "Guardar"
  Then I should be on the show questions page
  When I click on "Regresar a Entrevista"
  Then I should be back on the campaign page

Scenario: Can switch recommend friends boolean after creation
  Given that I have an active campaign
  And I am on the campaign page
  Then I should see "Recomendar Amigos"
  And I should see "Permitido"
  When I click on "deny_recommend_friends"
  Then I should be back on the campaign page
  And I should see "No Permitido"
  And recommend friends should be "false"
  When I click on "allow_recommend_friends"
  Then I should be back on the campaign page
  And I should see "Permitido"
  And recommend friends should be "true"

Scenario: Can switch candidate references boolean after creation
  Given that I have an active campaign
  And I am on the campaign page
  Then I should see "Pedir Referencias"
  And I should see "Sí"
  When I click on "No Pedir"
  Then I should be back on the campaign page
  And I should see "No"
  And candidate references should be "false"

Scenario: Can close a campaign
  Given that I have an active campaign
  And I am on the campaign page
  When I click on "Cerrar Entrevista"
  Then I should be back on the campaign page
  And I should see "La entrevista fue cerrada exitosamente."
  And campaign should be closed

Scenario: Can delete a campaign
  Given that I have an active campaign
  And I am on the campaign page
  When I click on "Borrar Entrevista"
  Then I should be back on the recruiter page
  And I should see "La entrevista fue eliminada exitosamente."
  And campaign should not exist