module PilotNews
  module API
    module Helpers
      module Authentication
        AuthenticationError = Class.new(StandardError)

        def authenticate!
          raise AuthenticationError unless authenticated?
        end

        def authenticated?
          auth = Rack::Auth::Basic::Request.new(request.env)

          if auth.provided? && auth.basic? && auth.credentials
            user = User.find_by(login: auth.credentials.first)

            return [user.login, user.password] == auth.credentials
          end

          false
        end
      end
    end
  end
end