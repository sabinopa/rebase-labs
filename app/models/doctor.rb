require_relative '../../config/database'
class Doctor
  attr_reader :id, :crm, :crm_state, :name, :email

  def initialize(attributes = {})
    @id = attributes['id']
    @crm = attributes['crm']
    @crm_state = attributes['crm_state']
    @name = attributes['name']
    @email = attributes['email']
  end

  def self.create(attributes, conn = nil)
    conn ||= DatabaseConfig.connect
    result = conn.exec_params(
      'INSERT INTO doctors (crm, crm_state, name, email) VALUES ($1, $2, $3, $4) RETURNING *',
      [
        attributes['crm'],
        attributes['crm_state'],
        attributes['name'],
        attributes['email']
      ]
    )
    conn.close if conn
    new(result[0])
  end

  def self.find_by_crm(crm, crm_state, conn = nil)
    conn ||= DatabaseConfig.connect
    result = conn.exec_params('SELECT * FROM doctors WHERE crm = $1 AND crm_state = $2 LIMIT 1', [crm, crm_state])
    conn.close if conn
    result.any? ? new(result[0]) : nil
  end
end

