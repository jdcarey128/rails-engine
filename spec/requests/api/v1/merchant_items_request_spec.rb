require 'rails_helper'

RSpec.describe 'Merchant Items API', type: :request do 
  it 'returns all items for a merchant' do 
    merchant = create(:merchant, :with_items, item_count: 5)

    get "/api/v1/merchants/#{merchant.id}/items"

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items.count).to eq(5)

    items.each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(Integer)

      expect(item).to have_key(:name)
      expect(item[:name]).to be_a(String)

      expect(item).to have_key(:description)
      expect(item[:description]).to be_a(String)

      expect(item).to have_key(:unit_price)
      expect(item[:unit_price]).to be_a(Float)

      expect(item).to have_key(:merchant_id)
      expect(item[:merchant_id]).to be_a(Integer)
      expect(item[:merchant_id]).to eq(merchant.id)
    end
  end

  it 'returns all items for specific merchant' do 
    merchant = create(:merchant, :with_items, item_count: 3)
    merchant_2 = create(:merchant, :with_items, item_count: 5)

    get "/api/v1/merchants/#{merchant.id}/items"

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(Item.count).to eq(8)
    expect(items.count).to eq(3)

    items.each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(Integer)

      expect(item).to have_key(:name)
      expect(item[:name]).to be_a(String)

      expect(item).to have_key(:description)
      expect(item[:description]).to be_a(String)

      expect(item).to have_key(:unit_price)
      expect(item[:unit_price]).to be_a(Float)

      expect(item).to have_key(:merchant_id)
      expect(item[:merchant_id]).to be_a(Integer)
      expect(item[:merchant_id]).to eq(merchant.id)
    end
  end
end
