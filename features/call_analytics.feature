@javascript
@call_analytics
Feature: Call Analytics

  Background:
    Given there is a business
    And I'm a "Company User"
    When I visit Call Analytics page
    Given I set the required cookies
    And I set page size to include all elements
    Then I should see the title "Call Analytics | Clickx"

  Scenario: Verify the elements in call analytics
    # Verify the pagination of table
    And I should see "10" contents on the table
    When I select the pagination dropdown "5"
    Then I should see "5" contents on the table

    # Verify the call details
    When I click on the plus icon
    Then I should be able to see the call start date and time
    And I should be able to see the inbound  number
    And I should be able to see the caller name
    And I should be able to see the call end date and time
    And I should be able to see the answered by number
    And I should be able to see the caller number

    # Verify the download of call audio
    Then I should be able to see the link "Download Recording"
    And I click on the link "Download Recording"

    # Verify the presence of elements in call analytics page
    And it should have three graphs and one table
    And a date range picker with date range of last 30 days

    # Verify the presence of Back button
    When I go to the keywords page
    When I visit Call Analytics page
    When I click on the link "Back" 
    Then I should see "View Keywords | Clickx" in the title of the page

