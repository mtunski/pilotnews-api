require 'sinatra/base'
require 'sinatra/namespace'
require 'sinatra/json'
require 'sinatra/router'

require 'dotenv'
require 'active_record'

module PilotNews
  module API
    class Base < Sinatra::Base
      configure do
        Dotenv.load(".env.#{environment}", '.env')
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
