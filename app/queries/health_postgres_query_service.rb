# frozen_string_literal: true

require './app/daos/postgres/pg_wrapper'

# Postgres のヘルスチェッククエリ実行サービス
class HealthPostgresQueryService
  SELECT_ONE = 'SELECT 1'

  def healthy?(conn)
    PgWrapper.find_first(conn, HealthMapper, SELECT_ONE, [])
  end
end

# ヘルスチェックの結果のマッパー
module HealthMapper
  class << self
    def map(_)
      true
    end
  end
end
