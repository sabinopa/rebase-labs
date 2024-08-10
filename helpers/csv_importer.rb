require 'csv'
require_relative '../config/database'

module CSVImporter
  def self.import
    conn = DatabaseConfig.connect
    csv_file_path = '/data/data.csv'

    CSV.foreach(csv_file_path, headers: true, col_sep: ';') do |row|
      conn.exec_params(
          'INSERT INTO patients (cpf, name, email, birthdate, address, city, state) VALUES ($1, $2, $3, $4, $5, $6, $7) ON CONFLICT DO NOTHING',
          [
            row['cpf'],
            row['nome paciente'],
            row['email paciente'],
            row['data nascimento paciente'],
            row['endereço/rua paciente'],
            row['cidade paciente'],
            row['estado paciente']
          ]
        )

        conn.exec_params(
          'INSERT INTO doctors (crm, crm_state, name, email) VALUES ($1, $2, $3, $4) ON CONFLICT DO NOTHING',
          [
            row['crm médico'],
            row['crm médico estado'],
            row['nome médico'],
            row['email médico']
          ]
        )

        patient_result = conn.exec_params('SELECT id FROM patients WHERE cpf = $1', [row['cpf']])
        doctor_result = conn.exec_params('SELECT id FROM doctors WHERE crm = $1', [row['crm médico']])

        if patient_result.any? && doctor_result.any?
          patient_id = patient_result[0]['id']
          doctor_id = doctor_result[0]['id']

          exam_result = conn.exec_params('SELECT id FROM exams WHERE result_token = $1', [row['token resultado exame']])

          if exam_result.any?
            exam_id = exam_result[0]['id']
          else
            conn.exec_params(
              'INSERT INTO exams (result_token, result_date, patient_id, doctor_id) VALUES ($1, $2, $3, $4)',
              [
                row['token resultado exame'],
                row['data exame'],
                patient_id,
                doctor_id
              ]
            )
            exam_id = conn.exec_params('SELECT id FROM exams WHERE result_token = $1', [row['token resultado exame']])[0]['id']
          end

          conn.exec_params(
            'INSERT INTO tests (exam_id, type, limits, results) VALUES ($1, $2, $3, $4)',
            [
              exam_id,
              row['tipo exame'],
              row['limites tipo exame'],
              row['resultado tipo exame']
            ]
          )

        end
    end

    conn.close
  end
end

CSVImporter.import
