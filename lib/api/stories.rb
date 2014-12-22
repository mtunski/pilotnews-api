require_relative 'base'
require_relative '../models/story'

module PilotNews
  module API
    class Stories < Base
      namespace '/stories' do
        get '' do
          json Story.all
        end

        get '/:id' do
          json Story.find(params[:id])
        end
      end
    end
  end
end
