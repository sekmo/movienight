FactoryGirl.define do
  factory :user do
    sequence(:email){ |n| "user#{n}@example.org" }
    password '123456'
    confirmed_at Time.now
  end
end
