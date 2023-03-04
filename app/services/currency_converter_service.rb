# frozen_string_literal: true

class CurrencyConverterService
  attr_reader :amount, :from, :to

  def initialize(amount:, to:, from: :USD)
    @amount = (amount * 100).to_i
    @from = from
    @to = to
  end

  def self.convert(*args)
    new(*args).perform
  end

  def perform
    money = Money.new(amount, from) # amount is in cents
    money.exchange_to(to).fractional / 100.0
  end
end
