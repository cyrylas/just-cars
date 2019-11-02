# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Offer, type: :model do
  let(:offer) { FactoryBot.build(:offer) }

  describe 'with default data is valid' do
    it { expect(offer).to be_valid }
  end

  describe 'validate title' do
    specify 'when empty not valid' do
      offer.title = 'aa'
      expect(offer).not_to be_valid
    end

    specify 'when too long not valid' do
      offer.title = 'a' * 101
      expect(offer).not_to be_valid
    end
  end

  describe 'validate description' do
    specify 'when too long not valid' do
      offer.description = 'a' * 3001
      expect(offer).not_to be_valid
    end
  end

  describe 'validate price' do
    specify 'when free not valid' do
      offer.price = 0
      expect(offer).not_to be_valid
    end
    specify 'when one cent is valid' do
      offer.price = 0.01
      expect(offer).to be_valid
    end
    specify 'when one million is not valid' do
      offer.price = 1_000_000
      expect(offer).not_to be_valid
    end
  end
end
