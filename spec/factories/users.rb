# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    name { Faker::Name.name }

    trait :with_oauth do
      provider { "google_oauth2" }
      sequence(:uid) { |n| "google_uid_#{n}" }
      avatar_url { Faker::Avatar.image }
    end
  end
end
