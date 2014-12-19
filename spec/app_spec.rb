require 'spec_helper'
require 'app'

describe App do
  let(:app) { Rack::Lint.new(App.new) }

  it 'returns a successful response' do
    get '/'
    expect(last_response).to be_ok
  end

  it 'GET /api/stories returns all submitted stories' do
    skip

    get '/api/stories'
    expect(last_response).to be_ok
  end

  it 'GET /api/stories/:id returns single story' do
    skip

    story = {}

    get "/api/stories/#{story.id}"
    expect(last_response).to be_ok
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
