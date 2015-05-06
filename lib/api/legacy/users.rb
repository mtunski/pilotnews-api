require_relative '../base'
require_relative '../../models/user'

module PilotNews
  module API
    class Users < Base
      route *ALLOWED_METHODS, '/users*' do
        redirect "/v1#{request.fullpath}", 301
      end
    end
  end
end
