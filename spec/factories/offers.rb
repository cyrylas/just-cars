# frozen_string_literal: true

FactoryBot.define do
  factory :offer do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph(sentence_count: 20, supplemental: true) }
    price { BigDecimal(Faker::Number.number(digits: 6).to_s) / 100 }

    pictures = Dir.glob(Rails.root.join('spec/factories/pictures/*.jpg'))
    picture { Rack::Test::UploadedFile.new(pictures.sample, 'image/jpeg') }
  end
end
