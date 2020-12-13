require 'rails_helper'

RSpec.describe 'Items API', type: :request do 
  it 'sends a list of items' do 
    create_list(:item, 5)

    get '/api/v1/items'

    expect(response).to be_successful 

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(5)

    items[:data].each do |item|
      expect(item[:attributes]).to have_key(:id)
      expect(item[:attributes][:id]).to be_a(Integer)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_a(Integer)
    end 
  end

  it 'can show an item by id' do 
    id = create(:item).id

    get "/api/v1/items/#{id}" 

    expect(response).to be_successful 

    item = JSON.parse(response.body, symbolize_names: true) 
    result = item[:data][:attributes]

    expect(result).to have_key(:id)
    expect(result[:id]).to be_a(Integer)

    expect(result).to have_key(:name)
    expect(result[:name]).to be_a(String)

    expect(result).to have_key(:description)
    expect(result[:description]).to be_a(String)

    expect(result).to have_key(:unit_price)
    expect(result[:unit_price]).to be_a(Float)

    expect(result).to have_key(:merchant_id)
    expect(result[:merchant_id]).to be_a(Integer)
  end

  it 'can create an item' do 
    merchant = create(:merchant)
    item = build(:item)

    item_params = {
            name: item[:name],
            description: item[:description],
            unit_price: item[:unit_price],
            merchant_id: merchant.id
          }

    headers = {'CONTENT_TYPE' => 'application/json'}

    post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params) 

    expect(response).to be_successful

    new_item = Item.last 
        
    expect(new_item.name).to eq(item[:name])
    expect(new_item.description).to eq(item[:description])
    expect(new_item.unit_price).to eq(item[:unit_price])
    expect(new_item.merchant_id).to eq(merchant.id)
  end

  it 'can update an item' do 
    item = create(:item)
    example_item = build(:item)

    previous_name = item.name 
    previous_description = item.description
    previous_unit_price = item.unit_price 

    #update item name 
    item_params = {
      name: example_item[:name]
    }

    headers = {'CONTENT_TYPE' => 'application/json'}

    patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate(item_params)

    expect(response).to be_successful
    
    updated_item = Item.find(item.id)

    expect(updated_item.name).to_not eq(previous_name) 
    expect(updated_item.name).to eq(example_item.name) 

    #update description and unit price 
    item_params = {
                    description: example_item[:description],
                    unit_price: example_item[:unit_price]
                  }

    patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate(item_params)

    expect(response).to be_successful
    
    updated_item = Item.find(item.id)
    expect(updated_item.description).to_not eq(previous_description) 
    expect(updated_item.description).to eq(example_item.description) 

    expect(updated_item.unit_price).to_not eq(previous_unit_price) 
    expect(updated_item.unit_price).to eq(example_item.unit_price) 
  end

  it 'can delete an item' do 
    item = create(:item)

    delete "/api/v1/items/#{item.id}"

    expect(response).to be_successful
    expect(response.status).to eq(204)

    expect(Item.count).to eq(0)
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

end
