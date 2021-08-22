require 'bundler'
require 'capybara/dsl'
require 'capybara/rspec'

Bundler.setup(:default)
Bundler.require

Capybara.default_driver = :selenium_chrome_headless
Capybara.app_host = 'https://stage.mdlive.com'
Capybara.default_max_wait_time = 20

# Run using:
# bundle exec rspec spec/features/<file>.rb


RSpec.configure do |config|
  config.formatter = :documentation
  config.include Capybara::DSL

  config.before(:suite) do
    Capybara.register_driver(:chrome) do |app|
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument('--window-size=1240,1400')

      CAPABILITIES = Selenium::WebDriver::Remote::Capabilities.chrome(
        'goog:loggingPrefs': {
        browser: 'INFO', # Capture JavaScript errors in Browser
        driver: 'INFO' # Capture WebDriver severe errors
      }
    )

    Capybara::Selenium::Driver.new(app, browser: :chrome,
                                    desired_capabilities: CAPABILITIES,
                                      options: options)
    end
  end
end
