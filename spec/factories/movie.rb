FactoryGirl.define do
  factory :movie do
    sequence(:title){ |n| "Kill Bill vol: #{n}" }
    sequence(:tmdb_code) { |n| n }
  end
end
