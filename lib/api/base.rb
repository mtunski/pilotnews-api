require 'sinatra/base'
require 'sinatra/namespace'
require 'sinatra/json'
require 'sinatra/respond_with'
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
        register Sinatra::RespondWith
        helpers  Sinatra::JSON

        helpers Helpers::Authentication
      end

      respond_to :json, :xml

      error ActiveRecord::RecordNotFound do
        status       404
        respond_with error: env['sinatra.error'].message
      end

      error ActiveRecord::RecordInvalid do
        status       422
        respond_with errors: env['sinatra.error'].record.errors
      end

      error AuthenticationError do
        status       401
        headers      'WWW-Authenticate' => 'Basic realm="Restricted Area"'
        respond_with error: env['sinatra.error'].message
      end

      error AuthorizationError do
        status       403
        respond_with error: env['sinatra.error'].message
      end
    end
  end
end
