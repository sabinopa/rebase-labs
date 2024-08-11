require 'spec_helper'
require_relative '../../app/models/doctor'
require_relative '../../app/models/patient'
require_relative '../../app/models/exam'

RSpec.describe Patient, type: :model do
  context '.create' do
    it 'creates a valid patient' do
      patient = Patient.create( 'cpf' => '024.489.320-93', 'name' => 'Carlos Silva',
                                'email' => 'carlos.silva@example.com',
                                'birthdate' => '1985-02-15',
                                'address' => 'Rua das Flores, 123',
                                'city' => 'São Paulo', 'state' => 'SP' )

      expect(patient.id).not_to be_nil
      expect(patient.valid?).to be true
      expect(patient.cpf).to eq('024.489.320-93')
    end

    it 'raises an error when required fields are missing' do
      expect { Patient.create({ 'name' => 'John Doe' }) }.to raise_error("CPF is required")
    end
  end

  context '.find_by_cpf' do
    it 'finds a patient by CPF' do
      patient = Patient.create( 'cpf' => '150.128.090-25', 'name' => 'Ana Oliveira',
                                'email' => 'ana.oliveira@example.com',
                                'birthdate' => '1992-07-20',
                                'address' => 'Avenida Paulista, 456',
                                'city' => 'São Paulo', 'state' => 'SP' )

      found_patient = Patient.find_by_cpf('150.128.090-25')

      expect(found_patient).not_to be_nil
      expect(found_patient.cpf).to eq '150.128.090-25'
    end

    it 'returns nil for a non-existent CPF' do
      found_patient = Patient.find_by_cpf('999.999.999-99')
      expect(found_patient).to be_nil
    end
  end

  context '#valid?' do
    it 'validates the presence of attributes' do
      patient = Patient.new( 'cpf' => '', 'name' => '', 'email' => '',
                             'birthdate' => '', 'address' => '',
                             'city' => '', 'state' => '' )

      expect(patient).not_to be_valid
      expect(patient.errors.values.count { |msg| msg == 'cannot be empty' }).to eq 7
    end

    it 'validates CPF uniqueness' do
      cpf = '250.014.730-47'
      Patient.create( 'cpf' => cpf, 'name' => 'Mariana Lima',
                      'email' => 'mariana.lima@example.com', 'birthdate' => '1989-05-25',
                      'address' => 'Avenida Atlântica, 101',
                      'city' => 'Rio de Janeiro', 'state' => 'RJ' )

      expect {
        Patient.create( 'cpf' => cpf, 'name' => 'Mariana Lima',
                        'email' => 'mariana.lima@example.com',
                        'birthdate' => '1989-05-25',
                        'address' => 'Avenida Atlântica, 101',
                        'city' => 'Rio de Janeiro', 'state' => 'RJ' )
      }.to raise_error("CPF must be unique")
    end
  end

  context '#associations' do
    it 'has many exams' do
      patient = Patient.create('cpf' => '55566677788', 'name' => 'João Pereira',
                               'email' => 'joao.pereira@example.com',
                               'birthdate' => '1975-08-30',
                               'address' => 'Rua do Comércio, 202',
                               'city' => 'Belo Horizonte', 'state' => 'MG')

      doctor = Doctor.create({ 'crm' => '123456', 'crm_state' => 'SP',
                               'name' => 'Dr. Silva', 'email' => 'dr.silva@example.com' })

      2.times do
        Exam.create({ 'result_token' => "token-#{rand(1000)}", 'result_date' => '2024-01-01',
                      'patient_id' => patient.id, 'doctor_id' => doctor.id })
      end

      exams = patient.exams
      expect(patient.exams.size).to eq(2)
    end

    it 'returns an empty array if no exams are associated' do
      patient = Patient.create('cpf' => '55566677788', 'name' => 'João Pereira',
                                'email' => 'joao.pereira@example.com',
                                'birthdate' => '1975-08-30',
                                'address' => 'Rua do Comércio, 202',
                                'city' => 'Belo Horizonte', 'state' => 'MG')
      expect(patient.exams).to be_empty
    end
  end
end
