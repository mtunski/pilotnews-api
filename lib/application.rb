require_relative 'api/stories'
require_relative 'api/users'

module PilotNews
  class Application < Sinatra::Base
    use Sinatra::Router do
      mount API::Stories
      mount API::Users
    end
  end
end
