# frozen_string_literal: true

# プレイヤーリポジトリ
class PlayerRepository
  def initialize(player_dao)
    @player_dao = player_dao
  end

  def find_player_by_id(transaction, player_id)
    @player_dao.find_player_by_id(transaction, player_id)
  end
end
