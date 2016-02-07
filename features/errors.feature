Feature: Enable custom error pages

@allow-rescue
Scenario: 404 Page
  When I visit "/foobar"
  Then I should see "Ups! Página no encontrado."
  And the response status should be "404"