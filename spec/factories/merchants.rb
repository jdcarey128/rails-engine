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
        invoice_count { 1 }
        invoice_status { 'shipped' }
        invoice_item_count { 1 }
        item_quantity { 3 }
        unit_price { 10 }
        transaction_result { 'success' }
        created_at {'2020-12-01 12:00:00'}
      end 

      after :create do |merchant, evaluator|
        invoices = create_list(:invoice, evaluator.invoice_count, merchant: merchant, status: evaluator.invoice_status, created_at: evaluator.created_at)
        invoices.each do |invoice|
          invoice.invoice_items << create_list(:invoice_item, evaluator.invoice_item_count, quantity: evaluator.item_quantity, unit_price: evaluator.unit_price)
          invoice.transactions << create(:transaction, result: evaluator.transaction_result)
        end
      end
    end
    
  end
end
