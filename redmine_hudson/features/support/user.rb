module RedmineHudson
  module Cucumber
    module Support
      def self.set_current_user(login_name)
        user = User.find_by_login(login_name)
        raise "User not found login: '${login_name}'" if user == nil

        I18n.locale = user.language.to_sym
      end
    end
  end
end
