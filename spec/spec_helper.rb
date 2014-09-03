require 'rubygems'
require 'bundler'
require 'rack/test'

require 'simplecov'
SimpleCov.start

Bundler.require(:default, :test)

require File.join(File.dirname(__FILE__), '..', 'mds_integration.rb')

Dir['./spec/support/**/*.rb'].each &method(:require)

Sinatra::Base.environment = 'test'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.filter_sensitive_data("CLIENT_SIGNATURE") do |interaction|
    sample_credentials["client_signature"]
  end

  c.filter_sensitive_data("CLIENT_CODE") do |interaction|
    sample_credentials["client_code"]
  end
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
end

def app
  MDSIntegration
end
