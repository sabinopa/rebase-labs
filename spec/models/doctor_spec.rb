require 'spec_helper'
require_relative '../../app/models/doctor'

RSpec.describe Doctor, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      doctor = Doctor.new('crm' => '123456', 'crm_state' => 'SP',
                          'name' => 'Dr. House', 'email' => 'house@email.com')

      expect(doctor.valid?).to be true
    end

    it 'is invalid without a CRM' do
      doctor = Doctor.new('crm' => nil, 'crm_state' => 'SP', '
                          name' => 'Dr. House', 'email' => 'house@email.com')

      expect(doctor.valid?).to be false
      expect(doctor.errors['crm']).to eq('cannot be empty')
    end

    it 'is invalid without a CRM state' do
      doctor = Doctor.new('crm' => '123456', 'crm_state' => nil,
                          'name' => 'Dr. House', 'email' => 'house@email.com')

      expect(doctor.valid?).to be false
      expect(doctor.errors['crm_state']).to eq('cannot be empty')
    end

    it 'is invalid without a name' do
      doctor = Doctor.new('crm' => '123456', 'crm_state' => 'SP',
                          'name' => nil, 'email' => 'house@email.com')

      expect(doctor.valid?).to be false
      expect(doctor.errors['name']).to eq('cannot be empty')
    end

    it 'is invalid with a non-unique CRM within the same state' do
      Doctor.create('crm' => '123456', 'crm_state' => 'SP',
                    'name' => 'Dr. House', 'email' => 'house@email.com')
      duplicate_doctor = Doctor.new('crm' => '123456', 'crm_state' => 'SP',
                                    'name' => 'Dr. Strange', 'email' => 'strange@email.com')

      expect(duplicate_doctor.valid?).to be false
      expect(duplicate_doctor.errors['crm']).to eq('must be unique')
    end
  end

  context '.create' do
    it 'can be created with valid attributes' do
      doctor = Doctor.create('crm' => '123456', 'crm_state' => 'SP',
                            'name' => 'Dr. House', 'email' => 'house@email.com')

      expect(doctor.id).not_to be_nil
      expect(doctor.id).to be_a String
      expect(doctor.crm).to eq '123456'
      expect(doctor.crm_state).to eq 'SP'
      expect(doctor.name).to eq 'Dr. House'
      expect(doctor.email).to eq 'house@email.com'

    end

    it 'cannot be created with invalid attributes' do
      doctor = Doctor.create('crm' => nil, 'crm_state' => 'SP',
                            'name' => 'Dr. House', 'email' => 'house@email.com')

      expect(doctor.id).to be_nil
      expect(doctor.errors['crm']).to eq('cannot be empty')
    end
  end

  context 'find_by_crm' do
    it 'finds a doctor by CRM and CRM state' do
      created_doctor = Doctor.create(
        'crm' => '123456',
        'crm_state' => 'SP',
        'name' => 'Dr. House',
        'email' => 'house@example.com'
      )

      found_doctor = Doctor.find_by_crm('123456', 'SP')
      expect(found_doctor.crm).to eq(created_doctor.crm)
      expect(found_doctor.crm_state).to eq(created_doctor.crm_state)
      expect(found_doctor.name).to eq(created_doctor.name)
      expect(found_doctor.email).to eq(created_doctor.email)
    end

    it 'returns nil if the doctor is not found' do
      found_doctor = Doctor.find_by_crm('000000', 'SP')
      expect(found_doctor).to be_nil
    end
  end
end
