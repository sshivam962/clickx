@javascript
Feature: Common Backlinks
  As a business user
  I should be able to view competitors based on common backlinks

  Background:
    Given there is a business
    And I'm a "Company User"
    When I go to the competition page
    And I should see the "Add Competitors" button
    Then I should see the add competitors dialog box
    And I fill the competitors domain as "http://sampletest.com/"
    And I click on the Add submit button
    When I click on the button "Common Backlinks" in the page
    Then I should see the text "Common Backlinks" on the page

  @common_backlinks
  Scenario: Verify the Common Backlinks in the competitors dashboard
    Then I should see the table with URL and Count

    # Verify the Back button in the Competitors page
    When I click on the button "Back" in the page
    Then I should see "Competition | Clickx" in the title of the page
