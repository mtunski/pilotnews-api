require 'sinatra'
require 'json'
require 'dotenv'

Dotenv.load(".env.#{settings.environment}")

class App < Sinatra::Base
  get '/' do '' end

  get '/api/stories' do
    content_type :json

    {
      story1: { id: 1, title: 'Story 1', url: 'http://www.lipsum.com/' },
      story2: { id: 2, title: 'Story 2', url: 'http://www.lipsum.com/' }
    }.to_json
  end

  get '/api/stories/:id' do
    content_type :json

    if params['id'] == '1'
      { story: { id: 1, title: 'Story 1', url: 'http://www.lipsum.com/' } }.to_json(:root => true)
    else
      status 404
    end
  end
end
