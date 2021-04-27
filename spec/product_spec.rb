# frozen_string_literal: true

require 'rspec'

describe Product do
  describe 'initialize' do
    it 'raise an error when name is not present' do
      expect { described_class.new(name: ' ', price: 12) }.to raise_error(
        ArgumentError,
        'Name can not be empty'
      )
    end

    it 'raise an error when price is not valid' do
      expect do
        described_class.new(name: 'walkers crisps',
                            price: -12)
      end.to raise_error(ArgumentError, 'Price must be greater than zero')
    end

    it 'load product with valid name and price' do
      product = described_class.new(name: 'walkers crisps', price: 12.5)
      expect(product.name).to eq('walkers crisps')
      expect(product.price).to eq(1250.0)
    end
  end
end
