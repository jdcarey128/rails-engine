require 'rails_helper' 

RSpec.describe 'Items Single Finder', type: :request do 
  describe 'it returns an item match for attribute' do 
    before :each do 
      @item = create(:item)
      @items = create_list(:item, 5)
    end

    it 'name' do 
      expect(Item.count).to eq(6)

      get "/api/v1/items/find?name=#{@item.name}"

      expect(response).to be_successful
      
      found_item = JSON.parse(response.body, symbolize_names: true)[:data][:attributes]

      expect(found_item[:name]).to eq(@item.name)
      expect(found_item[:description]).to eq(@item.description)
      expect(found_item[:unit_price]).to eq(@item.unit_price)
      expect(found_item[:merchant_id]).to eq(@item.merchant_id)
    end

    it 'description' do 
      description = @item.description.gsub(' ', '+')
      get "/api/v1/items/find?description=#{description}"

      expect(response).to be_successful
      
      found_item = JSON.parse(response.body, symbolize_names: true)[:data][:attributes]

      expect(found_item[:name]).to eq(@item.name)
      expect(found_item[:description]).to eq(@item.description)
      expect(found_item[:unit_price]).to eq(@item.unit_price)
      expect(found_item[:merchant_id]).to eq(@item.merchant_id)
    end

    it 'unit_price' do 
      get "/api/v1/items/find?unit_price=#{@item.unit_price}"

      expect(response).to be_successful
      
      found_item = JSON.parse(response.body, symbolize_names: true)[:data][:attributes]
      
      expect(found_item[:name]).to eq(@item.name)
      expect(found_item[:description]).to eq(@item.description)
      expect(found_item[:unit_price]).to eq(@item.unit_price)
      expect(found_item[:merchant_id]).to eq(@item.merchant_id)
    end

    it 'item id' do 
      get "/api/v1/items/find?id=#{@item.id}"

      expect(response).to be_successful
      
      found_item = JSON.parse(response.body, symbolize_names: true)[:data][:attributes]
      
      expect(found_item[:name]).to eq(@item.name)
      expect(found_item[:description]).to eq(@item.description)
      expect(found_item[:unit_price]).to eq(@item.unit_price)
      expect(found_item[:merchant_id]).to eq(@item.merchant_id)
    end

    it 'created at' do 
      get "/api/v1/items/find?created_at=#{@item.created_at}"

      expect(response).to be_successful
      
      found_item = JSON.parse(response.body, symbolize_names: true)[:data][:attributes]
      
      expect(found_item[:name]).to eq(@item.name)
      expect(found_item[:description]).to eq(@item.description)
      expect(found_item[:unit_price]).to eq(@item.unit_price)
      expect(found_item[:merchant_id]).to eq(@item.merchant_id)
    end

    it 'updated at' do 
      get "/api/v1/items/find?updated_at=#{@item.updated_at}"

      expect(response).to be_successful
      
      found_item = JSON.parse(response.body, symbolize_names: true)[:data][:attributes]
      
      expect(found_item[:name]).to eq(@item.name)
      expect(found_item[:description]).to eq(@item.description)
      expect(found_item[:unit_price]).to eq(@item.unit_price)
      expect(found_item[:merchant_id]).to eq(@item.merchant_id)
    end
  end

  describe 'it returns an item for a partial string match' do 
    before :each do 
      @item = create(:item, 
                     name: 'The Wacky Inflatable Arms Man', 
                     description: 'It inflates up to 20 ft tall! 
                                  Why would you want it? Who knows!'
                    )
      @items = create_list(:item, 5)
    end

    it 'name' do 
      name = 'waCKY'
      get "/api/v1/items/find?name=#{name}"

      expect(response).to be_successful
      
      found_item = JSON.parse(response.body, symbolize_names: true)[:data][:attributes]
      
      expect(found_item[:name]).to eq(@item.name)
      expect(found_item[:description]).to eq(@item.description)
      expect(found_item[:unit_price]).to eq(@item.unit_price)
      expect(found_item[:merchant_id]).to eq(@item.merchant_id)
    end

    it 'description' do 
      description = 'FT TALL'
      get "/api/v1/items/find?description=#{description}"

      expect(response).to be_successful
      
      found_item = JSON.parse(response.body, symbolize_names: true)[:data][:attributes]
      
      expect(found_item[:name]).to eq(@item.name)
      expect(found_item[:description]).to eq(@item.description)
      expect(found_item[:unit_price]).to eq(@item.unit_price)
      expect(found_item[:merchant_id]).to eq(@item.merchant_id)
    end
  end
end
