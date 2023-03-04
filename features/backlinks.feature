@javascript
Feature: Backlinks

  Background:
    Given there is a business
    And I'm a "Company User"
    Then I'm in Backlinks page
    And I set page size to include all elements
    Given I set the required cookies

  Scenario: Verify the elements in overview tab
    And I should see "Backlinks Overview | Clickx" in the title of the page
    And I should see the text "Summary" on the page
    And I should be able to see the "Overview" tab
    And I should be able to see the "Backlinks" heading
    And I should be able to see the "Referring Domains" heading
    And I should be able to see the "Trust Flow" heading
    And I should be able to see the "Citation Flow" heading
    And I should be able to see the "New Backlinks" heading
    And I should be able to see the "Lost Backlinks" heading

    # Verify the tabs in the backlinks page
    And I should be able to see the "Backlinks" tab
    And I should be able to see the "Anchor Text" tab
    And I should be able to see the "Topics" tab
    And I should be able to see the "Pages" tab
    And I should be able to see the "Referring Domains" tab

    # Verify the Export link
    When I click on the link "Export"
    And I should see "PDF" template
    And I click on the link "PDF"

    # Verify the presence of elements in Backlinks tab
    When I click on the link "Backlinks"
    And I should see the text "Backlinks" on the page

    # Verify the presence of elements in Anchor Text tab
    When I click on the link "Anchor Text"
    And I should see "Anchor Text | Clickx" in the title of the page
    And I should see the text "Anchortext" on the page

    # Verify the presence of elements in Topics tab
    When I click on the link "Topics"
    And I should see "Backlinks Topic | Clickx" in the title of the page
    And I should see the text "Topics" on the page

    # Verify the presence of elements in Pages tab
    When I click on the link "Pages"
    And I should see "Backlinks Top Pages | Clickx" in the title of the page
    And I should see the text "Pages" on the page

    # Verify the presence of elements in Referring Domains tab
    When I click on the link "Referring Domains"
    And I should see "Backlinks Reference Domains | Clickx" in the title of the page
    And I should see the text "Ref Domains" on the page

    # Verify the link Back
    When I visit Call Analytics page
    Then I'm in Backlinks page
    And I click on the link "Back"
    Then I should see the title "Call Analytics | Clickx"
