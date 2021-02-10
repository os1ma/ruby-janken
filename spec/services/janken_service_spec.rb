# frozen_string_literal: true

require './app/services/janken_service'
require './app/daos/postgres/postgres_transaction_manager'
require './app/daos/postgres/janken_postgres_dao'
require './app/models/janken/hand'

RSpec.describe JankenService do # rubocop:disable Metrics/BlockLength:
  let(:tm) do
    PostgresTransactionManager
  end

  let(:janken_dao) do
    JankenPostgresDao.new
  end

  let(:service) do
    player_dao = PlayerPostgresDao.new
    janken_detail_dao = :メソッド呼び出し時に例外発生

    player_repository = PlayerRepository.new(player_dao)
    janken_repository = JankenRepository.new(janken_dao, janken_detail_dao)

    described_class.new(tm, player_repository, janken_repository)
  end

  describe '#play' do
    it 'じゃんけん明細保存時に例外が発生した場合じゃんけんも保存されない' do # rubocop:disable RSpec/ExampleLength, RSpec/MultipleExpectations
      janken_count_before_play = tm.transactional do |tx|
        janken_dao.count(tx)
      end

      expect do
        player1_id = 1
        player2_id = 2
        service.play(player1_id, Hand::STONE, player2_id, Hand::STONE).name
      end.to raise_error NoMethodError

      janken_count_after_play = tm.transactional do |tx|
        janken_dao.count(tx)
      end
      expect(janken_count_after_play).to eq janken_count_before_play
    end
  end
end
