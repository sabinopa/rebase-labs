require 'sinatra'
require_relative 'config/test_service'
require_relative 'app/controllers/tests_controller'

configure :development do
  set :show_exceptions, true
end

set :bind, '0.0.0.0'
set :port, 3000
set :server, :puma
