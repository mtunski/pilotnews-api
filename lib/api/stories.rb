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

        post '' do
          status 201 if Story.create!(params[:story])
        end
      end
    end
  end
end
