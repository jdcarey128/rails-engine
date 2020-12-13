FactoryBot.define do
  factory :item do
    merchant
    name { Faker::Commerce.product_name }
    description { Faker::Quote.yoda }
    unit_price { Faker::Commerce.price(range: 10.00..150.00)}
  end
end
