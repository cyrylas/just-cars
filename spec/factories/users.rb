# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.safe_email }
    password { 'password' }
    password_confirmation { 'password' }

    is_active { true }
  end
end
