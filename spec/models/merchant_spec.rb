require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'relationships' do
    it { should have_many(:items) }
    it { should have_many(:invoices) }
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many(:invoice_items).through(:invoices) }
  end

  describe 'class methods' do
    describe 'self.find_merchant()' do
      before :each do
        @merchants = create_list(:merchant, 4, created_at: 3.days.ago, updated_at: 3.minutes.ago)
        @merchant = create(:merchant, name: 'Bruce Wayne and Alfred Co')
      end

      it 'returns a merchant with id match' do
        expect(Merchant.find_one('id' => @merchant.id.to_s)).to eq(@merchant)
      end

      it 'returns a merchant with name match' do
        expect(Merchant.find_one('name' => @merchant.name)).to eq(@merchant)
      end

      it 'returns a merchant with created_at match' do
        expect(Merchant.find_one('created_at' => @merchant.created_at.to_s)).to eq(@merchant)
      end

      it 'returns a merchant with updated_at match' do
        expect(Merchant.find_one('updated_at' => @merchant.updated_at.to_s)).to eq(@merchant)
      end

      it 'returns a merchant with partial name match' do
        expect(Merchant.find_one('name' => 'bruce WAYNE')).to eq(@merchant)
      end
    end

    describe 'find_all()' do
      before :each do
        @merchants = create_list(:merchant, 3,
                                 name: 'Holly and Davis')
        @merchant_1 = @merchants[0]
        @merchant_4 = create(:merchant,
                             name: 'Randall Pits Meals On Wheels')
      end

      it 'returns array with one merchant with id' do
        expect(Merchant.find_all('id' => @merchant_1.id.to_s)).to eq([@merchant_1])
      end

      it 'returns array with multiple merchants with name' do
        expect(Merchant.find_all('name' => @merchant_1.name)).to eq(@merchants)
        expect(Merchant.find_all('name' => @merchant_4.name)).to eq([@merchant_4])
      end

      it 'returns an array with all merchants with created_at and updated_at' do
        expect(Merchant.find_all('created_at' => @merchant_1.created_at.to_s)).to eq([@merchants, @merchant_4].flatten)
        expect(Merchant.find_all('updated_at' => @merchant_1.updated_at.to_s)).to eq([@merchants, @merchant_4].flatten)
      end
    end

    describe 'most_revenue(limit)' do
      before :each do
        #revenue = $800
        @merchant_1 = create(:merchant, :with_invoice_items, invoice_count: 2, invoice_status: 'shipped', invoice_item_count: 2, item_quantity: 2,  unit_price: 100, transaction_result: 'success')
        #revenue = $300
        @merchant_2 = create(:merchant, :with_invoice_items, invoice_count: 2, invoice_status: 'shipped', invoice_item_count: 3, item_quantity: 1,  unit_price: 50, transaction_result: 'success')
        #revenue = $200
        @merchant_3 = create(:merchant, :with_invoice_items, invoice_count: 1, invoice_status: 'shipped', invoice_item_count: 5, item_quantity: 2,  unit_price: 20, transaction_result: 'success')
        #revenue = $100
        @merchant_4 = create(:merchant, :with_invoice_items, invoice_count: 5, invoice_status: 'shipped', invoice_item_count: 2, item_quantity: 1,  unit_price: 10, transaction_result: 'success')
        #revenue = $60
        @merchant_5 = create(:merchant, :with_invoice_items, invoice_count: 3, invoice_status: 'shipped', invoice_item_count: 2, item_quantity: 2,  unit_price: 5, transaction_result: 'success')
        #not successful transactions
        @merchant_6 = create(:merchant, :with_invoice_items, invoice_count: 6, invoice_status: 'shipped', invoice_item_count: 3, item_quantity: 2,  unit_price: 60, transaction_result: 'failed')
        @merchant_7 = create(:merchant, :with_invoice_items, invoice_count: 3, invoice_status: 'packaged', invoice_item_count: 1, item_quantity: 2,  unit_price: 100, transaction_result: 'success')
        @ordered_revenues = [@merchant_1, @merchant_2, @merchant_3, @merchant_4, @merchant_5]
      end

      it 'returns array with ordered merchants by revenue' do
        expect(Merchant.most_revenue(3)).to eq(@ordered_revenues.first(3))
      end

      it 'returns array length based on limit arg' do
        expect(Merchant.most_revenue(1).first).to eq(@ordered_revenues.first)
        expect(Merchant.most_revenue(5)).to eq(@ordered_revenues.first(5))
        expect(Merchant.most_revenue(7)).to eq(@ordered_revenues)
        expect(Merchant.most_revenue(10)).to eq(@ordered_revenues)
      end
    end

    describe 'most_items()' do
      before :each do
        @merchant_1 = create(:merchant, :with_invoice_items, item_quantity: 8)
        @merchant_2 = create(:merchant, :with_invoice_items, item_quantity: 12)
        @merchant_3 = create(:merchant, :with_invoice_items, item_quantity: 5)
        @merchant_4 = create(:merchant, :with_invoice_items, item_quantity: 10)
        @merchant_5 = create(:merchant, :with_invoice_items, item_quantity: 7)
        @merchant_6 = create(:merchant, :with_invoice_items, item_quantity: 20)
        @merchant_7 = create(:merchant, :with_invoice_items, item_quantity: 15)
        @expected_results = [@merchant_6, @merchant_7, @merchant_2, @merchant_4, @merchant_1, @merchant_5, @merchant_3]
      end

      it 'returns a variable array of merchant objects who have sold the most items' do 
        expect(Merchant.most_items(3)).to eq(@expected_results.first(3))
        expect(Merchant.most_items(5)).to eq(@expected_results.first(5))
        expect(Merchant.most_items(10)).to eq(@expected_results.first(7))
      end
    end

    
  end
end
