# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::AuthController, type: :routing do
  describe 'routing' do
    it 'routes to #login' do
      expect(post: '/api/v1/auth').to route_to('api/v1/auth#login', format: 'json')
    end

    it 'routes to #refresh' do
      expect(post: '/api/v1/auth/refresh').to route_to('api/v1/auth#refresh', format: 'json')
    end
  end
end
