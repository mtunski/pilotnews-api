require 'spec_helper'
require 'application'

describe PilotNews::API do
  let(:app)                   { Rack::Lint.new(PilotNews::Application) }
  let(:resource_not_found)    { { error: 'Resource not found' }.to_json }
  let(:resource_invalid)      { { error: 'Resource invalid' }.to_json }
  let(:authentication_failed) { { error: 'Authentication failed' }.to_json }

  describe '::Stories' do
    let(:story_1) { Story.find(1) }
    let(:story_2) { Story.find(2) }
    let(:valid_story_attributes)   { { title: 'Valid Story', url: 'http://validurl.com' } }
    let(:invalid_story_attributes) { { title: '', url: 'invalidurl' } }

    before do
      Story.create!(title: 'Lorem ipsum', url: 'http://www.lipsum.com/')
      Story.create!(title: 'Dolor sit amet', url: 'http://www.dsitamet.com/')
      User.create!(login: 'test', password: 'test')
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

        it 'returns the story with given id' do
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

    describe 'POST /stories' do
      context 'user is not authenticated' do
        let(:request)  { -> { post '/stories', { story: valid_story_attributes } } }
        let(:response) { request.call }

        it 'responds with code 401' do
          expect(response.status).to eq(401)
        end

        it 'contains `WWW-Authenticate` header' do
          expect(response.headers['WWW-Authenticate']).to be_present
        end

        it 'returns proper error message' do
          expect(response.body).to eq(authentication_failed)
        end

        it 'does not save the story in the db' do
          expect(request).not_to change{ Story.count }
        end
      end

      context 'user is authenticated' do
        before { authorize 'test', 'test' }

        context 'story is valid' do
          let(:request)  { -> { post '/stories', { story: valid_story_attributes } } }
          let(:response) { request.call }

          it 'responds with code 201' do
            expect(response.status).to eq(201)
          end

          it 'contains `Location` header pointing to the newly created resource' do
            expect(response.headers['Location']).to eq("/stories/#{Story.last.id}")
          end

          it 'returns nothing' do
            expect(response.body).to be_empty
          end

          it 'saves the story in the db' do
            expect(request).to change{ Story.count }.by(1)
          end
        end

        context 'story is invalid' do
          let(:request)  { -> { post '/stories', { story: invalid_story_attributes } } }
          let(:response) { request.call }

          it 'responds with code 422' do
            expect(response.status).to eq(422)
          end

          it 'returns proper error message' do
            expect(response.body).to eq(resource_invalid)
          end

          it 'does not save the story in the db' do
            expect(request).not_to change{ Story.count }
          end
        end
      end
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
    let(:valid_user_attributes)   { { login: 'user', password: 'user' } }
    let(:invalid_user_attributes) { { login: 'user', password: '1' } }

    describe 'POST /users' do
      context 'user is valid' do
        let(:request)  { -> { post '/users', { user: valid_user_attributes } } }
        let(:response) { request.call }

        it 'responds with code 201' do
          expect(response.status).to eq(201)
        end

        it 'returns nothing' do
          expect(response.body).to be_empty
        end

        it 'saves the user in the db' do
          expect(request).to change{ User.count }.by(1)
        end
      end

      context 'user is invalid' do
        let(:request)  { -> { post '/users', { user: invalid_user_attributes } } }
        let(:response) { request.call }

        before { User.create!(valid_user_attributes) }

        it 'responds with code 422' do
          expect(response.status).to eq(422)
        end

        it 'returns proper error message' do
          expect(response.body).to eq(resource_invalid)
        end

        it 'does not save the user in the db' do
          expect(request).not_to change{ User.count }
        end
      end
    end
  end
end
