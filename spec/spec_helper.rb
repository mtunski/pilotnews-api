require 'rack/test'
require 'database_cleaner'

ENV['RACK_ENV'] = 'test'

RSpec.configure do |config|
  config.include Rack::Test::Methods

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
  end

  config.around do |example|
    DatabaseCleaner.cleaning { example.run }
  end
end
