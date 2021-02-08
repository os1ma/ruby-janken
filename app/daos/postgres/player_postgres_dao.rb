# frozen_string_literal: true

require './app/daos/postgres/postgres_dao_utils'

# プレイヤーを PosgtreSQL と読み書きする DAO
class PlayerPostgresDao
  SELECT_WHERE_ID_EQUALS_QUERY = 'SELECT "id", "name" FROM "players" WHERE "id" = $1'

  def find_player_by_id(conn, player_id)
    conn.prepare(SELECT_WHERE_ID_EQUALS_QUERY, SELECT_WHERE_ID_EQUALS_QUERY)
    res = conn.exec_prepared(SELECT_WHERE_ID_EQUALS_QUERY, [player_id])
    res.map { |r| Player.new(r['id'].to_i, r['name']) }.first
  end
end
