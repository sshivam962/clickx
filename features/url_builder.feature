@javascript
Feature: URL Builder  

  Background:
    Given there is a business
    And I'm a "Company User"
    When I visit URL Builder page
    Given I set the required cookies
    Then I should see the title "Google Analytics Campaigns | Clickx"
    And I set page size to include all elements
    And I should be able to see the Add URL popup window
    And I should be able to fill the Website URL as "http://www.clickx.io/"
    And I should be able to fill the Campaign Source as "sample source"
    And I should be able to fill the Campaign Medium as "sample medium" 
    And I should be able to fill the Campaign Name as "sample name"
    And I should be able to fill the Campaign Term as "sample term"
    And I should be able to fill the Campaign Content as "sample test content"
    And I click on the Save button
    And I should be able to see the Campaign Name "sample name"
    And I should be able to see the Complete URL "http://www.clickx.io/?utm_source=sample source&utm_campaign=sample name&utm_medium=sample medium&utm_term=sample term&utm_content=sample test content"

  Scenario: Verify url builder feature
    # Verify the delete button
    And I should be able to close the window of link
    And I click on the icon Delete the Campaign
    And I should see "Url deleted Successfully" notification

    # Verify the Add A New URL button and table elements
    When I click on the link "Add A New URL"
    And I should be able to see the Add URL popup window
    And I should be able to fill the Website URL as "http://www.clickx.io/"
    And I should be able to fill the Campaign Source as "sample source"
    And I should be able to fill the Campaign Medium as "sample medium" 
    And I should be able to fill the Campaign Name as "sample name"
    And I should be able to fill the Campaign Term as "sample term"
    And I should be able to fill the Campaign Content as "sample test content"
    And I click on the Save button
    And I should be able to see the Campaign Name "sample name"
    And I should be able to see the Complete URL "http://www.clickx.io/?utm_source=sample source&utm_campaign=sample name&utm_medium=sample medium&utm_term=sample term&utm_content=sample test content"

    # Verify the Copy URL link
    When I click on the link "Copy URL"
    Then I should see "Custom url copied to clipboard" notification
  
    # Verify the Export button
    When I click on the link "Export"
    Then I should be able to see the "PDF" template

    # Verify the Edit the campaign
    When I click on the icon Edit the campaign
    And I should be able to see the Add URL popup window
    And I should be able to fill the Campaign Source as "edited source"
    And I should be able to fill the Campaign Medium as "edited medium" 
    And I should be able to fill the Campaign Name as "edited name"
    And I should be able to fill the Campaign Term as "edited term"
    And I should be able to fill the Campaign Content as "edited test content"
    And I click on the Submit button
    And I should be able to see the Campaign Name "edited name"
    And I should be able to see the Complete URL "http://www.clickx.io/?utm_source=edited source&utm_campaign=edited name&utm_medium=edited medium&utm_term=edited term&utm_content=sample test content"
    
    # Verify the Go to the URL icon
    When I click on the icon of Go to the URL
    And I should see the title "Clickx Marketing | Online SEO & Lead Generation Software"

    # Verify the Complete URL link
    And I should be able to close the window of link
    And I click on the complete URL
    And I should see the title "Clickx Marketing | Online SEO & Lead Generation Software"

    # Verify the Back button
    When I visit Call Analytics page
    Then I visit URL Builder page
    And I click on the link "Back" 
    Then I should see the title "Call Analytics | Clickx"


    