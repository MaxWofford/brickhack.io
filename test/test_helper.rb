ENV["RAILS_ENV"] = "test"

if ["manual", "travis"].include?(ENV["RUN_COVERAGE"])
  require 'simplecov'
  require 'codeclimate-test-reporter' if ENV["RUN_COVERAGE"] == "travis"
  SimpleCov.add_filter 'vendor/'
  SimpleCov.add_filter 'app/mailers/mail_preview.rb'
  if ENV["RUN_COVERAGE"] == "travis"
    SimpleCov.formatters = []
    SimpleCov.start CodeClimate::TestReporter.configuration.profile
  else
    SimpleCov.start 'rails'
  end
end

require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"
require "strip_attributes/matchers"
require "minitest/reporters"
require "valid_attribute"
require "factory_girl_rails"
require "paperclip/matchers"
require "sidekiq/testing"

if defined?(RUBY_ENGINE) && RUBY_ENGINE == "ruby" && RUBY_VERSION >= "1.9"
  module Kernel
    alias :__at_exit :at_exit
    def at_exit(&block)
      __at_exit do
        exit_status = $!.status if $!.is_a?(SystemExit)
        block.call
        exit exit_status if exit_status
      end
    end
  end
end

Minitest::Reporters.use!
FactoryGirl.reload

# To add Capybara feature tests add `gem "minitest-rails-capybara"`
# to the test group in the Gemfile and uncomment the following:
# require "minitest/rails/capybara"

# Uncomment for awesome colorful output
# require "minitest/pride"

def sample_file(filename = "sample_pdf.pdf")
  File.new("test/fixtures/#{filename}")
end

class ActiveSupport::TestCase
  extend StripAttributes::Matchers
  include ValidAttribute::Method
  include FactoryGirl::Syntax::Methods
  extend Paperclip::Shoulda::Matchers

  # Add more helper methods to be used by all tests here...
end

class ActionController::TestCase
  include Devise::TestHelpers
end
