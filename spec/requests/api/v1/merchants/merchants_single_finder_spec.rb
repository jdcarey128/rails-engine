require 'rails_helper'

RSpec.describe 'Merchants Single Finder', type: :request do 
  describe 'it returns a merchant match for attribute' do 
    before :each do 
      @merchants = create_list(:merchant, 4, created_at: 3.days.ago, updated_at: 3.minutes.ago)
      @merchant = create(:merchant, name: 'Bagel and Deli Bros')
    end

    it 'id' do 
      expect(Merchant.count).to eq(5)

      get "/api/v1/merchants/find?id=#{@merchant.id.to_s}"

      expect(response).to be_successful

      found_merchant = JSON.parse(response.body, symbolize_names: true)[:data][:attributes]

      expect(found_merchant[:name]).to eq(@merchant.name)
    end

    it 'name' do 
      get "/api/v1/merchants/find?name=#{@merchant.name}"

      expect(response).to be_successful

      found_merchant = JSON.parse(response.body, symbolize_names: true)[:data][:attributes]

      expect(found_merchant[:name]).to eq(@merchant.name)
    end

    it 'created_at' do 
      get "/api/v1/merchants/find?created_at=#{@merchant.created_at}"

      expect(response).to be_successful

      found_merchant = JSON.parse(response.body, symbolize_names: true)[:data][:attributes]

      expect(found_merchant[:name]).to eq(@merchant.name)
    end

    it 'updated_at' do 
      get "/api/v1/merchants/find?updated_at=#{@merchant.updated_at}"

      expect(response).to be_successful

      found_merchant = JSON.parse(response.body, symbolize_names: true)[:data][:attributes]

      expect(found_merchant[:name]).to eq(@merchant.name)
    end

    it 'name partial match' do 
      name = 'bagel and DELI'
      get "/api/v1/merchants/find?name=#{name}"

      expect(response).to be_successful

      found_merchant = JSON.parse(response.body, symbolize_names: true)[:data][:attributes]

      expect(found_merchant[:name]).to eq(@merchant.name)
    end
  end
end
