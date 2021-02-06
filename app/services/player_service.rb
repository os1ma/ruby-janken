# frozen_string_literal: true

require 'csv'

# プレイヤーサービス
class PlayerService
  DATA_DIR = './data'
  PLAYERS_CSV = "#{DATA_DIR}/players.csv"

  def find_player_by_id(player_id)
    CSV.read(PLAYERS_CSV)
       .map { |r| Player.new(r[0].to_i, r[1]) }
       .find { |p| p.id == player_id }
  end
end
