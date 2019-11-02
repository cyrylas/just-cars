# frozen_string_literal: true

class Offer < ApplicationRecord

  validates :title, length: { minimum: 3, maximum: 100 }
  validates :description, length: { maximum: 3_000 }
  validates :price, numericality: { greater_than_or_equal_to: 0.01, less_than: 1_000_000.00 }
end
