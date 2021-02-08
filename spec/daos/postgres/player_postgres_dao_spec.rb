# frozen_string_literal: true

require './app/daos/postgres/player_postgres_dao'
require './app/models/player'

RSpec.describe PlayerPostgresDao do
  let(:dao) do
    described_class.new
  end

  describe '#find_player_by_id' do
    it 'プレイヤーが存在する場合' do
      actual = dao.find_player_by_id(1)
      expected = Player.new(1, 'Alice')
      expect(actual).to eq expected
    end

    it 'プレイヤーが存在しない場合' do
      actual = dao.find_player_by_id(0)
      expect(actual).to eq nil
    end
  end
end
