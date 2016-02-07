Feature: manage site as an admin

  as an Admin
  so that I can manage the app
  I want to be able to complete adminstrative tasks

Background: Admin setup
  Given that I am logged in as an Admin
  And there exists at least 1 account

Scenario: I can setup a new organization, view it and delete it
  When I click on "New Organization"
  Then I should see "Account Type"
  When I fill in "Name" with "My Organization"
  And I click on "Save"
  Then I should be on the manage organization page
  And I should see "My Organization"
  And I should see "MyString"
  And I should see correct anniversary date
  And I should see "Current Users: 0 of 2"
  And I should see "Current Candidates: 0 of 2"
  And I should see "Create New Recruiter"
  When I click on "Delete Organization"
  Then I should be back on my home page
  And I should see "My Organization Deleted"
  And "New Organization" should not exist

Scenario: I can create a new recruiter, view it and delete it
  Given that I have created an organization with name "New Org"
  And I am on the manage organization page
  When I click on "Create New Recruiter"
  And I fill in "Name" with "John Smith"
  And I fill in "Email" with "johnsmith@email.com"
  And I fill in "Password" with "default0000"
  And I click on "Save"
  Then I should be on the manage organization page
  And "John Smith" should belong to "New Org"
  When I go to edit "John Smith"
  Then I should be on the manage recruiter page for "John Smith"
  When I click on "Delete John Smith"
  Then I should be on the manage organization page
  And I should see "John Smith Deleted"
  And recruiter "John Smith" should not exist

Scenario: I can create a new questions category, add, edit and delete questions and edit and delete the category
  When I click on "New Category"
  And I fill in "Name" with "Extra Category"
  And I click on "Save"
  Then I should be on the category page for "Extra Category"
  When I click on "Add Question"
  And I fill in "Content" with "My new question"
  And I check "text_question"
  And I check "verbal_question"
  And I click on "Save"
  Then I should be on the category page for "Extra Category"
  And "Extra Category" should have a "text" question called "My new question"
  And "Extra Category" should have a "verbal" question called "My new question"
  When I click on delete for "text" question "My new question"
  Then I should be on the category page for "Extra Category"
  And "Extra Category" should not have a "text" question called "My new question"
  When I click on edit for "verbal" question "My new question"
  And I fill in "Content" with "My new new question"
  And I click on "Save"
  Then "Extra Category" should have a "verbal" question called "My new new question"
  When I click on edit category for "Extra Category"
  And I fill in "Name" with "Extra Category II"
  And I click on "Save"
  Then "Extra Category II" should exist
  And "Extra Category" should not exist
  When I click on "Delete Category"
  Then I should be back on my home page
  And "Extra Category II" should not exist


