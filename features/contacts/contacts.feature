@javascript
Feature: Contacts
  As a business user
  I should be able to see the contacts dashboard

  Background:
    Given there is a business
    And I'm a "Company User"
    And I set page size to include all elements
    When I go to the contacts page
    Then I should see "Contacts | Clickx" in the title of the page

  Scenario: Verify the contacts page
    # Verify the Export button in the contacts dashboard
    When I see the Export button
    And I click on the "Export" button
    Then I should be able to see any of the "3" templates

    # Verify the SELECT DATE-RANGE button in the contacts dashboard CANCEL button
    When I click on the SELECT DATE-RANGE button
    And I should be able to select a date
    When I click on the button "CLEAR"
    And I click on the button "CANCEL"

    # Verify the SELECT DATE-RANGE button in the contacts dashboard CLEAR button
    When I click on the SELECT DATE-RANGE button
    And I should be able to select a date
    Then I should have a button with text "CLEAR"
    When I click on the button "CLEAR"
    And I click on the button "OK"

    # Verify the SELECT DATE-RANGE button in the contacts dashboard with OK button
    When I click on the INVALID DATE button
    And I should be able to select a date
    And I click on the button "OK"

    # Verify the Contacts buttons in the contacts dashboard
    When I see the Contacts button
    And I click on "Contacts" button
    Then I should see the 0 contacts

    # Verify the Customers button in the contacts dashboard
    When I see the Customers button
    And I click on the "Customers" button
    Then I should see 0 customers

    # Verify the Calls button in the contacts dashboard
    When I see the Calls button
    And I click on the "Calls" button
    Then I should see 0 phone calls

    # Verify the Forms button in the contacts dashboard
    When I see the Forms button
    And I click on the "Forms" button
    Then I should see 0 forms

    # Verify the Column Customize button in the contacts dashboard
    When I see the Column Customize button
    And I click on the Column Customize button
    Then I should be able to see all of the templates in Column Customize
    And I should be able to select Name

    # Verify the All button in the contacts dashboard
    Then I should see 2 buttons with text "All" and "Form Submission"
    And I click on the "first" All button
    Then I should be able to see all of the templates in the "first" All dropdown
    When I click on the link "Contact"
    Then I should have a link with text "Contact"

    # Verify the All button in the contacts dashboard
    When I click on the button "Form Submission"
    Then I should be able to see all of the templates in the "second" All dropdown
    When I click on the link "Manual"
    Then I should have a button with text "Manual"

    # Verify the pagination limit in the contacts dashboard
    When I click on the link "Import CSV"
    When I upload a csv with this data:
    | name | email              | phone      | organization | gender | job title | nationality |
    | Alan | alanjsph@live.com  | 9447344020 | Clickx  | Male   | Developer | India       |
    | Sue  | sue@alan2.com      | 1234567891 | UTD          | Female | ECI       | USA         |
    | Sue  | sue@alan3.com      | 1234567892 | UTD          | Female | ECI       | USA         |
    | Sue  | sue@alan4.com      | 1234567893 | UTD          | Female | ECI       | USA         |
    | Sue  | sue@alan5.com      | 1234567894 | UTD          | Female | ECI       | USA         |
    | Sue  | sue@alan6.com      | 1234567895 | UTD          | Female | ECI       | USA         |
    And I go to the contacts page
    When I select the pagination limit "5"
    Then I should see "5" table contents

    # Verify the date range buttons
    And I set page size to include all elements
    When I click datepicker
    When I click on the date range "LAST 30 DAYS"
    Then I should see "Last 30 Days" on the top of box
    When I click on the date range "LAST MONTH"
    Then I should see "Last Month" on the top of box
