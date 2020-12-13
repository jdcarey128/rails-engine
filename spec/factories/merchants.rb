FactoryBot.define do
  factory :merchant do
    name { Faker::Company.name }

    factory :merchant_with_albums do 
      transient do 
        item_count { 3 }
      end

      after(:create) do |merchant, evaluator|
        create_list(:item, evaluator.item_count, merchant_id: merchant)
      end
    end
  end
end
