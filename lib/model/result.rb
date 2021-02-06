# frozen_string_literal: true

# 結果を表す定数を扱うモジュール
module Result
  # 結果
  class Result
    attr_reader :number

    def initialize(number)
      @number = number
    end

    def to_s
      "Result(#{number})"
    end
  end
  private_constant :Result

  WIN = Result.new(0)
  LOSE = Result.new(1)
  DRAW = Result.new(2)
end
