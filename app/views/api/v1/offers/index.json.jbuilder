# frozen_string_literal: true

json.array! @offers, partial: 'api/v1/offers/offer', as: :offer
