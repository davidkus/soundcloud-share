FactoryGirl.define do
  factory :room do
    name        { Faker::Lorem.word }
    public      { false }
    share_link  { true }
  end
end
