# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::OffersController, type: :controller do
  let(:valid_attributes) { FactoryBot.attributes_for(:offer) }
  let(:invalid_attributes) { FactoryBot.attributes_for(:offer, title: '') }
  let(:valid_session) { {} }

  describe 'POST #create' do
    context 'with valid params' do
      it 'has status unauthorized' do
        post :create, params: { offer: valid_attributes }, session: valid_session, format: 'json'
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PUT #update' do
    context 'with invalid params' do
      it 'returns unauthorized status' do
        offer = Offer.create! valid_attributes
        put :update, params: { id: offer.to_param, offer: invalid_attributes }, session: valid_session, format: 'json'
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'renders unauthorized answer' do
      offer = Offer.create! valid_attributes
      delete :destroy, params: { id: offer.to_param }, session: valid_session, format: 'json'
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
