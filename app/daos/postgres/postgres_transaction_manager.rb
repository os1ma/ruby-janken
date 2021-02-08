# frozen_string_literal: true

# PostgreSQL のトランザクション管理を提供するモジュール
module PostgresTransactionManager
  POSTGRES_HOST = 'localhost'
  POSTGRES_PORT = '5432'
  POSTGRES_DB = 'janken'
  POSTGRES_USER = 'postgres'
  POSTGRES_PASSWORD = 'password'

  class << self
    def transactional(&block)
      conn = PG::Connection.new(
        host: POSTGRES_HOST,
        port: POSTGRES_PORT,
        dbname: POSTGRES_DB,
        user: POSTGRES_USER,
        password: POSTGRES_PASSWORD
      )

      conn.transaction(&block)
    ensure
      conn&.close
    end
  end
end
