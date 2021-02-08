# frozen_string_literal: true

require './app/daos/postgres/postgres_dao_utils'

# じゃんけんを PosgtreSQL と読み書きする DAO
class JankenPostgresDao
  INSERT_COMMAND = 'INSERT INTO "jankens" ("played_at") VALUES ($1) RETURNING "id"'

  def insert(janken)
    PostgresDaoUtils.with_connection do |conn|
      conn.prepare(INSERT_COMMAND, INSERT_COMMAND)
      res = conn.exec_prepared(INSERT_COMMAND, [janken.played_at])
      id = res[0]['id']
      Janken.new(id, janken.played_at)
    end
  end
end
