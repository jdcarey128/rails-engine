require 'rails_helper' 

RSpec.describe 'Business Intelligence Endpoints', type: :request do 
  describe 'merchants with most revenue' do 
    before :each do 
      @merchant_1 = create(:merchant, :with_invoice_items, invoice_count: 1, item_quantity: 2, unit_price: 100)
      @merchant_2 = create(:merchant, :with_invoice_items, invoice_count: 1, item_quantity: 2, unit_price: 10)
      @merchant_3 = create(:merchant, :with_invoice_items, invoice_count: 1, item_quantity: 2, unit_price: 500)
      @merchant_4 = create(:merchant, :with_invoice_items, invoice_count: 1, item_quantity: 2, unit_price: 75)
      @merchant_5 = create(:merchant, :with_invoice_items, invoice_count: 1, item_quantity: 2, unit_price: 50)
      @merchant_6 = create(:merchant, :with_invoice_items, invoice_count: 1, item_quantity: 2, unit_price: 5)
      @merchant_7 = create(:merchant, :with_invoice_items, invoice_count: 1, item_quantity: 2, unit_price: 8)
    end

    it 'returns an array of merchants with most revenue' do
      get '/api/v1/merchants/most_revenue?quantity=5'

      expect(response).to be_successful 

      merchants = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(merchants.count).to eq(5)

      merchants.each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant).to have_key(:type)
        expect(merchant).to have_key(:attributes)
        expect(merchant[:attributes]).to have_key(:name)
      end

      expect(merchants[0][:attributes][:name]).to eq(@merchant_3.name)
      expect(merchants[1][:attributes][:name]).to eq(@merchant_1.name)
      expect(merchants[2][:attributes][:name]).to eq(@merchant_4.name)
      expect(merchants[3][:attributes][:name]).to eq(@merchant_5.name)
      expect(merchants[4][:attributes][:name]).to eq(@merchant_2.name)
    end

    it 'returns a variable count of merchants' do 
      get '/api/v1/merchants/most_revenue?quantity=2'

      merchants = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(merchants.count).to eq(2)
      expect(merchants[0][:attributes][:name]).to eq(@merchant_3.name)

      get '/api/v1/merchants/most_revenue?quantity=7'

      merchants = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(merchants.count).to eq(7)
      expect(merchants[0][:attributes][:name]).to eq(@merchant_3.name)
    end

    it 'does not include merchants with unsuccessful transactions' do 
      new_merchant = create(:merchant, :with_invoice_items, invoice_count: 1, 
                            item_quantity: 2, unit_price: 1000, transaction_result: 'failed')
      get '/api/v1/merchants/most_revenue?quantity=2'

      merchants = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(merchants[0][:attributes][:name]).to_not eq(new_merchant.name)
      expect(merchants[0][:attributes][:name]).to eq(@merchant_3.name)
    end

    it 'returns a 400 error without parameter' do 
      get '/api/v1/merchants/most_revenue' 

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json).to have_key(:errors)
      expect(json).to have_key(:status)
      expect(json[:errors][0]).to eq("A quantity param is required in your query")
    end
  end

  describe 'merchants with most sold items' do 
    before :each do 
      @merchant_1 = create(:merchant, :with_invoice_items, item_quantity: 8)
      @merchant_2 = create(:merchant, :with_invoice_items, item_quantity: 12)
      @merchant_3 = create(:merchant, :with_invoice_items, item_quantity: 5)
      @merchant_4 = create(:merchant, :with_invoice_items, item_quantity: 10)
      @merchant_5 = create(:merchant, :with_invoice_items, item_quantity: 7)
      @merchant_6 = create(:merchant, :with_invoice_items, item_quantity: 20)
      @merchant_7 = create(:merchant, :with_invoice_items, item_quantity: 15)
    end

    it 'returns a variable array of ordered merchants by item sold' do 
      get '/api/v1/merchants/most_items?quantity=3' 

      expect(response).to be_successful
      
      merchants = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(merchants.count).to eq(3)

      merchants.each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant).to have_key(:type)
        expect(merchant).to have_key(:attributes)
      end

      expect(merchants[0][:attributes][:name]).to eq(@merchant_6.name)
      expect(merchants[1][:attributes][:name]).to eq(@merchant_7.name)
      expect(merchants[2][:attributes][:name]).to eq(@merchant_2.name)

      get '/api/v1/merchants/most_items?quantity=6' 
      merchants = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(merchants.count).to eq(6)
    end

    it 'returns a 400 error without parameter' do 
      get '/api/v1/merchants/most_items' 

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json).to have_key(:errors)
      expect(json).to have_key(:status)
      expect(json[:errors][0]).to eq("A quantity param is required in your query")
    end
  end
end
