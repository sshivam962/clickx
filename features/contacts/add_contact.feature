@javascript
Feature: Contacts
  As a business user who can access contacts feature
  I should be able to see the contacts dashboard
  And I should be able to add new contacts

  Background:
    Given there is a business
    And I'm a "Company User"

  Scenario: Adding a new contact using form
    When I go to the contacts page
    Then I should see "Contacts | Clickx" in the title of the page
    And I should see "0" contacts
    When I click on the link "Add Contact"
    Then I should see the add contacts dialogue box
    When I fill in the fields with:
    | First Name   | Alan                  |
    | Last Name    | Joseph                |
    | Email        | alanjsph@live.com     |
    | Phone        | 9447344020            |
    | Gender       | Male                  |
    | Address      | Door No 1, st. Heaven |
    | Country      | India                 |
    | Job Title    | Developer             |
    | Organization | Developer             |
    And I click on the button "Save Changes"
    Then I should see "1" contact

    # Adding a new contact using CSV upload
    When I click on the link "Import CSV"
    Then I should see the text "CLICK HERE OR DRAG FILES HERE TO UPLOAD" on the page
    When I upload a csv with this data:
    | name | email             | phone      | organization | gender | job title | nationality |
    | Alan | alanjsph@live.com | 9447344020 | Clickx  | Male   | Developer | India       |
    And I go to the contacts page
    Then I should see "1" contact
