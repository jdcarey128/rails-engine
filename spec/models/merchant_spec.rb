require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'validations' do 
    it { should validate_presence_of(:name) }
  end

  describe 'relationships' do
    it { should have_many(:items) }
    it { should have_many(:invoices) }
    it { should have_many(:customers).through(:invoices)}
  end

  describe 'class methods' do 
    describe 'self.find_merchant()' do 
      before :each do 
        @merchants = create_list(:merchant, 4, created_at: 3.days.ago, updated_at: 3.minutes.ago)
        @merchant = create(:merchant, name: 'Bruce Wayne and Alfred Co')
      end

      it 'returns a merchant with id match' do 
        expect(Merchant.find_merchant('id' => @merchant.id.to_s)).to eq(@merchant)
      end

      it 'returns a merchant with name match' do 
        expect(Merchant.find_merchant('name' => @merchant.name)).to eq(@merchant)
      end

      it 'returns a merchant with created_at match' do 
        expect(Merchant.find_merchant('created_at' => @merchant.created_at.to_s)).to eq(@merchant)
      end

      it 'returns a merchant with updated_at match' do 
        expect(Merchant.find_merchant('updated_at' => @merchant.updated_at.to_s)).to eq(@merchant)
      end

      it 'returns a merchant with partial name match' do 
        expect(Merchant.find_merchant('name' => 'bruce WAYNE')).to eq(@merchant)
      end

    end
  end
end
