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
      Story.create!(id: 1, title: 'Lorem ipsum', url: 'http://www.lipsum.com/')
      Story.create!(id: 2, title: 'Dolor sit amet', url: 'http://www.dsitamet.com/')
    end

    it 'GET /stories returns all submitted stories' do
      get '/stories'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq([story_1, story_2].to_json)
    end

    it 'GET /stories/:id returns single story if found' do
      get "/stories/1"
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq(story_1.to_json)

      get "/stories/2"
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq(story_2.to_json)
    end

    it 'GET /stories/:id returns 404 if not found' do
      get "/stories/0"
      expect(last_response.status).to eq(404)
      expect(last_response.body).to eq(resource_not_found)
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

    it 'PATCH /stories/:id/upvote upvotes a story' do
      skip

      story = {}

      patch "/stories/#{story.id}/upvote"
      expect(last_response.status).to eq(204)
    end

    it 'PATCH /stories/:id/downvote downvotes a story' do
      skip

      story = {}

      patch "/stories/#{story.id}/downvote"
      expect(last_response.status).to eq(204)
    end

    it 'PATCH /stories/:id/unvote undoes the vote' do
      skip

      story = {}

      patch "/stories/#{story.id}/unvote"
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
