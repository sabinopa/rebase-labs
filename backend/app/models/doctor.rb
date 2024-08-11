class Doctor
  attr_reader :id, :crm, :crm_state, :name, :email, :errors

  def initialize(attributes = {})
    @id = attributes['id']
    @crm = attributes['crm']
    @crm_state = attributes['crm_state']
    @name = attributes['name']
    @email = attributes['email']
    @errors = {}
  end

  def valid?
    @errors.clear
    validate_presence_of_attributes
    validate_uniqueness_of_crm if @crm && @crm_state
    @errors.empty?
  end

  def self.create(attributes, conn = nil)
    doctor = new(attributes)
    return doctor unless doctor.valid?

    conn ||= DatabaseConfig.connect
    result = conn.exec_params(
      'INSERT INTO doctors (crm, crm_state, name, email) VALUES ($1, $2, $3, $4) RETURNING *',
      [attributes['crm'], attributes['crm_state'], attributes['name'], attributes['email']]
    )
    conn.close if conn.nil?
    new(result[0])
  end

  def self.find_by_crm(crm, crm_state, conn = nil)
    conn ||= DatabaseConfig.connect
    result = conn.exec_params('SELECT * FROM doctors WHERE crm = $1 AND crm_state = $2 LIMIT 1', [crm, crm_state])
    conn.close if conn.nil?
    result.any? ? new(result[0]) : nil
  end

  private

  def validate_presence_of_attributes
    validate_presence('crm', @crm)
    validate_presence('crm_state', @crm_state)
    validate_presence('name', @name)
    validate_presence('email', @email)
  end

  def validate_presence(attribute, value)
    @errors[attribute] = 'cannot be empty' if value.nil? || value.strip.empty?
  end

  def validate_uniqueness_of_crm
    existing_doctor = self.class.find_by_crm(@crm, @crm_state)
    @errors['crm'] = 'must be unique' if existing_doctor && existing_doctor.id != @id
  end
end
