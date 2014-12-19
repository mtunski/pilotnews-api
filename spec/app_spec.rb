require 'spec_helper'
require 'app'

describe App do
  let(:app) { Rack::Lint.new(App.new) }
  let(:story1) { { id: 1, title: 'Story 1', url: 'http://www.lipsum.com/' } }
  let(:story2) { { id: 2, title: 'Story 2', url: 'http://www.lipsum.com/' } }

  it 'returns a successful response' do
    get '/'
    expect(last_response).to be_ok
  end

  it 'GET /api/stories returns all submitted stories' do
    get '/api/stories'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq({
      story1: story1,
      story2: story2
    }.to_json)
  end

  it 'GET /api/stories/:id returns single story if found' do
    get "/api/stories/1"
    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq({story: story1}.to_json)
  end

  it 'GET /api/stories/:id returns 404 if not found' do
    get "/api/stories/2"
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
