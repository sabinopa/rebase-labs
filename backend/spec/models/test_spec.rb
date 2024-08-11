require 'spec_helper'
require_relative '../../app/models/doctor'
require_relative '../../app/models/patient'
require_relative '../../app/models/exam'
require_relative '../../app/models/test'

RSpec.describe Test, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      test = Test.new('exam_id' => 1, 'type' => 'Exame de Sangue',
                      'limits' => '10-20', 'results' => '15')

      expect(test.valid?).to be true
    end

    it 'is invalid without an exam_id' do
      test = Test.new('exam_id' => nil, 'type' => 'Exame de Sangue',
                      'limits' => '10-20', 'results' => '15')

      expect(test.valid?).to be false
      expect(test.errors['exam_id']).to eq('cannot be empty')
    end

    it 'is invalid without a type' do
      test = Test.new('exam_id' => 1, 'type' => nil,
                      'limits' => '10-20', 'results' => '15')

      expect(test.valid?).to be false
      expect(test.errors['type']).to eq('cannot be empty')
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
      test = Test.create('exam_id' => exam.id, 'type' => 'Exame de Sangue',
                        'limits' => '10-20', 'results' => '15')

      expect(test.id).not_to be_nil
    end

    it 'cannot be created with invalid attributes' do
      patient = Patient.create('cpf' => '123.456.789-00', 'name' => 'João Silva',
                              'email' => 'joao.silva@example.com', 'birthdate' => '1985-01-01')
      doctor = Doctor.create('crm' => '123456', 'crm_state' => 'SP',
                            'name' => 'Dr. Maria Souza','email' => 'maria.souza@example.com')
      exam = Exam.create('result_token' => 'ABC123', 'result_date' => '2022-01-01',
                      'patient_id' => patient.id, 'doctor_id' => doctor.id)
      test = Test.create('exam_id' => exam.id, 'type' => nil,
                        'limits' => '10-20', 'results' => '15')

      expect(test.id).to be_nil
    end
  end
end
