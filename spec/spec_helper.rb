require 'dotenv'
require 'rack/test'

Dotenv.load('.env.test')

ENV['RACK_ENV'] = 'test'

RSpec.configure do |config|
  config.include Rack::Test::Methods
end
