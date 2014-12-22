require 'sinatra'

require_relative 'api/endpoints'

module PilotNews
  class App < Sinatra::Base
    get '/' do 'PilotNews' end

    use API::Endpoints
  end
end
