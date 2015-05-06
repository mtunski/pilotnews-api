require_relative '../base'
require_relative '../../models/user'

module PilotNews
  module API
    class Users < Base
      namespace '/v1/users' do
        post '' do
          status 201 if User.create!(params[:user])
        end
      end
    end
  end
end
