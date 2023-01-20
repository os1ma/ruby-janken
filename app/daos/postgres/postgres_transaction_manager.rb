# frozen_string_literal: true

require 'pg'

# PostgreSQL のトランザクション管理を提供するモジュール
module PostgresTransactionManager
  POSTGRES_URL = ENV['DATABASE_URL']
  POSTGRES_HOST = ENV['POSTGRES_HOST'] || 'localhost'
  POSTGRES_PORT = '5432'
  POSTGRES_DB = 'janken'
  POSTGRES_USER = 'postgres'
  POSTGRES_PASSWORD = 'password'

  class << self
    def transactional(&block) # rubocop:disable Metrics/MethodLength
      conn =
        if POSTGRES_URL
          PG::Connection.new(POSTGRES_URL)
        else
          PG::Connection.new(
            host: POSTGRES_HOST,
            port: POSTGRES_PORT,
            dbname: POSTGRES_DB,
            user: POSTGRES_USER,
            password: POSTGRES_PASSWORD
          )
        end

      conn.transaction(&block)
    ensure
      conn&.close
    end
  end
end
