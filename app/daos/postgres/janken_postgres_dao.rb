# frozen_string_literal: true

require './app/daos/postgres/pg_wrapper'

# じゃんけんを PosgtreSQL と読み書きする DAO
class JankenPostgresDao
  TABLE_NAME = 'jankens'
  INSERT_COMMAND = 'INSERT INTO "jankens" ("played_at") VALUES ($1) RETURNING "id"'

  def count(conn)
    PgWrapper.count(conn, TABLE_NAME)
  end

  def insert(conn, janken)
    PgWrapper.insert_one_and_return_object_with_key(conn, JankenMapper, TABLE_NAME, janken)
  end
end

# PgWrapper で利用するじゃんけんのマッピング定義
module JankenMapper
  class << self
    def object_to_insert_params(janken)
      {
        played_at: janken.played_at
      }
    end

    def map_with_id(id, janken_without_id)
      Janken.new(
        id,
        janken_without_id.played_at
      )
    end
  end
end
