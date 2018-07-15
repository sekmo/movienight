FactoryGirl.define do
  factory :friendship do
    association :sender, factory: :profile
    association :receiver, factory: :profile
  end
end
