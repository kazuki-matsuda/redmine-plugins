Feature: issue
  show hudson build results on issue

  Scenario: Use filter for hudson job name and number
    Given Project "eCookbook" uses modules below:
        | name       |
        | Hudson     |
    When I go to Issues at "eCookbook" Project
    Then the field named "add_filter_select" should have option "Hudson(Job)" 
     And the field named "add_filter_select" should have option "Hudson(BuildNumber)" 

  @javascript
  Scenario Outline: Show job simple-ruby-application
    Given Project "eCookbook" uses modules below:
        | name       |
        | Hudson     |
      And Issue #1 is related to revisions "2"
      And "eCookbook" project has jobs:
        | name                    |
        | simple-ruby-application |
      And Job "simple-ruby-application" has build results:
        | number | result  | finished_at | building | error | caused_by | revisions |
        | 5      | SUCCESS | #today      | false    |       | 1         | 2         |
      And "<login name>" joins project "eCookbook" as "Developer" 
      And I am logged in as "<login name>" with password "foo"
    When I show issue #1
    When save the page
    Then I should see build results in Associated revisions:
        | revision | job name                | build number | build result  | build url                                           | finished at        |
        | 2        | simple-ruby-application | 5            | SUCCESS       | http://localhost:8080/job/simple-ruby-application/5 | <finished at> |

    Examples:
      | login name | finished at        |
      | dlopper    | less than a minute |
      | miscuser8  | meno di un minuto  |

