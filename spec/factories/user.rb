FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.org" }
    password { Faker::Internet.password }
    first_name { Faker::Name.unique.first_name }
    last_name { Faker::Name.unique.last_name }
    username { Faker::Name.unique.first_name.downcase }
  end
end
