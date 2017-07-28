require 'simplecov'
SimpleCov.start 'rails'

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)

require 'rails/test_help'
require "minitest/rails"
require 'mocha/setup'
require 'webrat'
require 'capybara/rails'
require 'capybara/minitest'

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL
  # Make `assert_*` methods behave like Minitest assertions
  include Capybara::Minitest::Assertions

  # Reset sessions and driver between tests
  # Use super wherever this method is redefined in your individual test classes
  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end

Webrat.configure do |config|
  config.mode = :rails
  config.open_error_files = false
end

module TestHelpers
  def json_response
    @json ||= JSON.parse(response.body)
  end
end

class ActionController::TestCase
  include TestHelpers
  include FactoryGirl::Syntax::Methods
  include Devise::TestHelpers

  self.use_transactional_fixtures = true
end

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
end
