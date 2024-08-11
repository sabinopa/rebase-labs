class Test
  attr_reader :id, :exam_id, :type, :limits, :results, :errors

  def initialize(attributes = {})
    @id = attributes['id']
    @exam_id = attributes['exam_id']
    @type = attributes['type']
    @limits = attributes['limits']
    @results = attributes['results']
    @errors = {}
  end

  def valid?
    @errors.clear
    validate_presence_of_attributes
    @errors.empty?
  end

  def self.create(attributes, conn = nil)
    test = new(attributes)
    return test unless test.valid?

    conn ||= DatabaseConfig.connect
    result = conn.exec_params(
      'INSERT INTO tests (exam_id, type, limits, results) VALUES ($1, $2, $3, $4) RETURNING *',
      [attributes['exam_id'], attributes['type'], attributes['limits'], attributes['results']]
    )
    conn.close if conn.nil?
    new(result[0])
  end

  private

  def validate_presence_of_attributes
    validate_presence('exam_id', @exam_id)
    validate_presence('type', @type)
    validate_presence('limits', @limits)
    validate_presence('results', @results)
  end

  def validate_presence(attribute, value)
    if value.nil? || (value.is_a?(String) && value.strip.empty?)
      @errors[attribute] = 'cannot be empty'
    end
  end
end
