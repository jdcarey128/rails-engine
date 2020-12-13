FactoryBot.define do
  factory :item do
    name { Faker::Commerce.product_name }
    description { "MyText" }
    unit_price { Faker::Commerce.price(range: 10.00..150.00)}
    merchant { nil }
  end
end
