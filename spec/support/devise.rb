RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::ControllerHelpers, type: :view
  config.include Warden::Test::Helpers
end

RSpec.configure do |config|
  config.after :each do
    Warden.test_reset!
  end
end
