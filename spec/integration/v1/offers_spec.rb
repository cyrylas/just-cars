# frozen_string_literal: true

require 'swagger_helper'

describe 'Offers API', type: :request, swagger_doc: 'v1/swagger.yaml' do
  tag_name = 'Offers'
  let(:user) { FactoryBot.create(:user) }
  let(:jwt_token) do
    JsonWebToken.encode({ user_id: user.id }, (Time.now + 3600).to_i)
  end

  path '/api/v1/offers' do
    get 'List all offers' do
      tags tag_name
      security []
      consumes 'application/json'
      produces 'application/json'

      parameter name: :limit, in: :query, type: :integer, description: 'Number of offers to display. Default: 50'
      parameter name: :offset, in: :query, type: :integer, description: 'Number of offers to skip. Default: 0'
      parameter name: :min_price, in: :query, type: :number, description: 'Minimum price (inclusive)'
      parameter name: :max_price, in: :query, type: :number, description: 'Maximum price (inclusive)'
      parameter name: :query, in: :query, type: :string, description: 'Exact query string to look for in title and descrition'

      response '200', 'Offers list' do
        let(:limit) { '10' }
        let(:offset) { '0' }
        let(:min_price) { nil }
        let(:max_price) { nil }
        let(:query) { nil }
        schema(type: :array, items: { "$ref": '#/definitions/offer' })
        run_test!
      end
    end

    post 'Creates an offer' do
      tags tag_name
      produces 'application/json'
      consumes 'multipart/form-data'
      parameter name: 'Authorization', in: :header, type: :string, required: true
      parameter name: 'offer[title]', in: :formData, schema: { type: :string }, required: true,
                description: 'Offer title to display'
      parameter name: 'offer[description]', in: :formData, schema: { type: :string }, required: false,
                description: 'Offer description'
      parameter name: 'offer[price]', in: :formData, schema: { type: :number }, required: true,
                description: 'Offer price, eg: 123.45'
      parameter name: 'offer[picture]', in: :formData, type: :file, required: false,
                description: 'Image that should be displayed with offer'

      let(:Authorization) { 'Bearer ' + jwt_token }

      response '201', 'offer created' do
        let(:'offer[title]') { 'Offer title' }
        let(:'offer[description]') { 'Offer description' }
        let(:'offer[price]') { '4999.99' }
        run_test!
      end

      response '422', 'invalid request' do
      end
    end
  end

  path '/api/v1/offers/{id}' do
    get 'Retrieves offer details' do
      tags tag_name
      security []
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'Offer details' do
        schema "$ref": '#/definitions/offer'

        let(:id) { FactoryBot.create(:offer).id }
        run_test!
      end

      response '404', 'offer not found' do
        schema(
          type: 'object',
          properties: {
            status: { type: 'number' },
            error: { type: 'string' }
          }
        )
      end
    end

    patch 'Update offer' do
      tags tag_name
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: 'Authorization', in: :header, type: :string, required: true
      parameter name: :id, in: :path, type: :number
      parameter name: 'offer[title]', in: :formData, schema: { type: :string }, required: false,
                description: 'Offer title to display'
      parameter name: 'offer[description]', in: :formData, schema: { type: :string }, required: false,
                description: 'Offer description'
      parameter name: 'offer[price]', in: :formData, schema: { type: :number }, required: false,
                description: 'Offer price, eg: 123.45'
      parameter name: 'offer[picture]', in: :formData, type: :file, required: false,
                description: 'Image that should be displayed with offer'

      let(:id) { FactoryBot.create(:offer).id }
      let(:Authorization) { 'Bearer ' + jwt_token }
      response '200', 'brand updated' do
        let(:'offer[title]') { 'Offer title' }
        let(:'offer[description]') { 'Offer description' }
        let(:'offer[price]') { '4999.99' }
        run_test!
      end

      response '422', 'invalid request' do
        let(:'offer[title]') { '' }
        run_test!
      end
    end

    delete 'Delete offer' do
      tags tag_name
      produces 'application/json'
      parameter name: 'Authorization', in: :header, type: :string, required: true

      parameter name: :id, in: :path, type: :number
      let(:Authorization) { 'Bearer ' + jwt_token }

      response '204', 'offer deleted' do
        let(:id) { FactoryBot.create(:offer).id }
        run_test!
      end
    end
  end
end
