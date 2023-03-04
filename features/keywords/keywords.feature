@javascript
Feature: Keywords
  As a business user who can access keywords feature
  I should be able to see the keywords dashboard
  And add various keywords to see the rankings from google analytics

  Background:
    Given there is a business
    And I'm a "Company User"
    And I set page size to include all elements
    When I go to the keywords page
    Given I set the required cookies
    Then I should see "View Keywords | Clickx" in the title of the page
    And I should see the text "Keywords" on the page
    And I click on the button "Add Keyword"
    And I should see the add keyword dialog box
    And I should be able to type keyword "competitors" in the box
    And I click on the button "Add" in the dialog box
    And I should see added keyword "competitors" in the page

  Scenario: Verify keywords feature
    # Verify the Export button with PDF
    When I click on the link "Export"
    Then I should see "PDF" template
    And I click on the "PDF" template

    # Verify the Export button with CSV
    When I click on the link "Export"
    And I should see "CSV" template
    And I click on the "CSV" template
    
    # Verify the Tags button when keyword is seleted
    And I should be able to Select keyword
    And I click on the button "Add Tags"
    And I should see the add tags dialog box
    And I should be able to type tags
    And I click on the button "Add" in the dialog box
    And I should see "Tags created" notification
    When I click on the link "Tags"
    And I should see the text "Tags" on the page
    Then I should be able to see added tags
    And I click on the added tags
    And I should be able to Select keyword
    And I click on the button "Untag"
    And I should be able to see the tag number as 0

    # Verify the Tags button when keyword is not seleted
    And I go to the keywords page
    When I click on the link "All Tags"
    And I should see the text "Not yet added any Tags" on the page
    Then I should not be able to see added tags

    # Verify the Back button in Tags page and Add Keyword button without search
    And I click on the link "Back"
    And I should see the text "Keywords" on the page

    # Verify the Opportunities button
    When I go to the competition page
    Then I should see "Competition | Clickx" in the title of the page
    And I should see the "Add Competitors" button
    Then I should see the add competitors dialog box
    And I fill the competitors domain as "http://sampletest.com/"
    And I click on the Add submit button
    And I should see "Competition domain saved successfully" notification
    When I go to the keywords page
    When I should have a link with text "Opportunities"
    And I click on the button "Opportunities" in the page
    And I should see the text "Keyword Opportunities" on the page
    And I should see the active tab "From Organic Traffic" in the page
    And I click on the "From Paid Traffic" tab

    # Verify the search of keywords
    And I go to the keywords page
    When I click on the keywords search field
    Then I enter the keyword "competitors" to search
    And I should see added keyword "competitors" in the page

    # Verify the filter - Keywords
    And I should have a filter with button named Keywords
    And I click on the "Keywords" filter
    And I should be able to filter content "Keywords"

    # Verify the filter - Google
    And I should have a filter with button named Google
    And I click on the "Google" filter
    And I should be able to filter content "Google"

    # Verify the filter - Search Volume
    And I should have a filter with button named Search Volume
    And I click on the "Search Volume" filter
    And I should be able to filter content "Search Volume"

    # Verify the time span 'Last 30 days'
    When I click on the dropdown "All Time"
    And I should see "This Month" template in dropdown
    And I click on the "This Month" template in dropdown
    And I should be able to select "This Month" as time span

    # Verify the filter - CPC  
    And I should have a filter with button named CPC
    And I click on the "CPC" filter
    And I should be able to filter content "CPC"

    # Verify the time span 'This Month'
    When I click on the dropdown "This Month"
    Then I should see "Last Seven days" template in dropdown
    And I click on the "Last Seven days" template in dropdown
    And I should be able to select "Last Seven days" as time span

    # Verify the filter - Keyword Difficulty
    And I should have a filter with button named Keyword Difficuty
    And I click on the "Keyword Difficulty" filter
    And I should be able to filter content "Keyword Difficulty"


    # Verify the time span 'Last Seven days'
    When I click on the dropdown "Last Seven days"
    And I should see "Last 30 days" template in dropdown
    And I click on the "Last 30 days" template in dropdown
    And I should be able to select "Last 30 days" as time span

    # Verify the Delete button
    And I click on the "Keywords" filter
    When I should see the "Delete Selected" button
    And I should be able to Select keyword
    And I click on the button "Delete Selected"
    And I should see "Keywords deleted successfully" notification

    # Verify Trash button                                                                 
    When I click on the link "Trash"
    Then I should be able to see the day and date
    And I should be able to see the deleted keyword

    # Verify the Delete button when select all keywords
    When I go to the keywords page
    And I click on the button "Add Keyword"
    And I should be able to type keyword "competitors" in the box
    And I click on the button "Add" in the dialog box
    And I should be able to Select All keyword
    And I click on the button "Delete Selected"
    And I should see "Keywords deleted successfully" notification