# frozen_string_literal: true

require 'rspec'

describe Machine do
  let(:product1) do
    Product.new(name: 'walkers crisps', price: 1.20, quantity: 20)
  end

  let(:product2) do
    Product.new(name: 'coke', price: 1.65, quantity: 10)
  end

  let(:product3) do
    Product.new(name: 'doritos', price: 1.50, quantity: 2)
  end

  let(:products) { [product1, product2, product3] }

  let(:coins) do
    [
      Change::Coin.new(:'100p', 100, 2),
      Change::Coin.new(:'50p', 50, 4),
      Change::Coin.new(:'10p', 10, 2),
      Change::Coin.new(:'5p', 5, 1)
    ]
  end
  let(:change) { Change.new(coins) }

  describe 'initialize' do
    it 'raise an error invalid change is supplied' do
      expect { described_class.new(products: products, change: 100) }.to raise_error(ArgumentError)
    end

    it 'raise an error when invalid products is supplied' do
      expect { described_class.new(products: 'wrong format of products') }.to raise_error(ArgumentError)
    end

    it 'loads initial products and change' do
      machine = described_class.new(products: products, change: change)
      expect(machine.products).to eq(products)
      expect(machine.change).to eq(change)
    end
  end

  describe '#add_products' do
    it 'more products can be loaded later' do
      machine = described_class.new(products: products)
      expect(machine.products).to eq(products)
      product4 = Product.new(name: 'pepsi', price: 2.5)
      product5 = Product.new(name: 'fanta', price: 6.5)
      machine.add_products([product4, product5])
      expect(machine.products).to match_array([product1, product2, product3, product4, product5])
    end

    it 'raise error when inserted products are not valid' do
      machine = described_class.new(products: products)
      expect(machine.products).to eq(products)
      invalid_products = ['mango']
      expect { machine.add_products(invalid_products) }.to raise_error(ArgumentError)
    end
  end

  it 'more coins can be loaded later' do
    machine = described_class.new(change: change)
    expect(machine.change.total).to eq(100 * 2 + 50 * 4 + 10 * 2 + 5)
    coins = [
      Change::Coin.new(:'100p', 100, 3),
      Change::Coin.new(:'50p', 50, 4),
      Change::Coin.new(:'5p', 5, 1),
      Change::Coin.new(:'1p', 1, 1)
    ]

    machine.change.load!(coins)
    expect(machine.change.total).to eq(100 * 5 + 50 * 8 + 10 * 2 + 5 * 2 + 1)
  end

  it 'amount can be unloaded from the machine' do
    machine = described_class.new(change: change)
    expect(machine.change.total).to eq(425)
    machine.change.unload!(225)

    expect(machine.change.total).to eq(425 - 225)
  end

  describe '#buy_product!' do
    it 'when insert correct amount returns the product and remove it from vending machine' do
      machine = described_class.new(products: products, change: change)
      coins = [
        Change::Coin.new(:'50p', 50, 3),
        Change::Coin.new(:'10p', 10, 1),
        Change::Coin.new(:'5p', 5, 1)
      ]
      money = Change.new(coins)
      expect(machine.change.total).to eq(425)
      machine.buy_product!(name: 'coke', money: money)
      expect(machine.item_to_buy.name).to eq('coke')
      expect(machine.item_to_buy.quantity).to eq(10 - 1)
      expect(machine.change.total).to eq(425 + machine.item_to_buy.price)
    end

    it 'when insert the excess amount return the remaining amount' do
      machine = described_class.new(products: products, change: change)
      coins = [
        Change::Coin.new(:'50p', 50, 3),
        Change::Coin.new(:'10p', 10, 1)
      ]
      money = Change.new(coins)
      machine.buy_product!(name: 'doritos', money: money)
      expect(machine.item_to_buy.name).to eq('doritos')
      expect(machine.item_to_buy.quantity).to eq(2 - 1)
      expect(machine.change.total).to eq(425 + (50 * 3 + 10 * 1) - 10)
    end

    it 'when the amount is insufficient ask for more money and does not load the money' do
      machine = described_class.new(products: products, change: change)
      coins = [
        Change::Coin.new(:'50p', 50, 3)
      ]
      money = Change.new(coins)
      machine.buy_product!(name: 'coke', money: money)
      expect(machine.item_to_buy.name).to eq('coke')
      expect(machine).to_not receive(:remove_product)
      expect(machine.change).to_not receive(:load!)
      expect(machine.change).to_not receive(:unload!)
    end
  end
end
