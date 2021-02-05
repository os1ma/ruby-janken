require './lib/janken_cli'
require 'stringio'

RSpec.describe 'janken_cli' do
  describe '#main' do
    it 'able to play janken' do
      $stdin = StringIO.new("0\n1")
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
        Alice selected STONE
        Bob selected PAPER
        Bob win !!!
      TEXT

      expect(actual).to eq(expected)
    end
  end
end
