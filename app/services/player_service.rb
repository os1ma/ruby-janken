# frozen_string_literal: true

require './app/daos/csv/player_csv_dao'

# プレイヤーサービス
class PlayerService
  def initialize
    @player_dao = PlayerCsvDao.new
  end

  def find_player_by_id(player_id)
    @player_dao.find_player_by_id(player_id)
  end
end
