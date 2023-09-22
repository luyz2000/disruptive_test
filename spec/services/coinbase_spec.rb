# frozen_string_literal: true

RSpec.describe(Coinbase::GetExchangeRate) do
  subject { Coinbase::GetExchangeRate.new(params).call }
  let(:params) do
    {
      from_coin: 'USD',
      to_coin: 'BTC'
    }
  end

  describe('correctly convertion rate coin') do
    context('when rate') do
      Visitor::AVAILABLE_COINS.each do |coin|
        let(:params) { { to_coin: coin[:short_name] } }
        it("- #{coin[:name]} is valid and more than 0") do
          expect(subject.data).to be > 0
        end
        it("- #{coin[:name]} is not nil") do
          expect(subject.data).not_to be_nil
        end
      end
    end
  end

  describe('coins') do
    context('when coins are blank') do
      let(:params) { {} }
      it('- should return success? false') do
        expect(subject.success?).to be_falsy
      end
      it('- should return error_message') do
        expect(subject.errors).to be_equal('Se necesita la moneda de origen y la moneda a convertir')
      end
    end
    context('when coins are valid') do
      it('- should return success? true') do
        expect(subject.success?).to be_truthy
      end
    end

    context('when from_coin are unknown') do
      let(:params) { { from_coin: 'USDDD', to_coin: 'BTC' } }
      it('- should return success? false') do
        expect(subject.success?).to be_falsy
      end
    end

    context('when to_coin are unknown') do
      let(:params) { { from_coin: 'BTC', to_coin: 'USDDD' } }
      it('- should return success? false') do
        expect(subject.success?).to be_falsy
      end
    end
  end
end
