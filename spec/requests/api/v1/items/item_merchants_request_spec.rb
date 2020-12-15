require 'rails_helper'

RSpec.describe 'ItemMerchants', type: :request do 
  it 'it returns a merchant for a given item' do 
    item = create(:item)
    item_merchant = item.merchant 

    get "/api/v1/items/#{item.id}/merchants"

    expect(response).to be_successful

    merchant_response = JSON.parse(response.body, symbolize_names: true)[:data][:attributes]
       
    expect(merchant_response).to have_key(:id)
    expect(merchant_response[:id]).to be_a(Integer)
    expect(merchant_response[:id]).to eq(item_merchant.id)

    expect(merchant_response).to have_key(:name)
    expect(merchant_response[:name]).to be_a(String)
    expect(merchant_response[:name]).to eq(item_merchant.name)
  end

  it 'it returns only item\'s merchant for a given item' do 
    item = create(:item)
    item_2 = create(:item)
    item_merchant_2 = item_2.merchant 

    get "/api/v1/items/#{item.id}/merchants"

    expect(response).to be_successful

    merchant_response = JSON.parse(response.body, symbolize_names: true)[:data][:attributes]
       
    expect(merchant_response[:id]).to_not eq(item_merchant_2.id)
    expect(merchant_response[:name]).to_not eq(item_merchant_2.name)
  end
end
