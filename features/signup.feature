@javascript
Feature: new user registration

  Background:
    Given there is an agency
    When I go to the new user registration page
    When I set page size to include all elements

  Scenario: new user go throuh signup form
    And there is a mailtemplate
    When I fill the signup form
    And I submit the form
    And I should See "We look forward to helping you grow your business. Please check your email to continue creating your account!"
