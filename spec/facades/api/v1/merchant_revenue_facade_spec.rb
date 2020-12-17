require 'rails_helper' 

RSpec.describe Api::V1::MerchantRevenueFacade, type: :facade do 
  it 'returns item objects for a merchant' do 
    start_date = '2020-12-12'
    end_date = '2020-12-17'
    merchant = create(:merchant, :with_invoice_items, created_at: '2020-12-13 18:00:00', item_quantity: 1, unit_price: 15.50)
    merchant_2 = create(:merchant, :with_invoice_items, created_at: '2020-12-16 18:13:10', item_quantity: 1, unit_price: 15.50)

    expect(Api::V1::MerchantRevenueFacade.total_revenue(start_date, end_date))
      .to eq(31.00)
  end
end
