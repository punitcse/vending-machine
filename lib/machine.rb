# frozen_string_literal: true

class Machine
  attr_accessor :products, :change, :item_to_buy

  def initialize(products: [], change: Change.new)
    @products = products
    @change = change

    validate!
  end

  def select_product!(name)
    @item_to_buy = products.find { |product| product.name == name }
  end

  def buy_product!(name:, money:)
    raise ArgumentError, 'money is not valid should be an object of change class' unless money.is_a? Change

    select_product!(name)

    if item_to_buy.price == money.total
      change.load!(money.coins)
      remove_product(item_to_buy)
      puts "you have successfully bought #{@item_to_buy.name}"
    elsif item_to_buy.price > money.total
      price_diff = item_to_buy.price - money.total
      puts "The money is not sufficient to buy #{@item_to_buy.name}. Please insert #{price_diff} more to buy"
    elsif item_to_buy.price < money.total
      price_diff = money.total - item_to_buy.price
      change.load!(money.coins)
      remove_product(item_to_buy)
      change.unload!(price_diff)
    end
  end

  def remove_product(item)
    if item.quantity == 1
      self.products = products.delete(item)
    else
      item.quantity -= 1
    end
  end

  def add_products(items)
    return if items.empty?

    items.each do |item|
      raise ArgumentError unless item.is_a?(Product)

      products << item
    end
  end

  private

  def validate!
    raise ArgumentError unless products.is_a? Array
    raise ArgumentError unless change.is_a? Change
  end
end
