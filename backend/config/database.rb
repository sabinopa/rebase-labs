require 'pg'
require_relative '../config/config'
require_relative '../config/database'

class DatabaseConfig
  def self.connect
    PG.connect(DB_CONFIG)
  end
end
