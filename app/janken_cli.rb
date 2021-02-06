# frozen_string_literal: true

require 'csv'
require 'fileutils'
require './app/views/cli/standard_output_view'
require './app/models/hand'
require './app/models/result'
require './app/models/player'
require './app/models/janken'
require './app/models/janken_detail'

# 定数定義

PLAYER1_ID = 1
PLAYER2_ID = 2

# View ファイルの定義

VIEW_DIR = './app/views/cli'
SCAN_PROMPT_VIEW_TEMPLATE = "#{VIEW_DIR}/scan_prompt.txt.erb"
INVALID_INPUT_VIEW_TEMPLATE = "#{VIEW_DIR}/invalid_input.txt.erb"
SHOW_HAND_VIEW_TEMPLATE = "#{VIEW_DIR}/show_hand.txt.erb"
RESULT_VIEW_TEMPLATE = "#{VIEW_DIR}/result.txt.erb"

# データの保存に関する定義

DATA_DIR = './data'
PLAYERS_CSV = "#{DATA_DIR}/players.csv"
JANKENS_CSV = "#{DATA_DIR}/jankens.csv"
JANKEN_DETAILS_CSV = "#{DATA_DIR}/janken_details.csv"

# メソッド定義

def find_player_by_id(player_id)
  CSV.read(PLAYERS_CSV)
     .map { |r| Player.new(r[0].to_i, r[1]) }
     .find { |p| p.id == player_id } ||
    # 存在しなければエラー
    raise("Player not exist. player_id = #{player_id}")
end

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

def count_file_lines(file_name)
  File.open(file_name, 'r') do |file|
    file.readlines.size
  end
end

def save_janken(janken)
  CSV.open(JANKENS_CSV, 'a') do |csv|
    csv << [janken.id, janken.played_at]
  end
end

def save_janken_details(janken_details)
  CSV.open(JANKEN_DETAILS_CSV, 'a') do |csv|
    janken_details.each do |jd|
      csv << [jd.id, jd.janken_id, jd.player_id, jd.hand.number, jd.result.number]
    end
  end
end

def main # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
  # プレイヤー名を取得

  player1 = find_player_by_id(PLAYER1_ID)
  player2 = find_player_by_id(PLAYER2_ID)

  # プレイヤーの手を取得

  player1_hand = get_hand(player1)
  player2_hand = get_hand(player2)

  puts_player_hand(player1, player1_hand)
  puts_player_hand(player2, player2_hand)

  # 勝敗判定

  player1_result, player2_result =
    case player1_hand
    when Hand::STONE
      case player2_hand
      when Hand::STONE
        [Result::DRAW, Result::DRAW]
      when Hand::PAPER
        [Result::LOSE, Result::WIN]
      when Hand::SCISSORS
        [Result::WIN, Result::LOSE]
      else
        raise "Invalid player2_hand. player2_hand = #{player2_hand}"
      end
    when Hand::PAPER
      case player2_hand
      when Hand::STONE
        [Result::WIN, Result::LOSE]
      when Hand::PAPER
        [Result::DRAW, Result::DRAW]
      when Hand::SCISSORS
        [Result::LOSE, Result::WIN]
      else
        raise "Invalid player2_hand. player2_hand = #{player2_hand}"
      end
    when Hand::SCISSORS
      case player2_hand
      when Hand::STONE
        [Result::LOSE, Result::WIN]
      when Hand::PAPER
        [Result::WIN, Result::LOSE]
      when Hand::SCISSORS
        [Result::DRAW, Result::DRAW]
      else
        raise "Invalid player2_hand. player2_hand = #{player2_hand}"
      end
    else
      raise "Invalid player1_hand. player1_hand = #{player1_hand}"
    end

  # 結果を保存

  FileUtils.touch(JANKENS_CSV)
  janken_id = count_file_lines(JANKENS_CSV) + 1
  played_at = Time.now
  janken = Janken.new(janken_id, played_at)
  save_janken(janken)

  FileUtils.touch(JANKEN_DETAILS_CSV)
  janken_details_count = count_file_lines(JANKEN_DETAILS_CSV)
  janken_detail1_id = janken_details_count + 1
  janken_detail2_id = janken_details_count + 2
  janken_detail1 = JankenDetail.new(janken_detail1_id, janken_id, player1.id, player1_hand, player1_result)
  janken_detail2 = JankenDetail.new(janken_detail2_id, janken_id, player2.id, player2_hand, player2_result)
  save_janken_details([janken_detail1, janken_detail2])

  # 勝敗の表示

  winner =
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

  StandardOutputView.new(RESULT_VIEW_TEMPLATE, winner: winner).show
end

main if __FILE__ == $PROGRAM_NAME
