# frozen_string_literal: true

require './app/daos/postgres/postgres_dao_utils'

# プレイヤーを PosgtreSQL と読み書きする DAO
class PlayerPostgresDao
  SELECT_WHERE_ID_EQUALS_QUERY = 'SELECT "id", "name" FROM "players" WHERE "id" = %s'

  def find_player_by_id(player_id)
    query = format(SELECT_WHERE_ID_EQUALS_QUERY, player_id)

    PostgresDaoUtils.with_connection do |conn|
      res = conn.exec(query)
      res.map { |r| Player.new(r['id'].to_i, r['name']) }.first
    end
  end
end
