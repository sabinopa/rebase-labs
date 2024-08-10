require 'csv'
require_relative '../config/database'

module CSVImporter
  class self.import
    conn = DatabaseConfig.connect
    csv_file_path = 'data.csv'

    CSV.foreach(csv_file_path, headers: true, col_sep: ';') do |row|
      conn.exec_params('INSERT INTO tests (...) VALUES (...)', [row['cpf'], ...])
    end

    conn.close
  end
end
