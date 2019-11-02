# frozen_string_literal: true

FactoryBot.define do
  factory :offer do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph(sentence_count: 20, supplemental: true) }
    price { Faker::Number.decimal(l_digits: 4, r_digits: 2) }
  end
end
