Feature: Show and Edit hudson Basic Settings 

  Background: 
    Given Project "eCookbook" uses "Hudson" Plugin
      And "Developer" has a permission below:
        | permissions         |
        | View Hudson         |
        | Edit Hudson settings|
      And I am logged in as "dlopper" with password "foo"

  # jsmith joins "eCookbook" Project as a "Developer"
  Scenario: Permission - "dlopper" has permisson, can see settings page.
    When I go to HudsonSettings at "eCookbook" Project
    Then I should see "Settings"
     And I should see "Plugin uses below url for access to hudson."

  Scenario: Add new project settings
    When I go to HudsonSettings at "eCookbook" Project
    Then I should see "Settings"
    When I fill in "http://localhost:8080" for "hudson_settings[url]"
     And I click "Save"
    Then the field named "hudson_settings[url]" should contain "http://localhost:8080/"

  @javascript
  Scenario: Add new project settings full detail
    When I go to HudsonSettings at "eCookbook" Project
    Then I should see "Settings"
    When I fill in "http://localhost:8080" for "hudson_settings[url]"
     And I check "enable_url_for_plugin"
     And I fill in "http://127.0.0.1:8080" for "hudson_settings[url_for_plugin]"
     And I fill in "test" for "hudson_settings[auth_user]"
     And I fill in "pass" for "ignore_auth_password"
     And I check "hudson_settings[show_compact]"
     And I click "Save"
    Then the field named "hudson_settings[url]" should contain "http://localhost:8080/"
     And the field named "enable_url_for_plugin" should be checked
     And the field named "hudson_settings[url_for_plugin]" should contain "http://127.0.0.1:8080/"
     And the field named "hudson_settings[auth_user]" should contain "test"
     And the field named "hudson_settings[show_compact]" should be checked
     And the HudsonSetting model should be below:
       | project   | auth_user | auth_password |
       | eCookbook | test      | pass          |

  @javascript
  Scenario: don't update auth_password, when field isnot modified.
    When I go to HudsonSettings at "eCookbook" Project
    Then I should see "Settings"
    When I fill in "http://localhost:8080" for "hudson_settings[url]"
     And I fill in "test" for "hudson_settings[auth_user]"
     And I fill in "pass" for "ignore_auth_password"
     And I click "Save"
    Then the field named "hudson_settings[url]" should contain "http://localhost:8080/"
     And the field named "hudson_settings[auth_user]" should contain "test"
     And the HudsonSetting model should be below:
       | project   | auth_user | auth_password |
       | eCookbook | test      | pass          |
    When I fill in "testnew" for "hudson_settings[auth_user]"
     And I click "Save"
    Then the field named "hudson_settings[auth_user]" should contain "testnew"
     And the HudsonSetting model should be below:
       | project   | auth_user | auth_password |
       | eCookbook | testnew   | pass          |


  @javascript
  Scenario: Add HealthReport settings
    When  I go to HudsonSettings at "eCookbook" Project
     And  I fill in "http://localhost:8080" for "hudson_settings[url]"
     And  I add health report settings below:
          | keyword         | url_format                                   |
          | Build stability | http://hoge.com/hudson/simple-job/lastBuild/ |
     And  I click "Save"
    Then  the field named "hudson_settings[url]" should contain "http://localhost:8080/"
     And  I should see health report settings below:
          | keyword         | url_format                                   |
          | Build stability | http://hoge.com/hudson/simple-job/lastBuild/ |

  @javascript
  Scenario: Add HealthReport settings
    When I go to HudsonSettings at "eCookbook" Project
     And I fill in "http://localhost:8080" for "hudson_settings[url]"
     And  I add health report settings below:
          | keyword         | url_format                                   |
          | Build stability | http://hoge.com/hudson/simple-job/lastBuild/ |
          | Coverage        | http://hoge.com/hudson/simple-job/rcov/      |
     And  I click "Save"
    Then  I should see health report settings below:
          | keyword         | url_format                                   |
          | Build stability | http://hoge.com/hudson/simple-job/lastBuild/ |
          | Coverage        | http://hoge.com/hudson/simple-job/rcov/      |
