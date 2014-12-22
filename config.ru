require_relative 'lib/api/stories'

use Sinatra::Router do
  mount PilotNews::API::Stories
end

run Sinatra::Application
