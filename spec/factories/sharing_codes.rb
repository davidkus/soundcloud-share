FactoryGirl.define do
  factory :sharing_code do
    code  { Faker::Lorem.characters(12) }
  end
end
