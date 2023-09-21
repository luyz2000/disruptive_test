# frozen_string_literal: true

RSpec.describe(Coinbase::GetExchangeRate) do
  let(:params) do
    {
      from_coin: 'USD',
      to_coin: 'BTC'
    }
  end

  context('when rate') do
    it('- is valid') do
      result = Coinbase::GetExchangeRate.new(params).call
      expect(result.data).to be > 0
    end
    it('- is valid') do
      result = Coinbase::GetExchangeRate.new(params).call
      expect(result.data).not_to be_nil
    end
  end

  context('when coins') do
    it('- are blank') do
      result = Coinbase::GetExchangeRate.new({}).call
      expect(result.success?).to be_falsy
    end
    it('- are valid') do
      result = Coinbase::GetExchangeRate.new(params).call
      expect(result.success?).to(eq(true))
    end
    it('- from is unknown') do
      params[:from_coin] = 'USDDD'
      result = Coinbase::GetExchangeRate.new(params).call
      expect(result.success?).to be_falsy
    end
    it('- to is unknown') do
      params[:to_coin] = 'USDDD'
      result = Coinbase::GetExchangeRate.new(params).call
      expect(result.success?).to be_falsy
    end
  end
end
