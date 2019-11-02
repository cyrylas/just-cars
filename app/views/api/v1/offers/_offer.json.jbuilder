# frozen_string_literal: true

# ids
json.extract! offer, :id, :title, :description, :price, :created_at, :updated_at
# stuff
json.extract! offer, :title, :description
json.price offer.price.to_f
# timestamps
json.extract! offer, :created_at, :updated_at
