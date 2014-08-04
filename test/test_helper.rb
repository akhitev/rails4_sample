ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'minitest/autorun'
require 'rails/test_help'

require "mocha/mini_test"

def given_valid_response
  response = mock('Net::HTTPResponse')
  response.stubs(:status).returns(200)
  response.stubs(:body).returns(File.read("test/fixtures/sample_offers_response.json"))
  response.stubs(:code).returns(200)
  response
end

