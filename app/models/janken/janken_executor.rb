# frozen_string_literal: true

# じゃんけんの実行機
module JankenExecutor
  class << self
    def play(player1_id, player1_hand, player2_id, player2_hand) # rubocop:disable Metrics/MethodLength
      # 勝敗判定
      player1_result, player2_result =
        if player1_hand.win?(player2_hand)
          [Result::WIN, Result::LOSE]
        elsif player2_hand.win?(player1_hand)
          [Result::LOSE, Result::WIN]
        else
          [Result::DRAW, Result::DRAW]
        end

      # じゃんけん明細の作成
      janken_details = [
        JankenDetail.new(nil, nil, player1_id, player1_hand, player1_result),
        JankenDetail.new(nil, nil, player2_id, player2_hand, player2_result)
      ]

      # じゃんけんの作成
      Janken.new(nil, Time.now, janken_details)
    end
  end
end
