require 'rails_helper' 

RSpec.describe 'Merchants Find All', type: :request do 
  describe 'It returns an array of items with matching attribute' do 
    before :each do 
      @merchants = create_list(:merchant, 3, 
                               name: 'Holly and Davis'
                              )
      @merchant_1 = @merchants[0]
      @merchant_4 = create(:merchant, 
                            name: 'Randall Pits Meals On Wheels')
    end
    
    it 'id' do 
      get "/api/v1/merchants/find_all?id=#{@merchant_1.id}"

      expect(response).to be_successful
      merchant = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(merchant.count).to eq(1)
      expect(merchant[0][:attributes][:name]).to eq(@merchant_1.name)
    end

    it 'name' do 
      get "/api/v1/merchants/find_all?name=#{@merchant_1.name}"

      expect(response).to be_successful
      merchant = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(merchant.count).to eq(3)
      expect(merchant[0][:attributes][:name]).to eq(@merchant_1.name)
    end

    it 'name partial match' do 
      get "/api/v1/merchants/find_all?name=DAVIS"

      expect(response).to be_successful

      merchant = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(merchant.count).to eq(3)
      expect(merchant[0][:attributes][:name].upcase).to include('DAVIS')
    end

    it 'created_at and updated_at' do 
      get "/api/v1/merchants/find_all?created_at=#{@merchant_1.created_at}"

      expect(response).to be_successful
      merchant = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(merchant.count).to eq(4)

      get "/api/v1/merchants/find_all?updated_at=#{@merchant_1.updated_at}"

      expect(response).to be_successful
      merchant = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(merchant.count).to eq(4)
    end

    it 'created_at and upated_at limit 20' do 
      merchants = create_list(:merchant, 20)

      get "/api/v1/merchants/find_all?created_at=#{@merchant_1.created_at}"

      expect(response).to be_successful
      merchant = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(merchant.count).to eq(20)

      get "/api/v1/merchants/find_all?updated_at=#{@merchant_1.updated_at}"

      expect(response).to be_successful
      merchant = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(merchant.count).to eq(20)
    end

    it 'created_at and updated_at within 12 hours' do 
      merchants = create_list(:merchant, 5, 
                              created_at: Time.now.utc + 1.day,
                              updated_at: Time.now.utc + 1.day)

      get "/api/v1/merchants/find_all?created_at=#{@merchant_1.created_at}"

      expect(response).to be_successful
      merchant = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(merchant.count).to eq(4)

      get "/api/v1/merchants/find_all?updated_at=#{@merchant_1.updated_at}"

      expect(response).to be_successful
      merchant = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(merchant.count).to eq(4)
    end
  end
end
