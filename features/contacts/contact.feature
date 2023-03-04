@javascript
Feature: Contact
  As a business user
  I should be able to view ,edit and delete the contacts details
  and create notes

  Background:
    Given there is a business
    And I'm a "Company User"
    And I set page size to include all elements
    When I go to the contacts page
    Then I should see "Contacts | Clickx" in the title of the page
    And I should see "0" contacts
    When I click on the link "Add Contact"
    Then I should see the add contacts dialogue box
    When I fill in the fields with:
    | First Name   | Developer             |
    | Last Name    | develop               |
    | Email        | developer@develop.com |
    | Phone        | 9978459685            |
    | Gender       | Female                |
    | Address      | Door No 1, st. Heaven |
    | Country      | India                 |
    | Job Title    | Developer             |
    | Organization | Developer             |
    And I click on the button "Save Changes"
    And I should see "Contact manually added.." notification

  Scenario: Create notes, Edit, Delete and Update contacts
    # Create Notes
    Then I should see "1" contact
    When I click on the contact in the table
    And I should see the NOTES button
    When I click on the button "NOTES" 
    Then I should see the form
    And I fill the form with sample note
    And I click on the button Save to submit note
    When I refresh the page
    And I should see sample note as content

    # Edit contact details
    And I should see the Edit button
    When I click on the button "Edit" 
    And  I edit all the fields with:
    And I click on the button "Save Changes"
    And I should see "User data updated successfully" notification

    # Update contacts
    And I should see the Contact dropdown
    When I click on the Contact dropdown
    Then I should be able to select Lead template
    And I should see "Contact Updated" notification

    # Delete contact details
    And I should see the Delete button
    When I click on the button "Delete"
    And I should see "Deleted Contact" notification

