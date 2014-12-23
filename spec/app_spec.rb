require 'spec_helper'
require 'api/stories'

describe PilotNews::API do
  let(:app) do
    Rack::Builder.new do
      use Rack::Lint
      use Sinatra::Router do
        mount PilotNews::API::Stories
      end

      run self
    end
  end
  let(:resource_not_found) { { error: 'Resource not found' }.to_json }

  describe '::Stories' do
    let(:story_1) { Story.find(1) }
    let(:story_2) { Story.find(2) }

    before do
      Story.create!(title: 'Lorem ipsum', url: 'http://www.lipsum.com/')
      Story.create!(title: 'Dolor sit amet', url: 'http://www.dsitamet.com/')
    end

    describe 'GET /stories' do
      before { get '/stories' }

      it 'responds with code 200' do
        expect(last_response.status).to eq(200)
      end

      it 'returns all stories' do
        expect(last_response.body).to eq([story_1, story_2].to_json)
      end
    end

    describe 'GET /stories/:id' do
      context 'story found' do
        before { get '/stories/1' }

        it 'responds with code 200' do
          expect(last_response.status).to eq(200)
        end

        it 'returns story with given id' do
          expect(last_response.body).to eq(story_1.to_json)
        end
      end

      context 'story not found' do
        before { get '/stories/0' }

        it 'responds with code 404' do
          expect(last_response.status).to eq(404)
        end

        it 'returns proper error message' do
          expect(last_response.body).to eq(resource_not_found)
        end
      end
    end

    it 'POST /stories creates a new story' do
      skip

      story = {}

      post '/stories', { story: story }
      expect(last_response.status).to eq(201)
    end

    it 'PATCH /stories/:id updates a story' do
      skip

      story = {}
      attributes = {}

      patch "/stories/#{story.id}", { attributes: attributes }
      expect(last_response.status).to eq(204)
    end

    it 'PUT /stories/:id/vote upvotes a story' do
      skip

      story = {}
      vote  = 1

      put "/stories/#{story.id}/vote", { vote: vote }
      expect(last_response.status).to eq(204)
    end

    it 'PUT /stories/:id/vote downvotes a story' do
      skip

      story = {}
      vote  = -1

      patch "/stories/#{story.id}/vote", { vote: vote }
      expect(last_response.status).to eq(204)
    end

    it 'DELETE /stories/:id/vote undoes the vote' do
      skip

      story = {}

      delete "/stories/#{story.id}/vote"
      expect(last_response.status).to eq(204)
    end
  end

  describe '::Users' do
    it 'POST /users creates a new user' do
      skip

      user = {}

      post '/users', { user: user }
      expect(last_response.status).to eq(201)
    end
  end
end
