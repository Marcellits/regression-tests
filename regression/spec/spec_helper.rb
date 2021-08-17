# frozen_string_literal: true

require 'bundler'
require 'capybara/dsl'
require 'capybara/rspec'


Bundler.setup(:default)
Bundler.require



# Which default browser do you want Selenium WebDriver to use?
# :selenium_chrome # Selenium driving Chrome
# :selenium_chrome_headless # Selenium driving Chrome in a headless configuration
# https://github.com/teamcapybara/capybara#selenium

Capybara.default_driver = :selenium_chrome_headless
Capybara.app_host = 'https://stage.mdlive.com'
Capybara.default_max_wait_time = 10



# Run using:
# bundle exec rspec spec/features/login.rb --format documentation
# ... Or...

RSpec.configure do |config|
  config.formatter = :documentation
  config.include Capybara::DSL
end
