class Exam
  attr_reader :id, :result_token, :result_date, :patient_id, :doctor_id, :errors

  def initialize(attributes = {})
    @id = attributes['id']
    @result_token = attributes['result_token']
    @result_date = attributes['result_date']
    @patient_id = attributes['patient_id']
    @doctor_id = attributes['doctor_id']
    @errors = {}
  end

  def valid?
    @errors.clear
    validate_presence_of_attributes
    validate_uniqueness_of_result_token if @result_token
    @errors.empty?
  end

  def self.create(attributes, conn = nil)
    exam = new(attributes)
    return exam unless exam.valid?

    conn ||= DatabaseConfig.connect
    result = conn.exec_params(
      'INSERT INTO exams (result_token, result_date, patient_id, doctor_id) VALUES ($1, $2, $3, $4) RETURNING *',
      [attributes['result_token'], attributes['result_date'], attributes['patient_id'], attributes['doctor_id']]
    )
    conn.close if conn.nil?
    new(result[0])
  end

  def self.find_by_result_token(result_token, conn = nil)
    conn ||= DatabaseConfig.connect
    result = conn.exec_params('SELECT * FROM exams WHERE result_token = $1 LIMIT 1', [result_token])
    conn.close if conn.nil?
    result.any? ? new(result[0]) : nil
  end

  def tests
    conn = DatabaseConfig.connect
    result = conn.exec_params('SELECT * FROM tests WHERE exam_id = $1', [@id])
    conn.close
    result.map { |test_data| Test.new(test_data) }
  end

  private

  def validate_presence_of_attributes
    validate_presence('result_token', @result_token)
    validate_presence('result_date', @result_date)
    validate_presence('patient_id', @patient_id)
    validate_presence('doctor_id', @doctor_id)
  end

  def validate_presence(attribute, value)
    if value.nil? || (value.is_a?(String) && value.strip.empty?)
      @errors[attribute] = 'cannot be empty'
    end
  end

  def validate_uniqueness_of_result_token
    existing_exam = self.class.find_by_result_token(@result_token)
    @errors['result_token'] = 'must be unique' if existing_exam && existing_exam.id != @id
  end
end
