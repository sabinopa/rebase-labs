require 'sinatra'
require 'faraday'
require 'json'
require_relative 'services/fetch.rb'

set :bind, '0.0.0.0'
set :port, 2000
set :server, :puma
set :views, File.join(File.dirname(__FILE__), '../frontend/views')

PER_PAGE = 10


get '/' do
  page = (params[:page] || 1).to_i
  token = params[:token]

  @exams = JSON.parse(Fetch.all)
  @exam = @exams.find { |exam| exam["result_token"] == token.upcase }

  @current_page = page
  @total_pages = (@exams.count / PER_PAGE.to_f).ceil
  start_index = (page - 1) * PER_PAGE
  end_index = start_index + PER_PAGE - 1

  @exams_paginated = @exams[start_index..end_index]
  p @exam

  erb :index
end

get '/exams/:token' do
  @exam = JSON.parse(Fetch.find_by_token(params[:token]))
  halt 404, { error: 'Exame não encontrado.' }.to_json unless @exam

  erb :exam_details
end
