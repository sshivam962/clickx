@javascript
Feature: Create new location

  Background:
    Given there is a business user
    And I signin as a business user
    And I set page size to include all elements

  Scenario: Create new location
    When I visit locations page
    And press new location button
    Then I must be in new location page
    When I fill the form
    And press save button
    Then I should be on locations page
    And a new location must be added



