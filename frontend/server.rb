require 'sinatra'
require_relative '../backend/config/database'
require_relative '../backend/app/models/exam'

set :bind, '0.0.0.0'
set :port, 2000
set :views, File.join(File.dirname(__FILE__), '../frontend/views')

PER_PAGE = 10

get '/' do
  page = (params[:page] || 1).to_i

  @exams = Exam.paginate(page: page, per_page: PER_PAGE)
  @current_page = page
  @total_pages = (Exam.count / PER_PAGE.to_f).ceil

  erb :index
end

get '/api/tests/:token' do
  content_type :json

  exam = Exam.find_by_result_token(params[:token])
  halt 404, { error: "Exame não encontrado." }.to_json unless exam

  {
    result_token: exam.result_token,
    result_date: exam.result_date,
    cpf: exam.patient.cpf,
    name: exam.patient.name,
    email: exam.patient.email,
    birthdate: exam.patient.birthdate,
    doctor: {
      crm: exam.doctor.crm,
      crm_state: exam.doctor.crm_state,
      name: exam.doctor.name,
      email: exam.doctor.email
    },
    tests: exam.tests.map do |test|
      {
        type: test.type,
        limits: test.limits,
        result: test.results
      }
    end
  }.to_json
end

get '/api/exams' do
  page = (params[:page] || 1).to_i

  exams = Exam.paginate(page: page, per_page: PER_PAGE).map do |exam|
    {
      result_token: exam.result_token,
      result_date: exam.result_date,
      patient_name: exam.patient.name
    }
  end

  total_pages = (Exam.count / PER_PAGE.to_f).ceil

  {
    exams: exams,
    pagination: {
      current_page: page,
      next_page: (page < total_pages) ? page + 1 : nil,
      prev_page: (page > 1) ? page - 1 : nil,
      total_pages: total_pages
    }
  }.to_json
end

get '/exams/:token' do
  @exam = Exam.find_by_result_token(params[:token])
  halt 404, { error: "Exame não encontrado." }.to_json unless @exam

  erb :exam_details
end
