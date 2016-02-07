Feature: Recruiter First Login

  as a Recruiter
  so that my account is very secure
  I want to have to change my password on first login, but not thereafter

  Background: recruiter create
    Given that a recruiter account has been created with a generic password

  Scenario: When I first login I mut be directed to change my password page
    When I visit the home page
    And I fill in "email-input" with "myemail@email.com"
    And I fill in "password-input" with "mypassword"
    And I click on "Enviar"
    Then I should be on the change password page

   Scenario: When I login and am not a new-user, I am directed to my home page
    Given that the recruiter has already logged in once
    When I visit the home page
    And I fill in "email-input" with "myemail@email.com"
    And I fill in "password-input" with "mypassword"
    And I click on "Enviar"
    Then I should be back on the recruiter page

