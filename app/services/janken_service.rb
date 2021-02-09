# frozen_string_literal: true

require './app/views/cli/standard_output_view'
require './app/models/janken/hand'
require './app/models/janken/result'
require './app/models/janken/janken'
require './app/models/janken/janken_detail'
require './app/models/janken/janken_executor'
require './app/models/player/player'

# じゃんけんサービス
class JankenService
  def initialize(transaction_manager, player_repository, janken_repository)
    @tm = transaction_manager
    @player_repository = player_repository
    @janken_repository = janken_repository
  end

  # じゃんけんを実行して結果を保存し、勝者を返却
  def play(player1, player1_hand, player2, player2_hand)
    @tm.transactional do |tx|
      janken = JankenExecutor.play(player1, player1_hand, player2, player2_hand)

      @janken_repository.save(tx, janken)

      janken.winner_player_ids
            .map { |id| @player_repository.find_player_by_id(tx, id) }
            .first
    end
  end
end
