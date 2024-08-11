require 'spec_helper'
require_relative '../../app/models/doctor'
require_relative '../../app/models/patient'
require_relative '../../app/models/exam'

RSpec.describe Exam, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      patient = Patient.create('cpf' => '123.456.789-00', 'name' => 'João Silva',
                              'email' => 'joao.silva@example.com', 'birthdate' => '1985-01-01')
      doctor = Doctor.create('crm' => '123456', 'crm_state' => 'SP',
                            'name' => 'Dr. Maria Souza','email' => 'maria.souza@example.com')
      exam = Exam.new('result_token' => 'ABC123', 'result_date' => '2022-01-01',
                      'patient_id' => patient.id, 'doctor_id' => doctor.id)

      expect(exam.valid?).to be true
    end

    it 'is invalid without a result_token' do
      patient = Patient.create('cpf' => '123.456.789-00', 'name' => 'João Silva',
                              'email' => 'joao.silva@example.com', 'birthdate' => '1985-01-01')
      doctor = Doctor.create('crm' => '123456', 'crm_state' => 'SP',
                            'name' => 'Dr. Maria Souza','email' => 'maria.souza@example.com')
      exam = Exam.new('result_token' => '', 'result_date' => '2022-01-01',
                      'patient_id' => patient.id, 'doctor_id' => doctor.id)

      expect(exam.valid?).to be false
      expect(exam.errors['result_token']).to eq('cannot be empty')
    end

    it 'is invalid with a non-unique result_token' do
      patient = Patient.create('cpf' => '123.456.789-00', 'name' => 'João Silva',
                              'email' => 'joao.silva@example.com', 'birthdate' => '1985-01-01')
      doctor = Doctor.create('crm' => '123456', 'crm_state' => 'SP',
                            'name' => 'Dr. Maria Souza','email' => 'maria.souza@example.com')
      Exam.create('result_token' => 'ABC123', 'result_date' => '2022-01-01',
                  'patient_id' => patient.id, 'doctor_id' => doctor.id)
      duplicate_exam = Exam.new('result_token' => 'ABC123', 'result_date' => '2022-02-01',
                                'patient_id' => patient.id, 'doctor_id' => doctor.id)

      expect(duplicate_exam.valid?).to be false
      expect(duplicate_exam.errors['result_token']).to eq('must be unique')
    end
  end

  context '.create' do
    it 'can be created with valid attributes' do
      patient = Patient.create('cpf' => '123.456.789-00', 'name' => 'João Silva',
                              'email' => 'joao.silva@example.com', 'birthdate' => '1985-01-01')
      doctor = Doctor.create('crm' => '123456', 'crm_state' => 'SP',
                            'name' => 'Dr. Maria Souza','email' => 'maria.souza@example.com')
      exam = Exam.create('result_token' => 'ABC123', 'result_date' => '2022-01-01',
                      'patient_id' => patient.id, 'doctor_id' => doctor.id)

      expect(exam.id).not_to be_nil
    end

    it 'cannot be created with invalid attributes' do
      patient = Patient.create('cpf' => '123.456.789-00', 'name' => 'João Silva',
                              'email' => 'joao.silva@example.com', 'birthdate' => '1985-01-01')
      doctor = Doctor.create('crm' => '123456', 'crm_state' => 'SP',
                            'name' => 'Dr. Maria Souza','email' => 'maria.souza@example.com')
      exam = Exam.create('result_token' => nil, 'result_date' => '2022-01-01',
                      'patient_id' => patient.id, 'doctor_id' => doctor.id)

      expect(exam.id).to be_nil
    end
  end

  context '.find_by_result_token' do
    it 'finds an exam by result_token' do
      patient = Patient.create('cpf' => '123.456.789-00', 'name' => 'João Silva',
                              'email' => 'joao.silva@example.com', 'birthdate' => '1985-01-01')
      doctor = Doctor.create('crm' => '123456', 'crm_state' => 'SP',
                            'name' => 'Dr. Maria Souza','email' => 'maria.souza@example.com')
      created_exam = Exam.create('result_token' => 'ABC123', 'result_date' => '2022-01-01',
                      'patient_id' => patient.id, 'doctor_id' => doctor.id)

      found_exam = Exam.find_by_result_token('ABC123')

      expect(found_exam.id).to eq(created_exam.id)
      expect(found_exam.result_token).to eq(created_exam.result_token)
      expect(found_exam.result_date).to eq(created_exam.result_date)
      expect(found_exam.patient_id).to eq(created_exam.patient_id)
      expect(found_exam.doctor_id).to eq(created_exam.doctor_id)
    end

    it 'returns nil if the exam is not found' do
      found_exam = Exam.find_by_result_token('XYZ789')
      expect(found_exam).to be_nil
    end
  end

  context '#associations' do
    it 'can have many tests associated with an exam' do
      patient = Patient.create('cpf' => '123.456.789-00', 'name' => 'João Silva',
                                'email' => 'joao.silva@example.com', 'birthdate' => '1985-01-01')
      doctor = Doctor.create('crm' => '123456', 'crm_state' => 'SP',
                              'name' => 'Dr. Maria Souza','email' => 'maria.souza@example.com')
      exam = Exam.create('result_token' => 'ABC123', 'result_date' => '2022-01-01',
                                  'patient_id' => patient.id, 'doctor_id' => doctor.id)
      test1 = Test.create('exam_id' => exam.id, 'type' => 'Exame de Sangue',
                            'limits' => '10-20', 'results' => '15')
      test2 = Test.create('exam_id' => exam.id, 'type' => 'Exame de Urina',
                          'limits' => '5-10', 'results' => '7')

      expect(exam.tests.size).to eq(2)
    end
  end
end
