require_relative '../base'
require_relative '../../models/story'
require_relative '../../models/vote'

module PilotNews
  module API
    class Stories < Base
      route *ALLOWED_METHODS, '/stories*' do
        redirect "/v1#{request.fullpath}", 301
      end
    end
  end
end
