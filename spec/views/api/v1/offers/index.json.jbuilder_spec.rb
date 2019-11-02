# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'api/v1/offers/index.json.jbuilder', type: :view do
  let(:offers) { FactoryBot.create_list(:offer, 2) }
  before(:each) { assign(:offers, offers) }

  it 'has two offers' do
    render
    expect(JSON.parse(rendered).size).to eq(2)
  end

  it 'should contain title, description and price' do
    render
    resp = JSON.parse(rendered)
    %w[title description price].each do |attr|
      expect(resp.pluck(attr)).to eq(offers.pluck(attr))
    end
  end
end
