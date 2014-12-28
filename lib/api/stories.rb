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
          story = Story.new(params[:story])

          if story.save!
            status 201
            headers 'Location' => "#{request.path_info}/#{story.id}"
            body
          end
        end
      end
    end
  end
end
