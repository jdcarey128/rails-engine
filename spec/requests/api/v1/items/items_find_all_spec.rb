require 'rails_helper' 

RSpec.describe 'Items Find All', type: :request do 
  describe 'It returns an array of items with matching attribute' do 
    before :each do 
      @items  = create_list(:item, 3, 
                           name: 'running watch', 
                           description: 'great for long distances!', 
                           unit_price: 50.00, 
                          )
      @item_1 = @items.first 
      @item_4 = create(    :item, 
                           name: 'gps watch',
                           description: 'top quality watch', 
                           unit_price: 500.00,
                           merchant: @item_1.merchant 
                      )
    end

    it 'id' do 
      expect(Item.count).to eq(4)

      get "/api/v1/items/find_all?id=#{@item_1.id}"

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)[:data]

      items.each do |item|
        item = item[:attributes]
        expect(item[:name]).to eq(@item_1.name)
        expect(item[:merchant_id]).to eq(@item_1.merchant_id)
        expect(item[:unit_price]).to eq(@item_1.unit_price)
        expect(item[:description]).to eq(@item_1.description)
      end
    end

    it 'name' do 
      get "/api/v1/items/find_all?name=#{@item_1.name}"

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(items.count).to eq(3)

      items.each do |item|
        expect(item[:attributes][:name]).to include(@item_1.name)
      end
    end

    it 'partial name' do 
      get "/api/v1/items/find_all?name=WATCH"

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(items.count).to eq(4)

      items.each do |item|
        expect(item[:attributes][:name].upcase).to include('WATCH')
      end
    end

    it 'description and partial match' do 
      get "/api/v1/items/find_all?description=top+quality"

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(items.count).to eq(1)

      get "/api/v1/items/find_all?description=#{@item_1.description}"

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(items.count).to eq(3)
    end

    it 'unit_price' do 
      get "/api/v1/items/find_all?unit_price=#{@item_1.unit_price}"

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(items.count).to eq(3)
    end

    it 'created_at and updated_at' do 
      get "/api/v1/items/find_all?created_at=#{@item_1.created_at}"

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(items.count).to eq(4)

      get "/api/v1/items/find_all?updated_at=#{@item_1.updated_at}"

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(items.count).to eq(4)
    end

    it 'merchant_id' do 
      get "/api/v1/items/find_all?merchant_id=#{@item_1.merchant.id}"

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(items.count).to eq(2)
    end
  end
end
