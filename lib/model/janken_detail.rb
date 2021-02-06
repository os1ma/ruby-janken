# frozen_string_literal: true

# じゃんけん明細
class JankenDetail
  attr_reader :id, :janken_id, :player_id, :hand, :result

  def initialize(id, janken_id, player_id, hand, result)
    @id = id
    @janken_id = janken_id
    @player_id = player_id
    @hand = hand
    @result = result
  end

  def to_s
    "JankenDetail(#{id}, #{janken_id}, #{player_id}, #{hand}, #{result})"
  end
end
