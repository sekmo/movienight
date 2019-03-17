FactoryGirl.define do
  factory :friendship do
    association :sender, factory: :user
    association :receiver, factory: :user
  end
end
