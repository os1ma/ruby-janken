# frozen_string_literal: true

require 'rack'
require 'json'
require './app/daos/postgres/postgres_transaction_manager'
require './app/daos/postgres/player_postgres_dao'
require './app/daos/postgres/janken_postgres_dao'
require './app/daos/postgres/janken_detail_postgres_dao'
require './app/repositories/player_repository'
require './app/repositories/janken_repository'
require './app/services/player_service'
require './app/services/janken_service'
require './app/controllers/api/health_api_controller'
require './app/controllers/api/janken_api_controller'

tm = PostgresTransactionManager
player_dao = PlayerPostgresDao.new
janken_dao = JankenPostgresDao.new
janken_detail_dao = JankenDetailPostgresDao.new

player_repository = PlayerRepository.new(player_dao)
janken_repository = JankenRepository.new(janken_dao, janken_detail_dao)

janken_service = JankenService.new(tm, player_repository, janken_repository)

HEALTH_API_CONTROLLER = HealthApiController.new
JANKEN_API_CONTROLLER = JankenApiController.new(janken_service)

HEADER = {
  'Content-Type' => 'text/plain'
}.freeze

# じゃんけんのウェブアプリケーション
class JankenWebApplication
  def call(env)
    request = Rack::Request.new(env)
    response = handle(request)
    response.finish
  end

  private

  def handle(request) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    if request.path == '/api/health' && request.get?
      response_body = HEALTH_API_CONTROLLER.get.to_json
      Rack::Response.new(response_body, 200, HEADER)
    elsif request.path == '/api/jankens' && request.post?
      request_body = JSON.parse(request.body.read)
      response_body = JANKEN_API_CONTROLLER.post(request_body).to_json
      Rack::Response.new(response_body, 201, HEADER)
    else
      response_body = { status: 404 }.to_json
      Rack::Response.new(response_body, 404, HEADER)
    end
  end
end

run JankenWebApplication.new
