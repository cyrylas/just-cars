# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'api/v1/offers/show.json.jbuilder', type: :view do
  let(:offer) { FactoryBot.create(:offer) }
  before(:each) { assign(:offer, offer) }

  it 'should contain title, description' do
    render
    resp = JSON.parse(rendered)
    %w[title description].each do |attr|
      expect(resp[attr]).to eq(offer[attr])
    end
  end

  it 'should contain price' do
    render
    resp = JSON.parse(rendered)
    # Sometimes price was converted to float as 0.575172e4
    # Make sure, that both values would be same
    expect(resp['price'].to_s).to eq(format('%.2f', offer['price']))
  end
end
