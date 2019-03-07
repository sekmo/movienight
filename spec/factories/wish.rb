FactoryGirl.define do
  factory :wish do
    association :user
    association :movie
  end
end
