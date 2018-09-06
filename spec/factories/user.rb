FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.org" }
    password "123456"
    trait :with_profile do
      after(:create) { |user| create(:profile, user: user) }
    end
  end
end
