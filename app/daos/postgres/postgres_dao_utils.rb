# frozen_string_literal: true

require 'pg'

# PostgreSQL の DAO に関するユーティリティ
module PostgresDaoUtils
  COUNT_QUERY = 'SELECT COUNT(*) AS "count_value" FROM %s'
  class << self
    def count(conn, table_name)
      query = format(COUNT_QUERY, table_name)
      res = conn.exec(query)
      res[0]['count_value'].to_i
    end
  end
end
