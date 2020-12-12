FactoryBot.define do
  factory :transaction do
    invoice { nil }
    credit_card_number { 1 }
    credit_card_expiration_date { "2020-12-11" }
    result { "MyString" }
  end
end
