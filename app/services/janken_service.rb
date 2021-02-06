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

# じゃんけんサービス
class JankenService
  DATA_DIR = './data'
  JANKENS_CSV = "#{DATA_DIR}/jankens.csv"
  JANKEN_DETAILS_CSV = "#{DATA_DIR}/janken_details.csv"

  def play(player1, player1_hand, player2, player2_hand) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
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

  private

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
end
