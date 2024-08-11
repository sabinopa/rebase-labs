require_relative '../../config/database'

class Exam
  attr_reader :id, :result_token, :result_date, :patient_id, :doctor_id

  def initialize(attributes = {})
    @id = attributes['id']
    @result_token = attributes['result_token']
    @result_date = attributes['result_date']
    @patient_id = attributes['patient_id']
    @doctor_id = attributes['doctor_id']
  end

  def self.create(attributes)
    conn = DatabaseConfig.connect
    result = conn.exec_params(
      'INSERT INTO exams (result_token, result_date, patient_id, doctor_id) VALUES ($1, $2, $3, $4) RETURNING *',
      [
        attributes['result_token'],
        attributes['result_date'],
        attributes['patient_id'],
        attributes['doctor_id']
      ]
    )
    conn.close
    new(result[0])
  end

  def self.find_by_result_token(token)
    conn = DatabaseConfig.connect
    result = conn.exec_params('SELECT * FROM exams WHERE result_token = $1 LIMIT 1', [token])
    conn.close
    result.any? ? new(result[0]) : nil
  end
end
