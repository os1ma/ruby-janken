# frozen_string_literal: true

require 'csv'
require 'fileutils'
require './app/views/cli/standard_output_view'
require './app/models/hand'
require './app/models/result'
require './app/models/player'
require './app/models/janken'
require './app/models/janken_detail'
require './app/services/player_service'
require './app/services/janken_service'

# じゃんけんの CLI のコントローラ
class JankenCliController
  # 定数定義
  PLAYER1_ID = 1
  PLAYER2_ID = 2

  # View ファイルの定義
  VIEW_DIR = './app/views/cli'
  SCAN_PROMPT_VIEW_TEMPLATE = "#{VIEW_DIR}/scan_prompt.txt.erb"
  INVALID_INPUT_VIEW_TEMPLATE = "#{VIEW_DIR}/invalid_input.txt.erb"
  SHOW_HAND_VIEW_TEMPLATE = "#{VIEW_DIR}/show_hand.txt.erb"
  RESULT_VIEW_TEMPLATE = "#{VIEW_DIR}/result.txt.erb"

  def initialize
    @player_service = PlayerService.new
    @janken_service = JankenService.new
  end

  def play
    # プレイヤー名を取得
    player1 = @player_service.find_player_by_id(PLAYER1_ID)
    player2 = @player_service.find_player_by_id(PLAYER2_ID)

    # プレイヤーの手を取得
    player1_hand = get_hand(player1)
    player2_hand = get_hand(player2)

    puts_player_hand(player1, player1_hand)
    puts_player_hand(player2, player2_hand)

    # 勝敗を表示
    winner = @janken_service.play(player1, player1_hand, player2, player2_hand)
    StandardOutputView.new(RESULT_VIEW_TEMPLATE, winner: winner).show
  end

  private

  def get_hand(player)
    loop do
      StandardOutputView.new(SCAN_PROMPT_VIEW_TEMPLATE, hands: Hand.all, player: player).show

      input = gets.chomp

      return Hand.value_of_num_string(input) if Hand.valid_hand_num_string?(input)

      StandardOutputView.new(INVALID_INPUT_VIEW_TEMPLATE, input: input).show
    end
  end

  def puts_player_hand(player, hand)
    StandardOutputView.new(SHOW_HAND_VIEW_TEMPLATE, player: player, hand: hand).show
  end
end
