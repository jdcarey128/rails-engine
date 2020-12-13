require 'rails_helper'

RSpec.describe MerchantFacade, type: :facade do 
  it 'returns a list of all merchant objects' do 
    create_list(:merchant, 5)
    expect(MerchantFacade.all_merchants.count).to eq(5)
    expect(MerchantFacade.all_merchants.first).to be_a(Merchant)
  end

end
