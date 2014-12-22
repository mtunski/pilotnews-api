require 'sinatra/namespace'
require 'sinatra/json'

require 'dotenv'
require 'active_record'

module PilotNews
  module API
    class APIBase < Sinatra::Base
      configure do
        Dotenv.load(".env.#{ENV['RACK_ENV']}", '.env')
        ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])

        register Sinatra::Namespace
        helpers  Sinatra::JSON
      end

      error ActiveRecord::RecordNotFound do
        content_type :json

        halt 404, { error: 'Resource not found' }.to_json
      end
    end
  end
end
