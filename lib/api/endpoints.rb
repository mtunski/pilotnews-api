require_relative 'stories'

module PilotNews
  module API
    class Endpoints < Sinatra::Base

      use Stories
    end
  end
end
