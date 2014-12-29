require 'sinatra/base'
require 'sinatra/namespace'
require 'sinatra/json'
require 'sinatra/router'

require 'dotenv'
require 'active_record'

require_relative 'helpers'

module PilotNews
  module API
    class Base < Sinatra::Base
      configure do
        Dotenv.load(".env.#{environment}", '.env')
        ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])

        use ActiveRecord::ConnectionAdapters::ConnectionManagement

        register Sinatra::Namespace
        helpers  Sinatra::JSON

        helpers  Helpers::Authentication
      end

      error ActiveRecord::RecordNotFound do
        content_type :json

        halt 404, { error: 'Resource not found' }.to_json
      end

      error ActiveRecord::RecordInvalid do
        content_type :json

        halt 422, { error: 'Resource invalid' }.to_json
      end

      error Helpers::Authentication::AuthenticationError do
        content_type :json

        halt 401,
             { 'WWW-Authenticate' => 'Basic realm="Restricted Area"' },
             { error: 'Authentication failed' }.to_json
      end
    end
  end
end
