FactoryBot.define do
  factory :customer do
    first_name { Faker::Movies::LordOfTheRings.character }
    last_name { Faker::Name.last_name }
  end
end
