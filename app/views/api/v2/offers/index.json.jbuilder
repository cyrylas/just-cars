# frozen_string_literal: true

json.results do
  json.array! @offers, partial: 'api/v1/offers/offer', as: :offer
end

json.has_next_page @has_next_page
