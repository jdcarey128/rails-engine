FactoryBot.define do
  factory :item do
    name { Faker::Commerce.product_name }
    description { Faker::Quote.yoda }
    unit_price { Faker::Commerce.price(range: 10.00..150.00)}
    created_at { Time.now }
    merchant
  end
end
