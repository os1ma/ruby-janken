# frozen_string_literal: true

require './app/views/cli/standard_output_view'
require './app/models/hand'
require './app/models/result'
require './app/models/player'
require './app/models/janken'
require './app/models/janken_detail'
require './app/models/janken_executor'

# じゃんけんサービス
class JankenService
  def initialize(transaction_manager, player_dao, janken_dao, janken_detail_dao)
    @tm = transaction_manager
    @player_dao = player_dao
    @janken_dao = janken_dao
    @janken_detail_dao = janken_detail_dao
  end

  def play(player1, player1_hand, player2, player2_hand) # rubocop:disable Metrics/MethodLength
    @tm.transactional do |tx|
      janken = JankenExecutor.play(player1, player1_hand, player2, player2_hand)

      # 結果を保存
      janken_id = @janken_dao.insert(tx, janken).id
      janken_details_with_janken_id = janken.details.map do |jd|
        JankenDetail.new(
          nil,
          janken_id,
          jd.player_id,
          jd.hand,
          jd.result
        )
      end
      @janken_detail_dao.insert_all(tx, janken_details_with_janken_id)

      # 勝者を返却
      janken.winner_player_ids
            .map { |id| @player_dao.find_player_by_id(tx, id) }
            .first
    end
  end
end
