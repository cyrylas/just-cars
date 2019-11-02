# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'api/v1/offers/show.json.jbuilder', type: :view do
  let(:offer) { FactoryBot.create(:offer) }
  before(:each) { assign(:offer, offer) }

  it 'should contain title, description and price' do
    render
    resp = JSON.parse(rendered)
    %w[title description price].each do |attr|
      expect(resp[attr]).to eq(offer[attr])
    end
  end
end
