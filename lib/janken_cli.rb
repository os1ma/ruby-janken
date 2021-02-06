# frozen_string_literal: true

require 'csv'
require 'fileutils'
require './lib/model/hand'
require './lib/model/result'
require './lib/model/player'
require './lib/model/janken'
require './lib/model/janken_detail'

# 定数定義

PLAYER1_ID = 1
PLAYER2_ID = 2

# 表示するメッセージの定義

HAND_NAME_NUMBER_MESSAGE_FORMAT = "%s: %s\n"
SCAN_PROMPT_MESSAGE_FORMAT = "Please select %s hand:\n"
INVALID_INPUT_MESSAGE_FORMAT = "Invalid input: %s\n\n"
SHOW_HAND_MESSAGE_FORMAT = "%s selected %s\n"
WINNING_MESSAGE_FORMAT = "%s win !!!\n"
DRAW_MESSAGE = "DRAW !!!\n"

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
    Hand.all.each do |h|
      printf(HAND_NAME_NUMBER_MESSAGE_FORMAT, h.name, h.number)
    end
    printf(SCAN_PROMPT_MESSAGE_FORMAT, player.name)

    input = gets.chomp

    return Hand.value_of_num_string(input) if Hand.valid_hand_num_string?(input)

    printf(INVALID_INPUT_MESSAGE_FORMAT, input)
  end
end

def puts_player_hand(player, hand)
  printf(SHOW_HAND_MESSAGE_FORMAT, player.name, hand.name)
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

  case player1_result
  when Result::WIN
    printf(WINNING_MESSAGE_FORMAT, player1.name)
  when Result::LOSE
    printf(WINNING_MESSAGE_FORMAT, player2.name)
  when Result::DRAW
    printf(DRAW_MESSAGE)
  else
    raise "Invaild player1_result. player1_result = #{player1_result}"
  end
end

main if __FILE__ == $PROGRAM_NAME
