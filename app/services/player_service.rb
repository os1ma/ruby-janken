# frozen_string_literal: true

# プレイヤーサービス
class PlayerService
  def initialize(transaction_manager, player_repository)
    @tm = transaction_manager
    @player_repository = player_repository
  end

  def find_player_by_id(player_id)
    @tm.transactional do |tx|
      @player_repository.find_player_by_id(tx, player_id)
    end
  end
end
