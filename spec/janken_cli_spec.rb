require './lib/janken_cli'
require 'stringio'

RSpec.describe 'janken_cli' do
  describe '#main' do
    where(
      :player_1_hand_num,
      :player_2_hand_num,
      :player_1_hand_name,
      :player_2_hand_name,
      :result_message,
      :player_1_result,
      :player_2_result
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
      it "正常な入力でじゃんけんが実行され結果が保存される" do
        $stdin = StringIO.new("#{player_1_hand_num}\n#{player_2_hand_num}")
        $stdout = StringIO.new
        main
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
      end
    end
  end
end
