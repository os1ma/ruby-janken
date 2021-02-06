# frozen_string_literal: true

require './lib/hand'

RSpec.describe Hand do # rubocop:disable Metrics/BlockLength
  describe 'STONE' do
    it 'グーの値が0' do
      expect(described_class::STONE.number).to eq 0
    end

    it 'グーの名前がSTONE' do
      expect(described_class::STONE.name).to eq :STONE
    end
  end

  describe '#valid_hand_num_string?' do # rubocop:disable Metrics/BlockLength
    describe '正常な値' do
      where(:num_str) do
        [
          ['0'],
          ['1'],
          ['2']
        ]
      end

      with_them do
        it '正常と判定される' do
          actual = described_class.valid_hand_num_string?(num_str)
          expect(actual).to be_truthy
        end
      end
    end

    describe '不正な値' do
      where(:num_str) do
        [
          ['-1'],
          ['3'],
          ['1.0'],
          ['a'],
          [''],
          [' '],
          ['あ']
        ]
      end

      with_them do
        it '不正と判定される' do
          actual = described_class.valid_hand_num_string?(num_str)
          expect(actual).to be_falsey
        end
      end
    end
  end

  describe '#value_of_num_string' do # rubocop:disable Metrics/BlockLength
    describe '正常な値' do
      where(:num_str, :expected_name) do
        [
          ['0', :STONE],
          ['1', :PAPER],
          ['2', :SCISSORS]
        ]
      end

      with_them do
        it '期待する手を返す' do
          actual = described_class.value_of_num_string(num_str).name
          expect(actual).to eq expected_name
        end
      end
    end

    describe '不正な値' do
      where(:num_str) do
        [
          ['-1'],
          ['3'],
          ['1.0'],
          ['a'],
          [''],
          [' '],
          ['あ']
        ]
      end

      with_them do
        it '例外が発生する' do
          expect do
            described_class.value_of_num_string(num_str).name
          end.to raise_error RuntimeError
        end
      end
    end
  end
end
