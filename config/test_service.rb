require_relative 'database'

class TestService
  def self.parse_tests
    sql_query = base_sql_query
    result = execute_query(sql_query)

    formatted_results = format_result(result)
    formatted_results.to_json
  end

  def self.parse_tests_by_token(token)
    sql_query = base_sql_query + "WHERE e.result_token = $1"
    result = execute_query(sql_query, [token])

    return { error: 'Token inválido.'}.to_json if result.nil? || result.entries.empty?

    exam = format_result(result.entries.first)
    exam.to_json
  end

  private

  def base_sql_query
    sql_query = <<-SQL
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
        e.id;
    SQL
  end

  def self.execute_query(sql, params = [])
    conn = DatabaseConfig.connect
    result = params.empty? ? conn.exec(sql) : conn.exec_params(sql, params)
    conn.close
    result
  end

  def self.format_result(results)
    results.map { |entry| format_result(exam) }
  end

  def self.format_result(entry)
    {
      "result_token": exam['result_token'],
      "result_date": exam['result_date'],
      "patient": JSON.parse(exam['patient']),
      "doctor": JSON.parse(exam['doctor']),
      "tests": JSON.parse(exam['tests'])
    }
  end
end
