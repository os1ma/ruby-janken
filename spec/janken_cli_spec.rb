require './lib/janken_cli'
require 'stringio'

RSpec.describe 'janken_cli' do

  after :context do
    $stdin = STDIN
    $stdout = STDOUT
  end

  describe '#main' do

    describe '正常な入力' do

      where(
        :player_1_hand_num,
        :player_2_hand_num,
        :player_1_hand_name,
        :player_2_hand_name,
        :result_message,
        :player_1_result_num,
        :player_2_result_num
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

      with_them do
        it "じゃんけんが実行され結果が保存される" do

          # 準備

          $stdin = StringIO.new("#{player_1_hand_num}\n#{player_2_hand_num}")
          $stdout = StringIO.new

          jankens_csv_length_before_test = count_file_lines(JANKENS_CSV)
          janken_details_csv_length_before_test = count_file_lines(JANKEN_DETAILS_CSV)

          # 実行

          Timecop.freeze(Time.new(2021, 2, 3, 4, 5, 6, "+09:00")) do
            main
          end

          # 検証

          # 標準出力の検証
          actual = $stdout.string
          expected = <<~TEXT
            STONE: 0
            PAPER: 1
            SCISSORS: 2
            Please select Alice hand:
            STONE: 0
            PAPER: 1
            SCISSORS: 2
            Please select Bob hand:
            Alice selected #{player_1_hand_name}
            Bob selected #{player_2_hand_name}
            #{result_message}
          TEXT

          expect(actual).to eq expected

          # じゃんけんデータの CSV の検証
          expected_janken_id = jankens_csv_length_before_test + 1
          jankens_csv_rows = CSV.read(JANKENS_CSV)
          expect(jankens_csv_rows.size).to eq expected_janken_id
          expect(jankens_csv_rows.last).to eq [expected_janken_id.to_s, "2021-02-03 04:05:06 +0900"]

          # じゃんけん明細データの CSV の検証
          expected_janken_detail_id_1 = janken_details_csv_length_before_test + 1
          expected_janken_detail_id_2 = janken_details_csv_length_before_test + 2
          janken_details_csv_rows = CSV.read(JANKEN_DETAILS_CSV)
          expect(janken_details_csv_rows.size).to eq expected_janken_detail_id_2
          expect(janken_details_csv_rows[-2]).to eq [
            expected_janken_detail_id_1,
            expected_janken_id,
            PLAYER_1_ID,
            player_1_hand_num,
            player_1_result_num
          ].map(&:to_s)
          expect(janken_details_csv_rows[-1]).to eq [
            expected_janken_detail_id_2,
            expected_janken_id,
            PLAYER_2_ID,
            player_2_hand_num,
            player_2_result_num
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
        it "再入力が促される" do

          $stdin = StringIO.new("#{invalid_input}\n0\n0")
          $stdout = StringIO.new

          main
          actual = $stdout.string

          expected = <<~TEXT
            STONE: 0
            PAPER: 1
            SCISSORS: 2
            Please select Alice hand:
            Invalid input: #{invalid_input}

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

          expect(actual).to eq expected
        end
      end
    end
  end
end
