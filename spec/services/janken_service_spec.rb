# frozen_string_literal: true

require './app/services/janken_service'
require './app/daos/postgres/postgres_transaction_manager'
require './app/daos/postgres/postgres_dao_utils'
require './app/daos/postgres/janken_postgres_dao'
require './app/models/hand'

JANKENS_TABLE_NAME = 'jankens'

RSpec.describe JankenService do
  let(:service) do
    tm = PostgresTransactionManager
    janken_dao = JankenPostgresDao.new
    janken_detail_dao = :メソッド呼び出し時に例外発生
    described_class.new(tm, janken_dao, janken_detail_dao)
  end

  describe '#play' do
    it 'じゃんけん明細保存時に例外が発生した場合じゃんけんも保存されない' do # rubocop:disable RSpec/ExampleLength, RSpec/MultipleExpectations
      janken_count_before_play = PostgresTransactionManager.transactional do |tx|
        PostgresDaoUtils.count(tx, JANKENS_TABLE_NAME)
      end

      expect do
        player1 = Player.new(1, 'Alice')
        player2 = Player.new(2, 'Bob')
        service.play(player1, Hand::STONE, player2, Hand::STONE).name
      end.to raise_error NoMethodError

      janken_count_after_play = PostgresTransactionManager.transactional do |tx|
        PostgresDaoUtils.count(tx, JANKENS_TABLE_NAME)
      end
      expect(janken_count_after_play).to eq janken_count_before_play
    end
  end
end