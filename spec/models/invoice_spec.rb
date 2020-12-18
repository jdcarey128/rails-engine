require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:status) }
  end

  describe 'relationships' do
    it { should belong_to(:merchant) }
    it { should belong_to(:customer) }
    it { should have_many(:invoice_items) }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:transactions) }
  end

  describe 'class methods' do 
    describe 'clean invoices' do 
      it 'removes invoices that no longer have items' do 
        create(:invoice)

        expect{Invoice.clean_invoices}.to change(Invoice, :count).by(-1)

      end

      it 'can remove all invoices that no longer have items' do 
        create_list(:invoice, 5)
        expect{Invoice.clean_invoices}.to change(Invoice, :count).by(-5)
      end

      it 'removes only invoices that do not have items' do 
        invoice1, invoice2, invoice3 = create_list(:invoice, 3)

        item  = create(:item)
        item2 = create(:item)
        ii1   = create(:invoice_item, item: item, invoice: invoice1)
        ii2   = create(:invoice_item, item: item2, invoice: invoice2)        

        expect{Invoice.clean_invoices}.to change(Invoice, :count).by(-1)
      end
    end
  end
end
