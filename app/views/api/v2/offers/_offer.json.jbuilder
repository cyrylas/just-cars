# frozen_string_literal: true

# ids
json.extract! offer, :id, :title, :description, :price, :created_at, :updated_at
# stuff
json.extract! offer, :title, :description
json.price offer.price.to_f
# timestamps
json.extract! offer, :created_at, :updated_at

if offer.picture.attached?
  json.picture do
    json.thumb url_for(offer.picture.variant(resize: '200x200'))
    json.original url_for(offer.picture)
  end
end