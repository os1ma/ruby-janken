# frozen_string_literal: true

require 'pg'

# PostgreSQL の DAO に関するユーティリティ
module PostgresDaoUtils
  POSTGRES_HOST = 'localhost'
  POSTGRES_PORT = '5432'
  POSTGRES_DB = 'janken'
  POSTGRES_USER = 'postgres'
  POSTGRES_PASSWORD = 'password'

  COUNT_QUERY = 'SELECT COUNT(*) AS "count_value" FROM %s'
  class << self
    def count(table_name)
      query = format(COUNT_QUERY, table_name)

      with_connection do |conn|
        res = conn.exec(query)
        res[0]['count_value'].to_i
      end
    end

    def with_connection
      conn = PG::Connection.new(
        host: POSTGRES_HOST,
        port: POSTGRES_PORT,
        dbname: POSTGRES_DB,
        user: POSTGRES_USER,
        password: POSTGRES_PASSWORD
      )

      yield(conn)
    ensure
      conn&.close
    end
  end
end
