require 'sinatra'
require_relative '../config/test_service'

get '/tests' do
  content_type :json
  TestService.parse_tests
end

get '/tests/:token' do
  content_type :json
  TestService.parse_tests_by_token(params[:token])
end
