# frozen_string_literal: true

require './app/daos/postgres/pg_wrapper'

# じゃんけんを PosgtreSQL と読み書きする DAO
class JankenDetailPostgresDao
  TABLE_NAME = 'janken_details'
  INSERT_COMMAND = 'INSERT INTO "janken_details" ("janken_id", "player_id", "hand", "result") VALUES %s RETURNING "id"'

  def insert_all(conn, janken_details)
    PgWrapper.insert_all_and_return_object_with_keys(conn, JankenDetailMapper, TABLE_NAME, janken_details)
  end
end

# PgWrapper で利用するじゃんけん明細のマッピング定義
module JankenDetailMapper
  class << self
    def object_to_insert_params(janken_detail)
      {
        janken_id: janken_detail.janken_id,
        player_id: janken_detail.player_id,
        hand: janken_detail.hand.number,
        result: janken_detail.result.number
      }
    end

    def map_with_id(id, janken_detail_without_id)
      JankenDetail.new(
        id,
        janken_detail_without_id.janken_id,
        janken_detail_without_id.player_id,
        janken_detail_without_id.hand.number,
        janken_detail_without_id.result.number
      )
    end
  end
end
