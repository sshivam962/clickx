@javascript
Feature: Switch user
  Switch Admin to Agency Admin

  Background:
    Given there is an agency
    Given there is a business

  Scenario: Switch Admin to Agency admin and back
    Given I'm a "Admin"
    And there is an Agency admin
    When I visit "/#/businesses"
    Given I set the required cookies
    When I click on the link Agencies
    Then agency should be listed
    Then select Agency admin for Agency
    Then I click on the link View Dashboard
    Then I should see "Dashboard | Clickx" in the title of the page
    Then I should see Agency admin as current user
    When I click on the link Switch To Admin User
    Then I should see "Business list" in the title of the page
    Then I should see the Admin email on the page

  Scenario: Switch Admin to Business User and back
    Given I'm a "Admin"
    And there is a Business User
    When I visit "/#/businesses"
    Then business should be listed
    Then I clink the switch user link
    Then I should see "Dashboard" in the title of the page
    When I click on the link Switch To Admin User
    Then I should see "Business list" in the title of the page
    Then I should see the Admin email on the page

  Scenario: Switch Agency Admin to business user and then another business user and back to agency admin
    Given business belongs to agency
    Given I'm a "Agency Admin"
    And there is a Business User
    And there is a Company Admin
    When I visit Agency Dashboard
    Then I select Business User and select go to Dashboard
    Given There is one more business
    Then I click profile info
    Then I select one of the business users
    Then I should be prompted to Select a Campaign
    When I am in the "dashboard" page
    Then I click profile settings
    When I click on the link "Switch To Agency Admin"
    Then I should see Agency admin first name on profile info
    
