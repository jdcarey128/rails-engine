require 'rails_helper' 

RSpec.describe 'Merchants API' do 
  it 'sends a list of merchants' do 
    create_list(:merchant, 4)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(4)

    merchants[:data].each do |merchant|
      expect(merchant[:attributes]).to have_key(:id)
      expect(merchant[:attributes][:id]).to be_a(Integer)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  it 'sends one merchant based on their id' do 
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"    

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(merchant[:data]).to have_key(:id)
    expect(merchant[:data][:id]).to be_a(String)

    expect(merchant[:data][:attributes]).to have_key(:name)
    expect(merchant[:data][:attributes][:name]).to be_a(String)
  end

  it 'can create a new merchant' do
    merchant_params = ({
                        name: 'Harry Potter'
                      })
    headers = {'CONTENT_TYPE' => 'application/json'}

    post '/api/v1/merchants', headers: headers, params: JSON.generate(merchant_params)

    created_merchant = Merchant.last 

    expect(response).to be_successful
    expect(created_merchant.name).to eq(merchant_params[:name])
  end

  it 'can update a merchant name' do 
    id = create(:merchant).id 

    previous_name = Merchant.last.name 
    merchant_params = {name: 'Ronald Weasley'}
    headers = {'CONTENT_TYPE' => 'application/json'}

    patch "/api/v1/merchants/#{id}", headers: headers, params: JSON.generate(merchant_params)
    merchant = Merchant.find_by(id: id)

    expect(response).to be_successful
    expect(merchant.name).to_not eq(previous_name)
    expect(merchant.name).to eq(merchant_params[:name])
    expect(merchant.created_at).to_not eq(merchant.updated_at)
  end

  it 'can destroy a merchant' do
    id = create(:merchant).id 

    expect(Merchant.count).to eq(1)

    delete "/api/v1/merchants/#{id}"

    expect(response).to be_successful
    expect(response.status).to eq(204)
    expect(Merchant.count).to eq(0)
    expect{(Merchant.find(id))}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'can destroy any associated items with a merchant' do 
    merchant = create(:merchant, :with_items, item_count: 3)
    
    expect(Item.all).to eq(merchant.items)
    expect(Item.count).to eq(3)

    delete "/api/v1/merchants/#{merchant.id}"

    expect(Item.count).to eq(0)
    expect(Item.all).to eq([])
  end
end
