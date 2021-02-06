# frozen_string_literal: true

require './app/janken_cli'
require 'stringio'
require 'fileutils'

VALID_INPUT_EXPECTED_TEXT = <<~TEXT
  STONE: 0
  PAPER: 1
  SCISSORS: 2
  Please select Alice hand:
  STONE: 0
  PAPER: 1
  SCISSORS: 2
  Please select Bob hand:
  Alice selected %s
  Bob selected %s
  %s
TEXT

INVALID_INPUT_EXPECTED_TEXT = <<~TEXT
  STONE: 0
  PAPER: 1
  SCISSORS: 2
  Please select Alice hand:
  Invalid input: %s

  STONE: 0
  PAPER: 1
  SCISSORS: 2
  Please select Alice hand:
  STONE: 0
  PAPER: 1
  SCISSORS: 2
  Please select Bob hand:
  Alice selected STONE
  Bob selected STONE
  DRAW !!!
TEXT

def count_file_lines(file_name)
  File.open(file_name, 'r') do |file|
    file.readlines.size
  end
end

RSpec.describe 'janken_cli' do # rubocop:disable Metrics/BlockLength, RSpec/DescribeClass
  before do
    FileUtils.touch(JANKENS_CSV)
    FileUtils.touch(JANKEN_DETAILS_CSV)
  end

  after do
    $stdin = STDIN
  end

  describe '#main' do # rubocop:disable Metrics/BlockLength
    describe '正常な入力' do # rubocop:disable Metrics/BlockLength
      where(
        :player1_hand_num,
        :player2_hand_num,
        :player1_hand_name,
        :player2_hand_name,
        :result_message,
        :player1_result_num,
        :player2_result_num
      ) do
        [
          [0, 0, 'STONE', 'STONE', 'DRAW !!!', 2, 2],
          [0, 1, 'STONE', 'PAPER', 'Bob win !!!', 1, 0],
          [0, 2, 'STONE', 'SCISSORS', 'Alice win !!!', 0, 1],
          [1, 0, 'PAPER', 'STONE', 'Alice win !!!', 0, 1],
          [1, 1, 'PAPER', 'PAPER', 'DRAW !!!', 2, 2],
          [1, 2, 'PAPER', 'SCISSORS', 'Bob win !!!', 1, 0],
          [2, 0, 'SCISSORS', 'STONE', 'Bob win !!!', 1, 0],
          [2, 1, 'SCISSORS', 'PAPER', 'Alice win !!!', 0, 1],
          [2, 2, 'SCISSORS', 'SCISSORS', 'DRAW !!!', 2, 2]
        ]
      end

      with_them do # rubocop:disable Metrics/BlockLength
        it 'じゃんけんが実行され結果が保存される' do # rubocop:disable Metrics/BlockLength, RSpec/ExampleLength, RSpec/MultipleExpectations
          # 準備
          $stdin = StringIO.new("#{player1_hand_num}\n#{player2_hand_num}")

          jankens_csv_length_before_test = count_file_lines(JANKENS_CSV)
          janken_details_csv_length_before_test = count_file_lines(JANKEN_DETAILS_CSV)

          # 実行と標準出力の検証
          expected = format(VALID_INPUT_EXPECTED_TEXT, player1_hand_name, player2_hand_name, result_message)

          expect do
            Timecop.freeze(Time.new(2021, 2, 3, 4, 5, 6, '+09:00')) do
              main
            end
          end.to output(expected).to_stdout

          # じゃんけんデータの CSV の検証
          expected_janken_id = jankens_csv_length_before_test + 1
          jankens_csv_rows = CSV.read(JANKENS_CSV)
          expect(jankens_csv_rows.size).to eq expected_janken_id
          expect(jankens_csv_rows.last).to eq [expected_janken_id.to_s, '2021-02-03 04:05:06 +0900']

          # じゃんけん明細データの CSV の検証
          expected_janken_detail1_id = janken_details_csv_length_before_test + 1
          expected_janken_detail2_id = janken_details_csv_length_before_test + 2
          janken_details_csv_rows = CSV.read(JANKEN_DETAILS_CSV)
          expect(janken_details_csv_rows.size).to eq expected_janken_detail2_id
          expect(janken_details_csv_rows[-2]).to eq [
            expected_janken_detail1_id,
            expected_janken_id,
            PLAYER1_ID,
            player1_hand_num,
            player1_result_num
          ].map(&:to_s)
          expect(janken_details_csv_rows[-1]).to eq [
            expected_janken_detail2_id,
            expected_janken_id,
            PLAYER2_ID,
            player2_hand_num,
            player2_result_num
          ].map(&:to_s)
        end
      end
    end

    describe '不正な入力' do
      where(:invalid_input) do
        [
          ['-1'],
          ['3'],
          ['1.0'],
          ['a'],
          [''],
          [' '],
          ['あ']
        ]
      end

      with_them do
        it '再入力が促される' do
          $stdin = StringIO.new("#{invalid_input}\n0\n0")

          expected = format(INVALID_INPUT_EXPECTED_TEXT, invalid_input)

          expect do
            main
          end.to output(expected).to_stdout
        end
      end
    end
  end
end
