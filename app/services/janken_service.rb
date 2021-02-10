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
  def play(player1_id, player1_hand, player2_id, player2_hand)
    @tm.transactional do |tx|
      # プレイヤーの存在チェック
      raise "Invalid player1_id. player1_id = #{player1_id}" unless @player_repository.find_player_by_id(tx, player1_id)
      raise "Invalid player2_id. player2_id = #{player2_id}" unless @player_repository.find_player_by_id(tx, player2_id)

      # じゃんけんを実行
      janken = JankenExecutor.play(player1_id, player1_hand, player2_id, player2_hand)

      # 保存
      @janken_repository.save(tx, janken)

      # 勝者を返却
      janken.winner_player_ids
            .map { |id| @player_repository.find_player_by_id(tx, id) }
            .first
    end
  end
end
