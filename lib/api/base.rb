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

        helpers Helpers::Authentication
      end

      error ActiveRecord::RecordNotFound do
        status 404
        json   error: env['sinatra.error'].message
      end

      error ActiveRecord::RecordInvalid do
        status 422
        json   errors: env['sinatra.error'].record.errors
      end

      error Helpers::Authentication::AuthenticationError do
        status  401
        headers 'WWW-Authenticate' => 'Basic realm="Restricted Area"'
        json    error: env['sinatra.error'].message
      end
    end
  end
end
