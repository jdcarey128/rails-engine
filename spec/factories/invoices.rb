FactoryBot.define do
  factory :invoice do
    customer 
    merchant 
    status { 'Shipped' }
  end
end
