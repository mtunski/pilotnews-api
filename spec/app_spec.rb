require 'spec_helper'
require 'app'

describe PilotNews::App do
  let(:app)     { Rack::Lint.new(PilotNews::App) }
  let(:story_1) { Story.find(1) }
  let(:story_2) { Story.find(2) }

  before do
    Story.create!(id: 1, title: 'Lorem ipsum', url: 'http://www.lipsum.com/')
    Story.create!(id: 2, title: 'Dolor sit amet', url: 'http://www.dsitamet.com/')
  end

  it 'returns a successful response' do
    get '/'
    expect(last_response).to be_ok
  end

  it 'GET /api/stories returns all submitted stories' do
    get '/api/stories'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq([story_1, story_2].to_json)
  end

  it 'GET /api/stories/:id returns single story if found' do
    get "/api/stories/1"
    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq(story_1.to_json)

    get "/api/stories/2"
    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq(story_2.to_json)
  end

  it 'GET /api/stories/:id returns 404 if not found' do
    get "/api/stories/666"
    expect(last_response.status).to eq(404)
  end

  it 'POST /api/stories creates a new story' do
    skip

    story = {}

    post '/api/stories', { story: story }
    expect(last_response.status).to eq(201)
  end

  it 'PATCH /api/stories/:id updates a story' do
    skip

    story = {}
    attributes = {}

    patch "/api/stories/#{story.id}", { attributes: attributes }
    expect(last_response.status).to eq(204)
  end

  it 'PATCH /api/stories/:id/upvote upvotes a story' do
    skip

    story = {}

    patch "/api/stories/#{story.id}/upvote"
    expect(last_response.status).to eq(204)
  end

  it 'PATCH /api/stories/:id/downvote downvotes a story' do
    skip

    story = {}

    patch "/api/stories/#{story.id}/downvote"
    expect(last_response.status).to eq(204)
  end

  it 'PATCH /api/stories/:id/unvote undoes the vote' do
    skip

    story = {}

    patch "/api/stories/#{story.id}/unvote"
    expect(last_response.status).to eq(204)
  end
end
