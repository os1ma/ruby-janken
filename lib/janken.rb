# frozen_string_literal: true

# じゃんけん
class Janken
  attr_reader :id, :played_at

  def initialize(id, played_at)
    @id = id
    @played_at = played_at
  end

  def to_s
    "Janken(#{id}, #{played_at})"
  end
end
