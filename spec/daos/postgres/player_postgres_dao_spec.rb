# frozen_string_literal: true

require './app/daos/postgres/postgres_transaction_manager'
require './app/daos/postgres/player_postgres_dao'
require './app/models/player'

RSpec.describe PlayerPostgresDao do
  let(:dao) do
    described_class.new
  end

  describe '#find_player_by_id' do
    it 'プレイヤーが存在する場合' do
      PostgresTransactionManager.transactional do |tx|
        actual = dao.find_player_by_id(tx, 1)
        expected = Player.new(1, 'Alice')
        expect(actual).to eq expected
      end
    end

    it 'プレイヤーが存在しない場合' do
      PostgresTransactionManager.transactional do |tx|
        actual = dao.find_player_by_id(tx, 0)
        expect(actual).to eq nil
      end
    end
  end
end
