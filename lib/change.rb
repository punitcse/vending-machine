# frozen_string_literal: true

class Change
  attr_accessor :coins

  VALID_CHANGE = %i[200p 100p 50p 20p 10p 5p 2p 1p].freeze

  Coin = Struct.new(:code, :val, :qty) do
    def total_value
      qty * val
    end
  end

  def initialize(coins_to_insert = nil)
    @coins = VALID_CHANGE.map do |code|
      val = code.to_s.delete_suffix('p').to_i
      Coin.new(code, val, 0)
    end.sort_by(&:val).reverse

    load!(coins_to_insert) if coins_to_insert
  end

  def total
    coins.reduce(0) do |sum, coin|
      sum += coin.total_value
      sum
    end
  end

  def load!(coins_to_insert)
    return unless coins_to_insert.is_a? Array
    return if coins_to_insert.empty?

    coins_to_insert.select { |coin| coin.qty.positive? }.each do |coin|
      insert!(coin)
    end
  end

  def unload!(amount)
    raise ArgumentError unless amount.positive?

    remaining_amount = amount
    coins.each do |coin|
      next if coin.total_value > remaining_amount
      next if coin.qty.zero?

      count, remainder = remaining_amount.divmod(coin.val)
      coin.qty -= count if count.positive? && coin.qty.positive?
      remaining_amount = remainder
      break if remaining_amount.zero?
    end
  end

  def insert!(coin)
    raise ArgumentError unless coin.is_a?(Coin)
    raise ArgumentError unless valid_coin?(coin.code)
    raise ArgumentError if coin.qty < 1

    coin_to_update = find(coin.code)
    coin_to_update.qty += coin.qty
  end

  def find(code)
    coins.find { |coin| coin.code == code }
  end

  def valid_coin?(code)
    VALID_CHANGE.include?(code)
  end
end
