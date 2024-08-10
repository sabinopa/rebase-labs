require 'csv'
require_relative '../config/database'

module CSVImporter
  def self.import
    conn = DatabaseConfig.connect
    csv_file_path = '/app/data/data.csv'

    CSV.foreach(csv_file_path, headers: true, col_sep: ';') do |row|
      conn.exec_params(
        'INSERT INTO tests (cpf, nome_paciente, email_paciente, data_nascimento_paciente, endereco_rua_paciente, cidade_paciente, estado_paciente, crm_medico, crm_medico_estado, nome_medico, email_medico, token_resultado_exame, data_exame, tipo_exame, limites_tipo_exame, resultado_tipo_exame) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15)',
        [
          row['cpf'],
          row['nome paciente'],
          row['email paciente'],
          row['data nascimento paciente'],
          row['endereço/rua paciente'],
          row['cidade paciente'],
          row['estado patiente'],
          row['crm médico'],
          row['crm médico estado'],
          row['nome médico'],
          row['email médico'],
          row['token resultado exame'],
          row['data exame'],
          row['tipo exame'],
          row['limites tipo exame'],
          row['resultado tipo exame']
        ]
      )
    end

    conn.close
  end
end
