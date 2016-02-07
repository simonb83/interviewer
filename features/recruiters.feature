Feature: recruiter manage account

  as a Recruiter
  so that I can manage my account
  I want to be able to complete administrative tasks

Background: recruiter setup
  Given that I am logged in as a recruiter

Scenario: I can submit a request for technical support
  When I go to the recruiter technical support page
  And I fill in "issue_content" with "string"
  And I click on "Enviar"
  Then I should be on the issue page
  And I should see "Estaremos en contacto lo más pronto posible para ayudarte con tu problema."
  And the issue email should be the recruiter email
  And the issue category should be "recruiter"
  And the issue content should be "string"
  And I should not see "Delete Issue"

Scenario: As a newly registered user I should see no campaigns text in campaigns table
  When I visit the recruiter page
  Then I should see "Actualmente no tienes ninguna entrevista"

Scenario: If I have at least one campaign, the campaigns table should be populated
  Given I have at least one campaign
  When I visit the recruiter page
  Then I should see the position name
  And I should not see "Actualmente no tienes ninguna entrevista"

  Scenario: As a newly registered user I should see no messages text in campaigns table
  When I visit the recruiter page
  Then I should see "Actualmente no tienes ningún mensaje"

Scenario: If I have received at least one message, the messages table should be populated
  Given I have at least one campaign
  Given I have at least one message
  When I visit the recruiter page
  Then I should see the message interview id
  And I should not see "Actualmente no tienes ninguna mensaje"

Scenario: I have received at least one message, then I can delete it
  Given I have at least one campaign
  Given I have at least one message
  When I visit the recruiter page
  And I click on "Eliminar"
  Then I should see "Actualmente no tienes ningún mensaje"
  And the message should not exist

Scenario: I can see and manage my Candidate Limits
  Given that my account has 10 Candidates included
  When I visit the recruiter page
  Then I should see "Candidatos Usados: 0"
  And I should see "Candidatos Restantes: 10"
  Given that I create a campaign
  Then I should have 1 campaign
  Given that I add 2 candidate to my campaign
  When I visit the recruiter page
  Then I should see "Candidatos Usados: 2"
  And I should see "Candidatos Restantes: 8"
  Given that the first candidate has commenced his interview
  When I visit my campaign page
  And I click on candidate 0
  And I click on "Borrar Candidato"
  Then I should see "Candidatos Usados: 2"
  When I click on candidate 1
  And I click on "Borrar Candidato"
  Then I should see "Candidatos Usados: 1"
  And I should see "Candidatos Restantes: 9"
  Given that I have contracted 10 additional candidates
  When I visit the recruiter page
  Then I should see "Candidatos Usados: 1"
  And I should see "Candidatos Restantes: 19"

Scenario: I can still perform basic admin, but not add or manage campaigns when my account is suspended
  Given I have at least one campaign
  And my account has been suspended
  When I visit the recruiter page
  Then I should see "Tu cuenta ha sido suspendida. Por favor habla con el administrador de tu empresa o contáctanos aquí para reactivarla."
  When I click on "Nueva Entrevista"
  Then I should see "Ups! Acceso Denegado."
  When I visit my campaign page
  Then I should see "Ups! Acceso Denegado."
  When I click on "Editar Cuenta"
  Then I should be on the edit recruiter page