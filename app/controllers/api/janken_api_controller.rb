# frozen_string_literal: true

require './app/models/janken/hand'

# じゃんけんの API コントローラ
class JankenApiController
  def initialize(janken_service)
    @janken_service = janken_service
  end

  def post(request_body)
    maybe_winner = @janken_service.play(
      request_body['player1Id'],
      Hand.of_num_string(request_body['player1Hand'].to_s),
      request_body['player2Id'],
      Hand.of_num_string(request_body['player2Hand'].to_s)
    )

    { winner_player_name: maybe_winner&.name }
  end
end
