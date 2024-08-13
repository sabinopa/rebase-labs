require_relative '../../config/database'

class Patient
  attr_reader :id, :cpf, :name, :email, :birthdate, :address, :city, :state, :errors

  def initialize(attributes = {})
    @id = attributes['id']
    @cpf = attributes['cpf']
    @name = attributes['name']
    @email = attributes['email']
    @birthdate = attributes['birthdate']
    @address = attributes['address']
    @city = attributes['city']
    @state = attributes['state']
    @errors = {}
  end

  def self.create(attributes)
    conn = DatabaseConfig.connect

    raise "CPF is required" if attributes['cpf'].nil? || attributes['cpf'].strip.empty?
    raise "Name is required" if attributes['name'].nil? || attributes['name'].strip.empty?

    validate_uniqueness_of_cpf!(attributes['cpf'], conn)

    result = conn.exec_params(
      'INSERT INTO patients (cpf, name, email, birthdate, address, city, state) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *',
      [
        attributes['cpf'],
        attributes['name'],
        attributes['email'],
        attributes['birthdate'],
        attributes['address'],
        attributes['city'],
        attributes['state']
      ]
    )

    conn.close
    new(result[0])
  end

  def self.find_by_cpf(cpf)
    conn = DatabaseConfig.connect
    result = conn.exec_params('SELECT * FROM patients WHERE cpf = $1 LIMIT 1', [cpf])
    conn.close
    result.any? ? new(result[0]) : nil
  end

  def self.find_by_id(id)
    conn = DatabaseConfig.connect
    result = conn.exec_params('SELECT * FROM patients WHERE id = $1 LIMIT 1', [id])
    conn.close
    result.any? ? new(result[0]) : nil
  end

  def valid?
    @errors.clear
    validate_presence_of_attributes
    @errors.empty?
  end

  def exams
    conn = DatabaseConfig.connect
    result = conn.exec_params('SELECT * FROM exams WHERE patient_id = $1', [@id])
    exams = result.map { |exam_data| Exam.new(exam_data) }
    conn.close
    exams
  end

  private

  def validate_presence_of_attributes
    validate_presence('cpf', @cpf)
    validate_presence('name', @name)
    validate_presence('email', @email)
    validate_presence('birthdate', @birthdate)
    validate_presence('address', @address)
    validate_presence('city', @city)
    validate_presence('state', @state)
  end

  def validate_presence(attribute, value)
    @errors[attribute] = 'cannot be empty' if value.nil? || value.strip.empty?
  end

  def self.validate_uniqueness_of_cpf!(cpf, conn)
    result = conn.exec_params('SELECT 1 FROM patients WHERE cpf = $1', [cpf])
    raise "CPF must be unique" if result.any?
  end
end
