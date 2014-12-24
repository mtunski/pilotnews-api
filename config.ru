require_relative 'lib/api/stories'
require_relative 'lib/api/users'

use Sinatra::Router do
  mount PilotNews::API::Stories
  mount PilotNews::API::Users
end

run Sinatra::Application
