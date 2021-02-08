# frozen_string_literal: true

require './app/daos/postgres/pg_wrapper'

# プレイヤーを PosgtreSQL と読み書きする DAO
class PlayerPostgresDao
  SELECT_WHERE_ID_EQUALS_QUERY = 'SELECT "id", "name" FROM "players" WHERE "id" = $1'

  def find_player_by_id(conn, player_id)
    PgWrapper.find_first(conn, PlayerMapper, SELECT_WHERE_ID_EQUALS_QUERY, [player_id])
  end
end

# PgWrapper で利用するプライヤークラスのマッピング定義
module PlayerMapper
  class << self
    def map(hash)
      Player.new(
        hash['id'].to_i,
        hash['name']
      )
    end
  end
end
