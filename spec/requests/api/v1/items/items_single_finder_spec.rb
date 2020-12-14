require 'rails_helper' 

RSpec.describe 'Items Single Finder', type: :request do 
  describe 'it returns an item match for attribute' do 
    it 'name' do 
      item = create(:item)
      items = create_list(:item, 5)

      expect(Item.count).to eq(6)

      get "/api/v1/items/find?name=#{item.name}"

      expect(response).to be_successful
      
      found_item = JSON.parse(response.body, symbolize_names: true)

      expect(found_item.name).to eq(item.name)
      expect(found_item.description).to eq(item.description)
      expect(found_item.unit_price).to eq(item.unit_price)
      expect(found_item.merchant_id).to eq(item.merchant_id)
    end
  end
end
