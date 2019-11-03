# frozen_string_literal: true

require 'swagger_helper'

describe 'Auth API', type: :request, swagger_doc: 'v2/swagger.json' do
  let(:user) { FactoryBot.create(:user) }
  let(:jwt_token) do
    JsonWebToken.encode({ user_id: user.id }, (Time.now + 3600).to_i)
  end

  path '/api/v2/auth' do
    post 'Get token' do
      tags 'Auth'
      security []
      produces 'application/json'
      consumes 'application/json'

      request_body_json schema: {
        type: 'object',
        properties: {
          email: { type: 'string' },
          password: { type: 'string' }
        }
      }

      parameter name: :auth, in: :body

      response '201', 'Valid credentials' do
        schema(
          type: 'object',
          properties: {
            token: { type: :string },
            exp: { type: :string, format: :'date-time' },
            user: {
              "$ref": '#/components/schemas/user'
            }
          },
          required: %w[token exp user]
        )

        let(:auth) { { email: user.email, password: 'password' } }
        run_test!
      end

      response '401', 'Invalid email or password' do
        let(:auth) { { email: user.email, password: 'bad-password' } }
        run_test!
      end
    end
  end

  path '/api/v2/auth/refresh' do
    post 'refresh token' do
      tags 'Auth'
      produces 'application/json'

      response '201', 'Valid credentials' do
        schema(
          type: 'object',
          properties: {
            token: { type: :string },
            exp: { type: :string, format: :'date-time' },
            user: {
              "$ref": '#/components/schemas/user'
            }
          },
          required: %w[token exp user]
        )
        let(:Authorization) { 'Bearer ' + jwt_token }
        run_test!
      end

      response '401', 'Invalid current token' do
        let(:Authorization) { 'Bearer no-token' }
        run_test!
      end
    end
  end
end
