require 'simplecov'
SimpleCov.start 'rails'

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)

require 'rails/test_help'
require "minitest/rails"
require 'mocha/setup'
require 'webrat'

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
