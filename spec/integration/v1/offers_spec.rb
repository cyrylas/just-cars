# frozen_string_literal: true

require 'swagger_helper'

describe 'Offers API', type: :request, swagger_doc: 'v1/swagger.json' do
  TAG_NAME = 'Offers'

  path '/api/v1/offers' do
    get 'List all offers' do
      tags TAG_NAME
      consumes 'application/json'
      produces 'application/json'

      response '200', 'Offers list' do
        schema type: :array, items: { "$ref": '#/components/schemas/offer' }
        run_test!
      end
    end

    post 'Creates an offer' do
      tags TAG_NAME
      description <<~DOC
        # There's some issues with rails 6 and rswag regarding file upload.
        To properly test this action please use command line.

        For example:
        ```
        curl -X POST "http://localhost:3000/api/v1/offers" -F "offer[title]=title" -F "offer[description]=my description" -F "offer[price]=123.45" -F "offer[picture]=@spec/factories/pictures/1971_Buick_Estate_wagon_rear.jpg"
        ````
      DOC
      consumes 'application/json'
      produces 'application/json'
      request_body_json schema: {
        type: :object,
        name: 'offer',
        properties: {
          offer: {
            type: :object,
            properties: {
              title: { type: :string },
              description: { type: :string },
              price: { type: :number },
              picture: { type: :string }
            },
            required: %w[title price]
          }
        }
      }
      parameter name: :offer, in: :body

      response '201', 'offer created' do
        let(:offer) do
          {
            title: 'Offer title',
            description: 'Offer description',
            price: 4999.99
          }
        end
        run_test!
      end

      response '422', 'invalid request' do
      end
    end
  end

  path '/api/v1/offers/{id}' do
    get 'Retrieves offer details' do
      tags TAG_NAME
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'Offer details' do
        schema "$ref": '#/components/schemas/offer'

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
      tags TAG_NAME
      description <<~DOC
        # There's some issues with rails 6 and rswag regarding file upload.
        To properly test this action please use command line.

        For example:
        ```
        curl -X PATCH "http://localhost:3000/api/v1/offers/:id" -F "offer[title]=title" -F "offer[description]=my description" -F "offer[price]=123.45" -F "offer[picture]=@spec/factories/pictures/1971_Buick_Estate_wagon_rear.jpg"
        ````
      DOC
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :number

      request_body_json schema: {
        type: 'object',
        properties: {
          offer: {
            type: 'object',
            properties: {
              title: { type: :string },
              description: { type: :string },
              price: { type: :number },
              picture: { type: :string }
            }
          }
        }
      }
      parameter name: :offer, in: :body
      parameter name: :id, in: :path, type: :number

      let(:id) { FactoryBot.create(:offer).id }
      response '200', 'brand updated' do
        let(:offer) { { offer: { title: 'My new title' } } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:offer) { { offer: { title: '' } } }
        run_test!
      end
    end

    delete 'Delete offer' do
      tags TAG_NAME
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :number

      response '204', 'offer deleted' do
        let(:id) { FactoryBot.create(:offer).id }
        run_test!
      end
    end
  end
end
