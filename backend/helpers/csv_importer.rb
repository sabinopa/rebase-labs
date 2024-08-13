require 'csv'
require_relative '../config/database'
require_relative '../app/models/patient'
require_relative '../app/models/doctor'
require_relative '../app/models/exam'
require_relative '../app/models/test'

module CSVImporter
  def self.import
    csv_file_path = 'data/data.csv'

    CSV.foreach(csv_file_path, headers: true, col_sep: ';') do |row|
      patient = Patient.find_by_cpf(row['cpf']) || Patient.create(
        'cpf' => row['cpf'],
        'name' => row['nome paciente'],
        'email' => row['email paciente'],
        'birthdate' => row['data nascimento paciente'],
        'address' => row['endereço/rua paciente'],
        'city' => row['cidade paciente'],
        'state' => row['estado paciente']
      )

      doctor = Doctor.find_by_crm(row['crm médico'], row['crm médico estado']) || Doctor.create(
        'crm' => row['crm médico'],
        'crm_state' => row['crm médico estado'],
        'name' => row['nome médico'],
        'email' => row['email médico']
      )

      exam = Exam.find_by_result_token(row['token resultado exame']) || Exam.create(
        'result_token' => row['token resultado exame'],
        'result_date' => row['data exame'],
        'patient_id' => patient.id,
        'doctor_id' => doctor.id
      )

      Test.create(
        'exam_id' => exam.id,
        'type' => row['tipo exame'],
        'limits' => row['limites tipo exame'],
        'results' => row['resultado tipo exame']
      )
    end
  end
end


CSVImporter.import
