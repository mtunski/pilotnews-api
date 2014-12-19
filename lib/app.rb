require 'sinatra'
require 'json'
require 'active_record'

require_relative 'story'

ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])

class App < Sinatra::Base
  get '/' do '' end

  get '/api/stories' do
    content_type :json

    Story.all.to_json
  end

  get '/api/stories/:id' do
    content_type :json

    Story.find(params[:id]).to_json
  end

  error ActiveRecord::RecordNotFound do
    status 404
  end
end
