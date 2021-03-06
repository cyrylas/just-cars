# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'api/v1/offers/index.json.jbuilder', type: :view do
  let(:offers) { FactoryBot.create_list(:offer, 2) }
  before(:each) { assign(:offers, offers) }

  it 'has two offers' do
    render
    expect(JSON.parse(rendered).size).to eq(2)
  end

  it 'should contain title, description' do
    render
    resp = JSON.parse(rendered)
    %w[title description].each do |attr|
      expect(resp.pluck(attr)).to eq(offers.pluck(attr))
    end
  end
  it 'should contain  price' do
    render
    resp = JSON.parse(rendered)
    # Sometimes price was converted to float as 0.575172e4
    # Make sure, that both values would be same
    expected = offers.pluck('price').map { |f| format('%.2f', f) }
    got = resp.pluck('price').map { |f| format('%.2f', f) }
    expect(expected).to eq(got)
  end
end
