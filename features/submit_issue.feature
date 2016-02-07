Feature: submit issue

  as an independent user
  so that I can get support
  I want to be able to submit a new issue

Scenario: I can submit a request for technical support
  When I go to the technical support page
  And I fill in "Email" with "email"
  And I fill in "Nombre" with "name"
  And I fill in "Entrevista" with "interview"
  And I fill in "issue_content" with "string"
  And I click on "Enviar"
  Then I should be on the issue page
  And I should not see "Delete Issue"
  And I should see "Estaremos en contacto lo más pronto posible para ayudarte con tu problema."
  And the issue email should be "email"
  And the issue name should be "name"
  And the issue interview id should be "interview"
  And the issue category should be "other"
  And the issue content should be "string"
  And the issue should be active