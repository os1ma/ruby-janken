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
    conn.prepare(INSERT_COMMAND, INSERT_COMMAND)
    res = conn.exec_prepared(INSERT_COMMAND, [janken.played_at])
    id = res[0]['id']
    Janken.new(id, janken.played_at)
  end
end
