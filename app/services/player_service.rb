# frozen_string_literal: true

# プレイヤーサービス
class PlayerService
  def initialize(player_dao)
    @player_dao = player_dao
  end

  def find_player_by_id(player_id)
    @player_dao.find_player_by_id(player_id)
  end
end
