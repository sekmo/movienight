FactoryGirl.define do
  factory :friendship do
    association :sender, factory: [:user, :with_profile]
    association :recipient, factory: [:user, :with_profile]
  end
end
