require_relative 'api/legacy/stories'
require_relative 'api/legacy/users'

require_relative 'api/v1/stories'
require_relative 'api/v1/users'

require_relative 'api/v2/users'
require_relative 'api/v2/stories'

module PilotNews
  class Application < Sinatra::Base
    use Sinatra::Router do
      mount API::Stories
      mount API::Users
    end
  end
end
