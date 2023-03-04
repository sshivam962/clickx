@javascript
Feature: Competitors
  As a business user
  I should be able to see the Competitors page

  Background:
    Given there is a business
    And I'm a "Company User"
    When I go to the competition page
    And I set page size to include all elements
    Then I should see "Competition | Clickx" in the title of the page
    And I should see the "Add Competitors" button
    Then I should see the add competitors dialog box
    And I fill the competitors domain as "http://sampletest.com/"
    And I click on the Add submit button
    And I should see "Competition domain saved successfully" notification

  Scenario: Verify the competitors
    # Verify the Search form in the Competitors page
    Then I type "sampletest" in the search field
    And I should see the link "sampletest.com" on the page

    # Verify the pagination limit in the Competitors page
    When I add these competitors:
    | http://webs.com                 |
    | https://3.basecamp.com          |
    | http://google.com               |
    | http://facebook.com             |
    When I select the pagination dropdown
    Then I should select "5" as limit
    And I should see "5" table rows

    # Verify the Export button in the Competitors page
    When I click on the link "Export"
    Then I should be able to see PDF template

    # Delete the Competitors
    When I click on the link "Delete"
    Then I should see a delete confirmation window
    When I click on the button "Delete"
    Then I should see the delete message for "facebook.com"

    # Verify the View button in the Competitors page
    When I click on the link "View"
    Then I should see the text "basecamp.com" on the page
    Then I go to the Dashboard page

    # Verify the Back button in the Competitors page
    Then I go to the Dashboard page
    When I go to the competition page
    When I click on the button "Back" in the page
    Then I should see "Dashboard" in the title of the page

