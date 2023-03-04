@javascript 
Feature: potential_competitors
  As a business user
  I should be able to view competitors based on common keywords

  Background:
    Given there is a business
    And I'm a "Company User"
    When I go to the competition page
    Then I should see "Competition | Clickx" in the title of the page
    And I should see the "Add Competitors" button
    Then I should see the add competitors dialog box
    And I fill the competitors domain as "http://sampletest.com/"
    And I click on the Add submit button
    And I should see "Competition domain saved successfully" notification
    When I click on the button "Potential Competitors" in the page
    Then I should see the text "Potential Competitors" on the page

  @potential_competitors
  Scenario: Verify the presence of elements in 'From Organic Traffic' tab 
    And I should see the active tab "From Organic Traffic" in the page
    And I should see the competitor on the From Organic Traffic tab

    # Verify the presence of elements in 'From Paid Traffic' tab
    When I click on the "From Paid Traffic" tab
    Then I should see the active tab "From Paid Traffic" in the page
    And I should see the competitor on the From Paid Traffic tab

    # Verify back button
    When I click on the button "Back" in the page
    Then I should see "Competition | Clickx" in the title of the page
    


    
