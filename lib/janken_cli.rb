# frozen_string_literal: true

require 'csv'
require 'fileutils'
require './lib/hand'
require './lib/result'

# 定数定義

PLAYER_1_ID = 1
PLAYER_2_ID = 2

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

def find_player_name_by_id(player_id)
  CSV.read(PLAYERS_CSV)
     # ID が一致する行を抽出
     .find { |row| row[0] == player_id.to_s }
     # 名前を取得
     &.at(1) ||
    # 存在しなければエラー
    raise("Player not exist. player_id = #{player_id}")
end

def get_hand(player_name)
  loop do
    Hand.all.each do |h|
      printf(HAND_NAME_NUMBER_MESSAGE_FORMAT, h.name, h.number)
    end
    printf(SCAN_PROMPT_MESSAGE_FORMAT, player_name)

    input = gets.chomp

    return Hand.value_of_num_string(input) if Hand.valid_hand_num_string?(input)

    printf(INVALID_INPUT_MESSAGE_FORMAT, input)
  end
end

def puts_player_hand(player_name, hand)
  printf(SHOW_HAND_MESSAGE_FORMAT, player_name, hand.name)
end

def count_file_lines(file_name)
  File.open(file_name, 'r') do |file|
    file.readlines.size
  end
end

def main # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
  # プレイヤー名を取得

  player_1_name = find_player_name_by_id(PLAYER_1_ID)
  player_2_name = find_player_name_by_id(PLAYER_2_ID)

  # プレイヤーの手を取得

  player_1_hand = get_hand(player_1_name)
  player_2_hand = get_hand(player_2_name)

  puts_player_hand(player_1_name, player_1_hand)
  puts_player_hand(player_2_name, player_2_hand)

  # 勝敗判定

  player_1_result, player_2_result =
    case player_1_hand
    when Hand::STONE
      case player_2_hand
      when Hand::STONE
        [Result::DRAW, Result::DRAW]
      when Hand::PAPER
        [Result::LOSE, Result::WIN]
      when Hand::SCISSORS
        [Result::WIN, Result::LOSE]
      else
        raise "Invalid player_2_hand. player_2_hand = #{player_2_hand}"
      end
    when Hand::PAPER
      case player_2_hand
      when Hand::STONE
        [Result::WIN, Result::LOSE]
      when Hand::PAPER
        [Result::DRAW, Result::DRAW]
      when Hand::SCISSORS
        [Result::LOSE, Result::WIN]
      else
        raise "Invalid player_2_hand. player_2_hand = #{player_2_hand}"
      end
    when Hand::SCISSORS
      case player_2_hand
      when Hand::STONE
        [Result::LOSE, Result::WIN]
      when Hand::PAPER
        [Result::WIN, Result::LOSE]
      when Hand::SCISSORS
        [Result::DRAW, Result::DRAW]
      else
        raise "Invalid player_2_hand. player_2_hand = #{player_2_hand}"
      end
    else
      raise "Invalid player_1_hand. player_1_hand = #{player_1_hand}"
    end

  # 結果を保存

  FileUtils.touch(JANKENS_CSV)
  janken_id = count_file_lines(JANKENS_CSV) + 1
  played_at = Time.now

  CSV.open(JANKENS_CSV, 'a') do |csv|
    csv << [janken_id, played_at]
  end

  FileUtils.touch(JANKEN_DETAILS_CSV)
  janken_details_count = count_file_lines(JANKEN_DETAILS_CSV)
  janken_detail_1_id = janken_details_count + 1
  janken_detail_2_id = janken_details_count + 2

  CSV.open(JANKEN_DETAILS_CSV, 'a') do |csv|
    csv << [janken_detail_1_id, janken_id, PLAYER_1_ID, player_1_hand.number, player_1_result.number]
    csv << [janken_detail_2_id, janken_id, PLAYER_2_ID, player_2_hand.number, player_2_result.number]
  end

  # 勝敗の表示

  case player_1_result
  when Result::WIN
    printf(WINNING_MESSAGE_FORMAT, player_1_name)
  when Result::LOSE
    printf(WINNING_MESSAGE_FORMAT, player_2_name)
  when Result::DRAW
    printf(DRAW_MESSAGE)
  else
    raise "Invaild player_1_result. player_1_result = #{player_1_result}"
  end
end

main if __FILE__ == $PROGRAM_NAME
