group :test do
  gem 'rspec', "~> 2.11.0"
  gem "rspec-rails", "~> 2.11.0"
  gem 'cucumber'
  gem 'cucumber-rails'
  gem 'capybara', '~> 2.0.0'
  gem 'selenium-webdriver', '2.35.1'
  gem 'database_cleaner'

  platforms :mri_19, :mingw_19 do
    gem 'simplecov'
    gem 'simplecov-rcov'
    gem 'simplecov-rcov-text'
  end
end

