require 'pg'
require_relative '../config/config'

class DatabaseConfig
  def self.connect
    PG.connect(DB_CONFIG)
  end
end
