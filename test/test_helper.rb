ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'minitest/autorun'
require 'rails/test_help'

require "mocha/mini_test"

class ActiveSupport::TestCase

end

