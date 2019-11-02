# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::OffersController, type: :controller do
  let(:valid_attributes) { FactoryBot.attributes_for(:offer) }
  let(:invalid_attributes) { FactoryBot.attributes_for(:offer, title: '') }
  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'returns a success response' do
      Offer.create! valid_attributes
      get :index, params: {}, session: valid_session, format: 'json'
      expect(response).to be_successful
    end
    it 'returns newest offer first' do
      offers = FactoryBot.create_list(:offer, 10)
      get :index, params: {}, session: valid_session, format: 'json'
      expect(assigns(:offers).first).to eq(offers.last)
    end
    describe 'limit and offset parameter' do
      it 'default to 50 offers' do
        FactoryBot.create_list(:offer, 60)
        get :index, params: {}, session: valid_session, format: 'json'
        expect(assigns(:offers).size).to eq(50)
      end
      it 'limit offers' do
        FactoryBot.create_list(:offer, 10)
        get :index, params: { limit: 5 }, session: valid_session, format: 'json'
        expect(assigns(:offers).size).to eq(5)
      end
      it 'limit offers and skip 5' do
        offers = FactoryBot.create_list(:offer, 10)
        # we should get offers id 6 to id 2 (as from newest to oldest)
        get :index, params: { limit: 5, offset: 4 }, session: valid_session, format: 'json'
        expect(assigns(:offers).first).to eq(offers[5]) # id 6 is 5th element
      end
    end
    describe 'min and max price' do
      before do
        FactoryBot.create(:offer, price: 1000.00)
        FactoryBot.create(:offer, price: 2000.00)
        FactoryBot.create(:offer, price: 3000.33)
      end
      it 'limits max price' do
        get :index, params: { max_price: 3000.30 }, session: valid_session, format: 'json'
        expect(assigns(:offers).size).to eq(2)
      end
      it 'limits min price' do
        get :index, params: { min_price: 2000 }, session: valid_session, format: 'json'
        expect(assigns(:offers).count).to eq(2)
      end
      it 'limits both min and max price' do
        get :index, params: { min_price: 2000, max_price: 3000 }, session: valid_session, format: 'json'
        expect(assigns(:offers).count).to eq(1)
      end
    end
    describe 'query text' do
      before do
        FactoryBot.create(:offer, title: 'Example text to search')
        FactoryBot.create(:offer, description: 'Example text to search in description')
        FactoryBot.create(:offer)
      end
      it 'search in title and description case insensitive' do
        get :index, params: { query: 'example text' }, session: valid_session, format: 'json'
        expect(assigns(:offers).size).to eq(2)
      end
      it 'escapes characters' do
        get :index, params: { query: "\"' OR 1=1 -- " }, session: valid_session, format: 'json'
        expect(assigns(:offers).count).to eq(0)
      end
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      offer = Offer.create! valid_attributes
      get :show, params: { id: offer.to_param }, session: valid_session, format: 'json'
      expect(response).to be_successful
    end
    it 'renders selected offer' do
      offer = Offer.create! valid_attributes
      get :show, params: { id: offer.to_param }, session: valid_session, format: 'json'
      expect(assigns(:offer)).to eq(offer)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Offer' do
        expect do
          post :create, params: { offer: valid_attributes }, session: valid_session, format: 'json'
        end.to change(Offer, :count).by(1)
      end
      it 'renders created offer' do
        post :create, params: { offer: valid_attributes }, session: valid_session, format: 'json'
        expect(response).to render_template(:show)
      end
      it 'has status created' do
        post :create, params: { offer: valid_attributes }, session: valid_session, format: 'json'
        expect(response).to have_http_status(:created)
      end
    end
    describe 'with attachment' do
      it 'saves attachment' do
        pictures = Dir.glob(Rails.root.join('spec/factories/pictures/*.jpg'))
        create_attributes = valid_attributes.merge(
          picture: Rack::Test::UploadedFile.new(pictures.sample, 'image/jpeg')
        )
        post :create, params: { offer: create_attributes }, session: valid_session, format: 'json'
        expect(Offer.last.picture.attached?).to be_truthy
      end
    end

    context 'with invalid params' do
      it 'does not create offer' do
        expect do
          post :create, params: { offer: invalid_attributes }, session: valid_session, format: 'json'
        end.not_to change(Offer, :count)
      end
      it 'returns 422 status' do
        post :create, params: { offer: invalid_attributes }, session: valid_session, format: 'json'
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        { title: 'new title' }
      end
      it 'updates the requested offer' do
        offer = Offer.create! valid_attributes
        put :update, params: { id: offer.to_param, offer: new_attributes }, session: valid_session, format: 'json'
        offer.reload
        expect(offer.title).to eq(new_attributes[:title])
      end
      it 'renders updated offer' do
        offer = Offer.create! valid_attributes
        put :update, params: { id: offer.to_param, offer: valid_attributes }, session: valid_session, format: 'json'
        expect(response).to render_template(:show)
      end
    end

    context 'with invalid params' do
      it 'returns 422 status' do
        offer = Offer.create! valid_attributes
        put :update, params: { id: offer.to_param, offer: invalid_attributes }, session: valid_session, format: 'json'
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested offer' do
      offer = Offer.create! valid_attributes
      expect do
        delete :destroy, params: { id: offer.to_param }, session: valid_session, format: 'json'
      end.to change(Offer, :count).by(-1)
    end
    it 'renders 204 answer' do
      offer = Offer.create! valid_attributes
      delete :destroy, params: { id: offer.to_param }, session: valid_session, format: 'json'
      expect(response).to have_http_status(:no_content)
    end
  end
end
