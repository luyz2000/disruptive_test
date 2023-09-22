# frozen_string_literal: true

RSpec.describe(CalculatePerformance) do
  subject { CalculatePerformance.new(base_amount).call }
  let(:base_amount) { 100_000 }

  describe('correctly base_amount param') do
    context('when base_amount is 0') do
      let(:base_amount) { 0 }
      it('- should return success? false') do
        expect(subject.success?).to be_falsy
      end
    end
    context('when base_amount is negative number') do
      let(:base_amount) { -100_000 }
      it('- should return success? false') do
        expect(subject.success?).to be_falsy
      end
    end
  end

  describe('correctly data response') do
    context('when call works') do
      it('- should return success? true') do
        expect(subject.success?).to be_truthy
      end
      it('- should return data size more than 0') do
        expect(subject.data.size).to be > 0
      end
    end
  end
end
