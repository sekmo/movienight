# Capybara.register_driver :selenium do |app|
#   Capybara::Selenium::Driver.new(
#     app,
#     browser: :chrome,
#     options: Selenium::WebDriver::Chrome::Options.new(args: %w[headless disable-gpu])
#   )
# end
RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, type: :system, js: true) do
    driven_by :selenium
  end
end

# Capybara.default_max_wait_time = 5
