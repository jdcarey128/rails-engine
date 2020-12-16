FactoryBot.define do
  factory :invoice do
    customer 
    merchant 
    status { 'shipped' }

    trait :with_invoice_items do 
      transient do 
        invoice_item_count { 3 }
      end

      after :created do |invoice, evaluator|
        invoice.invoice_items << create_list(:invoice_item, evaluator.invoice_item_count)
      end
    end
  end
end
