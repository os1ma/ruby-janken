# frozen_string_literal: true

# プレイヤー
class Player
  attr_reader :id, :name

  def initialize(id, name)
    @id = id
    @name = name
  end

  def to_s
    "Player(#{id}, #{name})"
  end
end
