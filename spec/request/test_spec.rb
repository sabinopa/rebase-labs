require 'spec_helper'

describe 'TestService API' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe 'GET /tests' do
    it 'returns a list of tests' do
      get '/tests'
      expect(last_response).to be_ok
      expect(last_response.content_type).to eq('application/json')
      expect(last_response.body).to include('result_token')
    end
  end

  describe 'GET /tests/:token' do
    it 'returns the test with the specified token' do
      token = 'abc123'

      allow(TestService).to receive(:parse_tests_by_token).with(token).and_return({ result_token: token }.to_json)

      get "/tests/#{token}"
      expect(last_response).to be_ok
      expect(last_response.body).to include(token)
    end

    it 'returns a list of tests' do
      get '/tests'
      expect(last_response).to be_ok
      expect(last_response.content_type).to eq('application/json')
      expect(last_response.body).to include('result_token')
    end
  end
end
