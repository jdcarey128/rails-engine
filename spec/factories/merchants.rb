FactoryBot.define do
  factory :merchant do
    name { Faker::Company.name }

    trait :with_items do 
      transient do 
        item_count { 3 }
      end

      after :create do |merchant, evaluator|
        create_list(:item, evaluator.item_count, merchant: merchant)
      end
    end

    trait :with_invoice_items do
      transient do 
        invoice_count { 3 }
        item_quantity { 1 }
        unit_price { 10 }
        transaction_result { 'success' }
      end 

      after :create do |merchant, evaluator|
        invoices = create_list(:invoice, evaluator.invoice_count, merchant: merchant)
        invoices.each do |invoice|
          invoice.invoice_items << create_list(:invoice_item, evaluator.invoice_count, quantity: evaluator.item_quantity, unit_price: evaluator.unit_price)
          invoice.transactions << create(:transaction, result: evaluator.transaction_result)
        end
      end
    end
    
  end
end
