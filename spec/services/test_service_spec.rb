require 'spec_helper'
require_relative '../../config/test_service'

RSpec.describe TestService do
  describe '.base_sql_query' do
    it 'returns the correct SQL query' do
      expected_sql = <<-SQL
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

      generated_sql = TestService.send(:base_sql_query).gsub(/\s+/, ' ').strip
      expected_sql_normalized = expected_sql.gsub(/\s+/, ' ').strip

      expect(generated_sql).to eq(expected_sql_normalized)
    end
  end

  describe '.format_result' do
    it 'formats the exam data correctly' do
      exam = {
        'result_token' => 'abc123',
        'result_date' => '2024-08-10',
        'patient' => '{"cpf": "12345678900", "name": "John Doe"}',
        'doctor' => '{"crm": "123456", "name": "Dr. Smith"}',
        'tests' => '[{"type": "blood", "limits": "10-20", "results": "15"}]'
      }

      formatted_exam = TestService.send(:format_result, exam)

      expected_result = {
        result_token: 'abc123',
        result_date: '2024-08-10',
        patient: { 'cpf' => '12345678900', 'name' => 'John Doe' },
        doctor: { 'crm' => '123456', 'name' => 'Dr. Smith' },
        tests: [{ 'type' => 'blood', 'limits' => '10-20', 'results' => '15' }]
      }

      expect(formatted_exam).to eq(expected_result)
    end
  end

  describe '.parse_tests_by_token' do
    it 'returns formatted result for a given token' do
      token = 'abc123'
      allow(TestService).to receive(:execute_query).and_return([mock_exam_data])

      result = TestService.parse_tests_by_token(token)
      expect(result).to include('"result_token":"abc123"')
    end

    private

    def mock_exam_data
      {
        'result_token' => 'abc123',
        'result_date' => '2024-08-10',
        'patient' => '{"cpf": "12345678900", "name": "John Doe"}',
        'doctor' => '{"crm": "123456", "name": "Dr. Smith"}',
        'tests' => '[{"type": "blood", "limits": "10-20", "results": "15"}]'
      }
    end
  end

end
