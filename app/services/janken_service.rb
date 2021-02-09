# frozen_string_literal: true

require './app/views/cli/standard_output_view'
require './app/models/hand'
require './app/models/result'
require './app/models/player'
require './app/models/janken'
require './app/models/janken_detail'

# じゃんけんサービス
class JankenService
  def initialize(transaction_manager, janken_dao, janken_detail_dao)
    @tm = transaction_manager
    @janken_dao = janken_dao
    @janken_detail_dao = janken_detail_dao
  end

  def play(player1, player1_hand, player2, player2_hand) # rubocop:disable Metrics/MethodLength
    @tm.transactional do |tx|
      # 勝敗判定
      player1_result, player2_result =
        if player1_hand.win?(player2_hand)
          [Result::WIN, Result::LOSE]
        elsif player2_hand.win?(player1_hand)
          [Result::LOSE, Result::WIN]
        else
          [Result::DRAW, Result::DRAW]
        end

      # 結果を保存
      janken = Janken.new(nil, Time.now)
      janken_id = @janken_dao.insert(tx, janken).id

      janken_details = [
        JankenDetail.new(nil, janken_id, player1.id, player1_hand, player1_result),
        JankenDetail.new(nil, janken_id, player2.id, player2_hand, player2_result)
      ]
      @janken_detail_dao.insert_all(tx, janken_details)

      # 勝者を返却
      case player1_result
      when Result::WIN
        player1
      when Result::LOSE
        player2
      when Result::DRAW
        nil
      else
        raise "Invaild player1_result. player1_result = #{player1_result}"
      end
    end
  end
end
