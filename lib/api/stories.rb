require_relative 'base'
require_relative '../models/story'
require_relative '../models/vote'

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
          authenticate!

          story        = Story.new(params[:story])
          story.poster = current_user

          if story.save!
            status 201
            headers 'Location' => "#{request.path_info}/#{story.id}"
            body
          end
        end

        patch '/:id' do
          authenticate!

          story = Story.find(params[:id])

          if current_user == story.poster
            story.update_attributes!(title: params[:title], url: params[:url])
          else
            raise AuthorizationError, 'You can only update your own stories'
          end

          status 204
        end

        put '/:id/vote' do
          authenticate!

          vote       = Vote.find_or_initialize_by(story_id: params[:id], user_id: current_user.id)
          vote.value = params[:value]

          vote.new_record? ? (status 201) : (status 204)
          vote.save!
        end

        delete '/:id/vote' do
          authenticate!

          Vote.find_by!(story_id: params[:id], user_id: current_user.id).destroy

          status 204
        end
      end
    end
  end
end
