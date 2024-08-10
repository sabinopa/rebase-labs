require 'sinatra'
require_relative 'config/test_service'
require_relative 'app/controllers/tests_controller'

set :bind, '0.0.0.0'
set :port, 3000
set :server, :puma
set :show_exceptions, false
