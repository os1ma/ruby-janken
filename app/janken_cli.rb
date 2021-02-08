# frozen_string_literal: true

require './app/daos/postgres/player_postgres_dao'
require './app/daos/csv/janken_csv_dao'
require './app/daos/csv/janken_detail_csv_dao'
require './app/services/player_service'
require './app/services/janken_service'
require './app/controllers/cli/janken_cli_controller'

player_dao = PlayerPostgresDao.new
janken_dao = JankenCsvDao.new
janken_detail_dao = JankenDetailCsvDao.new

player_service = PlayerService.new(player_dao)
janken_service = JankenService.new(janken_dao, janken_detail_dao)

janken_cli_controller = JankenCliController.new(player_service, janken_service)

janken_cli_controller.play
