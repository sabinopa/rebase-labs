require_relative 'database'
require 'json'

class TestService
  def self.parse_tests
    sql_query = base_sql_query
    result = execute_query(sql_query)
    format_results(result).to_json
  end

  def self.parse_tests_by_token(token)
    sql_query = sql_query_with_token_condition
    result = execute_query(sql_query, [token])

    if result_empty?(result)
      return error_response('Token inválido.')
    end

    format_result(result.entries.first).to_json
  end

  private

  def self.sql_query_with_token_condition
    <<-SQL
      SELECT
        e.result_token AS result_token,
        e.result_date AS result_date,
        jsonb_build_object(
          'cpf', p.cpf,
          'name', p.name,
          'email', p.email,
          'birthdate', p.birthdate,
          'address', p.address,
          'city', p.city,
          'state', p.state
        ) AS patient,
        jsonb_build_object(
          'crm', d.crm,
          'name', d.name,
          'email', d.email,
          'crm_state', d.crm_state
        ) AS doctor,
        jsonb_agg(
          json_build_object(
            'type', t.type,
            'limits', t.limits,
            'results', t.results
          )
        ) AS tests
      FROM
        exams e
      JOIN
        patients p ON e.patient_id = p.id
      JOIN
        doctors d ON e.doctor_id = d.id
      LEFT JOIN
        tests t ON e.id = t.exam_id
      WHERE
        e.result_token = $1
      GROUP BY
        e.id, p.id, d.id
      ORDER BY
        e.id
    SQL
  end

  def self.base_sql_query
    <<-SQL
      SELECT
        e.result_token AS result_token,
        e.result_date AS result_date,
        jsonb_build_object(
          'cpf', p.cpf,
          'name', p.name,
          'email', p.email,
          'birthdate', p.birthdate,
          'address', p.address,
          'city', p.city,
          'state', p.state
        ) AS patient,
        jsonb_build_object(
          'crm', d.crm,
          'name', d.name,
          'email', d.email,
          'crm_state', d.crm_state
        ) AS doctor,
        jsonb_agg(
          json_build_object(
            'type', t.type,
            'limits', t.limits,
            'results', t.results
          )
        ) AS tests
      FROM
        exams e
      JOIN
        patients p ON e.patient_id = p.id
      JOIN
        doctors d ON e.doctor_id = d.id
      LEFT JOIN
        tests t ON e.id = t.exam_id
      GROUP BY
        e.id, p.id, d.id
      ORDER BY
        e.id
    SQL
  end

  def self.execute_query(sql, params = [])
    conn = DatabaseConfig.connect
    result = conn.exec_params(sql, params)
    conn.close
    result
  rescue PG::Error => e
    handle_sql_error(e)
  end

  def self.format_results(results)
    results.map { |exam| format_result(exam) }
  end

  def self.format_result(entry)
    {
      "result_token": entry['result_token'],
      "result_date": entry['result_date'],
      "patient": JSON.parse(entry['patient']),
      "doctor": JSON.parse(entry['doctor']),
      "tests": filter_valid_tests(entry['tests'])
    }
  end

  def self.filter_valid_tests(tests_json)
    JSON.parse(tests_json).reject do |test|
      test['type'].nil? || test['limits'].nil? || test['results'].nil?
    end
  end

  def self.result_empty?(result)
    result.nil? || result.entries.empty?
  end

  def self.error_response(message)
    { error: message }.to_json
  end

  def self.handle_sql_error(error)
    puts "An error occurred while executing SQL query: #{error.message}"
    raise error
  end
end
