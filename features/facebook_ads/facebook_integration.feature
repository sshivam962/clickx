@javascript
Feature: Facebook Ads
  As a Company User
  I should be able to see the graphs of facebook ad campaigns
  If Facebook ad integration is enabled for me

  Background:
    Given there is a business
    And I'm a "Company User"
    When I go to the facebook ads page
    Then I should see "Facebook Ads | Clickx" in the title of the page

  Scenario: Facebook ads is disabled for user
    Then I should see the text "No Ad Account found, Please reconnect your Facebook Ads!" on the page
    When I click on the link "Export" 
    Then I should be able to see PDF template
    And a date range picker with date range of last 30 days
    When I click on the button "Back" in the page

    # Facebook ads is enabled for user
    When business is authenticated with facebook
    And I add facebook integration
    And I go to the facebook ads page
    Then I should see the active tab "Campaigns"
    Then I should see the active tab "Adsets"
    Then I should see the active tab "Ads"
    When I click on the link "Campaigns"
    Then I should see the text "Clicks" on the page
    Then I should see the text "Impressions" on the page
    Then I should see the text "CPC" on the page
    Then I should have a link with text "Clicks"
    Then I should have a link with text "Impressions"
    Then I should have a link with text "CPC"
