# frozen_string_literal: true

class Product
  attr_reader :name, :price
  attr_accessor :quantity

  def initialize(name:, price:, quantity: 1)
    @name = name.to_s.strip
    @price = price.to_f * 100 # price in penses
    @quantity = quantity.to_i

    validate!
  end

  def validate!
    raise ArgumentError, 'Name can not be empty' if name.empty?
    raise ArgumentError, 'Price must be greater than zero' unless price.positive?
  end
end
