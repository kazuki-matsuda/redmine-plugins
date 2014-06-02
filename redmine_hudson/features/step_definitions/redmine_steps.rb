# coding: utf-8

Given /"(.*)" has a permission below:/ do |role_name, table|
  steps %Q{
    When I am logged in as "admin" with password "admin"
     And I go to Roles 
     And I click "#{role_name}"
  }
  table.hashes.each do |hash|
    steps %Q{
      When I check "#{hash['permissions']}"
    }
  end
  steps %Q{
    When I click "Save"
  }
end

Given /^Project "([^"]*?)" uses "([^"]*?)" Plugin$/ do |project_name, plugin_name|
  steps %Q{
    When I am logged in as "admin" with password "admin"
     And I go to ProjectSettings at "#{project_name}" Project
     And I click "Modules"
     And I check "#{plugin_name}"
     And I click "Save" within "div#tab-content-modules"
  }
end

Given /^Project "([^"]*?)" uses modules below:$/ do |project_name, module_names|
  steps %Q{
    When I am logged in as "admin" with password "admin"
     And I go to ProjectSettings at "#{project_name}" Project
     And I click "Modules"
  }

  module_names.hashes.each do |hash|
    steps %Q{
      When I check "#{hash['name']}"
    }
  end

  steps %Q{
     When I click "Save" within "div#tab-content-modules"
  }
end

Given /^I am logged in as "([^"]*)" with password "([^"]*)"$/ do |login_name, password|
  steps %Q{
    When I go to "login"
  }

  if page.has_content?("Logged in as") == true then
    steps %Q{
      When I click "Sign out"
      When I go to "login"
    }
  end

  steps %Q{
     And I fill in "#{login_name}" for "Login"
     And I fill in "#{password}" for "Password"
     And I click "Login »"
  }

  RedmineHudson::Cucumber::Support::set_current_user(login_name)
  steps %Q{
    Then I should see "#{I18n.t(:label_my_page)}"
  }
end

Given /^"(.*)" joins project "(.*)" as "(.*)"$/ do |login, project_name, role_name|
  
  project = Project.find_by_name(project_name)

  unless project.users.find {|user| user.login == login} 
    member = Member.new
    member.user_id = User.find_by_login(login)
    member.role_ids = [Role.find_by_name(role_name).id]
    project.members << member
  end

end

Given /Issue #(.*) is related to revisions "(.*)"/ do |issue_no, revisions|
  issue = Issue.find(issue_no)

  raise Exception.new("issue not found - #{issue_no}") unless issue

  revisions.split(/,/).each do |revision|
    changeset = Changeset.where(:repository_id => issue.project.repository.id).
                          where(:revision => revision).
                          first()
    raise Exception.new("no such changeset - #{issue.project.name} rev-#{revision}") unless changeset

    Changeset.connection.execute("INSERT INTO changesets_issues (changeset_id, issue_id) values (#{changeset.id}, #{issue.id})")
  end
end

When /^I check "(.*?)" Activity$/ do | activity_type |
  within("#sidebar") do 
    check "#{activity_type}"
  end
end

Then /^I should see build results in Activity:$/ do |results|

  actual = [["activity", "activity url", "activity detail", "activity author"]]

  actual_data = all(:xpath, "//dt[contains(@class,'hudson-build')]").map do |dt|
    activity = dt.find("a").native.text
    activity_url = dt.find("a")['href']
    dd = dt.find(:xpath, "following-sibling::dd[1]")
    activity_detail = dd.find("span[@class='description']").text
    activity_author = dd.find("span[@class='author']").text
    [activity, activity_url, activity_detail, activity_author]
  end

  actual.concat(actual_data)

  results.diff!(actual)

end
