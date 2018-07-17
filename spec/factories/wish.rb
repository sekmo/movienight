FactoryGirl.define do
  factory :wish do
    association :profile
    association :movie
  end
end
