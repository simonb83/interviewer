Feature: manage candidates

  as a Recruiter
  so that I can manage my recruitment campaigns
  I want to be able to perform actions on my candidates

Background: recruiter setup

  Given that I am logged in as a recruiter
  And that I have a candidate

Scenario: Can accept candidate
  Given that the candidate has completed both interview parts
  And I am on the campaign page
  And I click on "Aceptar"
  Then the candidate should be accepted

Scenario: Can reject candidate
  Given that the candidate has completed both interview parts
  And I am on the campaign page
  And I click on "Rechazar"
  Then the candidate should be rejected

Scenario: Can delete candidate
  Given I am on the candidate page
  And I click on "Borrar Candidato"
  Then I should be back on the campaign page
  And the candidate should not exist

Scenario: Can update candidate email
  Given I am on the candidate page
  And I click on "Editar Email"
  And I fill in "Email" with "newstring@factory.com"
  And I click on "Guardar"
  Then I should be on the candidate page
  And I should see "El email del candidato fue actualizado exitosamente."
  And the candidate email should be "newstring@factory.com"

Scenario: Can share candidates with others
  Given that the candidate has completed both interview parts
  And there is a second recruiter
  And I am on the candidate page
  When I click on "Compartir Candidato"
  And I fill in "message_freeform" with "string"
  And I select "Simon Bedford" from "message_array"
  And I click on "Compartir Candidato"
  Then I should be on the candidate page
  And I should see "El candidato fue compartido exitosamente con 2 destinarios."
  And the message interview id should be the candidate uid
  And the message should have "2" recipients

Scenario: Can view history of candidates
  Given that the candidate has already been interviewed before
  And I am on the candidate page
  Then I should see "Historia del Candidato"
  And I should see the previous position name
  And I should see the interview date
  And I should see the candidate decision

Scenario: Does not see history if Candidate does not have any
  Given I am on the candidate page
  Then I should not see "Historia del Candidato"