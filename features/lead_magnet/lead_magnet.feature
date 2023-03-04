@javascript
Feature: Lead Magnet
  As a business user
  I should be able to create customized lead magnets
  To use in my websites to track users

  Background:
   Given there is a business
   And I'm a "Company User"
   And I set page size to include all elements
   When I go to the lead-magnets page

  Scenario: Creating a Lead Magnet
    Then I should see "Lead Magnet | Clickx" in the title of the page
    And I should see "0" Lead Magnet
    When I click on the link "Add Lead Magnet"
    When I filled the Lead Magnet Name field with "Lead Magnet 1"
    And I click on the link "Save"
    Then I should see "Lead Magnet Publish | Clickx" in the title of the page
    And I should see the text "Customize Lead Magnet 1" on the page
    And I should see "Pop Up" as active tab
    And I should see the Integrations button
    And I select the tab "Call To Action"
    And I should see the Lead Name edit option
    And I change the Lead Name to "Lead Magnet 2"
    And I should see the text "Customize Lead Magnet 2" on the page
    And I should see the 4 CTA link type option on top of the panel
    And I click on the link type "Content Link"
    Then I should see the lead magnet "Customize Content Link" panel
    And I should see the lead magnet "Content Link Preview" panel
    And I should see controls inside the Customize Content Link panel
    And I should see CTA link Preview inside the Content Link Preview panel
    When I click on the link type "Button Link"
    Then I should see the lead magnet "Customize Button Link" panel
    And I should see the lead magnet "Button Link Preview" panel
    And I should see controls inside the Customize Button Link panel
    And I should see CTA link Preview inside the Button Link Preview panel

    When I click on the link type "Image Link"
    Then I should see the lead magnet "Customize Image Link" panel
    And I should see the lead magnet "Image Link Preview" panel
    And I should see controls inside the Customize Image Link panel
    And I should see CTA link Preview inside the Image Link Preview panel

    When I click on the link type "Plain Text Link"
    Then I should see the lead magnet "Customize Plain Text Link" panel
    And I should see the lead magnet "Plain Text Link Preview" panel
    And I should see controls inside the Customize Plain Text Link panel
    And I should see CTA link Preview inside the Plain Text Link Preview panel

    When I click on the link "Save"
    Then I should see "Lead Magnet Publish | Clickx" in the title of the page
    And I should see the text "Customize Lead Magnet 2" on the page
    And I should see the lead magnet "Lead Magnet Form Settings" panel
    And I should see the lead magnet "Lead Magnet Customization" panel
    And I should see the lead magnet pop-up preview
    And I should see controls inside the Lead Magnet Form Settings panel
    And I should see controls inside the Lead Magnet Customization panel
    And I click on the "Templates" dropdown
    And I should be able to select any of the 4 templates
    And I click on the link "Publish"
    And I should see the "Settings updated successfully." success message
    And I click on the link "Get Snippet"
    Then I should see the get snippet modal
    And I should be able to send snippet to developer
    And I should see the "Email successfully sent" success message
    When I go to the lead-magnets page
    Then I should see "1" Lead Magnet

  Scenario: visit existing lead magnet
    When I click on the link "Add Lead Magnet"
    When I filled the Lead Magnet Name field with "Lead Magnet 2"
    And I click on the link "Save"
    When I go to the lead-magnets page
    Then I should see "1" Lead Magnet
    And I should see Edit, Archive and Analytics buttons
    When I click on the link Edit
    Then I should see "Lead Magnet Publish | Clickx" in the title of the page
    And I should see the text "Customize Lead Magnet" on the page
    When I go to the lead-magnets page
    Then I click on the "Analytics" link
    And I should see "Lead Magnet Analytics | Clickx" in the title of the page
    And I should see the text "Lead Magnet Analytics" on the page
    And I should see the Impressions, Unique Visitors, Total Opt-ins and Conversion Rate
    And I should see the "Lead Magnet Quick Information" panel
    When I am in the "lead-magnets" page
    Then I click on "Archive" link
    And I should see the "Archived Lead Magnets" panel
    And I should see "1" Archive Lead Magnet
    And I should see Delete and Restore buttons
    When I click on the link Restore
    Then I should see "0" Archive Lead Magnet
    And I should see "1" Lead Magnet
    When Archive lead magnet have a lead magnet
    And I click on the link Delete
    Then I should see "0" Archive Lead Magnet
    And I should see "0" Lead Magnet
