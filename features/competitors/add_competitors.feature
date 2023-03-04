@javascript
Feature: Add Competitors
  As a business user
  I should be able to add a new competitor

  Background:
    Given there is a business
    And I'm a "Company User"
    When I go to the competition page
    Then I should see "Competition | Clickx" in the title of the page
    And I set page size to include all elements
    
  Scenario: add a new competitor
    Then I should see the add competitors dialog box
    And I fill the competitors domain as "http://sampletest.com/"
    And I click on the Add submit button
    And I should see "Competition domain saved successfully" notification
    When I go to the competition page
    And I should see the link "sampletest.com" on the page

