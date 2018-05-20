FactoryGirl.define do
  factory :profile do
    first_name { Faker::Name.unique.first_name }
    last_name { Faker::Name.unique.last_name }
    nickname { first_name.downcase }
    user
  end
end
