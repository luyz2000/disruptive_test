class CalculatePerformance < ApplicationService
  attr_accessor :base_amount

  def initialize(base_amount)
    @base_amount = base_amount.to_f
  end

  def call
    result = Visitor::AVAILABLE_COINS.map do |coin|
      result = Coinbase::GetExchangeRate.new({ to_coin: coin[:short_name] }).call
      next unless result.success?

      build_hash(result.data, coin)
    end
    result.compact!
    if result.empty?
      error_response('Too many requests - You have exceeded request limit for this specific API Key over last 24 hours. Limit is defined in the customer portal in the API Key configuration section. You can disable this limit for this API Key, increase limit value or reduce request rate.')
    else
      success_response(result)
    end
  end

  private

  def build_hash(rate, coin)
    coin[:base_amount] = base_amount
    coin[:rate] = rate
    coin[:rate_anual_gain] = calculate_performance(coin)
    coin[:rate_anual_gain_compound] = calculate_performance_compound(coin)
    coin
  end

  def calculate_performance(coin_hash)
    base_performance = coin_hash[:performance] * 12.0
    total_amount = base_amount + (base_performance * base_amount)
    total_amount * coin_hash[:rate]
  end

  def calculate_performance_compound(coin_hash)
    total_amount = base_amount
    12.times do
      total_amount += total_amount * coin_hash[:performance]
    end
    total_amount * coin_hash[:rate]
  end
end
