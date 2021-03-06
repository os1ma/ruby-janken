# frozen_string_literal: true

# 手を表す定数を扱うモジュール
module Hand
  # 手
  class Hand
    attr_reader :number, :name

    def initialize(number, name)
      @number = number
      @name = name
    end

    def win?(other)
      case self
      when STONE
        other == SCISSORS
      when PAPER
        other == STONE
      when SCISSORS
        other == PAPER
      else
        raise "Invalid hand. self = #{self}"
      end
    end

    def to_s
      "Hand(#{number}, #{name})"
    end
  end
  private_constant :Hand

  STONE = Hand.new(0, :STONE)
  PAPER = Hand.new(1, :PAPER)
  SCISSORS = Hand.new(2, :SCISSORS)

  class << self
    def valid_hand_num_string?(str)
      all.map(&:number).map(&:to_s).include?(str)
    end

    def of_num_string(str)
      raise "Invalid string for hand num. str = #{str}" unless valid_hand_num_string?(str)

      hand_num = str.to_i
      all.detect { |h| h.number == hand_num }
    end

    def all
      [STONE, PAPER, SCISSORS]
    end
  end
end
