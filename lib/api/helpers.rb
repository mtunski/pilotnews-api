module PilotNews
  module API
    module Helpers
      module Authentication
        class AuthenticationError < StandardError
          def initialize(msg = 'Authentication failed')
            super
          end
        end

        class AuthorizationError < StandardError
          def initialize(msg = 'Unauthorized')
            super
          end
        end

        def authenticate!
          raise AuthenticationError unless authenticated?
        end

        def current_user
          @user
        end

        private

        def authenticated?
          auth = Rack::Auth::Basic::Request.new(request.env)

          if auth.provided? && auth.basic? && auth.credentials
            @user = User.find_by!(login: auth.credentials.first)

            return [@user.login, @user.password] == auth.credentials
          end

          false
        end
      end
    end
  end
end
