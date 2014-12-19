require 'spec_helper'
require 'app'

describe App do
  let(:app) { App.new }

  it 'returns a successful response' do
    get '/'

    expect(last_response).to be_ok
  end
end
