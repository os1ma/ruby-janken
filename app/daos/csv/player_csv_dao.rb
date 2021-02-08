# frozen_string_literal: true

require 'csv'
require './app/daos/csv/csv_dao_utils'

# プレイヤーを CSV で読み書きする DAO
class PlayerCsvDao
  PLAYERS_CSV = "#{CsvDaoUtils::DATA_DIR}/players.csv"

  def find_player_by_id(_, player_id)
    CSV.read(PLAYERS_CSV)
       .map { |r| Player.new(r[0].to_i, r[1]) }
       .find { |p| p.id == player_id }
  end
end
