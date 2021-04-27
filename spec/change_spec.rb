# frozen_string_literal: true

require 'rspec'

describe Change do
  describe 'initialize' do
    it 'coins count with zero quantity' do
      expect(described_class.new.coins.size).to eq(8)
      expect(described_class.new.coins.map(&:qty).uniq).to match_array([0])
      expect(described_class.new.coins.first).to eq(described_class::Coin.new(:'200p', 200, 0))
    end
  end

  describe '#load' do
    it 'raise error when invalid coin is inserted' do
      coins = [
        described_class::Coin.new(:'200p', 200, 2),
        described_class::Coin.new(:'900p', 900, 1)
      ]
      expect do
        described_class.new.load!(coins)
      end.to raise_exception(ArgumentError)
    end

    it 'with any number of coins' do
      coins = [
        described_class::Coin.new(:'1p', 1, 5),
        described_class::Coin.new(:'2p', 2, 2),
        described_class::Coin.new(:'100p', 100, 4)
      ]
      change = described_class.new(coins)
      expect(change.find(:'1p').qty).to eq(5)
      expect(change.find(:'2p').qty).to eq(2)
      expect(change.find(:'100p').qty).to eq(4)
      expect(change.find(:'200p').qty).to eq(0)
    end
  end

  describe '#total' do
    it 'return the sum of the all coins' do
      coins = [
        described_class::Coin.new(:'1p', 1, 5),
        described_class::Coin.new(:'2p', 2, 2),
        described_class::Coin.new(:'100p', 100, 4),
        described_class::Coin.new(:'200p', 200, 2)
      ]
      change = described_class.new(coins)
      expect(change.total).to eq(100 * 4 + 200 * 2 + 2 * 2 + 5 * 1)
    end

    it 'return zero for blank object' do
      change = described_class.new
      expect(change.total).to eq(0)
    end
  end
end
