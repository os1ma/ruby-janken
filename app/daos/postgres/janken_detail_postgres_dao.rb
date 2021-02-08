# frozen_string_literal: true

require './app/daos/postgres/postgres_dao_utils'

# じゃんけんを PosgtreSQL と読み書きする DAO
class JankenDetailPostgresDao
  INSERT_COMMAND = 'INSERT INTO "janken_details" ("janken_id", "player_id", "hand", "result") VALUES %s RETURNING "id"'

  def insert_all(conn, janken_details)
    placeholders = create_insert_all_placeholders(janken_details)
    sql = format(INSERT_COMMAND, placeholders)

    params = janken_details_to_param_array(janken_details)

    conn.prepare(sql, sql)
    res = conn.exec_prepared(sql, params)

    insert_all_result_to_janken_detail_with_ids(res, janken_details)
  end

  private

  # ($1, $2, $3, $4), ($5, $6, $7, $8), ... という文字列を作成
  def create_insert_all_placeholders(records)
    records.map.with_index do |_, i|
      offset = i * 4
      "($#{offset + 1}, $#{offset + 2}, $#{offset + 3}, $#{offset + 4})"
    end.join(', ')
  end

  def janken_details_to_param_array(janken_details)
    janken_details.flat_map do |jd|
      [
        jd.janken_id,
        jd.player_id,
        jd.hand.number,
        jd.result.number
      ]
    end
  end

  def insert_all_result_to_janken_detail_with_ids(res, janken_details)
    res.map.with_index do |r, i|
      jd = janken_details[i]
      JankenDetail.new(
        r['id'],
        jd.janken_id,
        jd.player_id,
        jd.hand.number,
        jd.result.number
      )
    end
  end
end
