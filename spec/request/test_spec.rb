require 'spec_helper'

describe 'TestService API' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe 'GET /tests' do
    it 'returns a list of tests' do
      patient = Patient.create(  'cpf' => '024.489.320-93', 'name' => 'Carlos Silva',
                                  'email' => 'carlos.silva@example.com',
                                  'birthdate' => '1985-02-15',
                                  'address' => 'Rua das Flores, 123',
                                  'city' => 'São Paulo', 'state' => 'SP' )

      doctor = Doctor.create({ 'crm' => '123456', 'crm_state' => 'SP',
                                'name' => 'Dr. Silva', 'email' => 'dr.silva@example.com' })


      Exam.create({ 'result_token' => "abc123", 'result_date' => '2024-01-01',
                    'patient_id' => patient.id, 'doctor_id' => doctor.id })

      get '/tests'
      expect(last_response).to be_ok
      expect(last_response.content_type).to eq('application/json')
      expect(last_response.body).to include('result_token')
    end
  end

  describe 'GET /tests/:token' do
    it 'returns the test with the specified token' do
      patient = Patient.create('cpf' => '024.489.320-93', 'name' => 'Carlos Silva',
                                'email' => 'carlos.silva@example.com',
                                'birthdate' => '1985-02-15',
                                'address' => 'Rua das Flores, 123',
                                'city' => 'São Paulo', 'state' => 'SP')

      doctor = Doctor.create({ 'crm' => '123456', 'crm_state' => 'SP',
                                'name' => 'Dr. Silva', 'email' => 'dr.silva@example.com' })


      Exam.create({ 'result_token' => "abc123", 'result_date' => '2024-01-01',
                    'patient_id' => patient.id, 'doctor_id' => doctor.id })

      token = 'abc123'
      get "/tests/#{token}"

      expect(last_response).to be_ok
      expect(last_response.body).to include(token)
    end

  end
end
