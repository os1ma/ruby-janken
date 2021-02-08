# frozen_string_literal: true

# プレイヤーサービス
class PlayerService
  def initialize(transaction_manager, player_dao)
    @tm = transaction_manager
    @player_dao = player_dao
  end

  def find_player_by_id(player_id)
    @tm.transactional do |tx|
      @player_dao.find_player_by_id(tx, player_id)
    end
  end
end
