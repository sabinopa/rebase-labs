require_relative '../../config/database'

class Test
  attr_reader :id, :exam_id, :type, :limits, :results

  def initialize(attributes = {})
    @id = attributes['id']
    @exam_id = attributes['exam_id']
    @type = attributes['type']
    @limits = attributes['limits']
    @results = attributes['results']
  end

  def self.create(attributes)
    conn = DatabaseConfig.connect
    result = conn.exec_params(
      'INSERT INTO tests (exam_id, type, limits, results) VALUES ($1, $2, $3, $4) RETURNING *',
      [
        attributes['exam_id'],
        attributes['type'],
        attributes['limits'],
        attributes['results']
      ]
    )
    conn.close
    new(result[0])
  end
end
