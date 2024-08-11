require 'sinatra'
require_relative '../../config/test_service'

get '/tests' do
  content_type :json
  TestService.parse_tests
end

get '/tests/:token' do
  content_type :json
  response = TestService.parse_tests_by_token(params[:token])
  halt 404, { error: "Test not found for token #{params[:token]}" }.to_json if response.nil?
  response
end

