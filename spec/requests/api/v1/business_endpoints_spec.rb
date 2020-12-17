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
      @merchant_1 = create(:merchant, :with_invoice_items, item_quantity: 5)
      @merchant_2 = create(:merchant, :with_invoice_items, item_quantity: 7)
      @merchant_3 = create(:merchant, :with_invoice_items, item_quantity: 8)
      @merchant_4 = create(:merchant, :with_invoice_items, item_quantity: 10)
      @merchant_5 = create(:merchant, :with_invoice_items, item_quantity: 12)
      @merchant_6 = create(:merchant, :with_invoice_items, item_quantity: 15)
      @merchant_7 = create(:merchant, :with_invoice_items, item_quantity: 20)
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

      expect(merchants[0][:attributes][:name]).to eq(@merchant_7.name)
      expect(merchants[1][:attributes][:name]).to eq(@merchant_6.name)
      expect(merchants[2][:attributes][:name]).to eq(@merchant_5.name)

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

  describe 'revenue' do 
    before :each do 
      @m1, @m2, @m3, @m4, @m5, @m6, @m7 = create_list(:merchant, 7)

      #Create item for each merchant 
      @item1 = create(:item, merchant: @m1)
      @item2 = create(:item, merchant: @m2)
      @item3 = create(:item, merchant: @m3)
      @item4 = create(:item, merchant: @m4)
      @item5 = create(:item, merchant: @m5)
      @item6 = create(:item, merchant: @m6)
      @item7 = create(:item, merchant: @m7)

      #Create invoice for each merchant 
      @invoice1 = create(:invoice, merchant: @m1, created_at: '2020-12-01 12:00:00')
      @invoice2 = create(:invoice, merchant: @m2, created_at: '2020-12-02 12:00:00')
      @invoice3 = create(:invoice, merchant: @m3, created_at: '2020-12-03 12:00:00')
      @invoice4 = create(:invoice, merchant: @m4, created_at: '2020-12-04 12:00:00')
      @invoice5 = create(:invoice, merchant: @m5, created_at: '2020-12-05 12:00:00')
      @invoice6 = create(:invoice, merchant: @m6, created_at: '2020-12-06 12:00:00')
      @invoice7 = create(:invoice, merchant: @m7, created_at: '2020-12-07 12:00:00', status: 'packaged')

      #Create Invoice items with above items and invoices
      @ii1 = create(:invoice_item, item: @item1, invoice: @invoice1, quantity: 1, unit_price: 10.00)
      @ii2 = create(:invoice_item, item: @item2, invoice: @invoice2, quantity: 1, unit_price: 20.00)
      @ii3 = create(:invoice_item, item: @item3, invoice: @invoice3, quantity: 1, unit_price: 30.00)
      @ii4 = create(:invoice_item, item: @item4, invoice: @invoice4, quantity: 1, unit_price: 40.00)
      @ii5 = create(:invoice_item, item: @item5, invoice: @invoice5, quantity: 1, unit_price: 50.00)
      @ii6 = create(:invoice_item, item: @item6, invoice: @invoice6, quantity: 1, unit_price: 60.00)
      @ii7 = create(:invoice_item, item: @item7, invoice: @invoice7, quantity: 1, unit_price: 70.00)

      #Transactions assigned to invoice 
      @t1 = create(:transaction, invoice: @invoice1)
      @t2 = create(:transaction, invoice: @invoice2)
      @t3 = create(:transaction, invoice: @invoice3)
      @t4 = create(:transaction, invoice: @invoice4)
      @t5 = create(:transaction, invoice: @invoice5)
      @t6 = create(:transaction, invoice: @invoice6, result: 'failed')
      @t7 = create(:transaction, invoice: @invoice7)
    end

    it 'returns the total revenue for successful transactions across date range' do 
      #expect revenue total for invoice items 1-3 (with 1 item, revenue = unit_price)
      revenue = @ii1.unit_price + @ii2.unit_price + @ii3.unit_price

      start_date = '2020-12-01'
      end_date   = '2020-12-03'

      get "/api/v1/revenue?start=#{start_date}&end=#{end_date}"
      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(json).to have_key(:id)
      expect(json[:id]).to be_nil
      expect(json).to have_key(:attributes)
      expect(json[:attributes]).to have_key(:revenue)
      expect(json[:attributes][:revenue]).to eq(revenue)
    end

    it 'returns an error with missing params' do 
      start_date = '2020-12-01'
      end_date   = '2020-12-05'

      get "/api/v1/revenue?start=#{start_date}"
      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json).to have_key(:status)
      expect(json[:status]).to eq("bad_request")
      expect(json).to have_key(:errors)
      expect(json[:errors]).to include("A end date param is required in your query")

      get "/api/v1/revenue?end=#{end_date}"
      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json).to have_key(:status)
      expect(json[:status]).to eq("bad_request")
      expect(json).to have_key(:errors)
      expect(json[:errors]).to include("A start date param is required in your query")

      get "/api/v1/revenue"
      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:errors]).to include("A start date param is required in your query")
      expect(json[:errors]).to include("A end date param is required in your query")
    end

    it 'includes revenue for all successful transactions in large date range' do 
      #expect all but @ii6 and @ii7 to be calculate in total revenue 
      revenue = @ii1.unit_price + @ii2.unit_price + @ii3.unit_price + @ii4.unit_price + @ii5.unit_price

      start_date = '1980-03-01'
      end_date   = '2050-09-03'

      get "/api/v1/revenue?start=#{start_date}&end=#{end_date}"
      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)[:data]
      
      expect(json).to have_key(:id)
      expect(json[:id]).to be_nil
      expect(json).to have_key(:attributes)
      expect(json[:attributes]).to have_key(:revenue)
      expect(json[:attributes][:revenue]).to eq(revenue)
    end

    it 'returns revenue for a single merchant' do 
      get "/api/v1/merchants/#{@m1.id}/revenue"

      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(json).to have_key(:id)
      expect(json[:nil]).to eq(nil)
      expect(json[:attributes]).to have_key(:revenue)
      expect(json[:attributes][:revenue]).to eq(@ii1.unit_price)
      
      get "/api/v1/merchants/#{@m2.id}/revenue"
      json = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(json).to have_key(:id)
      expect(json[:nil]).to eq(nil)
      expect(json[:attributes]).to have_key(:revenue)
      expect(json[:attributes][:revenue]).to eq(@ii2.unit_price)
    end

    it 'returns 0 for a merchant without successful transactions' do 
      get "/api/v1/merchants/#{@m6.id}/revenue"

      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(json[:attributes][:revenue]).to eq(0)
    end

    it 'returns an error for a merchant that does not exist' do 
      get "/api/v1/merchants/1252/revenue"

      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)
      expect(json).to have_key(:errors) 
      expect(json[:errors]).to include('A valid merchant id param is required in your query')
    end
  end
end
