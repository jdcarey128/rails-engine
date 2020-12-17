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
        @invoice4 = create(:invoice, merchant: @m4, created_at: '2020-12-05 14:00:00')
        @invoice5 = create(:invoice, merchant: @m5, created_at: '2020-12-05 23:59:59')
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

      it 'calculates the revenue of all merchants across date ranges' do 
        start_date = '2020-12-02'
        end_date   = '2020-12-04'

        revenue = @ii2.unit_price + @ii3.unit_price

        expect(Merchant.total_revenue(start_date, end_date)).to eq(revenue)
        start_date = '2020-12-01'
        
        end_date   = '2020-12-05'
        revenue = @ii1.unit_price + @ii2.unit_price + @ii3.unit_price + @ii4.unit_price + @ii5.unit_price 

        expect(Merchant.total_revenue(start_date, end_date)).to eq(revenue)
      end

      it 'can calculate the revenue of all merchants for a single day' do 
        start_date = '2020-12-05'
        end_date   = '2020-12-06'
        revenue = @ii4.unit_price + @ii5.unit_price 

        expect(Merchant.total_revenue(start_date, end_date)).to eq(revenue)
      end

      it 'will not include merchants with unsuccessful transactions' do 
        #expect all but 6 and 7 

        start_date = '2018-01-05'
        end_date   = '2022-01-05'
        revenue = @ii1.unit_price + @ii2.unit_price + @ii3.unit_price + @ii4.unit_price + @ii5.unit_price 

        expect(Merchant.total_revenue(start_date, end_date)).to eq(revenue)
      end

      it 'return the total revenue of a merchant' do 
        expect(Merchant.merchant_revenue(@m1.id)[0].revenue).to eq(@ii1.unit_price)
      end

      it 'returns an empty array for a merchant with no successful transactions' do 
        expect(Merchant.merchant_revenue(@m6.id)).to eq([])
      end

      it 'returns an empty array for a nonexisting merchant' do 
        expect(Merchant.merchant_revenue(1500)).to eq([])
      end
    end
  end
end
