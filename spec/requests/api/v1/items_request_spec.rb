require 'rails_helper'

RSpec.describe 'Items API', type: :request do 
  it 'sends a list of items' do 
    create_list(:item, 5)

    get '/api/v1/items'

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

      # expect(item).to have_key(:created_at)
      # expect(item[:created_at]).to be_a(DateTime)

      # expect(item).to have_key(:update_at)
      # expect(item[:update_at]).to be_a(DateTime)
    end 
  end

  it 'can show an item by id' do 
    id = create(:item).id

    get "/api/v1/items/#{id}" 

    expect(response).to be_successful 

    item = JSON.parse(response.body, symbolize_names: true) 

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

    # expect(item).to have_key(:created_at)
    # expect(item[:created_at]).to be_a(DateTime)

    # expect(item).to have_key(:update_at)
    # expect(item[:update_at]).to be_a(DateTime)
  end

  it 'can create an item'

end
