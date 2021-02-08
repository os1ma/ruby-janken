# frozen_string_literal: true

require './app/daos/postgres/postgres_transaction_manager'
require './app/daos/postgres/player_postgres_dao'
require './app/daos/postgres/janken_postgres_dao'
require './app/daos/postgres/janken_detail_postgres_dao'
require './app/services/player_service'
require './app/services/janken_service'
require './app/controllers/cli/janken_cli_controller'

tm = PostgresTransactionManager
player_dao = PlayerPostgresDao.new
janken_dao = JankenPostgresDao.new
janken_detail_dao = JankenDetailPostgresDao.new

player_service = PlayerService.new(tm, player_dao)
janken_service = JankenService.new(tm, janken_dao, janken_detail_dao)

janken_cli_controller = JankenCliController.new(player_service, janken_service)

janken_cli_controller.play
