require 'rails_helper'

RSpec.describe Api::V1::MerchantItemFacade, type: :facade do 
  it 'returns item objects for a merchant' do 
    merchant = create(:merchant, :with_items, item_count: 3)
    merchant_2 = create(:merchant, :with_items, item_count: 8)

    expect(Api::V1::MerchantItemFacade.all_items(merchant.id)).to eq(merchant.items)
  end
end
