require 'spec_helper'
require 'application'

describe PilotNews::API do
  let(:app) { Rack::Lint.new(PilotNews::Application) }

  describe '::Stories' do
    let(:story_1) { Story.find(1) }
    let(:story_2) { Story.find(2) }
    let(:poster)  { User.find(1) }
    let(:voter)   { User.find(2) }
    let(:valid_story_attributes)   { { title: 'Valid Story', url: 'http://validurl.com' } }
    let(:invalid_story_attributes) { { title: '',            url: 'invalidurl' } }

    before do
      poster = User.create!(login: 'poster', password: 'test')
      voter  = User.create!(login: 'voter',  password: 'test')
      Story.create!(title: 'Lorem ipsum',    url: 'http://www.lipsum.com/',   poster: poster)
      Story.create!(title: 'Dolor sit amet', url: 'http://www.dsitamet.com/', poster: poster)
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
          expect(JSON.parse(last_response.body)['error']).to eq("Couldn't find Story with 'id'=0")
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
          expect(JSON.parse(response.body)['error']).to eq('Authentication failed')
        end

        it 'does not save the story in the db' do
          expect(request).not_to change{ Story.count }
        end
      end

      context 'user is authenticated' do
        before { authorize 'poster', 'test' }

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
            expect(JSON.parse(response.body)['errors']).to eq({ 'title' => ["can't be blank"] })
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

    describe 'PUT /stories/:id/vote' do
      context 'user is not authenticated' do
        let(:request)  { -> { put '/stories/1/vote', { value: 1 } } }
        let(:response) { request.call }

        it 'responds with code 401' do
          expect(response.status).to eq(401)
        end

        it 'contains `WWW-Authenticate` header' do
          expect(response.headers['WWW-Authenticate']).to be_present
        end

        it 'returns proper error message' do
          expect(JSON.parse(response.body)['error']).to eq('Authentication failed')
        end

        it 'does not save the story in the db' do
          expect(request).not_to change{ Vote.count }
        end
      end

      context 'user is authenticated' do
        before { authorize 'voter', 'test' }

        context 'vote is invalid' do
          let(:request)  { -> { put '/stories/1/vote', { value: 0 } } }
          let(:response) { request.call }

          it 'responds with code 422' do
            expect(response.status).to eq(422)
          end

          it 'returns proper error message' do
            expect(JSON.parse(response.body)['errors']).to eq({
              'value' => ['Value can be either -1 (downvote) or 1 (upvote)']
            })
          end

          context 'vote does not exist in the db' do
            it 'does not save the vote in the db' do
              expect(request).not_to change{ Vote.count }
            end
          end

          context 'vote exists in the db' do
            before { Vote.create!(story: story_1, user: voter, value: 1) }

            it 'does not update the vote in the db' do
              expect(Vote.last.value).to eq(1)
            end
          end
        end

        context 'vote is valid' do
          describe 'upvoting' do
            let(:request)  { -> { put '/stories/1/vote', { value: 1 } } }
            let(:response) { request.call }

            context 'vote does not exist in the db' do
              it 'responds with code 201' do
                expect(response.status).to eq(201)
              end

              it 'returns nothing' do
                expect(response.body).to be_empty
              end

              it 'saves the vote in the db' do
                expect(request).to change{ Vote.count }.by(1)
              end
            end

            context 'vote exists in the db' do
              before { Vote.create!(story: story_1, user: voter, value: -1) }

              it 'responds with code 204' do
                expect(response.status).to eq(204)
              end

              it 'returns nothing' do
                expect(response.body).to be_empty
              end

              it 'updates the vote in the db' do
                expect(request).not_to     change{ Vote.count }
                expect(Vote.last.value).to eq(1)
              end
            end
          end

          describe 'downvoting' do
            let(:request)  { -> { put '/stories/1/vote', { value: -1 } } }
            let(:response) { request.call }

            context 'vote does not exist in the db' do
              it 'responds with code 201' do
                expect(response.status).to eq(201)
              end

              it 'returns nothing' do
                expect(response.body).to be_empty
              end

              it 'saves the vote in the db' do
                expect(request).to change{ Vote.count }.by(1)
              end
            end

            context 'vote exists in the db' do
              before { Vote.create!(story: story_1, user: voter, value: 1) }

              it 'responds with code 204' do
                expect(response.status).to eq(204)
              end

              it 'returns nothing' do
                expect(response.body).to be_empty
              end

              it 'updates the vote in the db' do
                expect(request).not_to     change{ Vote.count }
                expect(Vote.last.value).to eq(-1)
              end
            end
          end
        end
      end
    end

    describe 'DELETE /stories/:id/vote' do
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
          expect(JSON.parse(response.body)['errors']).to eq({
            'login'    => ['has already been taken'],
            'password' => ['is too short (minimum is 3 characters)'],
          })
        end

        it 'does not save the user in the db' do
          expect(request).not_to change{ User.count }
        end
      end
    end
  end
end
