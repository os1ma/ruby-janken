# frozen_string_literal: true

# じゃんけん
class Janken
  attr_reader :id, :played_at, :details

  def initialize(id, played_at, details = nil)
    @id = id
    @played_at = played_at
    @details = details
  end

  def winner_player_ids
    details.filter { |d| d.result == Result::WIN }
           .map(&:player_id)
  end

  def to_s
    "Janken(#{id}, #{played_at}, #{details})"
  end
end
